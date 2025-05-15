// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:flutter/material.dart';

class CPDFPagesExample extends StatelessWidget {
  final String documentPath;

  const CPDFPagesExample({super.key, required this.documentPath});

  static const _actions = [
    'Save',
    'Import Document',
    'Insert Blank Page',
    'Split Document'
  ];

  @override
  Widget build(BuildContext context) {
    return CPDFReaderPage(
        title: 'Pages Example',
        documentPath: documentPath,
        configuration: CPDFConfiguration(
            toolbarConfig: const CPDFToolbarConfig(
                iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail])),
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
      case 'Save':
        bool saveResult = await controller.document.save();
        debugPrint('ComPDFKit:save():$saveResult');
        break;
      case 'Import Document':
        String? path = await ComPDFKit.pickFile();
        if (path != null) {
          bool importResult = await controller.document.importDocument(
              filePath: path, pages: [0], insertPosition: 0);
          debugPrint('ComPDFKit:importDocument():$importResult');
        }
        break;
      case 'Insert Blank Page':
        bool insertResult = await controller.document.insertBlankPage(
            pageIndex: 0, pageSize: CPDFPageSize.a4);
        debugPrint('ComPDFKit:insertBlankPage():$insertResult');
        break;
      case 'Split Document':
        List<int> pages = [0];

        final tempDir = await ComPDFKit.getTemporaryDirectory();

        String fileNameNoExtension = await controller.document
            .getFileName()
            .then(
                (fileName) => fileName.substring(0, fileName.lastIndexOf('.')));

        String fileName = '${fileNameNoExtension}_(${pages.join(',')}).pdf';
        String savePath = '${tempDir.path}/$fileName';

        debugPrint('ComPDFKit:splitDocumentPages() fileName :$fileName');
        debugPrint('ComPDFKit:splitDocumentPages() savePath :$savePath');
        bool splitResult =
            await controller.document.splitDocumentPages(savePath, pages);
        debugPrint('ComPDFKit:splitDocumentPages():$splitResult');
        if(splitResult){
          ComPDFKit.openDocument(savePath);
        }
        break;
      default:
        break;
    }
  }
}
