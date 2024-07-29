/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
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
import 'package:compdfkit_flutter_example/cpdf_reader_widget_controller_example.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_widget_dark_theme_example.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'cpdf_reader_widget_example.dart';
import 'widgets/cpdf_fun_item.dart';

const String _documentPath = 'pdfs/PDF_Document.pdf';

List<Widget> examples(BuildContext context) => [
  Padding(padding: const EdgeInsets.only(top: 8, bottom: 8), child: Text(
    'Widget Examples',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
  )),
  FeatureItem(
      title: 'Show CPDFReaderWidget',
      description: 'Display PDF view in flutter widget',
      onTap: () => showCPDFReaderWidget(context)),
  if (Platform.isAndroid) ...[
    FeatureItem(title: 'CPDFReaderWidget Dark Theme',
        description: 'Opens a document in night mode with a custom dark theme',
        onTap: () => showDarkThemeCPDFReaderWidget(context))
  ],
  FeatureItem(title: 'Widget Controller Examples',
      description: 'CPDFReaderWidget Controller fun example',
      onTap: () => showCPDFReaderWidgetTest(context)),

  Padding(padding: const EdgeInsets.only(top: 8, bottom: 8), child: Text(
    'Modal View Examples',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
  )),

  FeatureItem(
      title: 'Basic Example',
      description: 'Open sample pdf document',
      onTap: () => showDocument(context)),
  FeatureItem(
      title: 'Select External Files',
      description: 'Select pdf document from system file manager',
      onTap: () => pickDocument())
];


void showDocument(context) async {
  File document = await extractAsset(context, _documentPath);
  ComPDFKit.openDocument(document.path,
      password: '', configuration: CPDFConfiguration());
}

void pickDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null) {
    ComPDFKit.openDocument(result.files.first.path!,
        password: '', configuration: CPDFConfiguration());
  }
}

void showCPDFReaderWidget(context) async {
  File document = await extractAsset(context, _documentPath, shouldOverwrite: false);
  goTo(CPDFReaderWidgetExample(documentPath: document.path), context);
}

void showDarkThemeCPDFReaderWidget(context) async {
  File document = await extractAsset(context, _documentPath, shouldOverwrite: false);
  goTo(CPDFDarkThemeExample(documentPath: document.path), context);
}

void showCPDFReaderWidgetTest(context) async {
  File document = await extractAsset(context, _documentPath, shouldOverwrite: false);
  goTo(CPDFReaderWidgetControllerExample(documentPath: document.path), context);
}

void goTo(Widget widget, BuildContext context) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));