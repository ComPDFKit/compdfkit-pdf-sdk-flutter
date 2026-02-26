// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Split Document Example
///
/// Demonstrates how to extract pages from a PDF and save them as a new document.
///
/// This example shows:
/// - Extracting specific pages from a PDF document
/// - Generating unique file names to avoid overwriting existing files
/// - Saving the extracted pages as a new PDF document
/// - Opening the newly created split document
///
/// Key classes/APIs used:
/// - [CPDFDocument.splitDocumentPages]: Extracts specified pages to a new PDF file
/// - [CPDFDocument.getFileName]: Gets the original document's file name
/// - [ComPDFKit.getTemporaryDirectory]: Gets the temporary directory for saving files
/// - [ComPDFKit.openDocument]: Opens the newly created document in the viewer
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Select "Split First Page" from the menu
/// 3. The first page will be extracted to a new PDF file
/// 4. The new document will automatically open in the viewer
class SplitDocumentExample extends StatelessWidget {
  /// Constructor
  const SplitDocumentExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Split Document',
      assetPath: _assetPath,
      builder: (path) => _SplitDocumentPage(documentPath: path),
    );
  }
}

class _SplitDocumentPage extends ExampleBase {
  const _SplitDocumentPage({required super.documentPath});

  @override
  State<_SplitDocumentPage> createState() => _SplitDocumentPageState();
}

class _SplitDocumentPageState extends ExampleBaseState<_SplitDocumentPage> {
  static const List<String> _menuActions = ['Split First Page'];

  @override
  String get pageTitle => 'Split Document';

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
    if (action == 'Split First Page') {
      _handleSplit(controller);
    }
  }

  Future<void> _handleSplit(CPDFReaderWidgetController controller) async {
    const pages = [0];
    final tempDir = await ComPDFKit.getTemporaryDirectory();

    final fileName = await controller.document.getFileName();
    final fileNameNoExtension = fileName.substring(
      0,
      fileName.lastIndexOf('.'),
    );
    final fileExtension = fileName.substring(fileName.lastIndexOf('.'));

    String splitFileName =
        '${fileNameNoExtension}_(${pages.join(',')})$fileExtension';
    String savePath = '${tempDir.path}/$splitFileName';
    File saveFile = File(savePath);

    int counter = 0;
    while (await saveFile.exists()) {
      counter++;
      splitFileName =
          '${fileNameNoExtension}_(${pages.join(',')})($counter)$fileExtension';
      savePath = '${tempDir.path}/$splitFileName';
      saveFile = File(savePath);
    }

    final result = await controller.document.splitDocumentPages(
      savePath,
      pages,
    );
    debugPrint('Split document result: $result');

    if (result) {
      ComPDFKit.openDocument(savePath);
    }
  }
}
