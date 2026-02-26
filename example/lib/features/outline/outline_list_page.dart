/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:flutter/material.dart';

/// Internal model representing a flattened outline node with its parent reference.
///
/// Used to convert the hierarchical outline tree into a flat list for
/// display in a [ListView], while preserving parent-child relationships
/// for indentation and navigation purposes.
class _FlatNode {
  /// The outline node data.
  final CPDFOutline node;

  /// Reference to the parent node, null for root-level items.
  final CPDFOutline? parent;

  _FlatNode(this.node, this.parent);
}

/// A full-screen page widget for viewing and managing PDF document outlines.
///
/// This widget provides comprehensive outline (bookmark/TOC) management with:
///
/// - **Hierarchical Display**: Outlines are displayed in a collapsible tree
///   structure with visual indentation indicating nesting levels.
/// - **CRUD Operations**: Full support for Create, Read, Update, and Delete
///   operations on outline items.
/// - **Move Operations**: Ability to move outline items to new parent nodes.
/// - **Navigation**: Tapping an outline navigates to the associated page.
///
/// ## Usage
///
/// ```dart
/// final pageIndex = await Navigator.push<int>(
///   context,
///   MaterialPageRoute(
///     builder: (context) => OutlineListPage(document: pdfDocument),
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
/// 2. **Move Mode Banner**: Appears when moving an item, shows cancel option
/// 3. **Outline List**: Expandable tree with action buttons for each item
/// 4. **FAB**: Floating action button to add new root-level outlines
///
/// ## Related Classes
///
/// - [CPDFDocument] - The PDF document containing the outlines
/// - [CPDFOutline] - Data model for individual outline nodes
class OutlineListPage extends StatefulWidget {
  /// The PDF document to manage outlines for.
  final CPDFDocument document;

  /// Creates an outline list page.
  ///
  /// The [document] parameter must be a valid, opened PDF document.
  const OutlineListPage({super.key, required this.document});

  @override
  State<OutlineListPage> createState() => _OutlineListPageState();
}

class _OutlineListPageState extends State<OutlineListPage> {
  // ==================== Controllers ====================

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pageIndexController = TextEditingController();

  // ==================== State ====================

  /// Root outline node (invisible container for top-level items).
  CPDFOutline? _rootOutline;

  /// Top-level outline items.
  List<CPDFOutline> _rootOutlines = [];

  /// Set of expanded node UUIDs for tree state management.
  final Set<String> _expanded = {};

  /// Loading state indicator.
  bool _loading = false;

  /// Error state indicator.
  bool _error = false;

  /// Outline being moved (null when not in move mode).
  CPDFOutline? _outlineBeingMoved;

  // ==================== Lifecycle ====================

  @override
  void initState() {
    super.initState();
    _loadOutlines();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pageIndexController.dispose();
    super.dispose();
  }

  // ==================== Data Operations ====================

  /// Loads outline data from the PDF document.
  Future<void> _loadOutlines() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final rootOutline = await widget.document.getOutlineRoot();
      _rootOutline = rootOutline;
      _rootOutlines = rootOutline?.childList ?? [];
    } catch (e) {
      debugPrint('OutlineListPage: Failed to load outlines: $e');
      _error = true;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  /// Flattens the hierarchical outline tree into a list for display.
  ///
  /// Only includes children of expanded nodes to support collapsible tree UI.
  List<_FlatNode> _flatten() {
    final result = <_FlatNode>[];

    void walk(List<CPDFOutline> nodes, CPDFOutline? parent) {
      for (final node in nodes) {
        result.add(_FlatNode(node, parent));
        if (_expanded.contains(node.uuid) && node.childList.isNotEmpty) {
          walk(node.childList, node);
        }
      }
    }

    walk(_rootOutlines, null);
    return result;
  }

  /// Toggles the expanded state of a node with children.
  void _toggleExpand(CPDFOutline node) {
    if (node.childList.isEmpty) return;
    setState(() {
      if (_expanded.contains(node.uuid)) {
        _expanded.remove(node.uuid);
      } else {
        _expanded.add(node.uuid);
      }
    });
  }

  /// Deletes an outline node.
  Future<void> _deleteOutline(CPDFOutline node) async {
    final confirmed = await _showDeleteConfirmation(node.title);
    if (confirmed != true) return;

    final success = await widget.document.removeOutline(node.uuid);
    if (success) {
      await _loadOutlines();
      setState(() => _expanded.remove(node.uuid));
    }
  }

  /// Adds a new child outline to the specified parent.
  Future<void> _addOutline(
    CPDFOutline parent, {
    required String title,
    required int pageIndex,
  }) async {
    final success = await widget.document.addOutline(
      parentUuid: parent.uuid,
      title: title,
      pageIndex: pageIndex,
    );

    if (success) {
      await _loadOutlines();
      setState(() => _expanded.add(parent.uuid));
    }
  }

  /// Updates an existing outline's title and page index.
  Future<void> _updateOutline(
    CPDFOutline outline,
    String newTitle,
    int pageIndex,
  ) async {
    final success = await widget.document.updateOutline(
      uuid: outline.uuid,
      title: newTitle,
      pageIndex: pageIndex,
    );

    if (success) {
      await _loadOutlines();
    }
  }

  /// Moves an outline to a new parent.
  Future<void> _moveOutline(CPDFOutline newParent) async {
    if (_outlineBeingMoved == null) return;

    final success = await widget.document.moveOutline(
      newParent: newParent,
      outline: _outlineBeingMoved!,
      insertIndex: -1,
    );

    if (success) {
      await _loadOutlines();
    }

    setState(() => _outlineBeingMoved = null);
  }

  /// Cancels the current move operation.
  void _cancelMove() {
    setState(() => _outlineBeingMoved = null);
  }

  // ==================== UI Builders ====================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final flatList = _flatten();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme, textTheme),
      body: Column(
        children: [
          // Move mode indicator banner
          if (_outlineBeingMoved != null)
            _buildMoveBanner(colorScheme, textTheme),
          // Main content
          Expanded(child: _buildBody(flatList, colorScheme, textTheme)),
        ],
      ),
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
        'Outlines',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: _loadOutlines,
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

  /// Builds the banner shown when in move mode.
  Widget _buildMoveBanner(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.drive_file_move_outline,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moving: ${_outlineBeingMoved!.title}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Tap a destination to move here',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _cancelMove,
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main body content based on loading/error/data states.
  Widget _buildBody(
    List<_FlatNode> flatList,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (_loading) {
      return _buildLoadingState(colorScheme);
    }

    if (_error) {
      return _buildErrorState(colorScheme, textTheme);
    }

    if (flatList.isEmpty) {
      return _buildEmptyState(colorScheme, textTheme);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: flatList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (_, index) => _buildOutlineRow(
        flatList[index],
        colorScheme,
        textTheme,
      ),
    );
  }

  /// Builds the loading indicator.
  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading outlines...',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  /// Builds the error state with retry option.
  Widget _buildErrorState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 32,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load outlines',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check the document and try again',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: _loadOutlines,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Builds the empty state with guidance.
  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 40,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Outlines',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first outline',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single outline row with expand/collapse and action buttons.
  Widget _buildOutlineRow(
    _FlatNode flat,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final node = flat.node;
    final hasChildren = node.childList.isNotEmpty;
    final isExpanded = _expanded.contains(node.uuid);
    final isBeingMoved = _outlineBeingMoved?.uuid == node.uuid;
    final isInMoveMode = _outlineBeingMoved != null;

    // Calculate indent based on level (16dp per level)
    final indent = node.level * 16.0;

    return Opacity(
      opacity: isBeingMoved ? 0.5 : 1.0,
      child: Container(
        margin: EdgeInsets.only(left: indent),
        decoration: BoxDecoration(
          color: isBeingMoved
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isBeingMoved
                ? colorScheme.primary.withAlpha(128)
                : colorScheme.outlineVariant.withAlpha(51),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isBeingMoved
                ? null
                : () {
                    if (isInMoveMode) {
                      _moveOutline(node);
                    } else {
                      Navigator.pop(context, node.destination?.pageIndex);
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  // Expand/collapse button
                  _buildExpandButton(
                    hasChildren,
                    isExpanded,
                    node,
                    colorScheme,
                  ),
                  const SizedBox(width: 8),
                  // Title and page info
                  Expanded(
                    child: _buildTitleSection(node, colorScheme, textTheme),
                  ),
                  // Action buttons (hidden in move mode)
                  if (!isInMoveMode) ...[
                    _buildActionButtons(node, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the expand/collapse toggle button.
  Widget _buildExpandButton(
    bool hasChildren,
    bool isExpanded,
    CPDFOutline node,
    ColorScheme colorScheme,
  ) {
    if (!hasChildren) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.article_outlined,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return InkWell(
      onTap: () => _toggleExpand(node),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isExpanded ? Icons.expand_more : Icons.chevron_right,
          size: 18,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  /// Builds the title and page index display section.
  Widget _buildTitleSection(
    CPDFOutline node,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          node.title,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 12,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              'Page ${(node.destination?.pageIndex ?? 0) + 1}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (node.childList.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${node.childList.length}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Builds the action buttons row (edit, add, move, delete).
  Widget _buildActionButtons(CPDFOutline node, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          icon: Icons.edit_outlined,
          tooltip: 'Edit',
          color: colorScheme.primary,
          onPressed: () => _showEditDialog(node),
        ),
        _buildIconButton(
          icon: Icons.add,
          tooltip: 'Add Child',
          color: colorScheme.primary,
          onPressed: () => _showAddChildDialog(node),
        ),
        _buildIconButton(
          icon: Icons.drive_file_move_outline,
          tooltip: 'Move',
          color: colorScheme.tertiary,
          onPressed: () => setState(() => _outlineBeingMoved = node),
        ),
        _buildIconButton(
          icon: Icons.delete_outline,
          tooltip: 'Delete',
          color: colorScheme.error,
          onPressed: () => _deleteOutline(node),
        ),
      ],
    );
  }

  /// Builds a styled icon button for actions.
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }

  /// Builds the floating action button for adding root outlines.
  Widget _buildFAB(ColorScheme colorScheme) {
    // Hide FAB during move mode
    if (_outlineBeingMoved != null) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: _showAddRootDialog,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      icon: const Icon(Icons.add),
      label: const Text('Add Outline'),
    );
  }

  // ==================== Dialogs ====================

  /// Shows the add root outline dialog.
  Future<void> _showAddRootDialog() async {
    final result = await _showOutlineDialog(
      title: 'Add Outline',
      confirmLabel: 'Add',
    );

    if (result != null) {
      final title = result['title'] as String;
      final pageIndex = result['pageIndex'] as int;

      if (_rootOutline != null) {
        await _addOutline(_rootOutline!, title: title, pageIndex: pageIndex);
      } else {
        final outlineRoot = await widget.document.newOutlineRoot();
        if (outlineRoot != null) {
          _rootOutline = outlineRoot;
          await _addOutline(_rootOutline!, title: title, pageIndex: pageIndex);
        }
      }
    }
  }

  /// Shows the add child outline dialog.
  Future<void> _showAddChildDialog(CPDFOutline parent) async {
    final result = await _showOutlineDialog(
      title: 'Add Child Outline',
      confirmLabel: 'Add',
    );

    if (result != null) {
      await _addOutline(
        parent,
        title: result['title'] as String,
        pageIndex: result['pageIndex'] as int,
      );
    }
  }

  /// Shows the edit outline dialog.
  Future<void> _showEditDialog(CPDFOutline outline) async {
    final result = await _showOutlineDialog(
      title: 'Edit Outline',
      initialTitle: outline.title,
      initialPageIndex: outline.destination?.pageIndex ?? 0,
      confirmLabel: 'Save',
    );

    if (result != null) {
      await _updateOutline(
        outline,
        result['title'] as String,
        result['pageIndex'] as int,
      );
    }
  }

  /// Shows a generic outline editing dialog.
  Future<Map<String, dynamic>?> _showOutlineDialog({
    required String title,
    String initialTitle = '',
    int initialPageIndex = 0,
    required String confirmLabel,
  }) async {
    _titleController.text = initialTitle;
    _pageIndexController.text = '${initialPageIndex + 1}';

    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter outline title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
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
                      : 'New Outline',
                  'pageIndex': (pageNum - 1).clamp(0, 999999),
                });
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  /// Shows a delete confirmation dialog.
  Future<bool?> _showDeleteConfirmation(String outlineTitle) {
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
          title: const Text('Delete Outline'),
          content: Text(
            'Are you sure you want to delete "$outlineTitle"? '
            'This will also delete all child outlines.',
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
