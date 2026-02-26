// Integration test: run on Android/iOS device to fetch real fonts
// Usage: flutter test integration_test/compdfkit_get_fonts_integration_test.dart -d <deviceId>

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<File> _copyAssetToTemp(String assetPath, String fileName) async {
  // Get temp dir via plugin to avoid extra deps
  final tempDir = await ComPDFKit.getTemporaryDirectory();
  final target = File('${tempDir.path}/$fileName');
  final data = await rootBundle.load(assetPath);
  await target.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    flush: true,
  );
  return target;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Initialize SDK using initWithPath (offline license file)',
      (tester) async {
    // Copy the license XML from assets to a temporary file
    final licenseFile = await _copyAssetToTemp(
        'assets/license_key_flutter.xml', 'compdfkit_license.xml');

    // Initialize the SDK using ComPDFKit.initWithPath and the license file path
    final initWithPath = await ComPDFKit.initWithPath(licenseFile.path);
    debugPrint('ComPDFKit.initWithPath: $initWithPath');

    final versionCode = await ComPDFKit.getVersionCode();
    final buildTag = await ComPDFKit.getSDKBuildTag();
    debugPrint('ComPDFKit SDK Version: $versionCode, BuildTag: $buildTag');

    expect(initWithPath, true);
  });

  testWidgets('Initialize SDK using initialize (online license key from asset)',
      (tester) async {
    // Load the license XML content from assets
    final xmlString =
        await rootBundle.loadString('assets/license_key_flutter.xml');
    // Extract the <key> value from the XML
    final keyReg = RegExp(r'<key>(.*?)<\/key>', dotAll: true);
    final match = keyReg.firstMatch(xmlString);
    expect(match, isNotNull, reason: 'Cannot find <key> tag in license XML');
    final key = match!.group(1)!.trim();

    // Initialize the SDK using ComPDFKit.initialize with the extracted key
    final result = await ComPDFKit.initialize(
      androidOnlineLicense: key,
      iosOnlineLicense: key,
    );
    debugPrint('ComPDFKit.initialize: $result');
    expect(result, true);
  });
}
