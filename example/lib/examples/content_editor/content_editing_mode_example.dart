// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_manager.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Content Editing Mode Example
///
/// Demonstrates how to enter and switch between different content editing modes in a PDF document.
///
/// This example shows:
/// - Opening a PDF document in content editor view mode
/// - Switching between text editing and image editing modes
/// - Exiting content editing mode
///
/// Key classes/APIs used:
/// - [CPDFViewMode.contentEditor]: Initial view mode for content editing
/// - [CPDFEditType]: Enum defining edit types (none, text, image)
/// - [CPDFEditManager.changeEditType]: Method to switch between editing modes
///
/// Usage:
/// 1. Open the example to view the PDF in content editor mode
/// 2. Use the menu to select 'Text Editing' or 'Image Editing' mode
/// 3. Select 'Exit Editing' to return to normal viewing mode
class ContentEditingModeExample extends StatelessWidget {
  /// Constructor
  const ContentEditingModeExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Content Editing Mode',
      assetPath: _assetPath,
      builder: (path) => _ContentEditingModePage(documentPath: path),
    );
  }
}

class _ContentEditingModePage extends ExampleBase {
  const _ContentEditingModePage({required super.documentPath});

  @override
  State<_ContentEditingModePage> createState() =>
      _ContentEditingModePageState();
}

class _ContentEditingModePageState
    extends ExampleBaseState<_ContentEditingModePage> {
  static const List<String> _menuActions = [
    'Exit Editing',
    'Text Editing',
    'Image Editing',
  ];

  @override
  String get pageTitle => 'Content Editing Mode';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.contentEditor,
        ),
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
      case 'Exit Editing':
        _changeEditType(controller, CPDFEditType.none);
        break;
      case 'Text Editing':
        _changeEditType(controller, CPDFEditType.text);
        break;
      case 'Image Editing':
        _changeEditType(controller, CPDFEditType.image);
        break;
    }
  }

  Future<void> _changeEditType(
    CPDFReaderWidgetController controller,
    CPDFEditType type,
  ) async {
    final result = await controller.editManager.changeEditType([type]);
    debugPrint('Change edit type to $type: $result');
  }
}
