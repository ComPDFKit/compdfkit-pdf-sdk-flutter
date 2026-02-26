/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/material.dart';

/// A reusable dialog for creating or editing a bookmark.
///
/// This dialog provides a consistent UI for bookmark operations, supporting
/// both creation and editing workflows. It manages its own [TextEditingController]s
/// internally, so callers don't need to handle controller lifecycle.
///
/// ## Return Value
///
/// Returns a `Map<String, dynamic>` with the following keys when confirmed:
/// - `title` (`String`): The bookmark title (defaults to 'New Bookmark' if empty)
/// - `pageIndex` (`int`): Zero-based page index (clamped to valid range)
///
/// Returns `null` when the dialog is dismissed or cancelled.
///
/// ## Usage Examples
///
/// ### Adding a new bookmark
///
/// ```dart
/// final result = await showDialog<Map<String, dynamic>>(
///   context: context,
///   builder: (context) => const BookmarkEditDialog(
///     title: 'Add Bookmark',
///     initialTitle: '',
///     initialPageIndex: 0,
///     confirmLabel: 'Add',
///     showPageField: true,
///   ),
/// );
///
/// if (result != null) {
///   final title = result['title'] as String;
///   final pageIndex = result['pageIndex'] as int;
///   await document.addBookmark(title: title, pageIndex: pageIndex);
/// }
/// ```
///
/// ### Editing an existing bookmark
///
/// ```dart
/// final result = await showDialog<Map<String, dynamic>>(
///   context: context,
///   builder: (context) => BookmarkEditDialog(
///     title: 'Edit Bookmark',
///     initialTitle: existingBookmark.title,
///     initialPageIndex: existingBookmark.pageIndex,
///     confirmLabel: 'Save',
///     showPageField: false, // Hide page field when editing title only
///   ),
/// );
///
/// if (result != null) {
///   await document.updateBookmark(
///     pageIndex: existingBookmark.pageIndex,
///     newTitle: result['title'] as String,
///   );
/// }
/// ```
///
/// ## Parameters
///
/// - [title]: The dialog title displayed at the top
/// - [initialTitle]: Pre-filled value for the title text field
/// - [initialPageIndex]: Zero-based page index (displayed as 1-based to user)
/// - [confirmLabel]: Text for the confirm button (e.g., 'Add', 'Save', 'Update')
/// - [showPageField]: Whether to show the page number input field
class BookmarkEditDialog extends StatefulWidget {
  final String title;
  final String initialTitle;
  final int initialPageIndex;
  final String confirmLabel;
  final bool showPageField;

  const BookmarkEditDialog({
    super.key,
    required this.title,
    required this.initialTitle,
    required this.initialPageIndex,
    required this.confirmLabel,
    required this.showPageField,
  });

  @override
  State<BookmarkEditDialog> createState() => _BookmarkEditDialogState();
}

class _BookmarkEditDialogState extends State<BookmarkEditDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _pageIndexController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _pageIndexController = TextEditingController(
      text: '${widget.initialPageIndex + 1}',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pageIndexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter bookmark title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          if (widget.showPageField) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _pageIndexController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Page Number',
                hintText: 'Enter page number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description_outlined),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final pageNum = int.tryParse(_pageIndexController.text) ?? 1;
            Navigator.pop(context, {
              'title': _titleController.text.isNotEmpty
                  ? _titleController.text
                  : 'New Bookmark',
              'pageIndex': (pageNum - 1).clamp(0, 999999),
            });
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
