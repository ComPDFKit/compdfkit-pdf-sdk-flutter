// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/utils/file_util.dart';
import 'package:compdf_viewer/utils/pdf_dir_util.dart';
import 'package:compdf_viewer/utils/pdf_viewer_document_util.dart';

/// Repository responsible for sidebar-related data access operations, including bookmarks, save, share, encryption, etc.
class SideNavigationRepository {
  final PdfViewerController pdfController = Get.find<PdfViewerController>();

  CPDFReaderWidgetController? get _controller =>
      pdfController.readerController.value;

  // ------------------- Bookmarks -------------------

  /// Check if current page has bookmark
  Future<bool> hasBookmark() async {
    if (_controller == null) {
      PdfViewerGlobal.logger.i('controller is null, hasBookmark return false');
      return false;
    }
    int currentPageIndex = await _controller!.getCurrentPageIndex();
    return await _controller!.document.hasBookmark(currentPageIndex);
  }

  /// Add bookmark for current page
  Future<void> addBookmark(String title) async {
    if (_controller == null) return;
    int pageIndex = await _controller!.getCurrentPageIndex();
    await _controller!.document.addBookmark(title: title, pageIndex: pageIndex);
  }

  /// Remove current page bookmark
  Future<void> removeCurrentPageBookmark() async {
    if (_controller == null) return;
    int pageIndex = await _controller!.getCurrentPageIndex();
    await _controller!.document.removeBookmark(pageIndex);
  }

  // ------------------- Save -------------------

  /// Check if document has changes
  Future<bool> hasChange() async {
    return await _controller?.document.hasChange() ?? false;
  }

  /// Save document
  Future<bool> save() async {
    if (_controller == null) return false;
    return await _controller!.document.save();
  }

  /// Save as to temp directory, returns saved path (empty string indicates failure)
  Future<String> saveAsToTempDirectory() async {
    if (_controller == null) return '';
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    String savePath =
        '${tempDir.path}/${await _controller!.document.getFileName()}';
    final file = File(savePath);
    if (await file.exists()) {
      await file.delete();
    }
    bool saveResult = await _controller!.document.saveAs(savePath);
    return saveResult ? savePath : '';
  }

  /// Get current document file name
  Future<String> getFileName() async {
    return await _controller?.document.getFileName() ?? '';
  }

  /// Save as flatten
  Future<String?> saveAsFlatten() async {
    if (_controller == null) return null;
    final fileName = await _controller!.document.getFileName();
    final flattenedDir = await PdfDirUtil.getFlattenedDirectory();
    final baseDirPath = flattenedDir?.path ?? '';
    final targetPath =
        await FileUtil.buildUniqueFilePath(baseDirPath, fileName);
    bool saveResult =
        await _controller!.document.flattenAllPages(targetPath, true);
    PdfViewerGlobal.logger
        .i('Document flatten result: $saveResult, file path: $targetPath');
    return saveResult ? targetPath : null;
  }

  // ------------------- Share -------------------

  /// Share current document
  Future<void> shareDocument() async {
    String? pdfPath = await _controller?.document.getDocumentPath();
    PdfViewerDocumentUtil.share(pdfPath);
  }

  // ------------------- Print -------------------

  /// Print current document
  void printDocument() {
    _controller?.document.printDocument();
  }

  // ------------------- Encryption -------------------

  /// Check if document is encrypted
  Future<bool> isEncrypted() async {
    return await _controller?.document.isEncrypted() ?? false;
  }

  /// Set document password
  Future<void> setPassword(String? password) async {
    if (_controller == null) return;
    if (password?.isEmpty == true) {
      await _controller!.document.removePassword();
    } else {
      await _controller!.document.setPassword(userPassword: password);
    }
  }

  /// Reload all pages
  Future<void> reloadPages() async {
    await _controller?.reloadPages2();
  }

  // ------------------- Others -------------------

  /// Delete all annotations
  Future<void> removeAllAnnotations() async {
    await _controller?.dismissContextMenu();
    await _controller?.document.removeAllAnnotations();
  }

  /// Show add watermark view
  Future<void> showAddWatermarkView() async {
    await _controller?.showAddWatermarkView(
        config: CPDFWatermarkConfig(saveAsNewFile: false));
  }

  /// Get reader controller for PDF operations
  CPDFReaderWidgetController? getReaderController() => _controller;
}
