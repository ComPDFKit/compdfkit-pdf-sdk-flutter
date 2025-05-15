// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_annotations_list_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFAnnotationsExample extends StatelessWidget {
  final String documentPath;

  const CPDFAnnotationsExample({super.key, required this.documentPath});

  static const _actions = [
    'Save',
    'Import Annotations 1',
    'Import Annotations 2',
    'Export Annotations',
    'Remove All Annotations',
    'Get Annotations'
  ];

  @override
  Widget build(BuildContext context) {
    return CPDFReaderPage(
      title: 'Annotations Example',
      documentPath: documentPath,
      configuration: CPDFConfiguration(
        annotationsConfig:
            const CPDFAnnotationsConfig(annotationAuthor: 'ComPDFKit-Flutter'),
        toolbarConfig: const CPDFToolbarConfig(
          iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail],
        ),
      ),
      appBarActions: (controller) => [
        PopupMenuButton<String>(
          onSelected: (value) => _handleAction(context, value, controller),
          itemBuilder: (context) => _actions.map((action) {
            return PopupMenuItem(value: action, child: Text(action));
          }).toList(),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String value,
      CPDFReaderWidgetController controller) async {
    switch (value) {
      case 'Save':
        bool saveResult = await controller.document.save();
        debugPrint('ComPDFKit: save():$saveResult');
        break;
      case "Import Annotations 1":
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null) {
          debugPrint('mimeType: ${result.files.first.extension}');
          if (result.files.first.extension != 'xfdf') {
            debugPrint('Please select a xfdf file.');
            return;
          }
          bool importResult = await controller.document
              .importAnnotations(result.files.first.path!);
          debugPrint('ComPDFKit:Document: importAnnotations:$importResult');
        }
        break;
      case "Import Annotations 2":
        // android assets:
        // String? xfdfFile = "file:///android_asset/test.xfdf";

        // android file path sample:
        File xfdfFile = await extractAsset(context, 'pdfs/test.xfdf');

        // android Uri:
        //String xfdfFile = "content://xxx";

        bool result =
            await controller.document.importAnnotations(xfdfFile.path);
        debugPrint('ComPDFKit:Document: importAnnotations:$result');
        break;
      case "Export Annotations":
        String xfdfPath = await controller.document.exportAnnotations();
        debugPrint('ComPDFKit:Document: exportAnnotations:$xfdfPath');
        break;
      case "Remove All Annotations":
        await controller.document.removeAllAnnotations();
        break;
      case 'Get Annotations':
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
          if(data == null){
            return;
          }
          String type = data['type'];
          CPDFAnnotation annotation = data['annotation'];
          if (type == 'jump') {
            await controller.setDisplayPageIndex(annotation.page);
          } else if (type == 'remove') {
            CPDFPage page = controller.document.pageAtIndex(annotation.page);
            bool result = await page.removeAnnotation(annotation);
            debugPrint('ComPDFKit:Document: removeAnnotation:$result');
          }
        }
        break;
    }
  }
}
