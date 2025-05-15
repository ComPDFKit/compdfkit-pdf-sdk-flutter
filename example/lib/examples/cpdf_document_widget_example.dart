/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:convert';
import 'dart:io';

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

class CPDFDocumentWidgetExample extends StatefulWidget {
  const CPDFDocumentWidgetExample({super.key});

  @override
  State<CPDFDocumentWidgetExample> createState() =>
      _CPDFDocumentExampleState();
}

class _CPDFDocumentExampleState extends State<CPDFDocumentWidgetExample> {
  List<String> logs = List.empty(growable: true);

  late CPDFDocument document;

  List<CPDFWidget> widgets = [];
  @override
  void initState() {
    super.initState();
    openDocument();
  }

  Future<void> openDocument() async {
    File encryptPDF = await extractAsset(
        context, shouldOverwrite: true, 'pdfs/annot_test.pdf');

    applyLog('filePath:${encryptPDF.path}\n');
    document = await CPDFDocument.createInstance();
    var error = await document.open(encryptPDF.path);

    applyLog('open result:${error.name}\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () async {
                clearLogs();
                widgets.clear();

                int pageCount = await document.getPageCount();
                for (int i = 0; i < pageCount; i++) {
                  CPDFPage page = document.pageAtIndex(i);
                  var pageWidgets = await page.getWidgets();
                  widgets.addAll(pageWidgets);
                }
                applyLog('Annotations Size: ${widgets.length}\n');
                final dynamic jsonData =
                json.decode(jsonEncode(widgets));
                const JsonEncoder encoder = JsonEncoder.withIndent('  ');
                final String prettyJson = encoder.convert(jsonData);
                applyLog(prettyJson);
              },
              child: const Text('Get Annotations')),
          TextButton(
              onPressed: () async {
                if (widgets.isNotEmpty) {
                  CPDFWidget firstWidget = widgets[0];
                  printJsonString(jsonEncode(firstWidget));
                  CPDFPage page = document.pageAtIndex(firstWidget.page);
                  bool result = await page.removeWidget(firstWidget);
                  clearLogs();
                  applyLog('ComPDFKit:Document: removeWidget:$result');
                }
              },
              child: const Text('Delete First')),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: SingleChildScrollView(
                child: Text(
              logs.join(),
              style: const TextStyle(fontSize: 12),
            )),
          ))
        ],
      ),
    );
  }

  void applyLog(String msg) {
    setState(() {
      logs.add(msg);
    });
  }

  void clearLogs() {
    setState(() {
      logs.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
