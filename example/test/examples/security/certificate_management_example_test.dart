// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter_example/examples/security/certificate_management_example.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildExample() => const MaterialApp(
        home: CertificateManagementExample(),
      );

  testWidgets('shows the compact certificate management workflow',
      (tester) async {
    await tester.pumpWidget(buildExample());

    expect(find.text('Certificate source'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
    expect(find.text('Choose existing'), findsOneWidget);
    expect(find.text('No certificate selected'), findsOneWidget);
    expect(find.text('Certificate actions'), findsOneWidget);
    expect(find.text('View certificate details'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('SDK-managed certificate storage'),
      200,
    );
    expect(find.text('Platform storage'), findsOneWidget);
    expect(find.text('SDK-managed certificate storage'), findsOneWidget);
    expect(
      find.text(
        'Certificates are stored in the application sandbox. Custom certificate directories are not supported.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('adapts source and action cards on a narrow screen',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildExample());

    expect(find.text('Generate'), findsOneWidget);
    expect(find.text('Unlock certificate'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the certificate generation flow', (tester) async {
    await tester.pumpWidget(buildExample());

    await tester.tap(find.text('Generate'));
    await tester.pumpAndSettle();

    expect(find.text('Generate certificate'), findsWidgets);
    expect(find.text('Certificate identity'), findsOneWidget);
    expect(find.text('Advanced identity fields'), findsOneWidget);
    expect(find.text('Output path'), findsOneWidget);
  });

  testWidgets('keeps certificate selection open when its password is invalid',
      (tester) async {
    const sdkChannel = MethodChannel('com.compdfkit.flutter.plugin');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final previousFilePicker = FilePickerIO();
    FilePicker.platform = previousFilePicker;
    FilePicker.platform = _TestFilePicker();
    messenger.setMockMethodCallHandler(
      sdkChannel,
      (call) async =>
          call.method == 'check_pkcs12_certificate_password' ? false : null,
    );
    addTearDown(() {
      messenger.setMockMethodCallHandler(sdkChannel, null);
      FilePicker.platform = previousFilePicker;
    });

    await tester.pumpWidget(buildExample());
    await tester.tap(find.text('Choose existing'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Browse files'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'wrong-password');
    await tester.tap(find.text('Use certificate'));
    await tester.pumpAndSettle();

    expect(find.text('Choose certificate'), findsOneWidget);
    expect(find.text('Incorrect PKCS#12 password.'), findsOneWidget);
  });
}

class _TestFilePicker extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async =>
      FilePickerResult([
        PlatformFile(path: '/tmp/example.p12', name: 'example.p12', size: 1),
      ]);
}
