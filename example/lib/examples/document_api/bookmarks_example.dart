// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../widgets/dialogs/bookmark_edit_dialog.dart';
import '../shared/api_example_base.dart';

/// Bookmarks Example
///
/// Demonstrates bookmark management using the [CPDFDocument] API without
/// requiring a PDF viewer widget.
///
/// This example shows:
/// - Retrieving all bookmarks from a PDF document
/// - Adding new bookmarks to specific pages
/// - Checking if a page already has a bookmark
/// - Removing bookmarks by page index
///
/// Key classes/APIs used:
/// - [CPDFDocument.getBookmarks]: Returns list of [CPDFBookmark] objects
/// - [CPDFDocument.addBookmark]: Adds a bookmark with title and page index
/// - [CPDFDocument.hasBookmark]: Checks if a page has an existing bookmark
/// - [CPDFDocument.removeBookmark]: Removes bookmark from a page
/// - [CPDFBookmark]: Model class containing bookmark title and page index
///
/// Usage:
/// 1. Open a PDF document
/// 2. Call [getBookmarks] to list existing bookmarks
/// 3. Use [hasBookmark] to check before adding duplicates
/// 4. Call [addBookmark] with title and page index to create
/// 5. Call [removeBookmark] with page index to delete
class BookmarksExample extends ApiExampleBase {
  /// Constructor
  const BookmarksExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Bookmarks';

  @override
  State<BookmarksExample> createState() => _BookmarksExampleState();
}

class _BookmarksExampleState extends ApiExampleBaseState<BookmarksExample> {
  List<CPDFBookmark> _bookmarks = [];

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(onPressed: _loadBookmarks, child: const Text('Get Bookmarks')),
      TextButton(onPressed: _addBookmark, child: const Text('Add Bookmark')),
      TextButton(
        onPressed: _removeFirstBookmark,
        child: const Text('Delete First Bookmark'),
      ),
    ];
  }

  Future<void> _loadBookmarks() async {
    clearLogs();
    _bookmarks = await document.getBookmarks();
    applyLog('Bookmarks length: ${_bookmarks.length}');
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(json.decode(jsonEncode(_bookmarks)));
    applyLog(jsonString);
  }

  Future<void> _addBookmark() async {
    final data = await _showAddDialog();
    if (data == null) {
      return;
    }

    final String title = data['title'] as String? ?? 'New Bookmark';
    final int pageIndex = data['pageIndex'] as int? ?? 0;

    final hasBookmark = await document.hasBookmark(pageIndex);
    if (hasBookmark) {
      applyLog('Bookmark already exists on Page Index: $pageIndex');
      return;
    }

    final result = await document.addBookmark(
      title: title,
      pageIndex: pageIndex,
    );
    applyLog('Add Bookmark: $result');
  }

  Future<void> _removeFirstBookmark() async {
    if (_bookmarks.isEmpty) {
      applyLog('No bookmarks to remove');
      return;
    }
    final first = _bookmarks.first;
    final result = await document.removeBookmark(first.pageIndex);
    applyLog('Remove Bookmark: $result');
  }

  Future<Map<String, dynamic>?> _showAddDialog() {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const BookmarkEditDialog(
        title: 'Add Bookmark',
        initialTitle: '',
        initialPageIndex: 0,
        confirmLabel: 'Add',
        showPageField: true,
      ),
    );
  }
}
