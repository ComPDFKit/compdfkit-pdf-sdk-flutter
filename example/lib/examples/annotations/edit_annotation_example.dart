// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_freetext_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_ink_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_line_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_text_attribute.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Edit Annotation Properties Example
///
/// Demonstrates modifying properties of existing annotations.
///
/// This example shows:
/// - Retrieving annotations from pages with [CPDFPage.getAnnotations]
/// - Updating common properties (color, opacity, content)
/// - Updating type-specific properties for markup, note, shape annotations
/// - Setting link actions with [CPDFUriAction]
/// - Updating text attributes with [CPDFTextAttribute]
///
/// Key classes/APIs used:
/// - [CPDFMarkupAnnotation]: Highlight, underline, strikeout properties
/// - [CPDFNoteAnnotation]: Note color and content
/// - [CPDFSquareAnnotation], [CPDFCircleAnnotation]: Shape properties
/// - [CPDFLineAnnotation]: Line endpoints and arrow types
/// - [CPDFFreeTextAnnotation]: Free text properties
/// - [CPDFLinkAnnotation]: Link actions
///
/// Usage:
/// 1. Open the example (contains pre-existing annotations)
/// 2. Tap menu and select "Edit Properties"
/// 3. All annotations will be updated with new properties
class EditAnnotationExample extends StatelessWidget {
  /// Constructor
  const EditAnnotationExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Edit Annotation',
      assetPath: _assetPath,
      builder: (path) => _EditAnnotationPage(documentPath: path),
    );
  }
}

class _EditAnnotationPage extends ExampleBase {
  const _EditAnnotationPage({required super.documentPath});

  @override
  State<_EditAnnotationPage> createState() => _EditAnnotationPageState();
}

class _EditAnnotationPageState extends ExampleBaseState<_EditAnnotationPage> {
  static const List<String> _menuActions = ['Edit Properties'];

  @override
  String get pageTitle => 'Edit Annotation';

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
      case 'Edit Properties':
        _handleEditAnnotationProperties(controller);
        break;
    }
  }

  Future<void> _handleEditAnnotationProperties(
    CPDFReaderWidgetController controller,
  ) async {
    final pageCount = await controller.document.getPageCount();
    final annotations = <CPDFAnnotation>[];

    for (int i = 0; i < pageCount; i++) {
      final CPDFPage page = controller.document.pageAtIndex(i);
      final pageAnnotations = await page.getAnnotations();
      annotations.addAll(pageAnnotations);
    }

    // ==================== Edit Annotation Properties ====================
    for (var annotation in annotations) {
      // Update common properties
      annotation.title = 'ComPDFKit-A';
      annotation.content = 'update ${annotation.type.name} annotation';

      // Update type-specific properties
      if (annotation is CPDFNoteAnnotation) {
        annotation.color = Colors.red;
        annotation.alpha = 255;
      } else if (annotation is CPDFMarkupAnnotation) {
        annotation.color = Colors.red;
        annotation.alpha = 200;
      } else if (annotation is CPDFInkAnnotation) {
        annotation.color = Colors.red;
        annotation.alpha = 100;
      } else if (annotation is CPDFSquareAnnotation) {
        annotation.borderWidth = 10;
        annotation.borderColor = Colors.red;
        annotation.borderAlpha = 200;
        annotation.fillColor = Colors.lightGreen;
        annotation.fillAlpha = 128;
      } else if (annotation is CPDFCircleAnnotation) {
        annotation.borderWidth = 10;
        annotation.borderColor = Colors.red;
        annotation.borderAlpha = 200;
        annotation.fillColor = Colors.lightGreen;
        annotation.fillAlpha = 128;
        annotation.dashGap = 8;
        annotation.effectType = CPDFBorderEffectType.cloudy;
      } else if (annotation is CPDFLineAnnotation) {
        annotation.borderAlpha = 255;
        annotation.borderColor = Colors.green;
        annotation.borderWidth = 5;
        annotation.dashGap = 5;
        annotation.lineHeadType = CPDFLineType.circle;
        annotation.lineTailType = CPDFLineType.diamond;
      } else if (annotation is CPDFFreeTextAnnotation) {
        annotation.alignment = CPDFAlignment.right;
        annotation.alpha = 255;
        annotation.textAttribute = CPDFTextAttribute(
          color: Colors.lime,
          familyName: 'Times',
          styleName: 'Bold',
          fontSize: 30,
        );
      } else if (annotation is CPDFLinkAnnotation) {
        annotation.action = CPDFUriAction(uri: 'https://www.google.com');
      }
      // Apply changes
      await controller.document.updateAnnotation(annotation);
    }
  }
}
