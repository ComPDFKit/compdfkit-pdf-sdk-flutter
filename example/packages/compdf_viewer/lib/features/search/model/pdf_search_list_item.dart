// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'pdf_search_item.dart';

/// A sealed class representing items in the grouped PDF search result list.
///
/// This sealed class pattern supports two types of list items for organizing
/// search results by page:
/// - [PdfSearchPageHeader] - Page number group header with match count
/// - [PdfSearchContentItem] - Individual search result content
///
/// **Usage:**
/// ```dart
/// final items = <PdfSearchListItem>[
///   PdfSearchPageHeader(5, 3),           // Page 6 header with 3 matches
///   PdfSearchContentItem(searchResult1),
///   PdfSearchContentItem(searchResult2),
///   PdfSearchContentItem(searchResult3),
/// ];
/// ```
///
/// Use pattern matching or type checking to render different widgets
/// for each item type in a ListView.
sealed class PdfSearchListItem {}

/// Page number group title item
class PdfSearchPageHeader extends PdfSearchListItem {
  final int pageIndex;
  final int count;

  PdfSearchPageHeader(this.pageIndex, this.count);
}

/// Search result content item
class PdfSearchContentItem extends PdfSearchListItem {
  final PdfSearchItem item;

  PdfSearchContentItem(this.item);
}
