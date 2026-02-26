/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:flutter/material.dart';
import '../../widgets/dialogs/bookmark_edit_dialog.dart';

/// A full-screen page widget for viewing and managing PDF document bookmarks.
///
/// This widget provides comprehensive bookmark management with:
///
/// - **List Display**: Bookmarks are displayed in a flat list with page info
///   and creation date.
/// - **CRUD Operations**: Full support for Create, Read, Update, and Delete
///   operations on bookmark items.
/// - **Navigation**: Tapping a bookmark navigates to the associated page.
///
/// ## Usage
///
/// ```dart
/// final pageIndex = await Navigator.push<int>(
///   context,
///   MaterialPageRoute(
///     builder: (context) => BookmarkListPage(
///       document: pdfDocument,
///       currentPageIndex: controller.currentPageIndex,
///     ),
///   ),
/// );
/// if (pageIndex != null) {
///   controller.goToPage(pageIndex);
/// }
/// ```
///
/// ## Visual Structure
///
/// 1. **AppBar**: Title with refresh action button
/// 2. **Bookmark List**: Scrollable list with edit/delete actions
/// 3. **FAB**: Floating action button to add new bookmark at current page
///
/// ## Related Classes
///
/// - [CPDFDocument] - The PDF document containing the bookmarks
/// - [CPDFBookmark] - Data model for individual bookmark nodes
class BookmarkListPage extends StatefulWidget {
  /// The PDF document to manage bookmarks for.
  final CPDFDocument document;

  /// The current page index in the PDF viewer.
  final int currentPageIndex;

  /// Creates a bookmark list page.
  ///
  /// The [document] parameter must be a valid, opened PDF document.
  /// The [currentPageIndex] is used when adding new bookmarks.
  const BookmarkListPage({
    super.key,
    required this.document,
    this.currentPageIndex = 0,
  });

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  // ==================== Controllers ====================

  // ==================== State ====================

  /// List of bookmarks from the document.
  List<CPDFBookmark> _bookmarks = [];

  // ==================== Lifecycle ====================

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ==================== Data Operations ====================

  /// Loads bookmark data from the PDF document.
  Future<void> _loadBookmarks() async {
    try {
      final bookmarks = await widget.document.getBookmarks();
      if (!mounted) return;
      setState(() {
        _bookmarks = bookmarks;
      });
    } catch (e) {
      debugPrint('BookmarkListPage: Failed to load bookmarks: $e');
    }
  }

  /// Adds a new bookmark at the specified page.
  Future<void> _addBookmark({
    required String title,
    required int pageIndex,
  }) async {
    // Check if bookmark already exists at this page
    final hasBookmark = await widget.document.hasBookmark(pageIndex);
    if (hasBookmark) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark already exists on page ${pageIndex + 1}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final success = await widget.document.addBookmark(
      title: title,
      pageIndex: pageIndex,
    );

    if (success) {
      await _loadBookmarks();
    }
  }

  /// Updates an existing bookmark's title.
  Future<void> _updateBookmark(CPDFBookmark bookmark, String newTitle) async {
    bookmark.title = newTitle;
    final success = await widget.document.updateBookmark(bookmark);

    if (success) {
      await _loadBookmarks();
    }
  }

  /// Deletes a bookmark.
  Future<void> _deleteBookmark(CPDFBookmark bookmark) async {
    final confirmed = await _showDeleteConfirmation(bookmark.title);
    if (confirmed != true) return;

    final success = await widget.document.removeBookmark(bookmark.pageIndex);
    if (success) {
      await _loadBookmarks();
    }
  }

  // ==================== UI Builders ====================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme, textTheme),
      body: _buildBody(colorScheme, textTheme),
      floatingActionButton: _buildFAB(colorScheme),
    );
  }

  /// Builds the app bar with consistent styling.
  PreferredSizeWidget _buildAppBar(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return AppBar(
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
        'Bookmarks',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: _loadBookmarks,
          icon: Icon(Icons.refresh, color: colorScheme.primary),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: colorScheme.outlineVariant.withAlpha(77),
        ),
      ),
    );
  }

  /// Builds the main body content based on loading/error/data states.
  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_bookmarks.isEmpty) {
      return _buildEmptyState(colorScheme, textTheme);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: _bookmarks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) => _buildBookmarkRow(
        _bookmarks[index],
        colorScheme,
        textTheme,
      ),
    );
  }

  /// Builds the empty state with guidance.
  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Bookmarks',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create your first bookmark',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single bookmark row with action buttons.
  Widget _buildBookmarkRow(
    CPDFBookmark bookmark,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pop(context, bookmark.pageIndex),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.bookmark, size: 24, color: colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookmark.title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Page ${bookmark.pageIndex + 1}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                icon: Icons.edit_outlined,
                onPressed: () => _showEditDialog(bookmark),
                color: colorScheme.primary,
              ),
              _buildActionButton(
                icon: Icons.delete_outline,
                onPressed: () => _deleteBookmark(bookmark),
                color: colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an action icon button.
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20, color: color),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
    );
  }

  /// Builds the floating action button for adding bookmarks.
  Widget _buildFAB(ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: _showAddDialog,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      icon: const Icon(Icons.add),
      label: const Text('Add Bookmark'),
    );
  }

  // ==================== Dialogs ====================

  /// Shows the add bookmark dialog.
  Future<void> _showAddDialog() async {
    final result = await _showBookmarkDialog(
      title: 'Add Bookmark',
      initialPageIndex: widget.currentPageIndex,
      confirmLabel: 'Add',
    );

    if (result != null) {
      await _addBookmark(
        title: result['title'] as String,
        pageIndex: result['pageIndex'] as int,
      );
    }
  }

  /// Shows the edit bookmark dialog.
  Future<void> _showEditDialog(CPDFBookmark bookmark) async {
    final result = await _showBookmarkDialog(
      title: 'Edit Bookmark',
      initialTitle: bookmark.title,
      initialPageIndex: bookmark.pageIndex,
      confirmLabel: 'Save',
      showPageField: false,
    );

    if (result != null) {
      await _updateBookmark(bookmark, result['title'] as String);
    }
  }

  /// Shows a generic bookmark editing dialog.
  Future<Map<String, dynamic>?> _showBookmarkDialog({
    required String title,
    String initialTitle = '',
    int initialPageIndex = 0,
    required String confirmLabel,
    bool showPageField = true,
  }) async {
    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => BookmarkEditDialog(
        title: title,
        initialTitle: initialTitle,
        initialPageIndex: initialPageIndex,
        confirmLabel: confirmLabel,
        showPageField: showPageField,
      ),
    );
  }

  /// Shows a delete confirmation dialog.
  Future<bool?> _showDeleteConfirmation(String bookmarkTitle) {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Bookmark'),
          content: Text(
            'Are you sure you want to delete "$bookmarkTitle"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
