// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/features/display/display_settings_page.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// Display Settings Example
///
/// Demonstrates how to access and modify PDF display settings using the
/// [CPDFReaderWidgetController].
///
/// This example shows:
/// - Opening the native display settings view
/// - Using a custom Flutter bottom sheet for display settings
/// - Configuring display mode, split mode, and crop mode
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.showDisplaySettingView]: Opens the native
///   display settings UI
/// - [DisplaySettingsPage]: Custom Flutter widget for display configuration
///
/// Usage:
/// 1. Open a PDF document in the reader widget
/// 2. Tap the menu button to see available options
/// 3. Select "Show Settings View" for native UI or "Show Settings Widget"
///    for custom Flutter implementation
class DisplaySettingsExample extends StatelessWidget {
  /// Constructor
  const DisplaySettingsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Display Settings',
      assetPath: _assetPath,
      builder: (path) => _DisplaySettingsPage(documentPath: path),
    );
  }
}

class _DisplaySettingsPage extends ExampleBase {
  const _DisplaySettingsPage({required super.documentPath});

  @override
  State<_DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends ExampleBaseState<_DisplaySettingsPage> {
  static const List<String> _menuActions = [
    'Show Settings View',
    'Show Settings Widget',
  ];

  @override
  String get pageTitle => 'Display Settings';

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
    if (action == 'Show Settings View') {
      controller.showDisplaySettingView();
    } else if (action == 'Show Settings Widget') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DisplaySettingsPage(controller: controller),
      );
    }
  }
}
