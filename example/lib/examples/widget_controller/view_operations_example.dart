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
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// View Operations Example
///
/// Demonstrates various PDF view operations and navigation features using
/// the [CPDFReaderWidgetController].
///
/// This example shows:
/// - Displaying thumbnail view for page navigation
/// - Opening BOTA (Bookmarks, Outline, Thumbnails, Annotations) panel
/// - Showing and hiding the text search interface
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.showThumbnailView]: Opens the thumbnail grid
///   for visual page navigation
/// - [CPDFReaderWidgetController.showBotaView]: Opens the BOTA panel for
///   bookmarks, outline, thumbnails, and annotations access
/// - [CPDFReaderWidgetController.showTextSearchView]: Displays the text
///   search interface
/// - [CPDFReaderWidgetController.hideTextSearchView]: Hides the text search
///   interface
///
/// Usage:
/// 1. Open a PDF document in the reader widget
/// 2. Tap the menu button to see available view operations
/// 3. Select an option to show thumbnails, BOTA panel, or search interface
class ViewOperationsExample extends StatelessWidget {
  /// Constructor
  const ViewOperationsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'View Operations',
      assetPath: _assetPath,
      builder: (path) => _ViewOperationsPage(documentPath: path),
    );
  }
}

class _ViewOperationsPage extends ExampleBase {
  const _ViewOperationsPage({required super.documentPath});

  @override
  State<_ViewOperationsPage> createState() => _ViewOperationsPageState();
}

class _ViewOperationsPageState extends ExampleBaseState<_ViewOperationsPage> {
  static const List<String> _menuActions = [
    'Show Thumbnails',
    'Show BOTA',
    'Show Search',
    'Hide Search',
  ];

  @override
  String get pageTitle => 'View Operations';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Show Thumbnails':
        controller.showThumbnailView(false);
        break;
      case 'Show BOTA':
        controller.showBotaView();
        break;
      case 'Show Search':
        controller.showTextSearchView();
        break;
      case 'Hide Search':
        controller.hideTextSearchView();
        break;
    }
  }
}
