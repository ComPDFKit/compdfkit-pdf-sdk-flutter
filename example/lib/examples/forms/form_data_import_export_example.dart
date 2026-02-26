// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Form Data Import/Export Example
///
/// Demonstrates how to import and export form field data using XFDF format
/// with the ComPDFKit Flutter API.
///
/// This example shows:
/// - Importing form data from an XFDF file to populate form fields
/// - Exporting current form field values to an XFDF file
/// - Handling import/export results with user feedback
///
/// Key classes/APIs used:
/// - [CPDFDocument.importWidgets]: Imports form data from XFDF file path
/// - [CPDFDocument.exportWidgets]: Exports form data to XFDF and returns path
///
/// Supported formats:
/// - XFDF (XML Forms Data Format): Standard format for form data exchange
///
/// Usage:
/// 1. Open the example and fill in some form fields
/// 2. Tap menu and select "Export Form Data" to save current values
/// 3. Modify the form fields, then select "Import Form Data" to restore
class FormDataImportExportExample extends StatelessWidget {
  /// Constructor
  const FormDataImportExportExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Form Data Import/Export',
      assetPath: _assetPath,
      builder: (path) => _FormDataImportExportPage(documentPath: path),
    );
  }
}

class _FormDataImportExportPage extends ExampleBase {
  const _FormDataImportExportPage({required super.documentPath});

  @override
  State<_FormDataImportExportPage> createState() =>
      _FormDataImportExportPageState();
}

class _FormDataImportExportPageState
    extends ExampleBaseState<_FormDataImportExportPage> {
  static const List<String> _menuActions = [
    'Import Form Data',
    'Export Form Data',
  ];

  @override
  String get pageTitle => 'Form Import/Export';

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
    switch (action) {
      case 'Import Form Data':
        _handleImport(controller);
        break;
      case 'Export Form Data':
        _handleExport(controller);
        break;
    }
  }

  Future<void> _handleImport(CPDFReaderWidgetController controller) async {
    final xfdfFile = await extractAsset(
      AppAssets.annotTestWidgetsXfdf,
      shouldOverwrite: false,
    );
    final result = await controller.document.importWidgets(xfdfFile.path);
    debugPrint('Import form data result: $result');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported form data result: $result')),
    );
  }

  Future<void> _handleExport(CPDFReaderWidgetController controller) async {
    final path = await controller.document.exportWidgets();
    debugPrint('Export form data path: $path');
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exported form data to: $path')));
  }
}
