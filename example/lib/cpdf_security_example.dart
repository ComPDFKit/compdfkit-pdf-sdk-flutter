// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_configuration_manager.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFSecurityExample extends CPDFExampleBase {

  const CPDFSecurityExample({super.key, required super.documentPath, super.password});

  @override
  State<CPDFSecurityExample> createState() => _CpdfSecurityExampleState();
}

class _CpdfSecurityExampleState extends CPDFExampleBaseState<CPDFSecurityExample> {

  static const _menuActions = [
    'Set Password',
    'Remove Password',
    'Check Owner Password',
    'Create Text Watermark',
    'Create Image Watermark',
    'Create Image Watermark Pick Image',
    'Remove All Watermarks',
    'Flatten All Pages',
    'Document Info'
  ];


  @override
  String get pageTitle => 'Security Example';

  @override
  CPDFConfiguration get configuration => CPDFConfigurationManager.defaultConfig;

  @override
  List<String> get menuActions => _menuActions;

  @override
  void onIOSClickBackPressed() {
    Navigator.pop(context);
  }

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Set Password':
        _handleSetPassword(controller);
        break;
      case 'Remove Password':
        _handleRemovePassword(controller);
        break;
      case 'Check Owner Password':
        _handleCheckOwnerPassword(controller);
        break;
      case 'Create Text Watermark':
        _handleCreateTextWatermark(controller);
        break;
      case 'Create Image Watermark':
        _handleCreateImageWatermark(controller);
        break;
      case 'Create Image Watermark Pick Image':
        _handleCreateImageWatermarkPickImage(controller);
        break;
      case 'Remove All Watermarks':
        _handleRemoveAllWatermarks(controller);
        break;
      case 'Flatten All Pages':
        _handleFlattenAllPages(controller);
        break;
      case 'Document Info':
        _handleDocumentInfo(controller);
        break;
    }
  }

  void _handleSetPassword(CPDFReaderWidgetController controller) async {
    final result = await controller.document.setPassword(
      userPassword: '1234',
      ownerPassword: '12345',
      allowsPrinting: false,
      allowsCopying: false,
      encryptAlgo: CPDFDocumentEncryptAlgo.aes256,
    );
    debugPrint('Set password result: $result');
  }

  void _handleRemovePassword(CPDFReaderWidgetController controller) async {
    final result = await controller.document.removePassword();
    debugPrint('Remove password result: $result');
  }

  void _handleCheckOwnerPassword(CPDFReaderWidgetController controller) async {
    final result = await controller.document.checkOwnerPassword('12345');
    debugPrint('Check owner password result: $result');
  }

  void _handleCreateTextWatermark(CPDFReaderWidgetController controller) async {
    await controller.document.createWatermark(
      CPDFWatermark.text(
        textContent: 'Flutter',
        scale: 1.0,
        fontSize: 60,
        rotation: 0,
        horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
        verticalAlignment: CPDFWatermarkVerticalAlignment.center,
        textColor: Colors.red,
        pages: [0, 1, 2, 3],
      ),
    );
    debugPrint('Text watermark created');
  }

  void _handleCreateImageWatermark(CPDFReaderWidgetController controller) async {
    final imageFile = await extractAsset(context, 'images/logo.png');
    await controller.document.createWatermark(
      CPDFWatermark.image(
        imagePath: imageFile.path,
        opacity: 1,
        scale: 1,
        rotation: 45,
        pages: [0, 1, 2, 3],
        horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
        verticalAlignment: CPDFWatermarkVerticalAlignment.center,
      ),
    );
    debugPrint('Image watermark created with logo');
  }

  void _handleCreateImageWatermarkPickImage(CPDFReaderWidgetController controller) async {
    final pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (pickerResult != null && pickerResult.files.first.path != null) {
      debugPrint('Selected image path: ${pickerResult.files.first.path}');
      await controller.document.createWatermark(
        CPDFWatermark.image(
          imagePath: pickerResult.files.first.path!,
          pages: [0, 1, 2, 3],
          scale: 0.3,
          horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
          verticalAlignment: CPDFWatermarkVerticalAlignment.center,
        ),
      );
      debugPrint('Image watermark created from picked image');
    }
  }

  void _handleRemoveAllWatermarks(CPDFReaderWidgetController controller) async {
    await controller.document.removeAllWatermarks();
    debugPrint('All watermarks removed');
  }

  void _handleFlattenAllPages(CPDFReaderWidgetController controller) async {
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    final fileName = await controller.document.getFileName();
    final savePath = '${tempDir.path}/$fileName';

    debugPrint('Flatten save path: $savePath');
    final result = await controller.document.flattenAllPages(savePath, true);
    debugPrint('Flatten all pages result: $result');

    if (result) {
      await controller.document.open(savePath);
    }
  }

  void _handleDocumentInfo(CPDFReaderWidgetController controller) async {
    final document = controller.document;
    debugPrint('Document Info:');
    debugPrint('  File name: ${await document.getFileName()}');
    debugPrint('  Owner unlocked: ${await document.checkOwnerUnlocked()}');
    debugPrint('  Is encrypted: ${await document.isEncrypted()}');
    debugPrint('  Permissions: ${await document.getPermissions()}');
    debugPrint('  Encrypt algorithm: ${await document.getEncryptAlgo()}');
  }

}
