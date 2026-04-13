// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_image_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart' as file_util;
import 'package:compdfkit_flutter_example/utils/preferences_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Add Annotation Example
///
/// Demonstrates programmatically adding various annotation types to a PDF.
///
/// This example shows:
/// - Adding highlight annotations with [CPDFMarkupAnnotation]
/// - Adding note annotations with [CPDFNoteAnnotation]
/// - Adding shape annotations (square, circle) with [CPDFSquareAnnotation] and [CPDFCircleAnnotation]
/// - Setting annotation properties (color, opacity, rect)
/// - Using [CPDFDocument.addAnnotation] to insert annotations
///
/// Key classes/APIs used:
/// - [CPDFMarkupAnnotation]: Highlight, underline, strikeout annotations
/// - [CPDFNoteAnnotation]: Sticky note annotations
/// - [CPDFSquareAnnotation]: Rectangle shape annotations
/// - [CPDFCircleAnnotation]: Circle/ellipse shape annotations
/// - [CPDFRectF]: Annotation positioning on page
///
/// Usage:
/// 1. Open the example
/// 2. Tap menu and select "Add Annotations"
/// 3. Annotations will be added to the document
class AddAnnotationExample extends StatelessWidget {
  /// Constructor
  const AddAnnotationExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Add Annotation',
      assetPath: _assetPath,
      builder: (path) => _AddAnnotationPage(documentPath: path),
    );
  }
}

class _AddAnnotationPage extends ExampleBase {
  const _AddAnnotationPage({required super.documentPath});

  @override
  State<_AddAnnotationPage> createState() => _AddAnnotationPageState();
}

class _AddAnnotationPageState extends ExampleBaseState<_AddAnnotationPage> {
  static const String _addAnnotationsAction = 'Add Annotations';
  static const String _addImageAnnotationsAction = 'Add Image Annotations';
  static const String _addUriImageAnnotationAction =
      'Add Picked URI Image Annotation';

  static const List<String> _menuActions = [
    _addAnnotationsAction,
    _addImageAnnotationsAction,
    _addUriImageAnnotationAction,
  ];

  static const CPDFRectF _dataUriRect = CPDFRectF(
    left: 48,
    top: 700,
    right: 148,
    bottom: 600,
  );
  static const CPDFRectF _base64Rect = CPDFRectF(
    left: 176,
    top: 700,
    right: 276,
    bottom: 600,
  );
  static const CPDFRectF _assetRect = CPDFRectF(
    left: 304,
    top: 700,
    right: 404,
    bottom: 600,
  );
  static const CPDFRectF _pathRect = CPDFRectF(
    left: 80,
    top: 540,
    right: 220,
    bottom: 400,
  );
  static const CPDFRectF _uriRect = CPDFRectF(
    left: 248,
    top: 540,
    right: 388,
    bottom: 400,
  );

  static const String _sampleImageBase64 =
      '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';

  @override
  String get pageTitle => 'Add Annotations';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig:
            const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
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
      case _addAnnotationsAction:
        _handleAddAnnotations(controller);
        break;
      case _addImageAnnotationsAction:
        _addImageAnnotations(controller);
        break;
      case _addUriImageAnnotationAction:
        _addPickedUriImageAnnotation(controller);
        break;
    }
  }

  Future<void> _handleAddAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    final annotations = [
      CPDFSquareAnnotation(
        page: 0,
        title: 'Square',
        content: 'Square annotation',
        rect: const CPDFRectF(left: 40, top: 220, right: 200, bottom: 140),
        borderWidth: 3,
        borderColor: Colors.deepOrangeAccent,
        fillColor: Colors.amberAccent,
        borderAlpha: 255,
        fillAlpha: 120,
      ),
      CPDFCircleAnnotation(
        page: 0,
        title: 'Circle',
        content: 'Circle annotation',
        rect: const CPDFRectF(left: 230, top: 220, right: 380, bottom: 140),
        borderWidth: 3,
        borderColor: Colors.blueAccent,
        fillColor: Colors.lightBlueAccent,
        borderAlpha: 255,
        fillAlpha: 120,
      ),
      CPDFNoteAnnotation(
        page: 0,
        title: 'Note',
        content: 'Note annotation',
        rect: const CPDFRectF(left: 60, top: 720, right: 95, bottom: 690),
        color: Colors.green,
        alpha: 255,
      ),
      CPDFMarkupAnnotation(
        type: CPDFAnnotationType.highlight,
        page: 1,
        title: 'Highlight',
        content: 'Highlight annotation',
        rect: const CPDFRectF(left: 60, top: 790, right: 250, bottom: 760),
        markedText: 'Annotations',
        color: Colors.yellow,
        alpha: 200,
      ),
      CPDFMarkupAnnotation(
        type: CPDFAnnotationType.underline,
        page: 1,
        title: 'Underline',
        content: 'Underline annotation',
        rect: const CPDFRectF(left: 60, top: 430, right: 340, bottom: 405),
        markedText: 'Annotate and share',
        color: Colors.deepOrange,
        alpha: 200,
      )
    ];

    await controller.document.addAnnotations(annotations);
  }

  Future<void> _addImageAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    final imagePath =
        await file_util.extractAsset('images/sign/signature_4.png');
    await controller.document
        .addAnnotations(_buildImageAnnotations(imagePath.path));
    _showMessage(
      'Added image annotations from data URI, base64, asset, and file path.',
    );
  }

  List<CPDFImageAnnotation> _buildImageAnnotations(String imagePath) {
    return [
      CPDFImageAnnotation.fromDataUri(
        page: 1,
        title: 'Picture',
        content: 'Picture annotation from data URI',
        rect: _dataUriRect,
        dataUri: 'data:image/png;base64,$_sampleImageBase64',
      ),
      CPDFImageAnnotation.fromBase64(
        page: 1,
        title: 'Picture',
        content: 'Picture annotation from base64',
        rect: _base64Rect,
        base64: _sampleImageBase64,
      ),
      CPDFImageAnnotation.fromAsset(
        page: 1,
        title: 'Picture',
        content: 'Picture annotation from asset',
        rect: _assetRect,
        assetPath: 'images/sign/signature_1.png',
      ),
      CPDFImageAnnotation.fromPath(
        page: 1,
        title: 'Picture',
        content: 'Picture annotation from file path',
        rect: _pathRect,
        filePath: imagePath,
      ),
    ];
  }

  Future<void> _addPickedUriImageAnnotation(
    CPDFReaderWidgetController controller,
  ) async {
    final uriAnnotation = await _pickUriImageAnnotation();
    if (uriAnnotation == null) {
      return;
    }

    await controller.document.addAnnotations([uriAnnotation]);
    _showMessage('Added image annotation from the picked URI or file.');
  }

  Future<CPDFImageAnnotation?> _pickUriImageAnnotation() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final pickedFile = result.files.first;
    final identifier = pickedFile.identifier;
    final path = pickedFile.path;

    if (defaultTargetPlatform == TargetPlatform.android &&
        identifier != null &&
        identifier.startsWith('content://')) {
      return CPDFImageAnnotation.fromUri(
        page: 1,
        title: 'Picture',
        content: 'Picture annotation from Android URI',
        rect: _uriRect,
        uri: identifier,
      );
    }

    if (path != null && path.isNotEmpty) {
      return CPDFImageAnnotation.fromPath(
        page: 1,
        title: 'Picture',
        content: defaultTargetPlatform == TargetPlatform.android
            ? 'Picture annotation from picked file path'
            : 'Picture annotation from picked file',
        rect: _uriRect,
        filePath: path,
      );
    }

    _showMessage(
        'Unable to obtain a usable URI or file path from the selected image.');

    return null;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
