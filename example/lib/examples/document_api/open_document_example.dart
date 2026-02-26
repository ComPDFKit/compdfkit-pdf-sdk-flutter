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

/// Open Document Example
///
/// Demonstrates how to open PDF documents using the [CPDFDocument] API.
///
/// This example shows:
/// - Opening a standard PDF document from a file path
/// - Opening a password-protected PDF with authentication
/// - Handling document open results and error states
///
/// Key classes/APIs used:
/// - [CPDFDocument.open]: Opens a PDF document with optional password
/// - [CPDFOpenResultType]: Enum indicating the result of open operation
///
/// Usage:
/// 1. Extract the PDF asset to a local file path
/// 2. Call [document.open] with the file path
/// 3. For encrypted PDFs, provide the password parameter
/// 4. Check the result to verify successful opening
class OpenDocumentExample extends ApiExampleBase {
  /// Constructor
  const OpenDocumentExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Open Document';

  @override
  State<OpenDocumentExample> createState() => _OpenDocumentExampleState();
}

class _OpenDocumentExampleState
    extends ApiExampleBaseState<OpenDocumentExample> {
  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: _reopenDefaultDocument,
        child: const Text('Reopen Sample Document'),
      ),
      TextButton(
        onPressed: _openEncryptedDocument,
        child: const Text('Open Encrypted Sample (Password: compdfkit)'),
      ),
    ];
  }

  Future<void> _reopenDefaultDocument() async {
    clearLogs();
    final file = await extractAsset(widget.assetPath, shouldOverwrite: true);
    applyLog('filePath: ${file.path}');
    final result = await document.open(file.path);
    applyLog('Open result: ${result.name}');
  }

  Future<void> _openEncryptedDocument() async {
    clearLogs();
    final file = await extractAsset(
      AppAssets.passwordProtectedPdf,
      shouldOverwrite: true,
    );
    applyLog('filePath: ${file.path}');
    final result = await document.open(file.path, password: 'compdfkit');
    applyLog('Open encrypted result: ${result.name}');
  }
}
