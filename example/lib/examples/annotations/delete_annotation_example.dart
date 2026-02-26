// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Delete Annotation Example
///
/// Demonstrates removing annotations from PDF documents.
///
/// This example shows:
/// - Deleting all annotations from the entire document
/// - Deleting annotations from the current page only
/// - Using [CPDFPage.getAnnotations] to retrieve annotations
/// - Using [CPDFDocument.removeAnnotation] to delete annotations
///
/// Key classes/APIs used:
/// - [CPDFDocument.removeAnnotation]: Remove specific annotation
/// - [CPDFPage.getAnnotations]: Get all annotations on a page
/// - [CPDFReaderWidgetController.getCurrentPageIndex]: Get current page
/// - [CPDFDocument.getPageCount]: Get total page count
///
/// Usage:
/// 1. Open the example (contains pre-existing annotations)
/// 2. Tap menu to select delete option
/// 3. Choose "Delete All" or "Delete Current Page"
class DeleteAnnotationExample extends StatelessWidget {
  /// Constructor
  const DeleteAnnotationExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Delete Annotation',
      assetPath: _assetPath,
      builder: (path) => _DeleteAnnotationPage(documentPath: path),
    );
  }
}

class _DeleteAnnotationPage extends ExampleBase {
  const _DeleteAnnotationPage({required super.documentPath});

  @override
  State<_DeleteAnnotationPage> createState() => _DeleteAnnotationPageState();
}

class _DeleteAnnotationPageState
    extends ExampleBaseState<_DeleteAnnotationPage> {
  static const List<String> _menuActions = [
    'Delete All Annotations',
    'Delete Current Page Annotations',
  ];

  @override
  String get pageTitle => 'Delete Annotation';

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
      case 'Delete All Annotations':
        _removeAllAnnotations(controller);
        break;
      case 'Delete Current Page Annotations':
        _removeCurrentPageAnnotations(controller);
        break;
    }
  }

  Future<void> _removeAllAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    final result = await controller.document.removeAllAnnotations();
    debugPrint('Remove all annotations result: $result');
  }

  Future<void> _removeCurrentPageAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    final pageIndex = await controller.getCurrentPageIndex();
    final CPDFPage page = controller.document.pageAtIndex(pageIndex);
    final annotations = await page.getAnnotations();

    for (final annotation in annotations) {
      await page.removeAnnotation(annotation);
    }

    debugPrint('Remove current page annotations: ${annotations.length}');
  }
}
