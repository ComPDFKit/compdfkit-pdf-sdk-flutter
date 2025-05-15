// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_widget_list_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CPDFWidgetsExample extends StatelessWidget {
  final String documentPath;

  const CPDFWidgetsExample({super.key, required this.documentPath});

  static const _actions = [
    'Open Document',
    'Import Widgets',
    'Export Widgets',
    'Get Widgets'
  ];

  @override
  Widget build(BuildContext context) {
    return CPDFReaderPage(
        title: 'Widgets Example',
        documentPath: documentPath,
        configuration: CPDFConfiguration(
          toolbarConfig: const CPDFToolbarConfig(
            iosLeftBarAvailableActions: [
              CPDFToolbarAction.thumbnail
            ]
          )
        ),
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
      case 'Open Document':
        String? path = await ComPDFKit.pickFile();
        if (path != null) {
          var document = controller.document;
          var error = await document.open(path);
          debugPrint('ComPDFKit:Document: open:$error');
        }
        break;
      case 'Import Widgets':
        File xfdfFile = await extractAsset(
            context, 'pdfs/annot_test_widgets.xfdf',
            shouldOverwrite: false);
        bool importResult =
            await controller.document.importWidgets(xfdfFile.path);
        debugPrint('ComPDFKit:Document: importWidgets:$importResult');
        break;
      case 'Export Widgets':
        String xfdfPath = await controller.document.exportWidgets();
        debugPrint('ComPDFKit:Document: exportWidgets:$xfdfPath');
        break;
      case 'Get Widgets':
        int pageCount = await controller.document.getPageCount();
        List<CPDFWidget> widgets = [];
        for(int i = 0; i < pageCount; i++){
          CPDFPage page = controller.document.pageAtIndex(i);
          var pageWidgets = await page.getWidgets();
          widgets.addAll(pageWidgets);
        }
        if (context.mounted) {
          Map<String, dynamic> data = await showModalBottomSheet(
              context: context,
              builder: (context) =>
                  CpdfWidgetListPage(widgets: widgets));
          String type = data['type'];
          CPDFWidget widget = data['widget'];
          if (type == 'jump') {
            await controller.setDisplayPageIndex(widget.page);
          } else if (type == 'remove') {
            CPDFPage page = controller.document.pageAtIndex(widget.page);
            bool result = await page.removeWidget(widget);
            debugPrint('ComPDFKit:Document: removeWidget:$result');
          }
        }
        break;
      default:
        break;
    }
  }
}
