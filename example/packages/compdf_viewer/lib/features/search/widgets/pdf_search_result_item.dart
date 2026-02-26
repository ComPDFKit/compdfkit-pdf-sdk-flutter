// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/search/model/pdf_search_item.dart';

/// A list item widget representing a single PDF search result.
///
/// This widget displays a search result with the matching text snippet,
/// highlighting the search keyword within the context of surrounding text.
///
/// **Displayed Information:**
/// - Text snippet icon (leading) - Shows document icon in colored container
/// - Content preview (title) - Up to 3 lines with keyword highlighted
/// - Highlighted keyword - Yellow background with bold text
///
/// **User Interaction:**
/// - **Tap:** Navigate to the result's location in the PDF and close search panel
///
/// **Text Highlighting:**
/// - Calculates relative keyword position within content snippet
/// - Applies colored background and bold style to matched keyword
/// - Handles edge cases when keyword position is out of bounds
///
/// **Usage:**
/// ```dart
/// PdfSearchResultItem(item: searchResultItem)
/// ```
class PdfSearchResultItem extends GetView<PdfSearchController> {
  final PdfSearchItem item;

  const PdfSearchResultItem({super.key, required this.item});

  void _handleTap() async {
    await controller.setSelectionIndex(item);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: _handleTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.text_snippet_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: _buildHighlightText(context, item),
      ),
    );
  }

  Widget _buildHighlightText(BuildContext context, PdfSearchItem item) {
    final content = item.content;
    final keyword = item.keywords;
    final keywordStartInPage = item.keywordTextRange.location;
    final contentStartInPage = item.contentTextRange.location;

    final relativeKeywordStart = keywordStartInPage - contentStartInPage;

    final textStyle = Theme.of(context).textTheme.bodyMedium;
    if (relativeKeywordStart < 0 ||
        relativeKeywordStart + keyword.length > content.length) {
      return RichText(
        text: TextSpan(
          text: content,
          style: textStyle,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }

    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: content.substring(0, relativeKeywordStart)),
          TextSpan(
            text: content.substring(
              relativeKeywordStart,
              relativeKeywordStart + keyword.length,
            ),
            style: textStyle?.copyWith(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: content.substring(relativeKeywordStart + keyword.length),
          ),
        ],
      ),
    );
  }
}
