// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdf_viewer/utils/pdf_dir_util.dart';
import 'package:compdf_viewer/features/convert/model/pdf_page_range_type.dart';

/// PDF page range parsing and PDF-to-image conversion utilities.
///
/// Provides static methods for:
/// - Parsing predefined page ranges (all, odd, even, current)
/// - Parsing custom page range strings (e.g., "1-3,5,7-9")
/// - Converting PDF pages to PNG images with organized file storage
///
/// Key features:
/// - Validates page ranges against total page count
/// - Supports mixed range syntax: single pages and ranges ("1,3-5,7")
/// - Auto-increments output directory names to avoid overwriting
/// - Renders pages at native size for high-quality output
///
/// Usage examples:
/// ```dart
/// // Parse predefined range
/// final pages = PdfPageUtil.parsePageRanges(
///   PdfPageRangeType.odd,
///   totalPage: 10,
///   currentPageIndex: 0,
/// );
/// // Returns: [0, 2, 4, 6, 8]
///
/// // Parse custom range string
/// final customPages = PdfPageUtil.parseCustomPageRange("1-3,5,7", 10);
/// // Returns: [0, 1, 2, 4, 6] (0-indexed)
///
/// // Convert pages to images
/// final outputDir = await PdfPageUtil.pdfToImage(
///   controller,
///   [0, 1, 2],  // Pages to convert
/// );
/// // Creates: /path/to/images/document_name/page_1.png, page_2.png, ...
/// ```
///
/// Error handling:
/// - parseCustomPageRange throws FormatException for invalid syntax
/// - Validates page numbers are within bounds [1, totalPage]
/// - Empty or malformed input is rejected with descriptive errors
class PdfPageUtil {
  static List<int> parsePageRanges(
      PdfPageRangeType range, int totalPage, int currentPageIndex) {
    switch (range) {
      case PdfPageRangeType.all:
        return List.generate(totalPage, (index) => index);
      case PdfPageRangeType.odd:
        return List.generate(totalPage, (index) => index)
            .where((index) => index % 2 == 0)
            .toList();
      case PdfPageRangeType.even:
        return List.generate(totalPage, (index) => index)
            .where((index) => index % 2 == 1)
            .toList();
      case PdfPageRangeType.current:
        return [currentPageIndex];
      default:
        return [];
    }
  }

  static List<int> parseCustomPageRange(String input, int totalPage) {
    if (input.trim().isEmpty) {
      throw FormatException("Custom page range cannot be empty");
    }

    final Set<int> result = {};
    final parts = input.split(',');

    for (var part in parts) {
      part = part.trim();
      if (part.isEmpty) {
        throw FormatException("Page part cannot be empty");
      }

      if (part.contains('-')) {
        // Handle range, e.g. "1-3"
        final range = part.split('-');
        if (range.length != 2) {
          throw FormatException("Invalid range format: '$part'");
        }
        final start = int.tryParse(range[0]);
        final end = int.tryParse(range[1]);
        if (start == null || end == null) {
          throw FormatException(
              "Page numbers in range must be integers: '$part'");
        }
        if (start < 1 ||
            end < 1 ||
            start > totalPage ||
            end > totalPage ||
            start > end) {
          throw FormatException(
              "Page out of range or start page greater than end page: '$part'");
        }
        for (int i = start; i <= end; i++) {
          result.add(i - 1);
        }
      } else {
        // Handle single page number
        final page = int.tryParse(part);
        if (page == null) {
          throw FormatException("Page number must be an integer: '$part'");
        }
        if (page < 1 || page > totalPage) {
          throw FormatException("Page out of range: $page");
        }
        result.add(page - 1);
      }
    }

    return result.toList()..sort();
  }

  static Future<String> pdfToImage(
      CPDFReaderWidgetController controller, List<int> pages,
      {bool drawAnnot = true}) async {
    // 1. Get PDF file name
    final fileName = await controller.document.getFileName();
    final fileNameNoExt = fileName.split('.').first;

    // 3. Build base path
    final imageDir = await PdfDirUtil.getImageDirectory();
    final baseDirPath = imageDir?.path;

    // 4. Build final folder path, auto-increment if already exists
    String targetDirPath = '$baseDirPath/$fileNameNoExt';
    int counter = 0;
    while (await Directory(targetDirPath).exists()) {
      targetDirPath = '$baseDirPath/$fileNameNoExt($counter)';
      counter++;
    }

    final targetDir = Directory(targetDirPath);
    await targetDir.create(recursive: true);

    // 5. Iterate pages, save each page as image
    for (int pageIndex in pages) {
      final pageSize = await controller.document.getPageSize(pageIndex);
      final imageBytes = await controller.document.renderPage(
          pageIndex: pageIndex,
          width: pageSize.width.toInt(),
          height: pageSize.height.toInt());

      final filePath = '${targetDir.path}/page_${pageIndex + 1}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
    }

    // 6. Return directory path
    return targetDir.path;
  }
}
