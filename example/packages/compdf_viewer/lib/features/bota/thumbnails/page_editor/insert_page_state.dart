// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_data.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_option.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_size_data.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_type.dart';

/// Reactive state for insert page dialog configuration.
///
/// Manages all UI state for page insertion including type selection, size
/// options, orientation, and predefined page templates (blank, lines, music, grid).
///
/// Key state properties:
/// - `insertPageType`: Selected page type (blank or template)
/// - `pageOptions`: List of available templates with previews
/// - `pageSizes`: List of standard page sizes (A4, A3, Letter, etc.)
/// - `selectedPageSize`: Currently selected page size
/// - `selectOrientation`: Portrait or landscape
///
/// Page options with thumbnails:
/// - Blank white page
/// - Horizontal line paper
/// - Musical notation paper
/// - Square grid paper
///
/// Standard page sizes:
/// - A4, A3, Letter, Legal, Ledger (via CPDFPageSize)
///
/// Usage example:
/// ```dart
/// final state = InsertPageState();
///
/// // Select page type
/// state.setInsertPageType(InsertPageType.horizontalLine);
///
/// // Select size and orientation
/// state.selectedPageSize.value = pageSizes[0]; // A4
/// state.selectOrientation.value = Orientation.landscape;
///
/// // Get final insert data
/// final data = state.getInsertPageData();
///
/// // Reset to defaults
/// state.reset();
/// ```

class InsertPageState {
  // Currently selected insert page type
  Rx<InsertPageType> insertPageType = InsertPageType.blankPage.obs;

  List<InsertPageOption> pageOptions = [
    InsertPageOption(
      widget: Container(width: 50, height: 71, color: Colors.white),
      title: PdfLocaleKeys.blankPage.tr,
      type: InsertPageType.blankPage,
    ),
    InsertPageOption(
      widget: Image.asset(
        PdfViewerAssets.icPaperLineThumbnail,
        package: PdfViewerAssets.packageName,
        width: 50,
        height: 71,
      ),
      title: PdfLocaleKeys.horizontalLine.tr,
      type: InsertPageType.horizontalLine,
    ),
    InsertPageOption(
      widget: Image.asset(
        PdfViewerAssets.icPaperMusicThumbnail,
        package: PdfViewerAssets.packageName,
        width: 50,
        height: 71,
      ),
      title: PdfLocaleKeys.musicalNotation.tr,
      type: InsertPageType.musicalNotation,
    ),
    InsertPageOption(
      widget: Image.asset(
        PdfViewerAssets.icPaperGridThumbnail,
        package: PdfViewerAssets.packageName,
        width: 50,
        height: 71,
      ),
      title: PdfLocaleKeys.square.tr,
      type: InsertPageType.square,
    ),
  ];

  // Page size options list
  List<InsertPageSizeData> pageSizes = [
    InsertPageSizeData(
        name: PdfLocaleKeys.pageSizeA4.tr, pageSize: CPDFPageSize.a4),
    InsertPageSizeData(
        name: PdfLocaleKeys.pageSizeA3.tr, pageSize: CPDFPageSize.a3),
    InsertPageSizeData(
        name: PdfLocaleKeys.pageSizeLatter.tr, pageSize: CPDFPageSize.letter),
    InsertPageSizeData(
        name: PdfLocaleKeys.pageSizeLegal.tr, pageSize: CPDFPageSize.legal),
    InsertPageSizeData(
        name: PdfLocaleKeys.pageSizeLedger.tr, pageSize: CPDFPageSize.ledger),
  ];

  /// Selected page size
  Rx<InsertPageSizeData> selectedPageSize =
      Rx<InsertPageSizeData>(InsertPageSizeData(
    name: PdfLocaleKeys.pageSizeA4.tr,
    pageSize: CPDFPageSize.a4,
  ));

  Rx<Orientation> selectOrientation = Orientation.portrait.obs;

  void setInsertPageType(InsertPageType type) {
    insertPageType.value = type;
  }

  void reset() {
    insertPageType.value = InsertPageType.blankPage;
    selectedPageSize.value = InsertPageSizeData(
      name: PdfLocaleKeys.pageSizeA4.tr,
      pageSize: CPDFPageSize.a4,
    );
    selectOrientation.value = Orientation.portrait;
  }

  InsertPageData getInsertPageData() {
    return InsertPageData(
      type: insertPageType.value,
      pageSize: selectedPageSize.value.pageSize,
      orientation: selectOrientation.value,
    );
  }
}
