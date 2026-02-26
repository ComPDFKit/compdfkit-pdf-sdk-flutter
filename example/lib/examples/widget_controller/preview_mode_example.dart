// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../features/display/preview_mode_sheet.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// Preview Mode Example
///
/// Demonstrates how to switch between different PDF viewing and editing modes
/// using the [CPDFReaderWidgetController].
///
/// This example shows:
/// - Retrieving the current preview mode
/// - Switching between Viewer, Annotations, Content Editor, Forms, and
///   Signatures modes
/// - Using a custom bottom sheet for mode selection
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.getPreviewMode]: Gets the current view mode
/// - [CPDFReaderWidgetController.setPreviewMode]: Changes the active view mode
/// - [CPDFViewMode]: Enum defining available modes (viewer, annotations,
///   contentEditor, forms, signatures)
///
/// Usage:
/// 1. Open a PDF document in the reader widget
/// 2. Tap the menu button and select "Switch Preview Mode"
/// 3. Choose from available modes in the bottom sheet to change functionality
class PreviewModeExample extends StatelessWidget {
  /// Constructor
  const PreviewModeExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Preview Mode',
      assetPath: _assetPath,
      builder: (path) => _PreviewModePage(documentPath: path),
    );
  }
}

class _PreviewModePage extends ExampleBase {
  const _PreviewModePage({required super.documentPath});

  @override
  State<_PreviewModePage> createState() => _PreviewModePageState();
}

class _PreviewModePageState extends ExampleBaseState<_PreviewModePage> {
  static const List<String> _menuActions = ['Switch Preview Mode'];

  CPDFViewMode _currentMode = CPDFViewMode.viewer;

  @override
  String get pageTitle => 'Preview Mode';

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
    if (action == 'Switch Preview Mode') {
      _showPreviewModeSheet(controller);
    }
  }

  Future<void> _showPreviewModeSheet(
    CPDFReaderWidgetController controller,
  ) async {
    // Get current mode
    _currentMode = await controller.getPreviewMode();

    if (!mounted) return;

    final selectedMode = await showModalBottomSheet<CPDFViewMode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PreviewModeSheet(viewMode: _currentMode),
    );

    if (selectedMode != null && selectedMode != _currentMode) {
      await controller.setPreviewMode(selectedMode);
      setState(() {
        _currentMode = selectedMode;
      });
    }
  }
}
