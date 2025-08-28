// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFSecurityExample extends StatelessWidget {
  final String documentPath;

  final String password;

  const CPDFSecurityExample(
      {super.key, required this.documentPath, this.password = ''});

  static const _actions = [
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
  Widget build(BuildContext context) {
    return CPDFReaderPage(
        title: 'Security Example',
        documentPath: documentPath,
        password: password,
        configuration: CPDFConfiguration(
            toolbarConfig: const CPDFToolbarConfig(
                iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail])),
        onIOSClickBackPressed: (){
          Navigator.pop(context);
        },
        appBarActions: (controller) => [
              PopupMenuButton<String>(
                onSelected: (value) =>
                    _handleAction(context, value, controller),
                itemBuilder: (context) => _actions.map((action) {
                  return PopupMenuItem(value: action, child: Text(action));
                }).toList(),
              ),
            ]);
  }

  void _handleAction(BuildContext context, String value,
      CPDFReaderWidgetController controller) async {
    switch (value) {
      case 'Set Password':
        bool setPasswordResult = await controller.document.setPassword(
            userPassword: '1234',
            ownerPassword: '12345',
            allowsPrinting: false,
            allowsCopying: false,
            encryptAlgo: CPDFDocumentEncryptAlgo.aes256);
        debugPrint('ComPDFKit:set_user_password:$setPasswordResult');
        break;
      case 'Remove Password':
        bool removePasswordResult = await controller.document.removePassword();
        debugPrint('ComPDFKit:remove_user_password:$removePasswordResult');
        break;
      case 'Check Owner Password':
        bool result = await controller.document.checkOwnerPassword('12345');
        debugPrint('ComPDFKit:check_owner_password:$result');
        break;
      case 'Create Text Watermark':
        await controller.document.createWatermark(CPDFWatermark.text(
            textContent: 'Flutter',
            scale: 1.0,
            fontSize: 60,
            rotation: 0,
            horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
            verticalAlignment: CPDFWatermarkVerticalAlignment.center,
            textColor: Colors.red,
            pages: [0, 1, 2, 3]));
        break;
      case 'Create Image Watermark':
        File imageFile = await extractAsset(context, 'images/logo.png');
        await controller.document.createWatermark(CPDFWatermark.image(
          imagePath: imageFile.path,
          opacity: 1,
          scale: 1,
          rotation: 45,
          pages: [0, 1, 2, 3],
          horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
          verticalAlignment: CPDFWatermarkVerticalAlignment.center,
        ));
        break;
      case 'Create Image Watermark Pick Image':
        FilePickerResult? pickerResult = await FilePicker.platform
            .pickFiles(type: FileType.image, allowMultiple: false);
        if (pickerResult != null) {
          debugPrint('ComPDFKit:Document:${pickerResult.files.first.path}');
          await controller.document.createWatermark(CPDFWatermark.image(
            imagePath: pickerResult.files.first.path!,
            pages: [0, 1, 2, 3],
            scale: 0.3,
            horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
            verticalAlignment: CPDFWatermarkVerticalAlignment.center,
          ));
          return;
        }
        break;
      case 'Remove All Watermarks':
        await controller.document.removeAllWatermarks();
        break;
      case 'Flatten All Pages':

        final tempDir = await ComPDFKit.getTemporaryDirectory();
        String savePath =
            '${tempDir.path}/${await controller.document.getFileName()}';

        // var uri = await ComPDFKit.createUri('flatten_test.pdf');
        debugPrint('ComPDFKit:Document:$savePath');
        bool flattenResult = await controller.document.flattenAllPages(savePath, true);
        debugPrint('ComPDFKit:flatten_all_pages:$flattenResult');
        if (flattenResult) {
          controller.document.open(savePath);
        }
        break;
      case 'Document Info':
        var document = controller.document;
        debugPrint(
            'ComPDFKit:Document: fileName:${await document.getFileName()}');
        debugPrint(
            'ComPDFKit:Document: checkOwnerUnlocked:${await document.checkOwnerUnlocked()}');
        debugPrint(
            'ComPDFKit:Document: isEncrypted:${await document.isEncrypted()}');
        debugPrint(
            'ComPDFKit:Document: getPermissions:${await document.getPermissions()}');
        debugPrint(
            'ComPDFKit:Document: getEncryptAlgorithm:${await document.getEncryptAlgo()}');
        break;
    }
  }
}
