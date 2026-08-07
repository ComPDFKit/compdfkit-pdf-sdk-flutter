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

/// Watermark Example
///
/// Demonstrates how to add and remove watermarks in PDF documents.
///
/// This example shows:
/// - Adding customizable text watermarks with font, color, and rotation
/// - Adding image watermarks from asset files with scaling and opacity
/// - Configuring watermark alignment (horizontal and vertical)
/// - Applying watermarks to specific pages
/// - Counting, reading, updating, and removing individual watermarks
/// - Removing all document watermarks
///
/// Key classes/APIs used:
/// - [CPDFWatermark.text]: Creates a text-based watermark configuration
/// - [CPDFWatermark.image]: Creates an image-based watermark configuration
/// - [CPDFDocument.createWatermark]: Applies watermark to the document
/// - [CPDFDocument.getWatermarkCount]: Gets the current watermark count
/// - [CPDFDocument.getWatermark] and [CPDFDocument.getWatermarks]: Read watermarks
/// - [CPDFDocument.updateWatermark] and [CPDFDocument.removeWatermark]: Modify watermarks
/// - [CPDFDocument.removeAllWatermarks]: Removes all existing watermarks
/// - [CPDFWatermarkHorizontalAlignment]: Horizontal positioning options
/// - [CPDFWatermarkVerticalAlignment]: Vertical positioning options
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Tap the menu to select watermark action
/// 3. Choose "Add Text Watermark" for red "ComPDFKit" text overlay
/// 4. Choose "Add Image Watermark" for rotated logo overlay
/// 5. Use the remaining actions to inspect, update, or remove watermarks
/// 6. Choose "Remove All Watermarks" to clear existing watermarks
class WatermarkExample extends StatelessWidget {
  /// Constructor
  const WatermarkExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Watermark',
      assetPath: _assetPath,
      builder: (path) => _WatermarkPage(documentPath: path),
    );
  }
}

class _WatermarkPage extends ExampleBase {
  const _WatermarkPage({required super.documentPath});

  @override
  State<_WatermarkPage> createState() => _WatermarkPageState();
}

class _WatermarkPageState extends ExampleBaseState<_WatermarkPage> {
  static const List<String> _menuActions = [
    'Add Text Watermark',
    'Add Image Watermark',
    'Get Watermark Count',
    'Get First Watermark',
    'Get All Watermarks',
    'Update First Watermark',
    'Remove First Watermark',
    'Remove All Watermarks',
  ];

  @override
  String get pageTitle => 'Watermark';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
        globalConfig: CPDFGlobalConfig(
          watermark: CPDFWatermarkConfig(
            saveAsNewFile: false
          )
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
      case 'Get Watermark Count':
        _getWatermarkCount(controller);
        break;
      case 'Get First Watermark':
        _getFirstWatermark(controller);
        break;
      case 'Get All Watermarks':
        _getAllWatermarks(controller);
        break;
      case 'Update First Watermark':
        _updateFirstWatermark(controller);
        break;
      case 'Remove First Watermark':
        _removeFirstWatermark(controller);
        break;
      case 'Remove All Watermarks':
        _removeAllWatermarks(controller);
        break;
    }
  }

  Future<void> _createTextWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final success = await controller.document.createWatermark(
      CPDFWatermark.text(
        textContent: 'ComPDF',
        scale: 1.0,
        fontSize: 56,
        rotation: 0,
        horizontalAlignment: CPDFWatermarkHorizontalAlignment.left,
        verticalAlignment: CPDFWatermarkVerticalAlignment.bottom,
        textColor: Colors.red,
        pages: [0, 1, 2],
      ),
    );
    _showMessage(
        success ? 'Text watermark created' : 'Failed to create watermark');
  }

  Future<void> _createImageWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final imageFile = await extractAsset(AppAssets.logo);
    final success = await controller.document.createWatermark(
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
    _showMessage(
        success ? 'Image watermark created' : 'Failed to create watermark');
  }

  Future<void> _removeAllWatermarks(
    CPDFReaderWidgetController controller,
  ) async {
    await controller.document.removeAllWatermarks();
    _showMessage('All watermarks removed');
  }

  Future<void> _getWatermarkCount(
    CPDFReaderWidgetController controller,
  ) async {
    final count = await controller.document.getWatermarkCount();
    _showMessage('Watermark count: $count');
  }

  Future<void> _getFirstWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final watermark = await controller.document.getWatermark(0, exportImage: true);
    if (watermark == null) {
      _showMessage('No watermark found');
      return;
    }
    _showMessage(
        'First watermark: #${watermark.index} (${watermark.type.name})');
  }

  Future<void> _getAllWatermarks(
    CPDFReaderWidgetController controller,
  ) async {
    final watermarks = await controller.document.getWatermarks(exportImages: true);
    _showMessage('Watermarks: ${watermarks.length}');
  }

  Future<void> _updateFirstWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final watermark = await controller.document.getWatermark(0, exportImage: true);
    if (watermark == null) {
      _showMessage('No watermark to update');
      return;
    }
    final success = await controller.document.updateWatermark(
      watermark.index,
      watermark.copyWith(rotation: watermark.rotation + 15),
    );
    _showMessage(
        success ? 'First watermark updated' : 'Failed to update watermark');
  }

  Future<void> _removeFirstWatermark(
    CPDFReaderWidgetController controller,
  ) async {
    final watermark = await controller.document.getWatermark(0);
    if (watermark == null) {
      _showMessage('No watermark to remove');
      return;
    }
    final success = await controller.document.removeWatermark(watermark.index);
    _showMessage(
        success ? 'First watermark removed' : 'Failed to remove watermark');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
