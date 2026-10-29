// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

// Integration test: PDF standard detection and conversion on a real device.
// Usage: flutter test integration_test/compdfkit_pdf_standard_integration_test.dart -d <deviceId>

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

/// Conversion targets that succeed on the bundled sample document.
///
/// PDF/E-1 is covered separately: its conversion is strict about the source
/// content (embedded fonts, font encodings, PDF version) and the sample
/// document does not meet those requirements.
const List<CPDFPdfStandardType> supportedTargets = [
  CPDFPdfStandardType.pdfA1a,
  CPDFPdfStandardType.pdfA1b,
  CPDFPdfStandardType.pdfA2a,
  CPDFPdfStandardType.pdfA2u,
  CPDFPdfStandardType.pdfA2b,
  CPDFPdfStandardType.pdfA3a,
  CPDFPdfStandardType.pdfA3u,
  CPDFPdfStandardType.pdfA3b,
  CPDFPdfStandardType.pdfX1a,
  CPDFPdfStandardType.pdfX3,
  CPDFPdfStandardType.pdfX4,
  CPDFPdfStandardType.pdfUA1,
  CPDFPdfStandardType.pdfVT1,
  CPDFPdfStandardType.pdfVT2,
];

Matcher throwsStandardError(String code) => throwsA(
      isA<CPDFPdfStandardException>().having((e) => e.code, 'code', code),
    );

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late String sourcePath;
  late String outputDirectory;

  setUpAll(() async {
    await initializeComPDFKitSDK();
    sourcePath =
        (await CPDFFileUtil.extractAsset('pdfs/PDF_Document.pdf')).path;
    final temp = await ComPDFKit.getTemporaryDirectory();
    final directory = Directory('${temp.path}/pdf_standard_integration');
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

  testWidgets('a plain PDF reports pdf', (tester) async {
    final document = await openDocument(sourcePath);
    expect(await document.getPdfStandardType(), CPDFPdfStandardType.pdf);
  });

  testWidgets('converts to every supported standard and reads it back',
      timeout: const Timeout(Duration(minutes: 5)), (tester) async {
    final document = await openDocument(sourcePath);
    final mismatches = <String>[];

    for (final target in supportedTargets) {
      final outputPath = '$outputDirectory/${target.value}.pdf';
      try {
        final success = await document.convertToPdfStandard(outputPath, target);
        expect(success, isTrue, reason: target.value);
      } on CPDFPdfStandardException catch (e) {
        mismatches.add('${target.value}: ${e.code} ${e.message}');
        continue;
      }

      final output = await CPDFDocument.createInstance();
      try {
        final error = await output.open(outputPath);
        if (error != CPDFDocumentError.success) {
          mismatches.add('${target.value}: reopen failed with ${error.name}');
          continue;
        }
        final actual = await output.getPdfStandardType();
        debugPrint('PDF standard ${target.value} -> ${actual.value}');
        if (actual != target) {
          mismatches.add('${target.value}: read back ${actual.value}');
        }
      } finally {
        await output.close();
      }
    }

    expect(mismatches, isEmpty, reason: mismatches.join('\n'));
    // The opened document and its source file keep the original standard.
    expect(await document.getPdfStandardType(), CPDFPdfStandardType.pdf);
    final source = await openDocument(sourcePath);
    expect(await source.getPdfStandardType(), CPDFPdfStandardType.pdf);
  });

  testWidgets('PDF/E-1 either round-trips or reports the native reason',
      (tester) async {
    final document = await openDocument(sourcePath);
    final outputPath =
        '$outputDirectory/${CPDFPdfStandardType.pdfE1.value}.pdf';
    try {
      expect(
        await document.convertToPdfStandard(
            outputPath, CPDFPdfStandardType.pdfE1),
        isTrue,
      );
    } on CPDFPdfStandardException catch (e) {
      debugPrint('PDF standard pdf_e_1 -> ${e.code}: ${e.message}');
      expect(e.code, 'PDF_STANDARD_CONVERT_FAILED');
      expect(e.message, isNotEmpty);
      return;
    }
    final output = await openDocument(outputPath);
    expect(await output.getPdfStandardType(), CPDFPdfStandardType.pdfE1);
  });

  testWidgets('writes without font subsets', (tester) async {
    final document = await openDocument(sourcePath);
    final outputPath = '$outputDirectory/pdf_a_2b_no_subset.pdf';
    expect(
      await document.convertToPdfStandard(
        outputPath,
        CPDFPdfStandardType.pdfA2b,
        fontSubset: false,
      ),
      isTrue,
    );
    expect(File(outputPath).existsSync(), isTrue);
  });

  testWidgets('rejects invalid output paths and keeps the source',
      (tester) async {
    final document = await openDocument(sourcePath);

    await expectLater(
      document.convertToPdfStandard('  ', CPDFPdfStandardType.pdfA2b),
      throwsStandardError('INVALID_OUTPUT_PATH'),
    );
    await expectLater(
      document.convertToPdfStandard(
        '$outputDirectory/missing/output.pdf',
        CPDFPdfStandardType.pdfA2b,
      ),
      throwsStandardError('INVALID_OUTPUT_PATH'),
    );
    await expectLater(
      document.convertToPdfStandard(sourcePath, CPDFPdfStandardType.pdfA2b),
      throwsStandardError('INVALID_OUTPUT_PATH'),
    );
    expect(File(sourcePath).existsSync(), isTrue);
    expect(await document.getPdfStandardType(), CPDFPdfStandardType.pdf);
  });

  testWidgets('rejects a document opened with a password', (tester) async {
    final file = await CPDFFileUtil.extractAsset(
        'pdfs/Password_compdfkit_Security_Sample_File.pdf');
    final document = await openDocument(file.path, password: 'compdfkit');
    await expectLater(
      document.convertToPdfStandard(
        '$outputDirectory/encrypted.pdf',
        CPDFPdfStandardType.pdfA2b,
      ),
      throwsStandardError('ENCRYPTED_DOCUMENT_NOT_CONVERTIBLE'),
    );
  });

  testWidgets('iOS rejects the targets its SDK does not support',
      skip: !Platform.isIOS, (tester) async {
    final document = await openDocument(sourcePath);
    for (final target in [
      CPDFPdfStandardType.pdfE2,
      CPDFPdfStandardType.pdf,
    ]) {
      await expectLater(
        document.convertToPdfStandard(
          '$outputDirectory/${target.value}.pdf',
          target,
        ),
        throwsStandardError('UNSUPPORTED_PDF_STANDARD'),
      );
    }
  });
}
