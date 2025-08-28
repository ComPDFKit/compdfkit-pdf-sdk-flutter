/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:flutter/material.dart';

import '../../utils/file_util.dart';
import 'log_info_page.dart';

abstract class BaseDocumentExample extends StatefulWidget {
  const BaseDocumentExample({super.key});

  String get assetPath; // Example: 'pdfs/PDF_Document.pdf'
  String get title;

  @override
  State<BaseDocumentExample> createState() => BaseDocumentExampleState();
}

class BaseDocumentExampleState<T extends BaseDocumentExample> extends State<T> {
  List<String> logs = [];
  late CPDFDocument document;

  @override
  void initState() {
    super.initState();
    openDocument();
  }

  Future<void> openDocument() async {
    File file = await extractAsset(context, shouldOverwrite: true, widget.assetPath);
    applyLog('filePath: ${file.path}');
    document = await CPDFDocument.createInstance();
    final error = await document.open(file.path);
    applyLog('Open result: ${error.name}');
    onDocumentReady();
  }

  /// Called after the document is successfully opened
  void onDocumentReady() {}

  void applyLog(String msg) {
    setState(() {
      logs.add('$msg\n');
    });
  }

  void clearLogs() {
    setState(() {
      logs.clear();
    });
  }

  /// Child class should override this to add buttons
  List<Widget> buildExampleContent(BuildContext context) => [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...buildExampleContent(context),
          Expanded(child: LogInfoPage(logs: logs)),
        ],
      ),
    );
  }
}