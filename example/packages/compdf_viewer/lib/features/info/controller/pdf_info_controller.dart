// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/info/repository/pdf_info_repository.dart';
import 'package:compdf_viewer/features/info/model/pdf_info_state.dart';

/// GetX controller for managing PDF document information display.
///
/// This controller handles loading and managing various document metadata
/// including file info, permissions, encryption status, and version information.
///
/// **Managed State:**
/// - File name and page count
/// - Document metadata (title, author, subject, keywords, etc.)
/// - PDF version (major.minor)
/// - Permission information
/// - Encryption and lock status
/// - File size in megabytes
///
/// **Lifecycle:**
/// - Automatically loads all document information on initialization
/// - Shows loading state during data fetch
/// - Logs errors if loading fails
///
/// **Usage:**
/// ```dart
/// final controller = Get.put(PdfInfoController(repository));
/// // Data is loaded automatically in onInit()
/// ```
class PdfInfoController extends GetxController {
  final PdfInfoRepository repository;
  final PdfInfoState state = PdfInfoState();

  PdfInfoController(this.repository);

  @override
  void onInit() {
    super.onInit();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      state.isLoading.value = true;
      state.fileName.value = await repository.getFileName();
      state.pageCount.value = await repository.getPageCount();
      state.pdfInfo.value = await repository.getInfo();
      state.documentVersion.value = await repository.getDocumentVersion();
      state.pdfPermissionInfo.value = await repository.getPermissionsInfo();
      state.isEncrypted.value = await repository.isEncrypted();
      state.isLocked.value = await repository.isLocked();
      state.fileSizeInMB.value = await repository.getFileSizeInMB();
    } catch (e) {
      PdfViewerGlobal.logger.e('Failed to load document information: $e');
    } finally {
      state.isLoading.value = false;
    }
  }
}
