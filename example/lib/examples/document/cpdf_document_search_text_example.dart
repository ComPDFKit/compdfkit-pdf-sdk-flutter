/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/page/cpdf_search_options.dart';
import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:compdfkit_flutter/page/cpdf_text_searcher.dart';
import 'package:flutter/material.dart';

import '../../model/cpdf_search_item.dart';
import '../../utils/file_util.dart';

class CPDFDocumentSearchTextExample extends StatefulWidget {
  const CPDFDocumentSearchTextExample({super.key});

  @override
  State<CPDFDocumentSearchTextExample> createState() =>
      _CPDFDocumentSearchTextExampleState();
}

class _CPDFDocumentSearchTextExampleState
    extends State<CPDFDocumentSearchTextExample> {
  final TextEditingController _textEditingController = TextEditingController();

  final List<CPDFSearchItem> _searchResults = [];

  late CPDFDocument _document;

  @override
  void initState() {
    super.initState();
    _openDocument();
  }

  /// Extracts the PDF from assets and opens it
  Future<void> _openDocument() async {
    final File file = await extractAsset(
      context,
      shouldOverwrite: true,
      'pdfs/PDF_Document.pdf',
    );
    _document = await CPDFDocument.createInstance();
    await _document.open(file.path);
  }

  /// Triggers search and updates the results
  Future<void> _handleSearch() async {
    // Prompt the user to input a search keyword.
    final String? keyword = await _showInputDialog();
    // If the input is null or empty (user canceled or entered nothing), return early.
    if (keyword == null || keyword.trim().isEmpty) return;

    // Create a CPDFTextSearcher instance from the document.
    final CPDFTextSearcher searcher = _document.getTextSearcher();

    // Perform a case-insensitive text search using the input keyword.
    final List<CPDFTextRange> ranges = await searcher.searchText(
      keyword,
      searchOptions: CPDFSearchOptions.caseInsensitive,
    );

    // For each found text range, extract context text and build a CPDFSearchItem list.
    final List<CPDFSearchItem> items =
        await Future.wait(ranges.map((range) async {
      // Get the page where the text was found.
      final CPDFPage page = _document.pageAtIndex(range.pageIndex);

      // Expand the found range to include 20 characters before and after for context.
      final CPDFTextRange expanded = range.expanded(before: 20, after: 20);

      // Extract the context text from the expanded range.
      final String contextText = await page.getText(expanded);

      // Construct a search item with keyword, context, and their respective ranges.
      return CPDFSearchItem(
        keywordsTextRange: range,
        contentTextRange: expanded,
        keywords: keyword,
        content: contextText,
      );
    }));

    setState(() {
      _searchResults
        ..clear()
        ..addAll(items);
    });
  }

  /// Group the search results by page index
  Map<int, List<CPDFSearchItem>> _groupResultsByPage() {
    final Map<int, List<CPDFSearchItem>> grouped = {};
    for (final item in _searchResults) {
      final int pageIndex = item.keywordsTextRange.pageIndex;
      grouped.putIfAbsent(pageIndex, () => []).add(item);
    }
    return grouped;
  }

  /// Dialog for entering keyword
  Future<String?> _showInputDialog() {
    _textEditingController.clear();

    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter keyword'),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Type text to search'),
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

  /// Highlights matched keyword in context text
  Widget _highlightResult(CPDFSearchItem item) {
    final String content = item.content;
    final String keyword = item.keywords;

    final int keywordStart = item.keywordsTextRange.location;
    final int contextStart = item.contentTextRange.location;
    final int relativeStart = keywordStart - contextStart;

    if (relativeStart < 0 || relativeStart + keyword.length > content.length) {
      return Text(content);
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: content.substring(0, relativeStart)),
          TextSpan(
            text: content.substring(
              relativeStart,
              relativeStart + keyword.length,
            ),
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: content.substring(relativeStart + keyword.length)),
        ],
      ),
    );
  }

  /// Builds the main UI
  @override
  Widget build(BuildContext context) {
    final groupedResults = _groupResultsByPage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Text Example'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: _handleSearch,
            child: const Text('Search Text'),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: groupedResults.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView(
                      children: groupedResults.entries.map((entry) {
                        final int pageIndex = entry.key;
                        final List<CPDFSearchItem> items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Page ${pageIndex + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            ...items.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: _highlightResult(item),
                                )),
                            const Divider(color: Colors.black26),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
