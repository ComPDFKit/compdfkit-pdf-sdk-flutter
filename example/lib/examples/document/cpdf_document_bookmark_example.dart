/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:convert';

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:flutter/material.dart';

import 'base_document_example.dart';

class CPDFDocumentBookmarkExample extends BaseDocumentExample {
  const CPDFDocumentBookmarkExample({super.key});

  @override
  String get title => 'Bookmark Example';

  @override
  String get assetPath => 'pdfs/PDF_Document.pdf';

  @override
  State<CPDFDocumentBookmarkExample> createState() =>
      _CPDFDocumentBookmarkExampleState();
}

class _CPDFDocumentBookmarkExampleState
    extends BaseDocumentExampleState<CPDFDocumentBookmarkExample> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _pageIndexTextEditingController =
      TextEditingController();
  List<CPDFBookmark> bookmarks = [];

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    return [
      TextButton(
        onPressed: () async {
          clearLogs();
          bookmarks.clear();
          bookmarks.addAll(await document.getBookmarks());
          applyLog('Bookmarks length: ${bookmarks.length}');

          final prettyJson = const JsonEncoder.withIndent('  ')
              .convert(json.decode(jsonEncode(bookmarks)));
          applyLog(prettyJson);
        },
        child: const Text('Get Bookmarks'),
      ),
      TextButton(
        onPressed: () async {
          if (bookmarks.isNotEmpty) {
            final bookmark = bookmarks.first;
            bool result = await document.removeBookmark(bookmark.pageIndex);
            if (result) {
              bookmarks.removeAt(0);
            }
            applyLog('Delete Bookmark: $result');
          }
        },
        child: const Text('Delete First'),
      ),
      TextButton(
        onPressed: () async {
          Map<String, dynamic>? map =
              await _showAddDialog(title: 'Add Bookmark');
          if (map != null) {
            String title = map['title'] ?? 'New Bookmark';
            int pageIndex = map['pageIndex'] ?? 0;

            bool hasBookmark = await document.hasBookmark(pageIndex);
            if (hasBookmark) {
              applyLog('Bookmark already exists on Page Index: $pageIndex');
              return;
            }
            bool result =
                await document.addBookmark(title: title, pageIndex: pageIndex);
            applyLog('Add Bookmark: $result');
          }
        },
        child: const Text('Add Bookmark First Page'),
      ),
      TextButton(
        onPressed: () async {
          if (bookmarks.isNotEmpty) {
            CPDFBookmark bookmark = bookmarks.first;
            bookmark.title = 'ComPDFKit Updated Bookmark';
            bool updateResult = await document.updateBookmark(bookmark);
            applyLog('Update Bookmark Result: ${jsonEncode(updateResult)}');
          }
        },
        child: const Text('Update Bookmark'),
      ),
    ];
  }

  Future<Map<String, dynamic>?> _showAddDialog({
    String title = 'Add Outline',
    String content = '',
    int pageIndex = 0,
  }) async {
    _textEditingController.text = content;
    _pageIndexTextEditingController.text = '$pageIndex';
    return await showDialog<Map<String, dynamic>?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    // Store the input value
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pageIndexTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Page Index',
                  ),
                  onChanged: (value) {
                    // Store the input value
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Call _onAdd with the input title
                  Navigator.of(context).pop({
                    'title': _textEditingController.text,
                    'pageIndex':
                        int.tryParse(_pageIndexTextEditingController.text) ?? 0,
                  });
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _pageIndexTextEditingController.dispose();
    super.dispose();
  }
}
