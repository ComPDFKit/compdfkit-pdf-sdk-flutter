// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/page/cpdf_search_options.dart';
import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:compdfkit_flutter/page/cpdf_text_searcher.dart';
import 'package:compdfkit_flutter_example/features/search/search_results_list.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../model/cpdf_search_item.dart';

/// Search Text Example (Document API)
///
/// Demonstrates full-text search using CPDFDocument API without UI widget.
///
/// This example shows:
/// - Opening a PDF document using [CPDFDocument.open]
/// - Creating and using [CPDFTextSearcher] for text search
/// - Configuring search options with [CPDFSearchOptions]
/// - Expanding search results with context using [CPDFTextRange.expanded]
/// - Extracting text content from search results with [CPDFPage.getText]
///
/// Key classes/APIs used:
/// - [CPDFDocument]: Opens and manages the PDF document
/// - [CPDFTextSearcher]: Performs text search operations
/// - [CPDFTextRange]: Represents search result position and range
/// - [CPDFSearchOptions]: Controls search behavior (case sensitivity)
/// - [CPDFPage]: Provides page-level text extraction
///
/// Usage:
/// 1. Open the example
/// 2. Tap "Search Text" button
/// 3. Enter a search keyword in the dialog
/// 4. View search results grouped by page
class SearchTextExample extends StatefulWidget {
  const SearchTextExample({super.key});

  @override
  State<SearchTextExample> createState() => _SearchTextExampleState();
}

class _SearchTextExampleState extends State<SearchTextExample> {
  final TextEditingController _textEditingController = TextEditingController();

  final List<CPDFSearchItem> _results = [];

  /// PDF document instance
  late CPDFDocument document;

  @override
  void initState() {
    super.initState();
    openDocument();
  }

  /// Open document
  Future<void> openDocument() async {
    final file = await extractAsset(
      shouldOverwrite: true,
      AppAssets.pdfDocument,
    );
    document = await CPDFDocument.createInstance();
    final error = await document.open(file.path);
    debugPrint('Open result: ${error.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Search Text Example',
            onBack: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: _handleSearch,
            child: const Text('Search Text'),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Future<void> _handleSearch() async {
    final keyword = await _showInputDialog();
    if (keyword == null || keyword.trim().isEmpty) {
      return;
    }

    final CPDFTextSearcher searcher = document.getTextSearcher();
    final List<CPDFTextRange> ranges = await searcher.searchText(
      keyword,
      searchOptions: CPDFSearchOptions.caseInsensitive,
    );

    final List<CPDFSearchItem> items = await Future.wait(
      ranges.map((range) async {
        final CPDFPage page = document.pageAtIndex(range.pageIndex);
        final CPDFTextRange expanded = range.expanded(before: 20, after: 20);
        final String contextText = await page.getText(expanded);
        return CPDFSearchItem(
          keywordsTextRange: range,
          contentTextRange: expanded,
          keywords: keyword,
          content: contextText,
        );
      }),
    );

    setState(() {
      _results
        ..clear()
        ..addAll(items);
    });
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return const Center(child: Text('No results'));
    }

    final grouped = <int, List<CPDFSearchItem>>{};
    for (final item in _results) {
      grouped.putIfAbsent(item.keywordsTextRange.pageIndex, () => []).add(item);
    }

    return SearchResultsList(results: _results, onResultTap: (item) {});
  }

  Future<String?> _showInputDialog() {
    _textEditingController.clear();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Keyword'),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Please enter search content',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, _textEditingController.text.trim()),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
