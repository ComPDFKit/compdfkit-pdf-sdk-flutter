// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

import 'package:compdf_viewer/features/search/model/pdf_search_item.dart';
import 'package:compdf_viewer/features/search/model/pdf_search_list_item.dart';

/// Reactive state for PDF text search functionality.
///
/// Manages:
/// - Search text input
/// - Raw search results with text ranges and context
/// - Grouped display list with page headers
/// - Current selection for result navigation
/// - Loading state during search operations
///
/// Example:
/// ```dart
/// final state = PdfSearchState();
///
/// // Start search
/// state.searchText.value = 'invoice';
/// state.searchResults.assignAll(results);
/// state.rebuildGroupedResults();
///
/// // Navigate results
/// final next = state.getNextSelectionItem();
/// state.setSelectionIndex(next);
///
/// // Clear search
/// state.reset();
/// ```
class PdfSearchState {
  /// Current search text input.
  final searchText = ''.obs;

  /// Raw search results list.
  ///
  /// Each item contains:
  /// - Keyword text range (exact match)
  /// - Content text range (with 20 chars context before/after)
  /// - Full context snippet
  final RxList<PdfSearchItem> searchResults = <PdfSearchItem>[].obs;

  /// Grouped display list for UI rendering.
  ///
  /// Combines [searchResults] with page headers showing result count per page.
  /// Cached to avoid rebuilding on each widget build.
  final RxList<PdfSearchListItem> groupedResults = <PdfSearchListItem>[].obs;

  /// Currently selected search result for highlight navigation.
  final Rx<PdfSearchItem?> currentSelectionItem = Rx(null);

  /// Whether a search operation is in progress.
  final RxBool isLoading = false.obs;

  PdfSearchState();

  /// Set loading state.
  void setLoading(bool value) => isLoading.value = value;

  /// Rebuild grouped display list based on [searchResults].
  ///
  /// Groups results by page and inserts page headers with result counts.
  /// Call this after updating [searchResults].
  void rebuildGroupedResults() {
    final list = searchResults;
    if (list.isEmpty) {
      groupedResults.clear();
      return;
    }

    final List<PdfSearchListItem> result = [];
    int? lastPage;

    // Count search results per page
    final Map<int, int> pageCountMap = {};
    for (var item in list) {
      final pageIndex = item.keywordTextRange.pageIndex;
      pageCountMap[pageIndex] = (pageCountMap[pageIndex] ?? 0) + 1;
    }

    for (var item in list) {
      final pageIndex = item.keywordTextRange.pageIndex;
      if (pageIndex != lastPage) {
        result.add(PdfSearchPageHeader(pageIndex, pageCountMap[pageIndex]!));
        lastPage = pageIndex;
      }
      result.add(PdfSearchContentItem(item));
    }

    groupedResults.assignAll(result);
  }

  /// Reset all state to initial values.
  ///
  /// Clears search text, results, grouped list, selection, and loading state.
  void reset() {
    searchText.value = '';
    searchResults.clear();
    groupedResults.clear();
    currentSelectionItem.value = null;
    isLoading.value = false;
  }

  /// Set the currently selected search result.
  void setSelectionIndex(PdfSearchItem item) {
    currentSelectionItem.value = item;
  }

  /// Get next search result (circular navigation).
  ///
  /// Wraps around to the first result when reaching the end.
  /// Returns null if no results exist.
  PdfSearchItem? getNextSelectionItem() {
    if (searchResults.isEmpty) return null;

    int currentIndex = searchResults.indexOf(currentSelectionItem.value);
    int nextIndex;

    if (currentIndex == -1 || currentIndex >= searchResults.length - 1) {
      nextIndex = 0; // Wrap to first
    } else {
      nextIndex = currentIndex + 1;
    }

    return searchResults[nextIndex];
  }

  /// Get previous search result (circular navigation).
  ///
  /// Wraps around to the last result when reaching the beginning.
  /// Returns null if no results exist.
  PdfSearchItem? getPreviousSelectionItem() {
    if (searchResults.isEmpty) return null;

    int currentIndex = searchResults.indexOf(currentSelectionItem.value);
    int prevIndex;

    if (currentIndex <= 0) {
      prevIndex = searchResults.length - 1; // Wrap to last
    } else {
      prevIndex = currentIndex - 1;
    }

    return searchResults[prevIndex];
  }
}
