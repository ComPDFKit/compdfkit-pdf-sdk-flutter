// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../features/forms/widget_list_page.dart';
import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Form Field Operations Example
///
/// Demonstrates how to retrieve, inspect, navigate to, and remove form fields
/// (widgets) from a PDF document using the ComPDFKit Flutter API.
///
/// This example shows:
/// - Iterating through all pages to collect form widgets
/// - Displaying a list of all form fields in a bottom sheet
/// - Navigating to a specific form field's page location
/// - Removing form fields from the document programmatically
///
/// Key classes/APIs used:
/// - [CPDFWidget]: Base class for all form field types
/// - [CPDFPage.getWidgets]: Retrieves all form widgets on a specific page
/// - [CPDFDocument.removeWidget]: Removes a form widget from the document
/// - [CPDFReaderWidgetController.setDisplayPageIndex]: Navigates to a page
///
/// Usage:
/// 1. Open the example and tap the menu button
/// 2. Select "Get Form Fields" to display all form widgets
/// 3. Tap a widget to jump to its page, or use the delete action to remove it
class FormFieldOperationsExample extends StatelessWidget {
  /// Constructor
  const FormFieldOperationsExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Form Field Operations',
      assetPath: _assetPath,
      builder: (path) => _FormFieldOperationsPage(documentPath: path),
    );
  }
}

class _FormFieldOperationsPage extends ExampleBase {
  const _FormFieldOperationsPage({required super.documentPath});

  @override
  State<_FormFieldOperationsPage> createState() =>
      _FormFieldOperationsPageState();
}

class _FormFieldOperationsPageState
    extends ExampleBaseState<_FormFieldOperationsPage> {
  static const List<String> _menuActions = ['Get Form Fields'];

  @override
  String get pageTitle => 'Form Field Operations';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(initialViewMode: CPDFViewMode.forms),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        )
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == 'Get Form Fields') {
      _handleGetWidgets(controller);
    }
  }

  Future<void> _handleGetWidgets(CPDFReaderWidgetController controller) async {
    final pageCount = await controller.document.getPageCount();
    final widgets = <CPDFWidget>[];

    for (int i = 0; i < pageCount; i++) {
      final page = controller.document.pageAtIndex(i);
      final pageWidgets = await page.getWidgets();
      widgets.addAll(pageWidgets);
    }

    if (!mounted) return;
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) =>
            WidgetListPage(widgets: widgets),
      ),
    );

    if (result == null || !mounted) return;

    final type = result['type'] as String?;
    final widget = result['widget'] as CPDFWidget?;

    if (widget == null) return;

    switch (type) {
      case 'jump':
        await controller.setDisplayPageIndex(pageIndex: widget.page);
        break;
      case 'remove':
        await controller.document.removeWidget(widget);
        break;
    }
  }
}
