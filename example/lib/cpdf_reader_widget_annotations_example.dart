// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:math';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CPDFReaderWidgetAnnotationsExample extends StatefulWidget {
  final String documentPath;

  const CPDFReaderWidgetAnnotationsExample(
      {super.key, required this.documentPath});

  @override
  State<CPDFReaderWidgetAnnotationsExample> createState() =>
      _CPDFReaderWidgetAnnotationsExampleState();
}

class _CPDFReaderWidgetAnnotationsExampleState
    extends State<CPDFReaderWidgetAnnotationsExample> {
  CPDFReaderWidgetController? _controller;

  bool pageSameWidth = true;

  bool isFixedScroll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('CPDFReaderWidget Example'),
          leading: IconButton(
              onPressed: () {
                _save();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: null == _controller ? null : _buildAppBarActions(context),
        ),
        body: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: CPDFConfiguration(
              toolbarConfig: const CPDFToolbarConfig(
                  iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail])),
          onCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
        ));
  }

  void _save() async {
    bool saveResult = await _controller!.document.save();
    debugPrint('ComPDFKit-Flutter: saveResult:$saveResult');
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          handleClick(value, _controller!);
        },
        itemBuilder: (context) {
          return actions.map((action) {
            return PopupMenuItem(
              value: action,
              child: Text(action),
            );
          }).toList();
        },
      ),
    ];
  }

  void handleClick(String value, CPDFReaderWidgetController controller) async {
    switch (value) {
      case 'Save':
        bool saveResult = await controller.document.save();
        debugPrint('ComPDFKit: save():$saveResult');
        break;
      case "Import Annotations 1":
        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
        if(result != null) {
          debugPrint('mimeType: ${result.files.first.extension}');
          if(result.files.first.extension != 'xfdf') {
            debugPrint('Please select a xfdf file.');
            return;
          }
          bool importResult = await controller.document.importAnnotations(result.files.first.path!);
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
    }
  }
}

var actions = [
  'Save',
  'Import Annotations 1',
  'Import Annotations 2',
  'Export Annotations',
  'Remove All Annotations',
];

Color randomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha value (fully opaque)
    random.nextInt(256), // Red value
    random.nextInt(256), // Green value
    random.nextInt(256), // Blue value
  );
}
