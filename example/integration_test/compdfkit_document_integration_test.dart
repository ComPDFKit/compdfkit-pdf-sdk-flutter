// Integration test: run on Android/iOS device to fetch real fonts
// Usage: flutter test integration_test/compdfkit_get_fonts_integration_test.dart -d <deviceId>

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
