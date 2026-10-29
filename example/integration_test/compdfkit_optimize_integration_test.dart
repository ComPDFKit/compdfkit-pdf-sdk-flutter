// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

// Integration test: document optimization (compression) on a real device.
// Usage: flutter test integration_test/compdfkit_optimize_integration_test.dart -d <deviceId>

import 'dart:async';
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> initializeComPDFKitSDK() async {
  final licenseFile =
      await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml');
  final ok = await ComPDFKit.initWithPath(licenseFile.path);
  if (!ok) {
    fail('ComPDFKit SDK initialization failed (license: ${licenseFile.path}).');
  }
}

Matcher throwsOptimizeError(String code) => throwsA(
      isA<CPDFOptimizeException>().having((e) => e.code, 'code', code),
    );

/// Keeps every flag of the default set except the lossy bookmark and
/// JavaScript removal, so page content and outlines can be compared.
final Set<CPDFOptimizeFlag> keepContentFlags = {
  ...CPDFOptimizeFlag.defaults,
}..removeAll({
    CPDFOptimizeFlag.removeBookmarks,
    CPDFOptimizeFlag.removeJavaScriptActions,
  });

CPDFOptimizeOptions optionsWithQuality(int quality) {
  const defaults = CPDFOptimizeOptions();
  return defaults.copyWith(
    flags: keepContentFlags,
    imageQuality: quality.toDouble(),
    colorImageOptions: defaults.colorImageOptions.copyWith(quality: quality),
    grayscaleImageOptions:
        defaults.grayscaleImageOptions.copyWith(quality: quality),
    monochromeImageOptions:
        defaults.monochromeImageOptions.copyWith(quality: quality),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late String sourcePath;
  late List<int> sourceBytes;
  late String outputDirectory;

  setUpAll(() async {
    await initializeComPDFKitSDK();
    sourcePath = (await CPDFFileUtil.extractAsset('pdfs/annot_test.pdf')).path;
    sourceBytes = File(sourcePath).readAsBytesSync();
    final temp = await ComPDFKit.getTemporaryDirectory();
    final directory = Directory('${temp.path}/optimize_integration');
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
    directory.createSync(recursive: true);
    outputDirectory = directory.path;
  });

  Future<CPDFDocument> openDocument(String path, {String? password}) async {
    final document = await CPDFDocument.createInstance();
    addTearDown(document.close);
    final error = await document.open(path, password: password ?? '');
    expect(error, CPDFDocumentError.success, reason: 'open $path');
    return document;
  }

  Future<int> pageCountOf(String path) async {
    final document = await CPDFDocument.createInstance();
    try {
      final error = await document.open(path);
      expect(error, CPDFDocumentError.success, reason: 'reopen $path');
      return await document.getPageCount();
    } finally {
      await document.close();
    }
  }

  testWidgets('getOptimizeOptions reports the shared defaults', (tester) async {
    final document = await openDocument(sourcePath);
    final options = await document.getOptimizeOptions();
    expect(options.flags.toMask(), 175767799);
    expect(options.imageQuality, 40);
    expect(options.colorImageOptions.upperPpi, 225);
    expect(options.colorImageOptions.targetPpi, 150);
    expect(options.colorImageOptions.compressAlgorithm,
        CPDFCompressAlgorithm.jpeg2000);
    expect(options.monochromeImageOptions.upperPpi, 450);
    expect(options.monochromeImageOptions.compressAlgorithm,
        CPDFCompressAlgorithm.jbig2);
    expect(options.colorSpaceConvert.isEnabled, isFalse);
  });

  testWidgets('writes a smaller, readable copy and leaves the source untouched',
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    final document = await openDocument(sourcePath);
    final pageCount = await document.getPageCount();
    final outputPath = '$outputDirectory/default.pdf';
    final progress = <int>[];

    final result = await document.optimizeToFile(
      outputPath,
      onProgress: progress.add,
    );

    debugPrint('default run: $result, '
        'source ${sourceBytes.length} -> ${File(outputPath).lengthSync()}');
    expect(result.ok, isTrue);
    expect(result.cancelled, isFalse);
    expect(result.pagesProcessed, pageCount);
    expect(result.stepsUs, greaterThan(0));
    expect(result.saveUs, greaterThan(0));
    expect(progress, isNotEmpty);
    expect(progress.last, pageCount - 1);
    expect(File(outputPath).lengthSync(), lessThan(sourceBytes.length));
    expect(await pageCountOf(outputPath), pageCount);
    expect(File(sourcePath).readAsBytesSync(), sourceBytes,
        reason: 'the source file must not be modified');
  });

  testWidgets('the opened document is restored after the run',
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    // Baseline: what saveAs writes for a document that was never optimized.
    final baseline = await openDocument(sourcePath);
    final baselinePath = '$outputDirectory/restore_baseline.pdf';
    expect(await baseline.saveAs(baselinePath), isTrue);

    final document = await openDocument(sourcePath);
    final optimizedPath = '$outputDirectory/restore_optimized.pdf';
    expect((await document.optimizeToFile(optimizedPath)).ok, isTrue);

    // Saving after the run must write the original content, not the optimized
    // one, so the copy matches the baseline rather than the optimized output.
    expect(await document.hasChange(), isFalse);
    final copyPath = '$outputDirectory/restore_copy.pdf';
    expect(await document.saveAs(copyPath), isTrue);
    final copySize = File(copyPath).lengthSync();
    final baselineSize = File(baselinePath).lengthSync();
    final optimizedSize = File(optimizedPath).lengthSync();
    debugPrint('restore: copy $copySize, baseline $baselineSize, '
        'optimized $optimizedSize');
    expect(copySize, baselineSize);
    expect(optimizedSize, lessThan(baselineSize));
    expect(await document.getPageCount(), await pageCountOf(sourcePath));
  });

  // The iOS SDK 3.2.0 build (pdf_sdk_apple 3f095d4c1) does not recompress
  // images at all: flags, quality, PPI and algorithm leave the image bytes
  // untouched. Reported to the iOS SDK team; enable on iOS once fixed.
  testWidgets('image settings change the output size',
      skip: Platform.isIOS,
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    final imagePath =
        (await CPDFFileUtil.extractAsset('pdfs/PDF_Document.pdf')).path;
    final document = await openDocument(imagePath);
    const defaults = CPDFOptimizeOptions();
    final keepPath = '$outputDirectory/images_kept.pdf';
    final smallPath = '$outputDirectory/images_small.pdf';

    final keep = {...keepContentFlags}..remove(CPDFOptimizeFlag.compressImages);
    expect(
        (await document.optimizeToFile(keepPath,
                options: defaults.copyWith(flags: keep)))
            .ok,
        isTrue);
    final small = optionsWithQuality(5).copyWith(
      colorImageOptions: optionsWithQuality(5)
          .colorImageOptions
          .copyWith(upperPpi: 1, targetPpi: 72),
    );
    expect(
        (await document.optimizeToFile(smallPath, options: small)).ok, isTrue);

    final kept = File(keepPath).lengthSync();
    final reduced = File(smallPath).lengthSync();
    debugPrint('images kept: $kept, images at q5/72ppi: $reduced');
    expect(reduced, lessThan(kept));
  });

  testWidgets('accepts every compression algorithm value',
      timeout: const Timeout(Duration(minutes: 5)), (tester) async {
    final document = await openDocument(sourcePath);
    const defaults = CPDFOptimizeOptions();
    for (final algorithm in CPDFCompressAlgorithm.values) {
      final outputPath = '$outputDirectory/alg_${algorithm.value}.pdf';
      final result = await document.optimizeToFile(
        outputPath,
        options: defaults.copyWith(
          colorImageOptions:
              defaults.colorImageOptions.copyWith(compressAlgorithm: algorithm),
        ),
      );
      expect(result.ok, isTrue, reason: algorithm.value);
      expect(File(outputPath).existsSync(), isTrue, reason: algorithm.value);
    }
  });

  testWidgets('rejects invalid output paths without writing anything',
      (tester) async {
    final document = await openDocument(sourcePath);
    await expectLater(
      document.optimizeToFile('$outputDirectory/missing/dir/out.pdf'),
      throwsOptimizeError('INVALID_OUTPUT_PATH'),
    );
    await expectLater(
      document.optimizeToFile(sourcePath),
      throwsOptimizeError('INVALID_OUTPUT_PATH'),
    );
    await expectLater(
      document.optimizeToFile('   '),
      throwsOptimizeError('INVALID_OUTPUT_PATH'),
    );
    expect(File(sourcePath).readAsBytesSync(), sourceBytes);
  });

  testWidgets('rejects out of range options', (tester) async {
    final document = await openDocument(sourcePath);
    const defaults = CPDFOptimizeOptions();
    final outputPath = '$outputDirectory/invalid_options.pdf';
    await expectLater(
      document.optimizeToFile(outputPath,
          options: defaults.copyWith(imageQuality: 101)),
      throwsOptimizeError('INVALID_OPTIMIZE_OPTIONS'),
    );
    await expectLater(
      document.optimizeToFile(outputPath,
          options: defaults.copyWith(
              colorImageOptions:
                  defaults.colorImageOptions.copyWith(upperPpi: 0))),
      throwsOptimizeError('INVALID_OPTIMIZE_OPTIONS'),
    );
    expect(File(outputPath).existsSync(), isFalse);
  });

  testWidgets('cancelling resolves with cancelled and leaves no output',
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    final document = await openDocument(sourcePath);
    final outputPath = '$outputDirectory/cancelled.pdf';
    var cancelRequested = false;

    final result = await document.optimizeToFile(
      outputPath,
      onProgress: (pageIndex) {
        if (!cancelRequested) {
          cancelRequested = true;
          unawaited(document.cancelOptimize());
        }
      },
    );

    debugPrint('cancelled run: $result');
    expect(cancelRequested, isTrue);
    expect(result.cancelled, isTrue);
    expect(result.ok, isFalse);
    expect(File(outputPath).existsSync(), isFalse);
    // The document is still usable after a cancelled run.
    expect(await document.getPageCount(), greaterThan(0));
  });

  testWidgets('a second run while one is in flight is rejected',
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    final document = await openDocument(sourcePath);
    final first = document.optimizeToFile('$outputDirectory/first.pdf');
    await expectLater(
      document.optimizeToFile('$outputDirectory/second.pdf'),
      throwsOptimizeError('OPTIMIZE_ALREADY_RUNNING'),
    );
    expect((await first).ok, isTrue);
  });

  testWidgets('optimizes an encrypted document and keeps it usable',
      timeout: const Timeout(Duration(minutes: 3)), (tester) async {
    final file = await CPDFFileUtil.extractAsset(
        'pdfs/Password_compdfkit_Security_Sample_File.pdf');
    final document = await openDocument(file.path, password: 'compdfkit');
    final pageCount = await document.getPageCount();
    final outputPath = '$outputDirectory/encrypted.pdf';

    final result = await document.optimizeToFile(outputPath);

    expect(result.ok, isTrue);
    expect(File(outputPath).existsSync(), isTrue);
    expect(await document.getPageCount(), pageCount);
  });

  testWidgets('cancelOptimize without a run in flight is a no-op',
      (tester) async {
    final document = await openDocument(sourcePath);
    await document.cancelOptimize();
  });
}
