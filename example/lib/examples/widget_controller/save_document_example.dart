// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../widgets/example_base.dart';
import '../../widgets/snack_bar_helper.dart';
import '../../utils/preferences_service.dart';
import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';

/// Save Document Example
///
/// Demonstrates how to save PDF document changes using the [CPDFDocument] API.
///
/// This example shows:
/// - Saving changes to the original document with incremental save
/// - Saving the document to a new location using "Save As"
/// - Configuring font subset embedding for optimized file size
///
/// Key classes/APIs used:
/// - [CPDFDocument.save]: Saves changes to the original file with options for
///   incremental save and font subsetting
/// - [CPDFDocument.saveAs]: Saves the document to a new file path
/// - [ComPDFKit.getTemporaryDirectory]: Gets the temporary directory for
///   saving files
///
/// Usage:
/// 1. Open and modify a PDF document (add annotations, fill forms, etc.)
/// 2. Tap the menu button to see save options
/// 3. Select "Save" to save to the original file or "Save As" to create a copy
class SaveDocumentExample extends StatelessWidget {
  /// Constructor
  const SaveDocumentExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Save Document',
      assetPath: _assetPath,
      builder: (path) => _SaveDocumentPage(documentPath: path),
    );
  }
}

class _SaveDocumentPage extends ExampleBase {
  const _SaveDocumentPage({required super.documentPath});

  @override
  State<_SaveDocumentPage> createState() => _SaveDocumentPageState();
}

class _SaveDocumentPageState extends ExampleBaseState<_SaveDocumentPage> {
  static const List<String> _menuActions = ['Save', 'Save As'];

  @override
  String get pageTitle => 'Save Document';

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
      case 'Save':
        _handleSave(controller);
        break;
      case 'Save As':
        _handleSaveAs(controller);
        break;
    }
  }

  Future<void> _handleSave(CPDFReaderWidgetController controller) async {
    bool saveIncremental = true;
    bool fontSubset = true;
    final result = await controller.document.save(
      saveIncremental: saveIncremental,
      fontSubSet: fontSubset,
    );
    if (!mounted) return;
    if (result) {
      SnackBarHelper.success(context, message: 'Document saved successfully');
    } else {
      SnackBarHelper.error(context, message: 'Failed to save document');
    }
  }

  Future<void> _handleSaveAs(CPDFReaderWidgetController controller) async {
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    final fileName = await controller.document.getFileName();
    final savePath = '${tempDir.path}/$fileName';
    const fontSubSet = true;
    final result = await controller.document.saveAs(
      savePath,
      fontSubSet: fontSubSet,
    );
    if (!mounted) return;
    if (result) {
      SnackBarHelper.success(context, message: 'Saved to: $savePath');
    } else {
      SnackBarHelper.error(context, message: 'Failed to save document');
    }
  }
}
