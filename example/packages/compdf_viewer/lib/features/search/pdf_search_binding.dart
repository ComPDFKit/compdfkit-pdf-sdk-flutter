// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';

/// GetX binding for the PDF search feature.
///
/// This binding class is responsible for lazy-loading the search controller
/// when the search page is opened.
///
/// **Registered Dependencies:**
/// - [PdfSearchController] - Manages search state and operations
///
/// **Usage:**
/// ```dart
/// Get.to(
///   () => PdfSearchPage(),
///   binding: PdfSearchBinding(),
/// );
/// ```
class PdfSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PdfSearchController());
  }
}
