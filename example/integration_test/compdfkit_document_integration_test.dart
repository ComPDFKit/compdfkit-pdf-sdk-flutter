// Integration test: run on Android/iOS device to fetch real fonts
// Usage: flutter test integration_test/compdfkit_get_fonts_integration_test.dart -d <deviceId>

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Initialize ComPDFKit SDK with license file from assets. Call before any test.
Future<void> initializeComPDFKitSDK() async {
  final licenseFile =
      await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml');
  final ok = await ComPDFKit.initWithPath(licenseFile.path);
  if (!ok) {
    fail('ComPDFKit SDK initialization failed (license: ${licenseFile.path}).');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeComPDFKitSDK();
  });

  group('CPDFDocument', () {
    testWidgets('search returns readable text ranges and no false hits',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final file = await CPDFFileUtil.extractAsset('pdfs/annot_test.pdf');
      final document = await CPDFDocument.createInstance();
      addTearDown(document.close);
      expect(await document.open(file.path), CPDFDocumentError.success);

      final searcher = document.getTextSearcher();
      final matches = await searcher.searchText('Highlight Annotation');
      expect(matches, isNotEmpty);
      final first = matches.first;
      expect(first.pageIndex, 0);
      expect(await document.pageAtIndex(first.pageIndex).getText(first),
          'Highlight Annotation');
      expect(await searcher.searchText('this-query-is-not-in-the-fixture'),
          isEmpty);
    });

    testWidgets('persists a page inserted into a standalone document',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final source = await CPDFFileUtil.extractAsset('pdfs/annot_test.pdf');
      final tempDir = await Directory.systemTemp.createTemp('compdfkit-save-');
      addTearDown(() => tempDir.delete(recursive: true));
      final file = await source.copy('${tempDir.path}/save-test.pdf');
      final document = await CPDFDocument.createInstance();
      addTearDown(document.close);
      expect(await document.open(file.path), CPDFDocumentError.success);

      final pageCount = await document.getPageCount();
      expect(await document.insertBlankPage(pageIndex: 0), isTrue);
      expect(await document.save(), isTrue);

      final reopened = await CPDFDocument.createInstance();
      addTearDown(reopened.close);
      expect(await reopened.open(file.path), CPDFDocumentError.success);
      expect(await reopened.getPageCount(), pageCount + 1);
    });

    testWidgets('opens a normal PDF',
        timeout: const Timeout(Duration(seconds: 30)), (tester) async {
      final file = await CPDFFileUtil.extractAsset('pdfs/annot_test.pdf');
      final document = await CPDFDocument.createInstance();
      addTearDown(() async {
        await document.close();
      });

      final error = await document.open(file.path);
      expect(error, CPDFDocumentError.success);
    });

    testWidgets('fails with wrong password, succeeds with correct password',
        timeout: const Timeout(Duration(seconds: 60)), (tester) async {
      final file = await CPDFFileUtil.extractAsset(
          'pdfs/Password_compdfkit_Security_Sample_File.pdf');
      final document = await CPDFDocument.createInstance();
      addTearDown(() async {
        await document.close();
      });

      final errorWrong =
          await document.open(file.path, password: 'wrongpassword');
      expect(errorWrong, CPDFDocumentError.errorPassword,
          reason: 'Should fail with wrong password');

      final errorCorrect =
          await document.open(file.path, password: 'compdfkit');
      expect(errorCorrect, CPDFDocumentError.success,
          reason: 'Should succeed with correct password');
    });
  });
}
