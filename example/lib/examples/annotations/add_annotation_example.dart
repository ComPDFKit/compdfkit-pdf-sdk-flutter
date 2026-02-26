// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/preferences_service.dart';
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
  static const List<String> _menuActions = ['Add Annotations'];

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
      case 'Add Annotations':
        _handleAddAnnotations(controller);
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
      ),
    ];

    await controller.document.addAnnotations(annotations);
  }
}
