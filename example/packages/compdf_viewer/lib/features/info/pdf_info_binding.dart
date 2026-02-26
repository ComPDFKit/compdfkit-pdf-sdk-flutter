// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/features/info/controller/pdf_info_controller.dart';
import 'package:compdf_viewer/features/info/repository/pdf_info_repository.dart';

/// GetX binding for the PDF document information feature.
///
/// This binding class is responsible for lazy-loading the dependencies
/// required by the PDF info page.
///
/// **Registered Dependencies:**
/// - [PdfInfoRepository] - Data access for document metadata
/// - [PdfInfoController] - Manages document info state and loading
///
/// **Usage:**
/// ```dart
/// Get.to(
///   () => PdfInfoPage(),
///   binding: PdfInfoBinding(),
/// );
/// ```
class PdfInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PdfInfoRepository());
    Get.lazyPut(() => PdfInfoController(Get.find()));
  }
}
