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

/// Snip Mode Example
///
/// Demonstrates how to use snip mode to capture and crop PDF content using
/// the [CPDFReaderWidgetController].
///
/// This example shows:
/// - Entering snip mode for content selection
/// - Exiting snip mode to return to normal viewing
/// - Capturing specific regions of PDF pages
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.enterSnipMode]: Activates the snip tool for
///   selecting and capturing PDF content regions
/// - [CPDFReaderWidgetController.exitSnipMode]: Deactivates snip mode and
///   returns to normal viewing
///
/// Usage:
/// 1. Open a PDF document in the reader widget
/// 2. Tap the menu button and select "Enter Snip Mode"
/// 3. Draw a selection rectangle on the PDF to capture content
/// 4. Select "Exit Snip Mode" to return to normal viewing
class SnipModeExample extends StatelessWidget {
  /// Constructor
  const SnipModeExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Snip Mode',
      assetPath: _assetPath,
      builder: (path) => _SnipModePage(documentPath: path),
    );
  }
}

class _SnipModePage extends ExampleBase {
  const _SnipModePage({required super.documentPath});

  @override
  State<_SnipModePage> createState() => _SnipModePageState();
}

class _SnipModePageState extends ExampleBaseState<_SnipModePage> {
  static const List<String> _menuActions = [
    'Enter Snip Mode',
    'Exit Snip Mode',
  ];

  @override
  String get pageTitle => 'Snip Mode';

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
      case 'Enter Snip Mode':
        controller.enterSnipMode();
        break;
      case 'Exit Snip Mode':
        controller.exitSnipMode();
        break;
    }
  }
}
