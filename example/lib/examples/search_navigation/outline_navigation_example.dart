// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../features/outline/outline_list_page.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

import '../../constants/asset_paths.dart';

/// Outline Navigation Example
///
/// Demonstrates how to navigate a PDF document using its table of contents
/// (outline/TOC structure).
///
/// This example shows:
/// - Accessing the PDF document's outline structure
/// - Displaying a hierarchical outline list with nested chapters
/// - Navigating to specific sections by tapping outline items
///
/// Key classes/APIs used:
/// - [CPDFDocument.getOutline]: Retrieves the document's outline/TOC structure
/// - [CPDFOutline]: Data class representing an outline item with title and destination
/// - [OutlineListPage]: UI component for displaying the hierarchical outline
///
/// Usage:
/// 1. Open a PDF document that contains an outline/TOC
/// 2. Tap "Open Outline" from the menu
/// 3. Browse the hierarchical outline and tap any item to navigate to that section
class OutlineNavigationExample extends StatelessWidget {
  /// Constructor
  const OutlineNavigationExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Outline Navigation',
      assetPath: _assetPath,
      builder: (path) => _OutlineNavigationPage(documentPath: path),
    );
  }
}

class _OutlineNavigationPage extends ExampleBase {
  const _OutlineNavigationPage({required super.documentPath});

  @override
  State<_OutlineNavigationPage> createState() => _OutlineNavigationPageState();
}

class _OutlineNavigationPageState
    extends ExampleBaseState<_OutlineNavigationPage> {
  static const List<String> _menuActions = ['Open Outline'];

  @override
  String get pageTitle => 'Outline Navigation';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == 'Open Outline') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutlineListPage(document: controller.document),
        ),
      );
    }
  }
}
