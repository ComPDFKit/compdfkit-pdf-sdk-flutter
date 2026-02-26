// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_document_permission_info.dart';
import 'package:compdfkit_flutter/document/cpdf_info.dart';
import 'package:get/get.dart';

/// A responsive state class for PDF document information that only stores data.
class PdfInfoState {
  final RxBool isLoading = true.obs;

  final RxString fileName = ''.obs;

  final RxInt pageCount = 0.obs;

  /// Document metadata (title, author, etc.)
  final Rx<CPDFInfo> pdfInfo = Rx(CPDFInfo.empty());

  final RxString documentVersion = ''.obs;

  /// Document permission information
  final Rx<CPDFDocumentPermissionInfo> pdfPermissionInfo =
      Rx(CPDFDocumentPermissionInfo.empty());

  final RxBool isEncrypted = false.obs;

  final RxBool isLocked = false.obs;

  final RxDouble fileSizeInMB = 0.0.obs;
}
