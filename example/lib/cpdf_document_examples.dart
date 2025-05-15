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
import 'package:compdfkit_flutter_example/examples/cpdf_document_open_pdf_example.dart';
import 'package:flutter/material.dart';

import 'examples/cpdf_document_annotation_example.dart';
import 'examples/cpdf_document_widget_example.dart';

class CPDFDocumentExamples extends StatelessWidget {
  const CPDFDocumentExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('CPDFDocument Examples'),
        ),
        body: ListView.builder(
            itemCount: examples(context).length,
            itemBuilder: (context, index) {
              return examples(context)[index];
            }));
  }

  List<Widget> examples(BuildContext context) => [
        ListTile(
          title: const Text('OpenEncryptPDFTest'),
          onTap: () {
            goTo(const CPDFDocumentOpenPDFExample(), context);
          },
        ),
        ListTile(
          title: const Text('AnnotationsTest'),
          onTap: () {
            goTo(const CPDFDocumentAnnotationExample(), context);
          },
        ),
        ListTile(
          title: const Text('WidgetsTest'),
          onTap: () {
            goTo(const CPDFDocumentWidgetExample(), context);
          },
        )
      ];
}
