/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cpdf_search_options.dart';

class CPDFTextSearcher {

  late final MethodChannel _channel;

  final List<CPDFTextRange> _searchResults = List.empty(growable: true);

  get searchResults => _searchResults;

  CPDFTextSearcher(int viewId)
      : _channel = MethodChannel('com.compdfkit.flutter.document_$viewId');

  /// Searches for text in the PDF document.
  /// This method allows you to search for specific keywords in the PDF document
  /// and returns a list of text ranges where the keywords are found.
  ///
  /// You can specify search options such as case sensitivity and whether to match whole words.
  /// ```dart
  /// final searcher = cpdfDocument.getTextSearcher();
  /// List<CPDFTextRange> results = await searcher.searchText(
  ///   'keywords', searchOptions: CPDFSearchOptions.caseInsensitive);
  /// ```
  /// selection can be made on the search results using the `selection()` method.
  Future<List<CPDFTextRange>> searchText(String keywords,
      {searchOptions = CPDFSearchOptions.caseInsensitive}) async {
    _searchResults.clear();
    final rawList = await _channel.invokeMethod('search_text',
        {'keywords': keywords, 'search_options': searchOptions.nativeValue});
    if (rawList is! List) return [];

    try {
      final mappedResults = rawList
          .cast<Map>()
          .map((raw) => Map<String, dynamic>.from(raw))
          .map(CPDFTextRange.fromJson)
          .toList();

      _searchResults.addAll(mappedResults);
    } catch (e) {
      debugPrint('Failed to parse search result: $e');
    }
    return searchResults;
  }

  /// Selects a specific text range in the PDF document.
  /// This method allows you to select a text range based on the provided
  /// ```dart
  /// // first: search for text
  /// final searcher = cpdfDocument.getTextSearcher();
  /// List<CPDFTextRange> results = await searcher.searchText(
  ///  'keywords', searchOptions: CPDFSearchOptions.caseInsensitive);
  ///
  /// // then: select the first result
  /// CPDFTextRange range = searcher.searchResults[0];
  /// await searcher.selection(range);
  /// ```
  Future<void> selection(CPDFTextRange range) async {
    return await _channel.invokeMethod('search_text_selection', range.toJson());
  }

  /// Clears the current search results.
  /// This method clears the list of search results and resets the search state.
  /// ```dart
  /// final searcher = cpdfDocument.getTextSearcher();
  /// await searcher.clearSearch();
  /// ```
  Future<void> clearSearch() async {
    _searchResults.clear();
    return await _channel.invokeMethod('search_text_clear');
  }

}
