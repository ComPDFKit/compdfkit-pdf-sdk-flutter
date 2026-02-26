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

/// Zoom Scale Example
///
/// Demonstrates how to programmatically control the PDF zoom level using
/// the [CPDFReaderWidgetController].
///
/// This example shows:
/// - Setting a specific zoom scale value
/// - Retrieving the current zoom scale
/// - Understanding zoom scale values (1.0 = 100%, 1.5 = 150%, etc.)
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.setScale]: Sets the zoom level to a specific
///   value (e.g., 1.5 for 150% zoom)
/// - [CPDFReaderWidgetController.getScale]: Retrieves the current zoom scale
///   value
///
/// Usage:
/// 1. Open a PDF document in the reader widget
/// 2. Tap the menu button and select "Set Scale"
/// 3. The zoom level will be set to 150% and the current scale will be logged
class ZoomScaleExample extends StatelessWidget {
  /// Constructor
  const ZoomScaleExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Zoom Scale',
      assetPath: _assetPath,
      builder: (path) => _ZoomScalePage(documentPath: path),
    );
  }
}

class _ZoomScalePage extends ExampleBase {
  const _ZoomScalePage({required super.documentPath});

  @override
  State<_ZoomScalePage> createState() => _ZoomScalePageState();
}

class _ZoomScalePageState extends ExampleBaseState<_ZoomScalePage> {
  static const List<String> _menuActions = ['Set Scale'];

  @override
  String get pageTitle => 'Zoom Scale';

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
    if (action == 'Set Scale') {
      _handleSetScale(controller);
    }
  }

  Future<void> _handleSetScale(CPDFReaderWidgetController controller) async {
    controller.setScale(1.5);
    final scaleValue = await controller.getScale();
    debugPrint('Current scale: $scaleValue');
  }
}
