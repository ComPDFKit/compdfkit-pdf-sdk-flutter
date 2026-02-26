// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/features/search/model/pdf_search_item.dart';
import 'package:compdf_viewer/features/search/model/pdf_search_state.dart';

/// Controller for PDF text search functionality.
///
/// Provides full-text search capabilities with:
/// - Keyword searching across all PDF pages
/// - Context snippet extraction (20 chars before/after match)
/// - Search result navigation (next/previous with wrap-around)
/// - Real-time highlight selection in PDF viewer
/// - Result grouping by page
///
/// Example:
/// ```dart
/// final searchController = Get.find<PdfSearchController>();
///
/// // Start search
/// await searchController.startSearchText('invoice');
///
/// // Navigate results
/// searchController.nextSelection();
/// searchController.previousSelection();
///
/// // Clear search
/// searchController.clearSearch();
/// ```
class PdfSearchController extends GetxController {
  final PdfViewerController _pdfController = Get.find<PdfViewerController>();

  final PdfSearchState state = PdfSearchState();

  CPDFReaderWidgetController? get _readerController =>
      _pdfController.readerController.value;

  /// Starts a full-text search in the PDF document for the given [text].
  ///
  /// For each match, expands the text range to include surrounding context
  /// and builds a [PdfSearchItem] with both the keyword range and the
  /// content snippet. Results are stored in [state.searchResults].
  Future<void> startSearchText(String text) async {
    state.searchText.value = text;
    final controller = _readerController;
    if (controller == null) return;
    state.setLoading(true);
    try {
      final document = controller.document;
      final textSearcher = document.getTextSearcher();
      final list = await textSearcher.searchText(text);
      final newList = await Future.wait(list.map((e) async {
        final newRange = e.expanded(before: 20, after: 20);
        final page = document.pageAtIndex(e.pageIndex);
        final content = await page.getText(newRange);
        return PdfSearchItem(
          keywordTextRange: e,
          contentTextRange: newRange,
          keywords: text,
          content: content,
        );
      }));
      state.searchResults.assignAll(newList);
      state.rebuildGroupedResults();
    } catch (e) {
      e.printInfo();
    } finally {
      state.setLoading(false);
    }
  }

  /// Selects the given search result [item] and highlights it in the PDF.
  Future<void> setSelectionIndex(PdfSearchItem item) async {
    state.setSelectionIndex(item);
    final controller = _readerController;
    if (controller == null) return;
    final textSearcher = controller.document.getTextSearcher();
    await textSearcher.selection(item.keywordTextRange);
  }

  /// Moves the highlight to the next search result, wrapping around to the first.
  void nextSelection() {
    final nextItem = state.getNextSelectionItem();
    if (nextItem != null) setSelectionIndex(nextItem);
  }

  /// Moves the highlight to the previous search result, wrapping around to the last.
  void previousSelection() {
    final previousItem = state.getPreviousSelectionItem();
    if (previousItem != null) setSelectionIndex(previousItem);
  }

  /// Clears all search results, resets the state, and removes
  /// the search highlight from the PDF document.
  void clearSearch() {
    state.reset();
    _readerController?.document.getTextSearcher().clearSearch();
  }

  @override
  void onClose() {
    clearSearch();
    super.onClose();
  }
}
