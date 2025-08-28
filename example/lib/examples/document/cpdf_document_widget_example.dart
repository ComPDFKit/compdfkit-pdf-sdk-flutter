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

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:flutter/material.dart';

import 'base_document_example.dart';

class CPDFDocumentWidgetExample extends BaseDocumentExample {
  const CPDFDocumentWidgetExample({super.key});

  @override
  String get assetPath => 'pdfs/annot_test.pdf';

  @override
  String get title => 'Widgets Example';

  @override
  State<CPDFDocumentWidgetExample> createState() =>
      _CPDFDocumentWidgetExampleState();
}

class _CPDFDocumentWidgetExampleState
    extends BaseDocumentExampleState<CPDFDocumentWidgetExample> {
  final List<CPDFWidget> widgets = [];

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: _getWidgets,
        child: const Text('Get Widgets'),
      ),
      TextButton(
        onPressed: _deleteFirstWidget,
        child: const Text('Delete First'),
      ),
    ];
  }

  Future<void> _getWidgets() async {
    clearLogs();
    widgets.clear();
    int pageCount = await document.getPageCount();

    for (int i = 0; i < pageCount; i++) {
      final page = document.pageAtIndex(i);
      final pageWidgets = await page.getWidgets();
      widgets.addAll(pageWidgets);
    }

    applyLog('Widgets found: ${widgets.length}');
    final jsonData = json.decode(jsonEncode(widgets));
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
    applyLog(prettyJson);
  }

  Future<void> _deleteFirstWidget() async {
    if (widgets.isEmpty) return;

    final first = widgets.first;
    final page = document.pageAtIndex(first.page);
    final result = await page.removeWidget(first);
    clearLogs();
    applyLog('Removed widget result: $result');
  }
}