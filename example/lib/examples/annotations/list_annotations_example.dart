// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../features/annotations/annotation_list_page.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// List Annotations Example
///
/// Demonstrates listing and navigating to annotations in a PDF.
///
/// This example shows:
/// - Collecting annotations from all pages
/// - Displaying annotations grouped by page in [AnnotationListPage]
/// - Navigating to specific annotations with [setDisplayPageIndex]
/// - Removing annotations with [CPDFDocument.removeAnnotation]
///
/// Key classes/APIs used:
/// - [CPDFPage.getAnnotations]: Get annotations for a page
/// - [CPDFReaderWidgetController.setDisplayPageIndex]: Navigate to annotation
/// - [CPDFDocument.removeAnnotation]: Delete specific annotation
/// - [AnnotationListPage]: Custom annotation list UI
///
/// Usage:
/// 1. Open the example (contains pre-existing annotations)
/// 2. Tap menu and select "List Annotations"
/// 3. Tap an annotation to navigate to it
/// 4. Tap delete icon to remove an annotation
class ListAnnotationsExample extends StatelessWidget {
  /// Constructor
  const ListAnnotationsExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'List Annotations',
      assetPath: _assetPath,
      builder: (path) => _ListAnnotationsPage(documentPath: path),
    );
  }
}

class _ListAnnotationsPage extends ExampleBase {
  const _ListAnnotationsPage({required super.documentPath});

  @override
  State<_ListAnnotationsPage> createState() => _ListAnnotationsPageState();
}

class _ListAnnotationsPageState extends ExampleBaseState<_ListAnnotationsPage> {
  static const List<String> _menuActions = ['List Annotations'];

  @override
  String get pageTitle => 'List Annotations';

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
      case 'List Annotations':
        _handleListAnnotations(controller);
        break;
    }
  }

  Future<void> _handleListAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    final pageCount = await controller.document.getPageCount();
    final annotations = <CPDFAnnotation>[];

    for (int i = 0; i < pageCount; i++) {
      final CPDFPage page = controller.document.pageAtIndex(i);
      final pageAnnotations = await page.getAnnotations();
      annotations.addAll(pageAnnotations);
    }

    if (!mounted) {
      return;
    }

    final data = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => AnnotationListPage(annotations: annotations),
    );

    if (data == null) {
      return;
    }

    final type = data['type'];
    final CPDFAnnotation annotation = data['annotation'];

    if (type == 'jump') {
      await controller.setDisplayPageIndex(
        pageIndex: annotation.page,
        rectList: [annotation.rect],
      );
    } else if (type == 'remove') {
      await controller.document.removeAnnotation(annotation);
    }
  }
}
