// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/page/cpdf_text_range.dart';

/// Model representing a single PDF text search result.
///
/// Contains:
/// - [keywordTextRange] - Exact text range of the matched keyword
/// - [contentTextRange] - Expanded text range including surrounding context
/// - [keywords] - The search keyword(s)
/// - [content] - Full text snippet with context (typically 20 chars before/after)
///
/// The expanded content helps users understand the context of each match.
///
/// Example:
/// ```dart
/// final searchItem = PdfSearchItem(
///   keywordTextRange: CPDFTextRange(pageIndex: 0, start: 50, count: 7),
///   contentTextRange: CPDFTextRange(pageIndex: 0, start: 30, count: 47),
///   keywords: 'invoice',
///   content: 'Please review the invoice number #12345 for payment',
/// );
///
/// // Display in search results list
/// Text(searchItem.content); // Shows context
/// // Highlight from index 20 to 27 (invoice)
/// ```
class PdfSearchItem {
  /// Exact text range of the matched keyword.
  final CPDFTextRange keywordTextRange;

  /// Expanded text range including surrounding context.
  final CPDFTextRange contentTextRange;

  /// The search keyword(s) that were matched.
  final String keywords;

  /// Full text snippet with context around the keyword.
  final String content;

  const PdfSearchItem({
    required this.keywordTextRange,
    required this.contentTextRange,
    required this.keywords,
    required this.content,
  });
}
