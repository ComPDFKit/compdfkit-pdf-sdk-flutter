/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter_example/model/cpdf_search_item.dart';
import 'package:flutter/material.dart';

/// A reusable widget that displays PDF text search results in a grouped,
/// list format with interactive navigation.
///
/// This widget provides:
/// - **Grouped Display**: Results are automatically grouped by page index
/// - **Keyword Highlighting**: Matched keywords are highlighted in context
/// - **Interactive Items**: Tap callback for navigation to search results
/// - **Summary Header**: Shows total results and pages with matches
///
/// ## Usage
///
/// ```dart
/// SearchResultsList(
///   results: searchResults,
///   onResultTap: (item) {
///     // Navigate to the selected result
///     controller.setDisplayPageIndex(pageIndex: item.keywordsTextRange.pageIndex);
///   },
/// )
/// ```
///
/// ## Related Classes
///
/// - [CPDFSearchItem] - Data model holding search result information
/// - [SearchTextListPage] - Full-screen page that uses this widget
class SearchResultsList extends StatelessWidget {
  /// The list of search results to display.
  ///
  /// Each [CPDFSearchItem] contains the matched keyword, its location,
  /// and surrounding context text. Results are automatically grouped
  /// by page index for organized display.
  final List<CPDFSearchItem> results;

  /// Callback invoked when a search result item is tapped.
  ///
  /// The callback receives the [CPDFSearchItem] that was tapped,
  /// allowing the parent widget to navigate to that location in
  /// the PDF document.
  ///
  /// Example:
  /// ```dart
  /// onResultTap: (item) {
  ///   pdfController.goToPage(item.keywordsTextRange.pageIndex);
  /// }
  /// ```
  final ValueChanged<CPDFSearchItem> onResultTap;

  /// Creates a search results list widget.
  ///
  /// Both [results] and [onResultTap] are required parameters.
  ///
  /// Example:
  /// ```dart
  /// SearchResultsList(
  ///   results: await textSearcher.searchText('keyword'),
  ///   onResultTap: (item) => handleSelection(item),
  /// )
  /// ```
  const SearchResultsList({
    super.key,
    required this.results,
    required this.onResultTap,
  });

  /// Groups search results by their page index.
  ///
  /// Returns a map where:
  /// - Keys are page indices (0-based)
  /// - Values are lists of [CPDFSearchItem]s found on that page
  Map<int, List<CPDFSearchItem>> get _groupedResults {
    final grouped = <int, List<CPDFSearchItem>>{};
    for (final item in results) {
      grouped.putIfAbsent(item.keywordsTextRange.pageIndex, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _buildHeader(colorScheme, textTheme),
        Expanded(child: _buildResultsList(colorScheme, textTheme)),
      ],
    );
  }

  /// Builds the summary header section.
  ///
  /// Displays:
  /// - A pill-shaped badge showing the total number of search results
  /// - Text showing the number of pages containing matches
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(51),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  size: 14,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${results.length} results',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '${_groupedResults.length} pages',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the scrollable list of page sections.
  ///
  /// Creates a [ListView.separated] that displays page sections in
  /// ascending page order. Each section contains all search results
  /// for that page.
  Widget _buildResultsList(ColorScheme colorScheme, TextTheme textTheme) {
    final entries = _groupedResults.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, sectionIndex) {
        final entry = entries[sectionIndex];
        final pageIndex = entry.key;
        final items = entry.value;

        return _buildPageSection(
          context,
          pageIndex,
          items,
          colorScheme,
          textTheme,
        );
      },
    );
  }

  /// Builds a card-style section for a single page's search results.
  ///
  /// Each page section consists of:
  /// 1. **Header**: Displays the page number, title, and match count
  /// 2. **Result Items**: List of individual search results with dividers
  Widget _buildPageSection(
    BuildContext context,
    int pageIndex,
    List<CPDFSearchItem> items,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${pageIndex + 1}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Page ${pageIndex + 1}',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${items.length} ${items.length == 1 ? 'match' : 'matches'} found',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: colorScheme.onSurfaceVariant.withAlpha(128),
                ),
              ],
            ),
          ),
          // Result items
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildResultItem(context, item, colorScheme, textTheme),
                    if (index < items.length - 1)
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 12,
                        endIndent: 12,
                        color: colorScheme.outlineVariant.withAlpha(51),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single tappable search result item.
  ///
  /// Each item displays:
  /// - A colored vertical indicator bar
  /// - Context text with the matched keyword highlighted
  /// - A forward arrow icon
  ///
  /// When tapped, invokes [onResultTap] with the corresponding [CPDFSearchItem].
  Widget _buildResultItem(
    BuildContext context,
    CPDFSearchItem item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onResultTap(item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(128),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _highlightKeyword(item, colorScheme, textTheme),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a [RichText] widget with the keyword highlighted.
  ///
  /// Creates a text span showing the surrounding context with the
  /// matched keyword emphasized using the theme's primary color,
  /// bold font weight, and a semi-transparent background.
  Widget _highlightKeyword(
    CPDFSearchItem item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final content = item.content;
    final keyword = item.keywords;
    final keywordStartInPage = item.keywordsTextRange.location;
    final contentStartInPage = item.contentTextRange.location;

    final relativeKeywordStart = keywordStartInPage - contentStartInPage;

    final baseStyle = textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.4,
        ) ??
        TextStyle(color: colorScheme.onSurface);

    if (relativeKeywordStart < 0 ||
        relativeKeywordStart + keyword.length > content.length) {
      return Text(content, style: baseStyle);
    }

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: content.substring(0, relativeKeywordStart)),
          TextSpan(
            text: content.substring(
              relativeKeywordStart,
              relativeKeywordStart + keyword.length,
            ),
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              backgroundColor: colorScheme.primaryContainer.withAlpha(128),
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
