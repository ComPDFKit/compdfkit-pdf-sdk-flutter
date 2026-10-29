// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

// Integration test: digital signature timestamp and LTV on a device or simulator.
//
// The timestamp tests need network access to the TSA. The LTV fixture tests
// need a signed PDF that already carries LTV material plus the PEM root of its
// signer chain. Neither file is committed; pass them at run time:
//
//   flutter test integration_test/compdfkit_signature_ltv_integration_test.dart \
//     -d <deviceId> \
//     --dart-define=LTV_FIXTURE_PDF=/path/to/ltv_signed.pdf \
//     --dart-define=LTV_TRUSTED_ROOT=/path/to/root.pem
//
// On Android, push both files to a readable path on the device first.

import 'dart:io';
import 'dart:math';

import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const String _timestampServerUrl = 'http://timestamp.digicert.com';
const String _ltvFixturePdf = String.fromEnvironment('LTV_FIXTURE_PDF');
const String _ltvTrustedRoot = String.fromEnvironment('LTV_TRUSTED_ROOT');

Future<void> _initializeSdk() async {
  final licenseFile =
      await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml');
  final ok = await ComPDFKit.initWithPath(licenseFile.path);
  if (!ok) {
    fail('ComPDFKit SDK initialization failed.');
  }
}

Future<Directory> _outputDirectory() async {
  final temp = await ComPDFKit.getTemporaryDirectory();
  final directory = Directory('${temp.path}/signature_ltv_it');
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
  return directory..createSync(recursive: true);
}

String _runtimePassword() {
  final random = Random.secure();
  return List.generate(16, (_) => random.nextInt(36).toRadixString(36)).join();
}

Future<CPDFDocument> _openDocument(String path) async {
  final document = await CPDFDocument.createInstance();
  final error = await document.open(path);
  expect(error, CPDFDocumentError.success, reason: 'open $path');
  return document;
}

Future<CPDFSignatureWidget> _firstSignatureWidget(CPDFDocument document) async {
  final pageCount = await document.getPageCount();
  for (var index = 0; index < pageCount; index++) {
    final widgets = await document.pageAtIndex(index).getWidgets();
    for (final widget in widgets) {
      if (widget is CPDFSignatureWidget) {
        return widget;
      }
    }
  }
  fail('No signature form field found.');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory output;
  late String certificatePath;
  late String certificatePassword;
  late String sourcePath;

  setUpAll(() async {
    await _initializeSdk();
    output = await _outputDirectory();
    certificatePath = '${output.path}/it_signer.p12';
    certificatePassword = _runtimePassword();
    final created = await ComPDFKit.generatePkcs12Certificate(
      CPDFCertificateRequest(
        subject: const CPDFCertificateSubject(
          commonName: 'ComPDF Flutter Timestamp IT',
          organization: 'PDF Technologies',
          country: 'SG',
        ),
        password: certificatePassword,
        outputPath: certificatePath,
      ),
    );
    expect(created, isTrue);
    sourcePath = (await CPDFFileUtil.extractAsset(
      'assets/unsigned_signature.pdf',
      shouldOverwrite: true,
    ))
        .path;
  });

  testWidgets('signs with an embedded RFC 3161 timestamp',
      timeout: const Timeout(Duration(seconds: 90)), (tester) async {
    final document = await _openDocument(sourcePath);
    addTearDown(document.close);
    final widget = await _firstSignatureWidget(document);
    final signedPath = '${output.path}/timestamp_signed.pdf';

    final signed = await document.writeSignature(
      widget,
      signedPath,
      CPDFDigitalSignatureConfig(
        certificatePath: certificatePath,
        password: certificatePassword,
        reason: 'Timestamp integration test',
        timestampServerUrl: _timestampServerUrl,
      ),
    );
    expect(signed, isTrue);

    final signedDocument = await _openDocument(signedPath);
    addTearDown(signedDocument.close);
    final signatures = await signedDocument.getDigitalSignatures();
    expect(signatures, isNotEmpty);
    final result = await signedDocument.verifyDigitalSignature(
      signatures.first.signatureIndex,
    );
    expect(result.signatureValid, isTrue);
    expect(result.timestampSource, CPDFSignatureTimestampSource.embedded);
    expect(result.embeddedTimestampValid, isTrue);
    expect(result.ltvEnabled, isFalse);

    final readiness = await signedDocument.getLtvReadiness();
    expect(readiness.success, isTrue);
    expect(readiness.ltvReady, isFalse);
    expect(readiness.missingMaterials, isNotEmpty);
  });

  testWidgets('reports an unreachable TSA without writing the output',
      timeout: const Timeout(Duration(seconds: 90)), (tester) async {
    final document = await _openDocument(sourcePath);
    addTearDown(document.close);
    final widget = await _firstSignatureWidget(document);
    final signedPath = '${output.path}/timestamp_unreachable.pdf';

    await expectLater(
      document.writeSignature(
        widget,
        signedPath,
        CPDFDigitalSignatureConfig(
          certificatePath: certificatePath,
          password: certificatePassword,
          timestampServerUrl: 'http://127.0.0.1:9/tsa',
        ),
      ),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'signature_timestamp_failed',
        ),
      ),
    );
  });

  testWidgets('adding LTV to a self-signed signature reports the reason',
      timeout: const Timeout(Duration(seconds: 90)), (tester) async {
    final document = await _openDocument(sourcePath);
    addTearDown(document.close);
    final widget = await _firstSignatureWidget(document);
    final signedPath = '${output.path}/self_signed.pdf';
    expect(
      await document.writeSignature(
        widget,
        signedPath,
        CPDFDigitalSignatureConfig(
          certificatePath: certificatePath,
          password: certificatePassword,
        ),
      ),
      isTrue,
    );
    final rootPath = '${output.path}/unrelated_root.pem';
    File(rootPath).writeAsStringSync(
      '-----BEGIN CERTIFICATE-----\nMA==\n-----END CERTIFICATE-----\n',
    );

    final signedDocument = await _openDocument(signedPath);
    addTearDown(signedDocument.close);
    final result = await signedDocument.addSignatureLtv(
      '${output.path}/self_signed_ltv.pdf',
      CPDFSignatureLtvOptions(trustedCertificatePath: rootPath),
    );

    expect(result.success, isFalse);
    expect(result.finalPath, isEmpty);
    expect(result.errors, isNotEmpty);
  });

  group('LTV fixture', () {
    // Skipped unless LTV_FIXTURE_PDF and LTV_TRUSTED_ROOT are passed.
    final skip = _ltvFixturePdf.isEmpty || _ltvTrustedRoot.isEmpty;

    testWidgets('reports LTV readiness and embedded timestamp', skip: skip,
        (tester) async {
      final document = await _openDocument(_ltvFixturePdf);
      addTearDown(document.close);

      final readiness = await document.getLtvReadiness();
      expect(readiness.success, isTrue);
      expect(readiness.ltvReady, isTrue);
      expect(readiness.hasDss, isTrue);
      expect(readiness.hasVri, isTrue);

      final signatures = await document.getDigitalSignatures();
      expect(signatures, isNotEmpty);
      final result = await document.verifyDigitalSignature(
        signatures.first.signatureIndex,
      );
      expect(result.ltvEnabled, isTrue);
      expect(result.timestampSource, CPDFSignatureTimestampSource.embedded);
      expect(result.embeddedTimestampValid, isTrue);
    });

    testWidgets('adds LTV material and a document timestamp',
        skip: skip,
        timeout: const Timeout(Duration(seconds: 120)), (tester) async {
      final document = await _openDocument(_ltvFixturePdf);
      addTearDown(document.close);
      final ltvPath = '${output.path}/fixture_ltv.pdf';
      final ltaPath = '${output.path}/fixture_lta.pdf';

      final result = await document.addSignatureLtv(
        ltvPath,
        CPDFSignatureLtvOptions(
          trustedCertificatePath: _ltvTrustedRoot,
          appendDocumentTimestamp: true,
          timestampServerUrl: _timestampServerUrl,
          timestampOutputPath: ltaPath,
        ),
      );
      expect(result.success, isTrue, reason: result.errors.join('\n'));
      expect(result.ltvPath, isNotEmpty);
      expect(result.finalPath, result.ltaPath);
      expect(File(result.finalPath).existsSync(), isTrue);

      final timestamped = await _openDocument(result.finalPath);
      addTearDown(timestamped.close);
      final readiness = await timestamped.getLtvReadiness();
      expect(readiness.ltvReady, isTrue);
      expect(readiness.hasCertificates, isTrue);
      final signatures = await timestamped.getDigitalSignatures();
      final sources = <CPDFSignatureTimestampSource>[];
      for (final signature in signatures) {
        final verification =
            await timestamped.verifyDigitalSignature(signature.signatureIndex);
        sources.add(verification.timestampSource);
      }
      expect(sources, contains(CPDFSignatureTimestampSource.document));
    });
  });
}
