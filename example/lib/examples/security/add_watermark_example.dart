// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Add Watermark Example
///
/// Demonstrates how to add text and image watermarks to PDF documents for
/// branding, copyright protection, or document status indication.
///
/// This example shows:
/// - Adding customizable text watermarks with font, color, and rotation
/// - Adding image watermarks from asset files with scaling and opacity
/// - Configuring watermark alignment (horizontal and vertical)
/// - Applying watermarks to specific pages
/// - Removing all watermarks from a document
///
/// Key classes/APIs used:
/// - [CPDFWatermark.text]: Creates a text-based watermark configuration
/// - [CPDFWatermark.image]: Creates an image-based watermark configuration
/// - [CPDFDocument.createWatermark]: Applies watermark to the document
/// - [CPDFDocument.removeAllWatermarks]: Removes all existing watermarks
/// - [CPDFWatermarkHorizontalAlignment]: Horizontal positioning options
/// - [CPDFWatermarkVerticalAlignment]: Vertical positioning options
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Tap the menu to select watermark action
/// 3. Choose "Add Text Watermark" for red "ComPDFKit" text overlay
/// 4. Choose "Add Image Watermark" for rotated logo overlay
/// 5. Choose "Remove All Watermarks" to clear existing watermarks
class AddWatermarkExample extends StatelessWidget {
  /// Constructor
  const AddWatermarkExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Add Watermark',
      assetPath: _assetPath,
      builder: (path) => _AddWatermarkPage(documentPath: path),
    );
  }
}

class _AddWatermarkPage extends ExampleBase {
  const _AddWatermarkPage({required super.documentPath});

  @override
  State<_AddWatermarkPage> createState() => _AddWatermarkPageState();
}

class _AddWatermarkPageState extends ExampleBaseState<_AddWatermarkPage> {
  static const List<String> _menuActions = [
    'Add Text Watermark',
    'Add Image Watermark',
    'Remove All Watermarks',
  ];

  @override
  String get pageTitle => 'Add Watermark';

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
      case 'Add Text Watermark':
        _createTextWatermark(controller);
        break;
      case 'Add Image Watermark':
        _createImageWatermark(controller);
        break;
      case 'Remove All Watermarks':
        _removeAllWatermarks(controller);
        break;
    }
  }

  Future<void> _createTextWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    await controller.document.createWatermark(
      CPDFWatermark.text(
        textContent: 'ComPDFKit',
        scale: 1.0,
        fontSize: 56,
        rotation: 0,
        horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
        verticalAlignment: CPDFWatermarkVerticalAlignment.center,
        textColor: Colors.red,
        pages: [0, 1, 2],
      ),
    );
    debugPrint('Text watermark created');
  }

  Future<void> _createImageWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final imageFile = await extractAsset(AppAssets.logo);
    await controller.document.createWatermark(
      CPDFWatermark.image(
        imagePath: imageFile.path,
        opacity: 1,
        scale: 0.6,
        rotation: 45,
        pages: [0, 1, 2],
        horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
        verticalAlignment: CPDFWatermarkVerticalAlignment.center,
      ),
    );
    debugPrint('Image watermark created');
  }

  Future<void> _removeAllWatermarks(
    CPDFReaderWidgetController controller,
  ) async {
    await controller.document.removeAllWatermarks();
    debugPrint('All watermarks removed');
  }
}
