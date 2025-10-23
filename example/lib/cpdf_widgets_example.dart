// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/page/cpdf_widget_list_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CPDFWidgetsExample extends CPDFExampleBase {
  const CPDFWidgetsExample({super.key, required super.documentPath});

  @override
  State<CPDFWidgetsExample> createState() => _CPDFWidgetsExampleState();
}

class _CPDFWidgetsExampleState extends CPDFExampleBaseState<CPDFWidgetsExample> {
  static const List<String> _menuActions = [
    'Open Document',
    'Import Widgets',
    'Export Widgets',
    'Get Widgets',
  ];

  @override
  String get pageTitle => 'Widgets Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
    toolbarConfig: const CPDFToolbarConfig(
      iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail],
    ),
  );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Open Document':
        _handleOpenDocument(controller);
        break;
      case 'Import Widgets':
        _handleImportWidgets(controller);
        break;
      case 'Export Widgets':
        _handleExportWidgets(controller);
        break;
      case 'Get Widgets':
        _handleGetWidgets(controller);
        break;
    }
  }

  void _handleOpenDocument(CPDFReaderWidgetController controller) async {
    final path = await ComPDFKit.pickFile();
    if (path != null) {
      final error = await controller.document.open(path);
      debugPrint('Open document result: $error');
    }
  }

  void _handleImportWidgets(CPDFReaderWidgetController controller) async {
    final xfdfFile = await extractAsset(
      context,
      'pdfs/annot_test_widgets.xfdf',
      shouldOverwrite: false,
    );
    final importResult = await controller.document.importWidgets(xfdfFile.path);
    debugPrint('Import widgets result: $importResult');
  }

  void _handleExportWidgets(CPDFReaderWidgetController controller) async {
    final xfdfPath = await controller.document.exportWidgets();
    debugPrint('Export widgets path: $xfdfPath');
  }

  void _handleGetWidgets(CPDFReaderWidgetController controller) async {
    final pageCount = await controller.document.getPageCount();
    final List<CPDFWidget> widgets = [];

    for (int i = 0; i < pageCount; i++) {
      final page = controller.document.pageAtIndex(i);
      final pageWidgets = await page.getWidgets();
      widgets.addAll(pageWidgets);
    }

    if (context.mounted) {
      final data = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        builder: (context) => CpdfWidgetListPage(widgets: widgets),
      );

      if (data != null) {
        final type = data['type'] as String;
        final widget = data['widget'] as CPDFWidget;

        if (type == 'jump') {
          await controller.setDisplayPageIndex(pageIndex: widget.page, rectList: [widget.rect]);
        } else if (type == 'remove') {
          final page = controller.document.pageAtIndex(widget.page);
          final result = await page.removeWidget(widget);
          debugPrint('Remove widget result: $result');
        }
      }
    }
  }
}
