// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../shared/api_example_base.dart';

/// Import/Export XFDF Example
///
/// Demonstrates XFDF annotation data exchange using the [CPDFDocument] API
/// without requiring a PDF viewer widget.
///
/// This example shows:
/// - Importing annotations from an XFDF file into a PDF document
/// - Exporting all annotations from a PDF to an XFDF file
/// - XFDF format for cross-platform annotation interchange
///
/// Key classes/APIs used:
/// - [CPDFDocument.importAnnotations]: Imports annotations from XFDF file path
/// - [CPDFDocument.exportAnnotations]: Exports annotations to XFDF file,
///   returns the output file path
///
/// Usage:
/// 1. Open a PDF document
/// 2. To import: provide the XFDF file path to [importAnnotations]
/// 3. To export: call [exportAnnotations] and receive the output path
/// 4. The XFDF file contains XML-formatted annotation data
///
/// Note: XFDF (XML Forms Data Format) is an XML-based format for representing
/// PDF form data and annotations, enabling annotation sharing between
/// different PDF applications.
class ImportExportXfdfExample extends ApiExampleBase {
  /// Constructor
  const ImportExportXfdfExample({super.key});

  @override
  String get assetPath => AppAssets.annotTestPdf;

  @override
  String get title => 'Import/Export XFDF';

  @override
  State<ImportExportXfdfExample> createState() =>
      _ImportExportXfdfExampleState();
}

class _ImportExportXfdfExampleState
    extends ApiExampleBaseState<ImportExportXfdfExample> {
  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(onPressed: _importXfdf, child: const Text('Import XFDF')),
      TextButton(onPressed: _exportXfdf, child: const Text('Export XFDF')),
    ];
  }

  Future<void> _importXfdf() async {
    clearLogs();
    final xfdfFile = await extractAsset(
      AppAssets.testXfdf,
      shouldOverwrite: true,
    );
    final result = await document.importAnnotations(xfdfFile.path);
    applyLog('Import XFDF result: $result');
  }

  Future<void> _exportXfdf() async {
    clearLogs();
    final path = await document.exportAnnotations();
    applyLog('Export XFDF path: $path');
  }
}
