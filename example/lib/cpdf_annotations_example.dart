// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/page/annotations/cpdf_annotations_list_page.dart';
import 'package:compdfkit_flutter_example/page/annotations/tools/cpdf_annotation_tools_widget.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFAnnotationsExample extends CPDFExampleBase {
  const CPDFAnnotationsExample({super.key, required super.documentPath});

  @override
  State<CPDFAnnotationsExample> createState() => _CPDFAnnotationsExampleState();
}

class _CPDFAnnotationsExampleState extends CPDFExampleBaseState<CPDFAnnotationsExample> {
  static const List<String> _menuActions = [
    'Save',
    'Import Annotations 1',
    'Import Annotations 2',
    'Export Annotations',
    'Remove All Annotations',
    'Get Annotations',
    'Clear Display Rect',
    'Save Current Ink',
    'Save Current Pencil'
  ];

  @override
  String get pageTitle => 'Annotations Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
    modeConfig: const CPDFModeConfig(
      initialViewMode: CPDFViewMode.annotations,
      uiVisibilityMode: CPDFUIVisibilityMode.never,
    ),
    toolbarConfig: const CPDFToolbarConfig(mainToolbarVisible: false),
  );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void onTapMainDocArea() {
    debugPrint('ComPDFKit-Flutter: onTapMainDocAreaCallback');
  }

  @override
  Widget buildContent() {
    return Column(
      children: [
        Expanded(child: super.buildContent()),
        if (controller != null)
          CPDFAnnotationToolsWidget(controller: controller!),
      ],
    );
  }

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Save':
        _handleSave(controller);
        break;
      case 'Import Annotations 1':
        _handleImportAnnotations1(controller);
        break;
      case 'Import Annotations 2':
        _handleImportAnnotations2(controller);
        break;
      case 'Export Annotations':
        _handleExportAnnotations(controller);
        break;
      case 'Remove All Annotations':
        _handleRemoveAllAnnotations(controller);
        break;
      case 'Get Annotations':
        _handleGetAnnotations(controller);
        break;
      case 'Clear Display Rect':
        _handleClearDisplayRect(controller);
        break;
      case 'Save Current Ink':
        _handleSaveCurrentInk(controller);
        break;
      case 'Save Current Pencil':
        _handleSaveCurrentPencil(controller);
        break;
    }
  }

  void _handleSave(CPDFReaderWidgetController controller) async {
    final result = await controller.document.save();
    debugPrint('Save result: $result');
  }

  void _handleImportAnnotations1(CPDFReaderWidgetController controller) async {
    final xfdfFile = await extractAsset(context, 'pdfs/test.xfdf');
    final result = await controller.document.importAnnotations(xfdfFile.path);
    debugPrint('Import annotations 1 result: $result');
  }

  void _handleImportAnnotations2(CPDFReaderWidgetController controller) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xfdf'],
    );

    if (result != null && result.files.single.path != null) {
      final importResult = await controller.document.importAnnotations(result.files.single.path!);
      debugPrint('Import annotations 2 result: $importResult');
    }
  }

  void _handleExportAnnotations(CPDFReaderWidgetController controller) async {
    await controller.saveCurrentInk();
    final path = await controller.document.exportAnnotations();
    debugPrint('Export annotations path: $path');
  }

  void _handleRemoveAllAnnotations(CPDFReaderWidgetController controller) async {
    final removeResult = await controller.document.removeAllAnnotations();
    debugPrint('Remove All Annotations result: $removeResult');
  }

  void _handleGetAnnotations(CPDFReaderWidgetController controller) async {
    int pageCount = await controller.document.getPageCount();
    List<CPDFAnnotation> annotations = [];
    for (int i = 0; i < pageCount; i++) {
      CPDFPage page = controller.document.pageAtIndex(i);
      var pageAnnotations = await page.getAnnotations();
      annotations.addAll(pageAnnotations);
    }
    if (context.mounted) {
      Map<String, dynamic>? data = await showModalBottomSheet(
          context: context,
          builder: (context) =>
              CpdfAnnotationsListPage(annotations: annotations));
      if (data == null) {
        return;
      }
      String type = data['type'];
      CPDFAnnotation annotation = data['annotation'];
      if (type == 'jump') {
        await controller.setDisplayPageIndex(pageIndex: annotation.page, rectList: [annotation.rect]);
      } else if (type == 'remove') {
        CPDFPage page = controller.document.pageAtIndex(annotation.page);
        bool result = await page.removeAnnotation(annotation);
        debugPrint('ComPDFKit:Document: removeAnnotation:$result');
      }
    }
  }

  void _handleClearDisplayRect(CPDFReaderWidgetController controller) async {
    await controller.clearDisplayRect();
    debugPrint('Display rect cleared');
  }

  void _handleSaveCurrentInk(CPDFReaderWidgetController controller) async {
    await controller.saveCurrentInk();
    debugPrint('saveCurrentInk');
  }

  void _handleSaveCurrentPencil(CPDFReaderWidgetController controller) async {
    await controller.saveCurrentPencil();
    debugPrint('saveCurrentPencil');
  }
}
