// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../shared/api_example_base.dart';

/// Document Info Example
///
/// Demonstrates how to read PDF document metadata and properties using the
/// [CPDFDocument] API.
///
/// This example shows:
/// - Retrieving basic document properties (file name, path, page count)
/// - Checking document encryption and permission status
/// - Accessing detailed document metadata (author, title, creation date)
/// - Reading document permission settings
///
/// Key classes/APIs used:
/// - [CPDFDocument.getFileName]: Returns the document file name
/// - [CPDFDocument.getPageCount]: Returns total number of pages
/// - [CPDFDocument.isEncrypted]: Checks if document is encrypted
/// - [CPDFDocument.getInfo]: Returns [CPDFDocumentInfo] with metadata
/// - [CPDFDocument.getPermissionsInfo]: Returns [CPDFDocumentPermissionInfo]
///
/// Usage:
/// 1. Open a PDF document
/// 2. Call the various getter methods to retrieve document properties
/// 3. Use [getInfo] for detailed metadata like author and creation date
/// 4. Use [getPermissionsInfo] to check allowed operations
class DocumentInfoExample extends ApiExampleBase {
  /// Constructor
  const DocumentInfoExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Document Info';

  @override
  State<DocumentInfoExample> createState() => _DocumentInfoExampleState();
}

class _DocumentInfoExampleState
    extends ApiExampleBaseState<DocumentInfoExample> {
  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: _loadDocumentInfo,
        child: const Text('Get Document Info'),
      ),
    ];
  }

  Future<void> _loadDocumentInfo() async {
    clearLogs();
    applyLog('Document Info:');
    applyLog('  File name: ${await document.getFileName()}');
    applyLog('  Document path: ${await document.getDocumentPath()}');
    applyLog('  Owner unlocked: ${await document.checkOwnerUnlocked()}');
    applyLog('  Has changes: ${await document.hasChange()}');
    applyLog('  Is encrypted: ${await document.isEncrypted()}');
    applyLog('  Is image doc: ${await document.isImageDoc()}');
    applyLog('  Permissions: ${await document.getPermissions()}');
    applyLog('  Page count: ${await document.getPageCount()}');

    final info = await document.getInfo();
    applyLog('  Info:');
    applyLog(const JsonEncoder.withIndent('  ').convert(info.toJson()));

    final permissions = await document.getPermissionsInfo();
    applyLog('  Permissions Info:');
    applyLog(const JsonEncoder.withIndent('  ').convert(permissions.toJson()));
  }
}
