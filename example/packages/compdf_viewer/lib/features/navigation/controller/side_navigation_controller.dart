// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/navigation/repository/side_navigation_repository.dart';
import 'package:compdf_viewer/features/navigation/model/side_navigation_state.dart';
import 'package:compdf_viewer/utils/pdf_page_util.dart';
import 'package:compdf_viewer/utils/pdf_viewer_document_util.dart';
import 'package:compdf_viewer/utils/snackbar_util.dart';

/// Side navigation controller, coordinates file operations and reading settings in the sidebar.
class SideNavigationController extends GetxController {
  final SideNavigationRepository repository;
  final SideNavigationState state = SideNavigationState();

  SideNavigationController(this.repository);

  @override
  void onReady() {
    super.onReady();
    _initEncryptedInfo();
  }

  void _initEncryptedInfo() async {
    state.isEncrypted.value = await repository.isEncrypted();
  }

  // ------------------- Bookmarks -------------------

  /// Refresh current page bookmark status
  void refreshHasBookmark() async {
    state.updateBookmarkStatus(await repository.hasBookmark());
  }

  /// Add bookmark for current page
  Future<void> addBookmark(String title) async {
    await repository.addBookmark(title);
    refreshHasBookmark();
  }

  /// Remove current page bookmark
  Future<void> removeCurrentPageBookmark() async {
    await repository.removeCurrentPageBookmark();
    refreshHasBookmark();
  }

  // ------------------- Share / Print -------------------

  /// Share current document
  Future<void> shareDocument() async {
    await repository.shareDocument();
  }

  /// Print current document
  void printDocument() {
    repository.printDocument();
  }

  // ------------------- Save -------------------

  /// Save document
  void save() async {
    bool hasChange = await repository.hasChange();
    if (!hasChange) return;
    bool success = await repository.save();
    SnackbarUtil.showTips(
        success ? PdfLocaleKeys.saveSuccess.tr : PdfLocaleKeys.saveFail.tr);
  }

  /// Save as
  void saveAs() async {
    final fileName = await repository.getFileName();
    final filePath = await repository.saveAsToTempDirectory();
    if (filePath.isEmpty) return;
    final bytes = await PdfViewerDocumentUtil.filePathToUint8List(filePath);
    final resultPath = await FilePicker.platform.saveFile(
        dialogTitle: PdfLocaleKeys.saveAs.tr,
        fileName: fileName,
        allowedExtensions: ['pdf'],
        bytes: bytes);
    final success = resultPath != null;
    PdfViewerGlobal.logger
        .i('Save as result: $success, file path: $resultPath');
    if (success) {
      SnackbarUtil.showTips(PdfLocaleKeys.saveSuccess.tr);
    }
  }

  /// Save as flatten
  Future<String?> saveAsFlatten() async {
    return await repository.saveAsFlatten();
  }

  // ------------------- Encryption -------------------

  /// Set document password and refresh encryption status
  Future<void> setPassword(String? password) async {
    await repository.setPassword(password);
    await repository.reloadPages();
    state.isEncrypted.value = await repository.isEncrypted();
  }

  // ------------------- Others -------------------

  /// Delete all annotations
  Future<void> removeAllAnnotations() async {
    await repository.removeAllAnnotations();
  }

  /// Show add watermark view
  Future<void> showAddWatermarkView() async {
    await repository.showAddWatermarkView();
  }

  // ------------------- Convert -------------------

  /// Convert PDF pages to images
  /// Returns the output directory path, or null if conversion failed
  Future<String?> pdfToImage(List<int> pages) async {
    final controller = repository.getReaderController();
    if (controller == null) {
      PdfViewerGlobal.logger
          .w('Reader controller is null, cannot convert PDF to image');
      return null;
    }
    try {
      return await PdfPageUtil.pdfToImage(controller, pages);
    } catch (e) {
      PdfViewerGlobal.logger.e('PDF to image conversion failed: $e');
      return null;
    }
  }
}
