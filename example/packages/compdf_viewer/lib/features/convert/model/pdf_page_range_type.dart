// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// PDF page range type enum
enum PdfPageRangeType {
  /// All pages
  all,

  /// Odd pages
  odd,

  /// Even pages
  even,

  /// Current page
  current,

  /// Custom page range
  custom,
}

/// PDF page range type enumeration and result data class.
///
/// Defines the available page range selection types for PDF operations like
/// conversion to images. Includes both predefined ranges (all, odd, even,
/// current) and custom range input.
///
/// Usage example:
/// ```dart
/// // Create result from selection
/// final result = PageRangeResult(
///   type: PdfPageRangeType.odd,
///   pageIndices: [0, 2, 4, 6, 8],
/// );
///
/// // Check range type
/// if (result.type == PdfPageRangeType.custom) {
///   // Handle custom range validation
/// }
/// ```
///
/// Integration:
/// - Used by PdfPageRangeSelectorPage for user selection
/// - Parsed by PdfPageUtil.parsePageRanges()
/// - Applied by PdfConvertImageController
class PageRangeResult {
  final PdfPageRangeType type;
  final List<int> pageIndices;

  const PageRangeResult({required this.type, required this.pageIndices});
}
