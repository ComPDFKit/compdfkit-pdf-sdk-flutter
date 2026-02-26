// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/features/convert/model/pdf_page_range_type.dart';

/// Reactive state class for PDF to image conversion feature.
///
/// Holds the selected page range type and the list of page indices to be
/// converted. All properties are reactive (Rx) for automatic UI updates.
///
/// Key features:
/// - Reactive page range type selection
/// - Reactive list of selected page indices (0-based)
/// - Defaults to "all pages" selection
///
/// Usage example:
/// ```dart
/// // In controller
/// final state = PdfConvertImageState();
///
/// // Initialize pages
/// state.pages.assignAll([0, 1, 2, 3, 4]);
///
/// // Change range type
/// state.pageRangeType.value = PdfPageRangeType.odd;
///
/// // Observe in UI
/// Obx(() => Text('Pages: ${state.pages.length}'));
/// ```
///
/// State updates:
/// - pageRangeType updated when user selects range type
/// - pages updated when range selection applied
/// - Both trigger UI rebuilds via Obx

/// PDF Convert Image State Class
class PdfConvertImageState {
  /// Currently selected page range type
  final Rx<PdfPageRangeType> pageRangeType = PdfPageRangeType.all.obs;

  /// List of page numbers to be converted (0-based index)
  final RxList<int> pages = <int>[].obs;
}
