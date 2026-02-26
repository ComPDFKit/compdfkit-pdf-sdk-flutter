// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/utils/file_util.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_type.dart';

/// Data model representing the configuration for inserting a new page into a PDF document.
///
/// This model encapsulates all the parameters needed to insert a page, including:
/// - Page type (blank, horizontal lines, musical notation, or square grid)
/// - Page size (A4, A3, Letter, Legal, Ledger, etc.)
/// - Page orientation (portrait or landscape)
///
/// Example:
/// ```dart
/// final pageData = InsertPageData(
///   type: InsertPageType.horizontalLine,
///   pageSize: CPDFPageSize.a4,
///   orientation: Orientation.portrait,
/// );
///
/// // Get page size adjusted for orientation
/// final finalSize = pageData.getPageSizeWithOrientation();
///
/// // Get template image path for the page type
/// final imagePath = await pageData.getImagePagePath();
/// ```
class InsertPageData {
  final InsertPageType type;

  final CPDFPageSize pageSize;

  final Orientation orientation;

  const InsertPageData({
    required this.type,
    required this.pageSize,
    required this.orientation,
  });

  CPDFPageSize getPageSizeWithOrientation() {
    if (orientation == Orientation.landscape) {
      return pageSize.withOrientation(Orientation.landscape);
    } else {
      return pageSize.withOrientation(Orientation.portrait);
    }
  }

  /// Get the file path of the inserted image page
  Future<String> getImagePagePath() async {
    final bool isA4 = pageSize == CPDFPageSize.a4;
    final bool isLandscape = orientation == Orientation.landscape;

    final baseName = _getBaseImageName(type, isA4);
    final orientationSuffix = isLandscape ? 'horizontal' : 'vertical';

    if (baseName.isEmpty) return '';

    File file = await FileUtil.extractAsset(
        'assets/${baseName}_$orientationSuffix.jpg');
    return file.path;
  }

  String _getBaseImageName(InsertPageType type, bool isA4) {
    switch (type) {
      case InsertPageType.horizontalLine:
        return isA4 ? 'ic_paper_line_a4' : 'ic_paper_line';
      case InsertPageType.musicalNotation:
        return isA4 ? 'ic_paper_music_a4' : 'ic_paper_music';
      case InsertPageType.square:
        return isA4 ? 'ic_paper_grid_a4' : 'ic_paper_grid';
      default:
        return '';
    }
  }
}
