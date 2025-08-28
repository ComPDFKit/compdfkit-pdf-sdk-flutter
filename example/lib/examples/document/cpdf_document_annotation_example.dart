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

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:flutter/material.dart';

import 'base_document_example.dart';

class CPDFDocumentAnnotationExample extends BaseDocumentExample {
  const CPDFDocumentAnnotationExample({super.key});

  @override
  String get assetPath => 'pdfs/annot_test.pdf';

  @override
  String get title => 'Annotations Example';

  @override
  State<CPDFDocumentAnnotationExample> createState() =>
      _CPDFDocumentAnnotationExampleState();
}

class _CPDFDocumentAnnotationExampleState
    extends BaseDocumentExampleState<CPDFDocumentAnnotationExample> {
  final List<CPDFAnnotation> annotations = [];

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: _getAnnotations,
        child: const Text('Get Annotations'),
      ),
      TextButton(
        onPressed: _deleteFirstAnnotation,
        child: const Text('Delete First'),
      ),
    ];
  }

  Future<void> _getAnnotations() async {
    clearLogs();
    annotations.clear();
    int pageCount = await document.getPageCount();

    for (int i = 0; i < pageCount; i++) {
      final page = document.pageAtIndex(i);
      final pageAnnotations = await page.getAnnotations();
      annotations.addAll(pageAnnotations);
    }

    applyLog('Annotations found: ${annotations.length}');

    final jsonData = json.decode(jsonEncode(annotations));
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
    applyLog(prettyJson);
  }

  Future<void> _deleteFirstAnnotation() async {
    if (annotations.isEmpty) return;

    final first = annotations.first;
    final page = document.pageAtIndex(first.page);
    final result = await page.removeAnnotation(first);
    clearLogs();
    applyLog('Removed annotation result: $result');
  }
}