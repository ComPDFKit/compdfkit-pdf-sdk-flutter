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

import '../../constants/asset_paths.dart';
import '../../features/annotations/annotation_list_page.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Render Annotation Appearance Example
///
/// Demonstrates rendering an annotation appearance into image bytes and
/// previewing the result inside the example app.
///
/// This example shows:
/// - Listing annotations on the current page
/// - Selecting a single annotation from a bottom sheet
/// - Using [CPDFDocument.renderAnnotationAppearance] to render the appearance
/// - Previewing the rendered image in a dialog
///
/// Usage:
/// 1. Open the example and navigate to a page with annotations
/// 2. Tap the menu and select "Render Current Page Annotation"
/// 3. Pick one annotation from the list
/// 4. Review the rendered appearance preview
class RenderAnnotationAppearanceExample extends StatelessWidget {
  /// Constructor
  const RenderAnnotationAppearanceExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Render Annotation Appearance',
      assetPath: _assetPath,
      builder: (path) => _RenderAnnotationAppearancePage(documentPath: path),
    );
  }
}

class _RenderAnnotationAppearancePage extends ExampleBase {
  const _RenderAnnotationAppearancePage({required super.documentPath});

  @override
  State<_RenderAnnotationAppearancePage> createState() =>
      _RenderAnnotationAppearancePageState();
}

class _RenderAnnotationAppearancePageState
    extends ExampleBaseState<_RenderAnnotationAppearancePage> {
  static const List<String> _menuActions = ['Render Current Page Annotation'];

  @override
  String get pageTitle => 'Render Annotation Appearance';

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
      case 'Render Current Page Annotation':
        _handleRenderAnnotationAppearance(controller);
        break;
    }
  }

  Future<void> _handleRenderAnnotationAppearance(
    CPDFReaderWidgetController controller,
  ) async {
    final pageIndex = await controller.getCurrentPageIndex();
    final CPDFPage page = controller.document.pageAtIndex(pageIndex);
    final annotations = await page.getAnnotations();

    if (!mounted) {
      return;
    }

    if (annotations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No annotations found on page ${pageIndex + 1}.'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.72,
        child: AnnotationListPage(
          annotations: annotations,
          title: 'Render Annotation Appearance',
          emptyTitle: 'No Annotations On Current Page',
          emptyMessage: 'Move to a page with annotations to render a preview.',
          headerIcon: Icons.image_search_outlined,
          showDeleteAction: false,
          onAnnotationTap: (sheetContext, annotation) async {
            try {
              final imageData = await controller.document
                  .renderAnnotationAppearance(
                annotation,
                options: const CPDFAnnotationRenderOptions(
                  compression: CPDFPageCompression.png,
                  quality: 100,
                ),
              );

              if (!sheetContext.mounted) {
                return;
              }

              await _showPreviewDialog(sheetContext, annotation, imageData);
            } catch (e) {
              if (!sheetContext.mounted) {
                return;
              }

              ScaffoldMessenger.of(sheetContext).showSnackBar(
                SnackBar(
                  content: Text('Failed to render annotation appearance: $e'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showPreviewDialog(
    BuildContext dialogContext,
    CPDFAnnotation annotation,
    dynamic imageData,
  ) {
    return showDialog<void>(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: Text(_buildAnnotationLabel(annotation)),
          content: Image.memory(imageData, fit: BoxFit.contain),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _buildAnnotationLabel(CPDFAnnotation annotation) {
    final details = <String>['Page ${annotation.page + 1}'];
    if (annotation.title.isNotEmpty) {
      details.add(annotation.title);
    } else if (annotation.content.isNotEmpty) {
      details.add(annotation.content);
    }
    return '${_formatAnnotationType(annotation.type)}${details.isEmpty ? '' : ' · ${details.join(' · ')}'}';
  }

  String _formatAnnotationType(CPDFAnnotationType type) {
    final raw = type.name;
    if (raw.isEmpty) {
      return 'Annotation';
    }
    return raw[0].toUpperCase() + raw.substring(1);
  }
}