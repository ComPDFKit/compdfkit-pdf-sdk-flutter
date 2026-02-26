// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/search/widgets/pdf_search_result_page.dart';

/// A full-screen page that provides text search functionality within a PDF document.
///
/// [PdfSearchPage] displays an [AppBar] with an embedded [TextField] for entering
/// search keywords, and a [PdfSearchResultPage] body that lists the matching results
/// grouped by page number.
///
/// This page depends on [PdfSearchController] being registered via GetX
/// (e.g. through [PdfSearchBinding]) before navigation.
///
/// **Behavior:**
/// - On first open, the text field auto-focuses so the user can start typing immediately.
/// - If the page is re-opened while a previous search is still active, the text field
///   is pre-filled with the last keyword and results remain visible.
/// - Pressing the search action on the keyboard triggers the search.
/// - Editing the text field clears the previous results until a new search is submitted.
///
/// **Usage example:**
///
/// Register the route in your [GetPage] configuration:
///
/// ```dart
/// GetPage(
///   name: PdfViewerRoutes.pdfSearch,
///   page: () => const PdfSearchPage(),
///   binding: PdfSearchBinding(),
/// )
/// ```
///
/// Then navigate to the search page:
///
/// ```dart
/// Get.toNamed(PdfViewerRoutes.pdfSearch);
/// ```
class PdfSearchPage extends StatefulWidget {
  const PdfSearchPage({super.key});

  @override
  State<PdfSearchPage> createState() => _PdfSearchPageState();
}

class _PdfSearchPageState extends State<PdfSearchPage> {
  final TextEditingController textEditingController = TextEditingController();

  final PdfSearchController searchController = Get.find<PdfSearchController>();

  bool get _canSearch => textEditingController.text.trim().isNotEmpty;

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    final keyword = textEditingController.text.trim();
    if (keyword.isEmpty) return;
    searchController.startSearchText(keyword);
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = searchController.state.searchText.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        titleSpacing: 0.0,
        title: TextField(
          controller: textEditingController,
          maxLines: 1,
          autofocus: textEditingController.text.isEmpty,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            hintText: PdfLocaleKeys.searchText.tr,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          onSubmitted: (_) => _submitSearch(),
          onEditingComplete: _submitSearch,
          onChanged: (text) {
            final currentKeyword = searchController.state.searchText.value;
            if (currentKeyword != text) {
              searchController.clearSearch();
            }
            setState(() {});
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: _canSearch ? _submitSearch : null,
              tooltip: PdfLocaleKeys.searchText.tr,
            ),
          ),
        ],
      ),
      body: const PdfSearchResultPage(),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
