// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// Repository for accessing and managing PDF bookmark data.
///
/// This repository provides a data access layer for bookmark operations,
/// interfacing with the ComPDFKit SDK through the [PdfViewerController].
///
/// **Provided Operations:**
/// - [fetchBookmarks] - Retrieve all bookmarks from the current document
/// - [removeBookmark] - Delete a bookmark at a specific page index
/// - [editBookmark] - Update an existing bookmark's properties
///
/// **Usage:**
/// ```dart
/// final repository = BookmarkRepository();
/// final bookmarks = await repository.fetchBookmarks();
/// final success = await repository.removeBookmark(5);
/// ```
///
/// All operations depend on an active [PdfViewerController] and its
/// associated document instance.
class BookmarkRepository {
  final PdfViewerController pdfController = Get.find<PdfViewerController>();

  /// Get bookmark data
  Future<List<CPDFBookmark>> fetchBookmarks() async {
    final controller = pdfController.readerController.value;
    if (controller == null) return [];
    final bookmarks = await controller.document.getBookmarks();
    return bookmarks;
  }

  Future<bool> removeBookmark(int pageIndex) async {
    final controller = pdfController.readerController.value;
    if (controller == null) return false;
    final result = await controller.document.removeBookmark(pageIndex);
    return result;
  }

  Future<bool> editBookmark(CPDFBookmark bookmark) async {
    final controller = pdfController.readerController.value;
    if (controller == null) return false;
    return await controller.document.updateBookmark(bookmark);
  }
}
