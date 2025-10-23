/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:flutter/material.dart';
import 'examples/document/cpdf_document_open_pdf_example.dart';
import 'examples/document/cpdf_document_annotation_example.dart';
import 'examples/document/cpdf_document_widget_example.dart';
import 'examples/document/cpdf_document_search_text_example.dart';
import 'examples/document/cpdf_document_render_page_example.dart';

/// Single document example item
class DocumentExampleItem {
  final String title;
  final Widget page;

  const DocumentExampleItem({required this.title, required this.page});
}

/// List of document examples
final List<DocumentExampleItem> documentExamples = [
  const DocumentExampleItem(title: 'Open PDF Document', page: CPDFDocumentOpenPDFExample()),
  const DocumentExampleItem(title: 'Manage Annotations', page: CPDFDocumentAnnotationExample()),
  const DocumentExampleItem(title: 'Form & Widget Handling', page: CPDFDocumentWidgetExample()),
  const DocumentExampleItem(title: 'Text Search', page: CPDFDocumentSearchTextExample()),
  const DocumentExampleItem(title: 'Render Page to Image', page: CPDFDocumentRenderPageExample()),
];

/// CPDFDocument example menu screen
class CPDFDocumentExamplesScreen extends StatelessWidget {
  const CPDFDocumentExamplesScreen({super.key});

  void _openExamplePage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPDFDocument APIs Examples'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: documentExamples.length,
        separatorBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 0.5,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          final example = documentExamples[index];
          return ListTile(
            title: Text(example.title),
            onTap: () => _openExamplePage(context, example.page),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
    );
  }
}