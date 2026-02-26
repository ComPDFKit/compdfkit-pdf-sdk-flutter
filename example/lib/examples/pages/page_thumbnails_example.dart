// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import 'pages/page_thumbnails_list_page.dart';
import '../../constants/asset_paths.dart';

/// Page Thumbnails Example
///
/// Demonstrates how to generate and display thumbnail images of PDF pages.
///
/// This example shows:
/// - Displaying the built-in thumbnail view provided by the SDK
/// - Rendering custom page thumbnails using the page rendering API
/// - Navigating between the main document view and thumbnail gallery
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.showThumbnailView]: Shows the built-in thumbnail navigation view
/// - [PageThumbnailsListPage]: Custom page that renders thumbnails using the page API
/// - [CPDFPage.renderPage]: Renders a page to an image at specified dimensions
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Select a thumbnail option from the menu:
///    - "Show Normal Thumbnails" to display the SDK's built-in thumbnail view
///    - "Render Thumbnails" to navigate to a custom thumbnail gallery page
/// 3. Use thumbnails to preview pages or navigate within the document
class PageThumbnailsExample extends StatelessWidget {
  /// Constructor
  const PageThumbnailsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Page Thumbnails',
      assetPath: _assetPath,
      builder: (path) => _PageThumbnailsPage(documentPath: path),
    );
  }
}

class _PageThumbnailsPage extends ExampleBase {
  const _PageThumbnailsPage({required super.documentPath});

  @override
  State<_PageThumbnailsPage> createState() => _PageThumbnailsPageState();
}

class _PageThumbnailsPageState extends ExampleBaseState<_PageThumbnailsPage> {
  static const List<String> _menuActions = [
    'Show Normal Thumbnails',
    'Render Thumbnails',
  ];

  @override
  String get pageTitle => 'Page Thumbnails';

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
    if (action == 'Show Normal Thumbnails') {
      controller.showThumbnailView(false);
    } else if (action == 'Render Thumbnails') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageThumbnailsListPage(controller: controller),
        ),
      );
    }
  }
}
