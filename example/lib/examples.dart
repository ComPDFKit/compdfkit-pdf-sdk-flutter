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

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter_example/cpdf_document_examples.dart';
import 'package:compdfkit_flutter_example/cpdf_controller_example.dart';
import 'package:compdfkit_flutter_example/cpdf_dark_theme_example.dart';
import 'package:compdfkit_flutter_example/cpdf_pages_example.dart';
import 'package:compdfkit_flutter_example/cpdf_security_example.dart';
import 'package:compdfkit_flutter_example/cpdf_widgets_example.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'cpdf_annotations_example.dart';
import 'cpdf_reader_widget_example.dart';
import 'widgets/cpdf_fun_item.dart';

const String _documentPath = 'pdfs/PDF_Document.pdf';

List<Widget> examples(BuildContext context) => [
      _title(context, 'Widget Examples'),
      FeatureItem(
          title: 'Show CPDFReaderWidget',
          description: 'Display PDF view in flutter widget',
          onTap: () async {
            File document = await extractAsset(context, _documentPath,
                shouldOverwrite: false);
            if (context.mounted) {
              showCPDFReaderWidget(context, document.path);
            }
          }),
      FeatureItem(
          title: 'Select External Files',
          description: 'Select pdf document from system file manager',
          onTap: () async {
            String? path = await pickDocument();
            if (context.mounted) {
              showCPDFReaderWidget(context, path);
            }
          }),
      if (Platform.isAndroid) ...[
        FeatureItem(
            title: 'CPDFReaderWidget Dark Theme',
            description:
                'Opens a document in night mode with a custom dark theme',
            onTap: () async {
              File document = await extractAsset(context, _documentPath,
                  shouldOverwrite: false);
              if (context.mounted) {
                goTo(
                    CPDFDarkThemeExample(documentPath: document.path), context);
              }
            })
      ],
      FeatureItem(
          title: 'Widget Controller Examples',
          description: 'CPDFReaderWidget Controller fun example',
          onTap: () async {
            File document = await extractAsset(context, _documentPath,
                shouldOverwrite: false);
            if (context.mounted) {
              goTo(CPDFControllerExample(documentPath: document.path), context);
            }
          }),
      FeatureItem(
          title: 'Security feature Examples',
          description:
              'This example shows how to set passwords, watermarks, etc.',
          onTap: () async {
            File document = await extractAsset(context, _documentPath,
                shouldOverwrite: false);
            if (context.mounted) {
              goTo(CPDFSecurityExample(documentPath: document.path), context);
            }
          }),
      FeatureItem(
          title: 'Annotations Examples',
          description:
              'Demonstrate how to implement annotation functionality using the CPDFReaderWidget , including adding, editing, and deleting annotations.',
          onTap: () async {
            File document = await extractAsset(context, 'pdfs/annot_test.pdf',
                shouldOverwrite: false);
            if (context.mounted) {
              goTo(
                  CPDFAnnotationsExample(documentPath: document.path), context);
            }
          }),
      FeatureItem(
          title: 'Widgets Examples',
          description:
              'Demonstrate form functionality in CPDFReaderWidget, including retrieving, modifying, importing, and exporting data.',
          onTap: () async {
            File document = await extractAsset(context, 'pdfs/annot_test.pdf',
                shouldOverwrite: false);
            if (context.mounted) {
              goTo(CPDFWidgetsExample(documentPath: document.path), context);
            }
          }),
      FeatureItem(
      title: 'Pages Examples',
      description:
      'This example demonstrates PDF page related operations, such as inserting and splitting PDF documents.',
      onTap: () async {
        File document = await extractAsset(context, _documentPath,
            shouldOverwrite: false);
        if (context.mounted) {
          goTo(CPDFPagesExample(documentPath: document.path), context);
        }
      }),
      _title(context, 'Modal View Examples'),
      FeatureItem(
          title: 'Basic Example',
          description: 'Open sample pdf document',
          onTap: () async {
            File document = await extractAsset(context, _documentPath);
            ComPDFKit.openDocument(document.path,
                password: '', configuration: CPDFConfiguration());
          }),
      FeatureItem(
          title: 'Select External Files',
          description: 'Select pdf document from system file manager',
          onTap: () async {
            String? path = await pickDocument();
            if (path != null) {
              ComPDFKit.openDocument(path,
                  password: '', configuration: CPDFConfiguration());
            }
          }),
      _title(context, 'CPDFDocument Examples'),
      FeatureItem(
          title: 'CPDFDocument Example',
          description:
              'This example demonstrates how to use CPDFDocument independently for PDF document operations, including opening documents, importing and exporting XFDF annotation files, setting passwords, and more.',
          onTap: () async {
            goTo(const CPDFDocumentExamples(), context);
          }),
    ];

Future<String?> pickDocument() async {
  return await ComPDFKit.pickFile();
}

void showCPDFReaderWidget(context, String? path) async {
  goTo(CPDFReaderWidgetExample(documentPath: path!), context);
}

void goTo(Widget widget, BuildContext context) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));

Widget _title(BuildContext context, String title) {
  return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.w500),
      ));
}
