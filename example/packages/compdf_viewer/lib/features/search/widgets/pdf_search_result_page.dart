// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/search/model/pdf_search_list_item.dart';
import 'package:compdf_viewer/features/search/widgets/pdf_search_result_head_item.dart';
import 'package:compdf_viewer/features/search/widgets/pdf_search_result_item.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// A page widget that displays grouped PDF search results with page headers.
///
/// This widget shows the complete list of search results organized by page,
/// with a total count header, page group headers, and individual result items.
///
/// **Layout Structure:**
/// - Total results header (top) - Shows "Search Results (count)"
/// - Scrollable list (main) - Alternating headers and result items
/// - Loading indicator (during search)
/// - Empty state (no results found)
///
/// **List Organization:**
/// - Results grouped by page using [PdfSearchPageHeader]
/// - Each group shows page number and match count
/// - Individual items rendered with [PdfSearchResultItem]
/// - Dividers between consecutive result items (not between header and item)
///
/// **States:**
/// - **Loading:** Shows centered CircularProgressIndicator
/// - **Empty:** Shows "No results" icon and message
/// - **Results:** Shows grouped list with total count
///
/// **Usage:**
/// ```dart
/// PdfSearchResultPage() // Auto-connects to PdfSearchController
/// ```
class PdfSearchResultPage extends GetView<PdfSearchController> {
  const PdfSearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final groupedList = controller.state.groupedResults;
      if (groupedList.isEmpty) {
        return _buildEmptyState(context);
      }

      return Column(
        children: [
          _buildTotalHeader(
            context,
            controller.state.searchResults.length,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: groupedList.length,
              separatorBuilder: (context, index) {
                final currentItem = groupedList[index];
                final nextItem = index + 1 < groupedList.length
                    ? groupedList[index + 1]
                    : null;
                if (currentItem is PdfSearchContentItem &&
                    nextItem is PdfSearchContentItem) {
                  return Divider(
                    height: 1,
                    indent: 56,
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  );
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (context, index) {
                final listItem = groupedList[index];
                return switch (listItem) {
                  PdfSearchPageHeader(:final pageIndex, :final count) =>
                    PdfSearchResultHeadItem(pageIndex: pageIndex, count: count),
                  PdfSearchContentItem(:final item) =>
                    PdfSearchResultItem(item: item),
                };
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            PdfLocaleKeys.noSearchResults.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalHeader(BuildContext context, int totalCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Text(
        '${PdfLocaleKeys.searchResults.tr} ($totalCount)',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
