// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// XFDF Import/Export Example
///
/// Demonstrates importing and exporting annotations using XFDF format.
///
/// This example shows:
/// - Importing annotations from XFDF asset files
/// - Importing annotations from external XFDF files
/// - Exporting current annotations to XFDF format
/// - Using [CPDFDocument.importAnnotations] for import
/// - Using [CPDFDocument.exportAnnotations] for export
///
/// Key classes/APIs used:
/// - [CPDFDocument.importAnnotations]: Import from XFDF file path
/// - [CPDFDocument.exportAnnotations]: Export to XFDF file path
/// - [FilePicker]: Select external XFDF files
/// - XFDF file format for annotation interchange
///
/// Usage:
/// 1. Open the example
/// 2. Tap "Import XFDF (Asset)" to load bundled annotations
/// 3. Or tap "Import XFDF (File)" to select external file
/// 4. Tap "Export XFDF" to save current annotations
class XfdfOperationsExample extends StatelessWidget {
  /// Constructor
  const XfdfOperationsExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'XFDF Operations',
      assetPath: _assetPath,
      builder: (path) => _XfdfOperationsPage(documentPath: path),
    );
  }
}

class _XfdfOperationsPage extends ExampleBase {
  const _XfdfOperationsPage({required super.documentPath});

  @override
  State<_XfdfOperationsPage> createState() => _XfdfOperationsPageState();
}

class _XfdfOperationsPageState extends ExampleBaseState<_XfdfOperationsPage> {
  static const List<String> _menuActions = [
    'Import XFDF (Asset)',
    'Import XFDF (File)',
    'Export XFDF',
  ];

  @override
  String get pageTitle => 'XFDF Operations';

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
      case 'Import XFDF (Asset)':
        _importFromAsset(controller);
        break;
      case 'Import XFDF (File)':
        _importFromFile(controller);
        break;
      case 'Export XFDF':
        _exportToFile(controller);
        break;
    }
  }

  Future<void> _importFromAsset(CPDFReaderWidgetController controller) async {
    final xfdfFile = await extractAsset(AppAssets.testXfdf);
    final result = await controller.document.importAnnotations(xfdfFile.path);
    debugPrint('Import XFDF from asset result: $result');
  }

  Future<void> _importFromFile(CPDFReaderWidgetController controller) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xfdf'],
    );

    if (result != null && result.files.single.path != null) {
      final importResult = await controller.document.importAnnotations(
        result.files.single.path!,
      );
      debugPrint('Import XFDF from file result: $importResult');
    }
  }

  Future<void> _exportToFile(CPDFReaderWidgetController controller) async {
    await controller.saveCurrentInk();
    final path = await controller.document.exportAnnotations();
    debugPrint('Export XFDF path: $path');
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to: $path')));
    }
  }
}
