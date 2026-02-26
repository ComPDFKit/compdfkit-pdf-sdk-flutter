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
import 'search_results_list.dart';
import 'package:flutter/material.dart';

/// A full-screen page widget that displays PDF text search results in a
/// grouped, paginated list format.
///
/// This widget provides a comprehensive search results view with the following
/// features:
///
/// - **Grouped Display**: Results are automatically grouped by page index,
///   making it easy to navigate large result sets.
/// - **Keyword Highlighting**: The matched keyword is highlighted within
///   the surrounding context text using the theme's primary color.
/// - **Interactive Navigation**: Tapping any result item returns the
///   corresponding [CPDFSearchItem] to the caller via [Navigator.pop],
///   enabling seamless navigation to that location in the PDF.
/// - **Material Design 3**: Uses the current theme's color scheme and
///   text styles for consistent visual appearance.
///
/// ## Usage
///
/// ```dart
/// final selectedResult = await Navigator.push<CPDFSearchItem>(
///   context,
///   MaterialPageRoute(
///     builder: (context) => SearchTextListPage(results: searchResults),
///   ),
/// );
/// if (selectedResult != null) {
///   // Navigate to the selected result in the PDF viewer
///   controller.goToPage(selectedResult.keywordsTextRange.pageIndex);
/// }
/// ```
///
/// ## Visual Structure
///
/// The page consists of:
/// 1. **AppBar**: Displays "Search Results" title with a styled back button
/// 2. **Summary Header**: Shows total result count and number of pages
/// 3. **Page Sections**: Card-based containers grouping results by page,
///    each with a header showing page number and match count
/// 4. **Result Items**: Individual search matches with context text and
///    keyword highlighting
///
/// ## Related Classes
///
/// - [CPDFSearchItem] - Data model holding search result information
/// - [CPDFTextSearcher] - API for performing text search in PDF documents
/// - [PdfSearchBar] - Companion widget for search input
/// - [SearchNavigationBar] - Companion widget for result navigation
///
/// See also:
/// - [CPDFTextRange] for text range representation
/// - [CPDFTextRange.expanded] for extracting context text around matches
class SearchTextListPage extends StatelessWidget {
  /// The list of search results to display.
  ///
  /// Each [CPDFSearchItem] contains:
  /// - [CPDFSearchItem.keywords]: The matched search term
  /// - [CPDFSearchItem.keywordsTextRange]: Location of the keyword in the PDF
  /// - [CPDFSearchItem.content]: Surrounding context text
  /// - [CPDFSearchItem.contentTextRange]: Location of the context text
  ///
  /// Results are automatically grouped by page index for display.
  final List<CPDFSearchItem> results;

  /// Creates a search results list page.
  ///
  /// The [results] parameter must not be null and typically contains
  /// items obtained from [CPDFTextSearcher.searchText].
  ///
  /// Example:
  /// ```dart
  /// final results = await textSearcher.searchText('ComPDFKit');
  /// Navigator.push(
  ///   context,
  ///   MaterialPageRoute(
  ///     builder: (_) => SearchTextListPage(results: results),
  ///   ),
  /// );
  /// ```
  const SearchTextListPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Search Results',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colorScheme.outlineVariant.withAlpha(77),
          ),
        ),
      ),
      body: SearchResultsList(
        results: results,
        onResultTap: (item) => Navigator.pop(context, item),
      ),
    );
  }
}
