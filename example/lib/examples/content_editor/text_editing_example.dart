// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/attributes/cpdf_editor_text_attr.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_manager.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Text Editing Example
///
/// Demonstrates how to edit and insert text content in PDF documents.
///
/// This example shows:
/// - Entering text editing mode in a PDF document
/// - Programmatically inserting new text areas with custom styling
/// - Configuring text attributes like font size, color, and alignment
///
/// Key classes/APIs used:
/// - [CPDFEditType.text]: Edit type for text content editing
/// - [CPDFEditManager.changeEditType]: Method to enter text editing mode
/// - [CPDFDocument.createNewTextArea]: Creates a new text area at specified position
/// - [CPDFEditorTextAttr]: Configures text attributes (fontSize, fontColor, alignment)
/// - [CPDFAlignment]: Enum for text alignment options (left, center, right)
///
/// Usage:
/// 1. Open the example to view the PDF in content editor mode
/// 2. Select 'Enter Text Editing' to enable text editing mode
/// 3. Select 'Insert Text' to add a new styled text area at position (50, 800)
class TextEditingExample extends StatelessWidget {
  /// Constructor
  const TextEditingExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Text Editing',
      assetPath: _assetPath,
      builder: (path) => _TextEditingPage(documentPath: path),
    );
  }
}

class _TextEditingPage extends ExampleBase {
  const _TextEditingPage({required super.documentPath});

  @override
  State<_TextEditingPage> createState() => _TextEditingPageState();
}

class _TextEditingPageState extends ExampleBaseState<_TextEditingPage> {
  static const List<String> _menuActions = [
    'Enter Text Editing',
    'Insert Text',
  ];

  @override
  String get pageTitle => 'Text Editing';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.contentEditor,
          availableViewModes: [CPDFViewMode.viewer, CPDFViewMode.contentEditor],
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
      case 'Enter Text Editing':
        _changeEditType(controller, CPDFEditType.text);
        break;
      case 'Insert Text':
        _insertText(controller);
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

  Future<void> _insertText(CPDFReaderWidgetController controller) async {
    final result = await controller.document.createNewTextArea(
      pageIndex: 0,
      content: 'ComPDFKit Insert Text Example',
      offset: const Offset(50, 800),
      maxWidth: 300,
      attr: const CPDFEditorTextAttr(
        fontSize: 18,
        fontColor: Colors.red,
        alignment: CPDFAlignment.left,
      ),
    );
    debugPrint('Insert text result: $result');
  }
}
