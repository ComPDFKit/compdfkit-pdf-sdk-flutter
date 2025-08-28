/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/examples/document/cpdf_document_open_pdf_example.dart';
import 'package:compdfkit_flutter_example/examples/document/cpdf_document_search_text_example.dart';
import 'package:flutter/material.dart';

import 'examples/document/cpdf_document_annotation_example.dart';
import 'examples/document/cpdf_document_widget_example.dart';

// Example model
class CPDFExample {
  final String title;
  final Widget page;

  const CPDFExample({required this.title, required this.page});
}

// Example list
final List<CPDFExample> cpdfExamples = [
  const CPDFExample(title: 'Open PDF Test', page: CPDFDocumentOpenPDFExample()),
  const CPDFExample(title: 'Annotations Test', page: CPDFDocumentAnnotationExample()),
  const CPDFExample(title: 'Widgets Test', page: CPDFDocumentWidgetExample()),
  const CPDFExample(title: 'Search Text Test', page: CPDFDocumentSearchTextExample()),
];

// Example menu screen
class CPDFDocumentExampleListScreen extends StatelessWidget {
  const CPDFDocumentExampleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CPDFDocument Examples'),
      ),
      body: ListView.builder(
        itemCount: cpdfExamples.length,
        itemBuilder: (context, index) {
          final example = cpdfExamples[index];
          return ListTile(
            title: Text(example.title),
            onTap: () => goTo(example.page, context),
          );
        },
      ),
    );
  }
}
