// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/convert/model/pdf_convert_image_state.dart';
import 'package:compdf_viewer/features/convert/model/pdf_page_range_type.dart';

/// GetX controller for PDF to image conversion feature.
///
/// Manages the state and logic for selecting page ranges when converting PDF
/// pages to images. Provides methods for initializing pages, applying range
/// selections, and getting localized range type labels.
///
/// Key features:
/// - Initialize page list from total page count
/// - Apply page range selection results
/// - Get localized labels for range types
///
/// Usage example:
/// ```dart
/// // In PdfConvertImagePage
/// final controller = Get.put(PdfConvertImageController());
/// controller.initPages(totalPages);
///
/// // After user selects range
/// controller.applyPageRangeResult(result);
///
/// // Get display label
/// final label = controller.getPageRangeTitle(
///   controller.state.pageRangeType.value
/// );
/// ```
///
/// State management:
/// - Uses PdfConvertImageState for reactive state
/// - Observes page range type and selected pages
/// - Integrates with PdfPageRangeSelectorPage for range selection
class PdfConvertImageController extends GetxController {
  final PdfConvertImageState state = PdfConvertImageState();

  void initPages(int totalPage) {
    state.pages.assignAll(List.generate(totalPage, (index) => index));
  }

  void applyPageRangeResult(PageRangeResult result) {
    state.pageRangeType.value = result.type;
    state.pages.assignAll(result.pageIndices);
  }

  String getPageRangeTitle(PdfPageRangeType type) {
    switch (type) {
      case PdfPageRangeType.all:
        return PdfLocaleKeys.pageChooseAll.tr;
      case PdfPageRangeType.odd:
        return PdfLocaleKeys.pageChooseOdd.tr;
      case PdfPageRangeType.even:
        return PdfLocaleKeys.pageChooseEven.tr;
      case PdfPageRangeType.current:
        return PdfLocaleKeys.pageChooseCurrent.tr;
      case PdfPageRangeType.custom:
        return PdfLocaleKeys.pageChoosePageRange.tr;
    }
  }
}
