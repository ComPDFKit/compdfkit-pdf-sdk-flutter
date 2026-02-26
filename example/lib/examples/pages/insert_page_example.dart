// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Insert Page Example
///
/// Demonstrates how to insert new pages into a PDF document using various methods.
///
/// This example shows:
/// - Inserting blank pages with standard sizes (e.g., A4)
/// - Inserting pages from image files with custom dimensions
/// - Importing pages from other PDF documents
///
/// Key classes/APIs used:
/// - [CPDFDocument.insertBlankPage]: Inserts a blank page at a specified index
/// - [CPDFDocument.insertPageWithImagePath]: Creates a page from an image file
/// - [CPDFDocument.importDocument]: Imports pages from another PDF document
/// - [CPDFPageSize]: Defines standard page sizes (A4, letter, etc.) or custom dimensions
/// - [ComPDFKit.pickFile]: Opens a file picker to select PDF documents
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Select an insert option from the menu:
///    - "Insert Blank Page" to add an A4 blank page at the beginning
///    - "Insert Image Page" to pick an image and insert it as a new page
///    - "Insert PDF Page" to import the first page from another PDF
/// 3. The document view will refresh to show the inserted page
class InsertPageExample extends StatelessWidget {
  /// Constructor
  const InsertPageExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Insert Page',
      assetPath: _assetPath,
      builder: (path) => _InsertPagePage(documentPath: path),
    );
  }
}

class _InsertPagePage extends ExampleBase {
  const _InsertPagePage({required super.documentPath});

  @override
  State<_InsertPagePage> createState() => _InsertPagePageState();
}

class _InsertPagePageState extends ExampleBaseState<_InsertPagePage> {
  static const List<String> _menuActions = [
    'Insert Blank Page',
    'Insert Image Page',
    'Insert PDF Page',
  ];

  @override
  String get pageTitle => 'Insert Page';

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
      case 'Insert Blank Page':
        _insertBlankPage(controller);
        break;
      case 'Insert Image Page':
        _insertImagePage(controller);
        break;
      case 'Insert PDF Page':
        _handleImportDocument(controller);
        break;
    }
  }

  void _handleImportDocument(CPDFReaderWidgetController controller) async {
    final path = await ComPDFKit.pickFile();
    if (path != null) {
      final importResult = await controller.document.importDocument(
        filePath: path,
        pages: [0],
        insertPosition: 0,
      );
      debugPrint('Import document result: $importResult');
    }
  }

  Future<void> _insertBlankPage(CPDFReaderWidgetController controller) async {
    final result = await controller.document.insertBlankPage(
      pageIndex: 0,
      pageSize: CPDFPageSize.a4,
    );
    debugPrint('Insert blank page result: $result');
    if (result) {
      controller.reloadPages();
    }
  }

  Future<void> _insertImagePage(CPDFReaderWidgetController controller) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) {
      return;
    }

    final filePath = result.files.first.path;
    if (filePath == null) {
      return;
    }

    final bytes = await File(filePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final insertResult = await controller.document.insertPageWithImagePath(
      pageIndex: 0,
      imagePath: filePath,
      pageSize: CPDFPageSize.custom(image.width, image.height),
    );

    debugPrint('Insert image page result: $insertResult');
    if (insertResult) {
      controller.reloadPages();
    }
  }
}
