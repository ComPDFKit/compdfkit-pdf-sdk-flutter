// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'dart:io';
import 'dart:ui' as ui;

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFPagesExample extends CPDFExampleBase {
  const CPDFPagesExample({super.key, required super.documentPath});

  @override
  State<CPDFPagesExample> createState() => _CPDFPagesExampleState();
}

class _CPDFPagesExampleState extends CPDFExampleBaseState<CPDFPagesExample> {
  static const List<String> _menuActions = [
    'Save',
    'Import Document',
    'Insert Blank Page',
    'Insert Image Page',
    'Split Document',
    'Set Rotation',
    'Remove Pages',
    'Move Page'
  ];

  @override
  String get pageTitle => 'Pages Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration();

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Save':
        _handleSave(controller);
        break;
      case 'Import Document':
        _handleImportDocument(controller);
        break;
      case 'Insert Blank Page':
        _handleInsertBlankPage(controller);
        break;
      case 'Insert Image Page':
        _handleInsertImagePage(controller);
        break;
      case 'Split Document':
        _handleSplitDocument(controller);
        break;
      case 'Set Rotation':
        _handleSetRotation(controller);
        break;
      case 'Remove Pages':
        _handleRemovePages(controller);
        break;
      case 'Move Page':
        _handleMovePage(controller);
        break;
    }
  }

  void _handleSave(CPDFReaderWidgetController controller) async {
    final saveResult = await controller.document.save();
    debugPrint('Save document result: $saveResult');
  }

  void _handleImportDocument(CPDFReaderWidgetController controller) async {
    final path = await ComPDFKit.pickFile();
    if (path != null) {
      final importResult = await controller.document.importDocument(
        filePath: path,
        pages: [0],
        insertPosition: 0,
      );
      debugPrint('Import document result: $importResult');
    }
  }

  void _handleInsertBlankPage(CPDFReaderWidgetController controller) async {
    final insertResult = await controller.document.insertBlankPage(
      pageIndex: 0,
      pageSize: CPDFPageSize.a4,
    );
    debugPrint('Insert blank page result: $insertResult');

    if (insertResult) {
      controller.reloadPages();
    }
  }

void _handleInsertImagePage(CPDFReaderWidgetController controller) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image);
  if (result != null && result.files.isNotEmpty) {
    final platformFile = result.files.first;
    final filePath = platformFile.path!;
    final bytes = await File(filePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final width = image.width;
    final height = image.height;
    final insertResult = await controller.document.insertPageWithImagePath(
      pageIndex: 0,
      imagePath: filePath,
      pageSize: CPDFPageSize.custom(width, height),
    );
    debugPrint('Insert image page result: $insertResult');
    if (insertResult) {
      controller.reloadPages();
    }
  }
}

  void _handleSplitDocument(CPDFReaderWidgetController controller) async {
    const pages = [0];

    final tempDir = await ComPDFKit.getTemporaryDirectory();

    final fileName = await controller.document.getFileName();
    final fileNameNoExtension =
    fileName.substring(0, fileName.lastIndexOf('.'));
    final fileExtension = fileName.substring(fileName.lastIndexOf('.'));
    String splitFileName = '${fileNameNoExtension}_(${pages.join(',')})$fileExtension';
    String savePath = '${tempDir.path}/$splitFileName';
    File saveFile = File(savePath);

    int counter = 0;
    while (await saveFile.exists()) {
      counter++;
      splitFileName = '${fileNameNoExtension}_(${pages.join(',')})($counter)$fileExtension';
      savePath = '${tempDir.path}/$splitFileName';
      saveFile = File(savePath);
    }

    debugPrint('Split document - fileName: $splitFileName');
    debugPrint('Split document - savePath: $savePath');

    final splitResult = await controller.document.splitDocumentPages(savePath, pages);
    debugPrint('Split document result: $splitResult');

    if (splitResult) {
      ComPDFKit.openDocument(savePath);
    }
  }


  void _handleSetRotation(CPDFReaderWidgetController controller) async {
    const pageIndex = 0;
    final page = controller.document.pageAtIndex(pageIndex);
    final currentRotation = await page.getRotation();
    final newAngle = currentRotation + 90;

    debugPrint('Page $pageIndex - current rotation: $currentRotation');
    debugPrint('Page $pageIndex - new angle: $newAngle');

    final result = await page.setRotation(newAngle);
    debugPrint('Set rotation result: $result');

    if (result) {
      controller.reloadPages();
    }
  }

  void _handleRemovePages(CPDFReaderWidgetController controller) async {
    const removePages = [0];
    bool removeResult = await controller.document.removePages(removePages);
    debugPrint('ComPDFKit:removePages():$removeResult');
    if(removeResult){
      controller.reloadPages2();
    }
  }

  void _handleMovePage(CPDFReaderWidgetController controller) async {
    const fromIndex = 0;
    const toIndex = 1;
    bool moveResult = await controller.document.movePage(
        fromIndex: fromIndex, toIndex: toIndex);
    debugPrint('ComPDFKit:movePage():$moveResult');
    if(moveResult){
      controller.reloadPages2();
    }
  }

}
