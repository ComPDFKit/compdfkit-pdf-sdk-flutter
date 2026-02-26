// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../features/bookmarks/bookmark_list_page.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

import '../../constants/asset_paths.dart';

/// Bookmark Operations Example
///
/// Demonstrates how to programmatically manage PDF bookmarks including
/// creating, listing, and deleting bookmarks.
///
/// This example shows:
/// - Opening a bookmark list UI for navigation
/// - Retrieving all bookmarks from a PDF document
/// - Adding a new bookmark to the current page
/// - Removing existing bookmarks from the document
///
/// Key classes/APIs used:
/// - [CPDFBookmark]: Data class representing a bookmark with title and page index
/// - [CPDFDocument.getBookmarks]: Retrieves all bookmarks in the document
/// - [CPDFDocument.addBookmark]: Creates a new bookmark at specified page
/// - [CPDFDocument.removeBookmark]: Deletes a bookmark by page index
/// - [CPDFDocument.hasBookmark]: Checks if a page already has a bookmark
///
/// Usage:
/// 1. Open the PDF document with the reader widget
/// 2. Use the menu to access bookmark operations
/// 3. Navigate to a page and add a bookmark, or view/delete existing ones
class BookmarkOperationsExample extends StatelessWidget {
  /// Constructor
  const BookmarkOperationsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Bookmark Operations',
      assetPath: _assetPath,
      builder: (path) => _BookmarkOperationsPage(documentPath: path),
    );
  }
}

class _BookmarkOperationsPage extends ExampleBase {
  const _BookmarkOperationsPage({required super.documentPath});

  @override
  State<_BookmarkOperationsPage> createState() =>
      _BookmarkOperationsPageState();
}

class _BookmarkOperationsPageState
    extends ExampleBaseState<_BookmarkOperationsPage> {
  static const List<String> _menuActions = [
    'Open Bookmark List',
    'Get Bookmarks',
    'Add Bookmark',
    'Delete First Bookmark',
  ];

  @override
  String get pageTitle => 'Bookmark Operations';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Open Bookmark List':
        _openBookmarkList(controller);
        break;
      case 'Get Bookmarks':
        _getBookmarks(controller);
        break;
      case 'Add Bookmark':
        _addBookmark(controller);
        break;
      case 'Delete First Bookmark':
        _removeFirstBookmark(controller);
        break;
    }
  }

  Future<void> _openBookmarkList(CPDFReaderWidgetController controller) async {
    final currentPageIndex = await controller.getCurrentPageIndex();
    if (!mounted) return;
    
    final pageIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarkListPage(
          document: controller.document,
          currentPageIndex: currentPageIndex,
        ),
      ),
    );
    if (pageIndex != null && mounted) {
      await controller.setDisplayPageIndex(pageIndex: pageIndex);
    }
  }

  Future<void> _getBookmarks(CPDFReaderWidgetController controller) async {
    final bookmarks = await controller.document.getBookmarks();
    final prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(json.decode(jsonEncode(bookmarks)));
    printJsonString(prettyJson);
  }

  Future<void> _addBookmark(CPDFReaderWidgetController controller) async {
    final pageIndex = await controller.getCurrentPageIndex();
    final hasBookmark = await controller.document.hasBookmark(pageIndex);
    if (hasBookmark) {
      debugPrint('Bookmark already exists on page $pageIndex');
      return;
    }
    final result = await controller.document.addBookmark(
      title: 'ComPDFKit Bookmark',
      pageIndex: pageIndex,
    );
    debugPrint('Add bookmark result: $result');
  }

  Future<void> _removeFirstBookmark(
    CPDFReaderWidgetController controller,
  ) async {
    final List<CPDFBookmark> bookmarks =
        await controller.document.getBookmarks();
    if (bookmarks.isEmpty) {
      return;
    }
    final bookmark = bookmarks.first;
    final result = await controller.document.removeBookmark(bookmark.pageIndex);
    debugPrint('Remove bookmark result: $result');
  }
}
