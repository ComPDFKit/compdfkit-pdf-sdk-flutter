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
import 'package:flutter/material.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';

import 'cpdf_reader_widget_example.dart';
import 'cpdf_dark_theme_example.dart';
import 'cpdf_controller_example.dart';
import 'cpdf_security_example.dart';
import 'cpdf_annotations_example.dart';
import 'cpdf_form_creation_example.dart';
import 'cpdf_content_editor_example.dart';
import 'cpdf_widgets_example.dart';
import 'cpdf_pages_example.dart';
import 'cpdf_search_example.dart';
import 'cpdf_document_example_list_screen.dart';
import 'widgets/cpdf_fun_item.dart';

const String _defaultDocument = 'pdfs/PDF_Document.pdf';

/// Configuration model for each example item
class ExampleConfig {
  final String title;
  final String description;
  final String? assetPath;
  final bool openInModal;
  final Widget Function(String path)? widgetBuilder;
  final bool requiresFilePicker; // 是否需要用户选择文件

  const ExampleConfig({
    required this.title,
    required this.description,
    this.assetPath,
    this.openInModal = false,
    this.widgetBuilder,
    this.requiresFilePicker = false,
  });
}

/// Example list configuration
final List<ExampleConfig> _widgetExamples = [
  ExampleConfig(
    title: 'Reader Widget',
    description: 'Display a PDF inside a custom Flutter widget.',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFReaderWidgetExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Open External File',
    description: 'Pick and open a PDF file from the system file manager.',
    widgetBuilder: (path) => CPDFReaderWidgetExample(documentPath: path),
    requiresFilePicker: true,
  ),
  if (Platform.isAndroid)
    ExampleConfig(
      title: 'Dark Theme',
      description: 'Open a PDF with a custom night/dark theme.',
      assetPath: _defaultDocument,
      widgetBuilder: (path) => CPDFDarkThemeExample(documentPath: path),
    ),
  ExampleConfig(
    title: 'Reader Controller',
    description: 'Control the reader widget programmatically (zoom, navigation, etc.).',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFControllerExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Security',
    description: 'Configure document security: passwords, watermarks, and permissions.',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFSecurityExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Annotations',
    description: 'Create, edit, and delete PDF annotations.',
    assetPath: 'pdfs/annot_test.pdf',
    widgetBuilder: (path) => CPDFAnnotationsExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Form Creation',
    description: 'Create and manage interactive PDF form fields (text, checkbox, radio).',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFFormCreationExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Content Editing',
    description: 'Switch between different content editing modes using API.',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFContentEditorExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Form Data (Import/Export)',
    description: 'Manage form data: retrieve, modify, import, and export.',
    assetPath: 'pdfs/annot_test.pdf',
    widgetBuilder: (path) => CPDFWidgetsExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Page Management',
    description: 'Insert, delete, split, and reorder PDF pages.',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CPDFPagesExample(documentPath: path),
  ),
  ExampleConfig(
    title: 'Text Search',
    description: 'Search, highlight, and navigate text content via APIs.',
    assetPath: _defaultDocument,
    widgetBuilder: (path) => CpdfSearchExample(documentPath: path),
  ),
];

final List<ExampleConfig> _modalExamples = [
  const ExampleConfig(
    title: 'Modal (Basic)',
    description: 'Open a sample PDF using modal presentation.',
    assetPath: _defaultDocument,
    openInModal: true,
  ),
  const ExampleConfig(
    title: 'Modal (External File)',
    description: 'Pick and open a PDF in modal presentation mode.',
    openInModal: true,
    requiresFilePicker: true
  ),
];

final List<ExampleConfig> _documentExamples = [
  ExampleConfig(
    title: 'CPDFDocument API',
    description: 'Use CPDFDocument directly for operations like open, XFDF import/export, and password setting.',
    widgetBuilder: (_) => const CPDFDocumentExamplesScreen(),
  ),
];

/// =======================
/// Build example widgets
/// =======================
List<Widget> examples(BuildContext context) {
  return [
    _sectionTitle(context, 'Widget Examples'),
    ..._widgetExamples.map((e) => _buildFeatureItem(context, e)),
    _sectionTitle(context, 'Modal View Examples'),
    ..._modalExamples.map((e) => _buildFeatureItem(context, e)),
    _sectionTitle(context, 'CPDFDocument Examples'),
    ..._documentExamples.map((e) => _buildFeatureItem(context, e)),
  ];
}

Widget _buildFeatureItem(BuildContext context, ExampleConfig config) {
  return FeatureItem(
    title: config.title,
    description: config.description,
    onTap: () async {
      String? path;

      if (config.widgetBuilder != null && !config.requiresFilePicker && config.assetPath == null && !config.openInModal) {
        if (context.mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => config.widgetBuilder!('')));
        }
        return;
      }

      if (config.assetPath != null) {
        final file = await extractAsset(context, config.assetPath!, shouldOverwrite: false);
        path = file.path;
      }

      if (config.requiresFilePicker) {
        path = await pickDocument();
        if (path == null) return;
      }

      if (config.openInModal && path != null) {
        ComPDFKit.openDocument(path, password: '', configuration: CPDFConfiguration());
        return;
      }

      if (config.widgetBuilder != null && path != null && context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => config.widgetBuilder!(path!)));
      }
    },
  );
}

/// File picker helper
Future<String?> pickDocument() => ComPDFKit.pickFile();

/// Section title widget
Widget _sectionTitle(BuildContext context, String title) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: Text(
    title,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
  ),
);