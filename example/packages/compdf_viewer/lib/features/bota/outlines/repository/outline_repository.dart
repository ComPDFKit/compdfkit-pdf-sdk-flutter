// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// Repository for accessing PDF document outline (table of contents) data.
///
/// This repository provides a data access layer for retrieving the outline
/// tree structure from the current PDF document.
///
/// **Provided Operations:**
/// - [fetchOutlineRoot] - Retrieve the root outline node with its children
///
/// **Usage:**
/// ```dart
/// final repository = OutlineRepository();
/// final outlineRoot = await repository.fetchOutlineRoot();
/// ```
///
/// Returns an empty outline node if the document has no outline or if
/// the reader controller is not available.
class OutlineRepository {
  final PdfViewerController pdfController = Get.find<PdfViewerController>();

  /// Get outline data
  Future<CPDFOutline> fetchOutlineRoot() async {
    final controller = pdfController.readerController.value;
    if (controller == null) return CPDFOutline(title: '', level: 0, uuid: '');
    final outline = await controller.document.getOutlineRoot();
    return outline ?? CPDFOutline(title: '', level: 0, uuid: '');
  }
}
