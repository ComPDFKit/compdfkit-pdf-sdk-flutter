// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/page/cpdf_search_options.dart';
import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:compdfkit_flutter/page/cpdf_text_searcher.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../model/cpdf_search_item.dart';
import '../../utils/preferences_service.dart';
import '../../features/search/search_text_list_page.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/search_navigation_bar.dart';
import '../shared/example_document_loader.dart';

import '../../constants/asset_paths.dart';

/// Text Search API Example
///
/// Demonstrates programmatic text search using the CPDFTextSearcher API,
/// providing full control over search operations, results, and navigation.
///
/// This example shows:
/// - Creating and using [CPDFTextSearcher] for programmatic search
/// - Searching text with configurable options (case-insensitive, etc.)
/// - Extracting context text around search matches
/// - Navigating between search results (previous/next)
/// - Displaying a list of all search results with context preview
/// - Highlighting and selecting search results in the document
///
/// Key classes/APIs used:
/// - [CPDFTextSearcher]: Core API for programmatic text search operations
/// - [CPDFTextSearcher.searchText]: Searches for text with specified options
/// - [CPDFTextSearcher.selection]: Highlights a specific search result
/// - [CPDFTextSearcher.clearSearch]: Clears all search highlights
/// - [CPDFTextRange]: Represents a text range with page index and character positions
/// - [CPDFSearchOptions]: Search configuration (case sensitivity, whole word, etc.)
/// - [CPDFPage.getText]: Extracts text content from a page for context preview
///
/// Usage:
/// 1. Open the PDF document with the reader widget
/// 2. Enter a search keyword in the bottom search bar
/// 3. Use navigation arrows to move between results
/// 4. Tap the list icon to view all results with context
/// 5. Select a result from the list to jump directly to it
class TextSearchApiExample extends StatelessWidget {
  /// Constructor
  const TextSearchApiExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Text Search API',
      assetPath: _assetPath,
      builder: (path) => _TextSearchApiPage(documentPath: path),
    );
  }
}

class _TextSearchApiPage extends StatefulWidget {
  final String documentPath;

  const _TextSearchApiPage({required this.documentPath});

  @override
  State<_TextSearchApiPage> createState() => _TextSearchApiPageState();
}

class _TextSearchApiPageState extends State<_TextSearchApiPage> {
  CPDFReaderWidgetController? _controller;
  CPDFTextSearcher? _searcher;
  bool _showPDFReader = false;

  final TextEditingController _searchController = TextEditingController();

  List<CPDFSearchItem> _searchResults = [];
  int _currentIndex = -1;
  bool _isSearching = false;

  bool get _hasResults => _searchResults.isNotEmpty;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() => _showPDFReader = true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Text Search API',
            onBack: () async {
              if (_controller != null) {
                await _controller!.document.save();
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showPDFReader ? _buildPDFReader() : const Center(),
            ),
          ),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildPDFReader() {
    return CPDFReaderWidget(
      document: widget.documentPath,
      configuration: CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      ),
      onCreated: (controller) async {
        final document = controller.document;
        setState(() {
          _controller = controller;
          _searcher = document.getTextSearcher();
        });
      },
    );
  }

  Widget _buildBottomPanel() {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchNavigationBar(
            visible: _hasResults,
            currentIndex: _currentIndex,
            totalCount: _searchResults.length,
            onPrevious: _goToPrevious,
            onNext: _goToNext,
            onShowList: _showResultList,
          ),
          PdfSearchBar(
            controller: _searchController,
            isLoading: _isSearching,
            onSearch: _performSearch,
            onClear: _clearSearch,
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch(String keyword) async {
    if (keyword.isEmpty || _searcher == null || _controller == null) return;

    setState(() => _isSearching = true);

    try {
      final document = _controller!.document;
      final ranges = await _searcher!.searchText(
        keyword,
        searchOptions: CPDFSearchOptions.caseInsensitive,
      );

      if (ranges.isEmpty) {
        setState(() {
          _searchResults = [];
          _currentIndex = -1;
          _isSearching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No results found')));
        }
        return;
      }

      final items = await Future.wait(
        ranges.map((range) async {
          final page = document.pageAtIndex(range.pageIndex);
          final expanded = range.expanded(before: 20, after: 20);
          final contextText = await page.getText(expanded);
          return CPDFSearchItem(
            keywordsTextRange: range,
            contentTextRange: expanded,
            keywords: keyword,
            content: contextText,
          );
        }),
      );

      setState(() {
        _searchResults = items;
        _currentIndex = 0;
        _isSearching = false;
      });

      _selectCurrentResult();
    } catch (e) {
      setState(() => _isSearching = false);
      debugPrint('Search error: $e');
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _selectCurrentResult();
    }
  }

  void _goToNext() {
    if (_currentIndex < _searchResults.length - 1) {
      setState(() => _currentIndex++);
      _selectCurrentResult();
    }
  }

  Future<void> _selectCurrentResult() async {
    if (_currentIndex < 0 || _currentIndex >= _searchResults.length) return;

    final item = _searchResults[_currentIndex];
    await _searcher?.selection(item.keywordsTextRange);
    await _controller?.setDisplayPageIndex(
      pageIndex: item.keywordsTextRange.pageIndex,
    );
  }

  Future<void> _showResultList() async {
    final selectedItem = await Navigator.push<CPDFSearchItem>(
      context,
      MaterialPageRoute(
        builder: (context) => SearchTextListPage(results: _searchResults),
      ),
    );

    if (selectedItem != null) {
      final index = _searchResults.indexOf(selectedItem);
      if (index >= 0) {
        setState(() => _currentIndex = index);
        _selectCurrentResult();
      }
    }
  }

  void _clearSearch() {
    _searcher?.clearSearch();
    setState(() {
      _searchResults = [];
      _currentIndex = -1;
    });
  }
}
