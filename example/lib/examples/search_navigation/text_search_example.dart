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

import '../../constants/asset_paths.dart';

/// Text Search Example
///
/// Demonstrates the built-in UI-based text search functionality with
/// automatic highlighting of search results.
///
/// This example shows:
/// - Showing the native text search view overlay
/// - Hiding the text search view when done
/// - Using the built-in search UI with result highlighting
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.showTextSearchView]: Displays the native search UI
/// - [CPDFReaderWidgetController.hideTextSearchView]: Hides the search UI overlay
///
/// Usage:
/// 1. Open the PDF document with the reader widget
/// 2. Tap "Show Search" from the menu to display the search view
/// 3. Enter search keywords to find and highlight matching text
/// 4. Tap "Hide Search" to dismiss the search view
class TextSearchExample extends StatelessWidget {
  /// Constructor
  const TextSearchExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Text Search',
      assetPath: _assetPath,
      builder: (path) => _TextSearchPage(documentPath: path),
    );
  }
}

class _TextSearchPage extends ExampleBase {
  const _TextSearchPage({required super.documentPath});

  @override
  State<_TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends ExampleBaseState<_TextSearchPage> {
  static const List<String> _menuActions = ['Show Search', 'Hide Search'];

  @override
  String get pageTitle => 'Text Search';

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
    switch (action) {
      case 'Show Search':
        controller.showTextSearchView();
        break;
      case 'Hide Search':
        controller.hideTextSearchView();
        break;
    }
  }
}
