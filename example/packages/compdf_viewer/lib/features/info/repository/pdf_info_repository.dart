// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/document/cpdf_document_permission_info.dart';
import 'package:compdfkit_flutter/document/cpdf_info.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// Repository for accessing PDF document metadata and properties.
///
/// This repository provides a comprehensive data access layer for retrieving
/// various document information from the current PDF via the ComPDFKit SDK.
///
/// **Provided Operations:**
/// - [getFileName] - Get the document file name
/// - [getPageCount] - Get total number of pages
/// - [getInfo] - Get document metadata (title, author, subject, etc.)
/// - [getPermissionsInfo] - Get document permission settings
/// - [getDocumentVersion] - Get PDF version as "major.minor" string
/// - [isEncrypted] - Check if document is encrypted
/// - [isLocked] - Check if document is password-protected
/// - [getFileSizeInMB] - Calculate file size in megabytes
///
/// **Usage:**
/// ```dart
/// final repository = PdfInfoRepository();
/// final fileName = await repository.getFileName();
/// final pageCount = await repository.getPageCount();
/// final fileSize = await repository.getFileSizeInMB();
/// ```
///
/// All methods return default/empty values if the reader controller is unavailable.
class PdfInfoRepository {
  final PdfViewerController _pdfController = Get.find<PdfViewerController>();

  CPDFReaderWidgetController? get _controller =>
      _pdfController.readerController.value;

  Future<String> getFileName() async {
    return await _controller?.document.getFileName() ?? '';
  }

  Future<int> getPageCount() async {
    return await _controller?.document.getPageCount() ?? 0;
  }

  Future<CPDFInfo> getInfo() async {
    return await _controller?.document.getInfo() ?? CPDFInfo.empty();
  }

  Future<CPDFDocumentPermissionInfo> getPermissionsInfo() async {
    return await _controller?.document.getPermissionsInfo() ??
        CPDFDocumentPermissionInfo.empty();
  }

  Future<String> getDocumentVersion() async {
    if (_controller == null) return '';
    int majorVersion = await _controller!.document.getMajorVersion();
    int minorVersion = await _controller!.document.getMinorVersion();
    return '$majorVersion.$minorVersion';
  }

  Future<bool> isEncrypted() async {
    return await _controller?.document.isEncrypted() ?? false;
  }

  Future<bool> isLocked() async {
    return await _controller?.document.isLocked() ?? false;
  }

  Future<double> getFileSizeInMB() async {
    final filePath = await _controller?.document.getDocumentPath();
    if (filePath == null) return 0.0;
    final file = File(filePath);
    if (!await file.exists()) return 0.0;
    final fileStat = await file.stat();
    return fileStat.size / (1024 * 1024);
  }
}
