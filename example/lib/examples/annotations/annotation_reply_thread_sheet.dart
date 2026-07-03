// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation_reply.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation_state.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';

/// Empty state shown when the current page has no annotations to reply to.
class EmptyAnnotationRepliesSheet extends StatelessWidget {
  /// Creates an empty annotation replies sheet.
  const EmptyAnnotationRepliesSheet({
    super.key,
    required this.pageIndex,
  });

  /// Zero-based page index displayed to the user as one-based.
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.speaker_notes_off_outlined,
              size: 48,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'No annotations on page ${pageIndex + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Move to a page with annotations, then tap Replies again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets users select one annotation before opening its reply thread.
class AnnotationReplyPickerSheet extends StatelessWidget {
  /// Creates an annotation picker sheet.
  const AnnotationReplyPickerSheet({
    super.key,
    required this.pageIndex,
    required this.annotations,
    required this.replyCounts,
  });

  /// Zero-based page index displayed to the user as one-based.
  final int pageIndex;

  /// Annotations available on the current page.
  final List<CPDFAnnotation> annotations;

  /// Reply counts keyed by annotation UUID.
  final Map<String, int> replyCounts;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.comment_outlined, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select Annotation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      'Page ${pageIndex + 1}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              itemCount: annotations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final annotation = annotations[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: colorScheme.surfaceContainerHighest,
                  leading: const Icon(Icons.notes_outlined),
                  title: Text(
                    annotationDisplayTitle(annotation),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    annotationDisplaySummary(annotation),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${replyCounts[annotation.uuid] ?? 0}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  onTap: () => Navigator.of(context).pop(annotation),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact thread UI for reading, adding, editing and deleting replies.
class AnnotationReplyThreadSheet extends StatefulWidget {
  /// Creates an annotation reply thread sheet.
  const AnnotationReplyThreadSheet({
    super.key,
    required this.controller,
    required this.annotation,
  });

  /// Reader controller used to access the document instance.
  final CPDFReaderWidgetController controller;

  /// Annotation whose plain replies are shown in this thread.
  final CPDFAnnotation annotation;

  @override
  State<AnnotationReplyThreadSheet> createState() =>
      _AnnotationReplyThreadSheetState();
}

class _AnnotationReplyThreadSheetState
    extends State<AnnotationReplyThreadSheet> {
  final TextEditingController _composerController = TextEditingController();
  final FocusNode _composerFocusNode = FocusNode();

  late CPDFAnnotationMarkState _annotationMarkState;
  late CPDFAnnotationReviewState _annotationReviewState;

  bool _loading = true;
  bool _sending = false;
  List<CPDFReplyAnnotation> _replies = [];

  @override
  void initState() {
    super.initState();
    _annotationMarkState = widget.annotation.markState;
    _annotationReviewState = widget.annotation.reviewState;
    _composerController.addListener(_handleComposerChanged);
    _loadReplies();
  }

  @override
  void dispose() {
    _composerController.removeListener(_handleComposerChanged);
    _composerController.dispose();
    _composerFocusNode.dispose();
    super.dispose();
  }

  bool get _canSend => _composerController.text.trim().isNotEmpty && !_sending;

  void _handleComposerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadReplies() async {
    setState(() => _loading = true);

    // Calls CPDFDocument.getAnnotationReplies to load plain replies for the
    // selected parent annotation.
    final replies = await widget.controller.document.getAnnotationReplies(
      widget.annotation,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _replies = replies;
      _loading = false;
    });
  }

  Future<void> _sendReply() async {
    _dismissKeyboard();
    final content = _composerController.text.trim();
    if (content.isEmpty || _sending) {
      return;
    }

    setState(() => _sending = true);

    // Calls CPDFDocument.addAnnotationReply to create a plain reply under the
    // selected annotation. The sample uses the configured document author as
    // the reply title.
    final reply = await _runSilently(
      'addAnnotationReply',
      () => widget.controller.document.addAnnotationReply(
        widget.annotation,
        content: content,
        title: PreferencesService.documentAuthor,
      ),
    );

    if (reply != null) {
      _composerController.clear();
      await _reloadAfterAction();
    } else if (mounted) {
      setState(() => _sending = false);
    }
  }

  Future<void> _editReply(CPDFReplyAnnotation reply) async {
    final data = await _showReplyEditDialog(reply);
    if (data == null) {
      return;
    }

    // Calls CPDFDocument.updateAnnotationReply. This API updates only the
    // selected plain reply content/title, not the parent annotation.
    final result = await _runSilently(
      'updateAnnotationReply',
      () => widget.controller.document.updateAnnotationReply(
        reply,
        content: data.content,
        title: data.title,
      ),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
  }

  Future<void> _deleteReply(CPDFReplyAnnotation reply) async {
    final confirmed = await _confirm(
      title: 'Delete Reply',
      message: 'Delete this reply?',
      action: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    // Calls CPDFDocument.removeAnnotationReply to remove one plain reply.
    final result = await _runSilently(
      'removeAnnotationReply',
      () => widget.controller.document.removeAnnotationReply(reply),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
  }

  Future<void> _clearReplies() async {
    final confirmed = await _confirm(
      title: 'Clear Replies',
      message: 'Remove all plain replies from this annotation?',
      action: 'Clear',
    );
    if (!confirmed) {
      return;
    }

    // Calls CPDFDocument.removeAllAnnotationReplies. Mark/review state replies
    // are implementation details and are not exposed as plain replies.
    final result = await _runSilently(
      'removeAllAnnotationReplies',
      () => widget.controller.document.removeAllAnnotationReplies(
        widget.annotation,
      ),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
  }

  Future<void> _setAnnotationMarkState() async {
    final state = await _pickMarkState(title: 'Mark');
    if (state == null) {
      return;
    }

    // Calls CPDFDocument.setAnnotationMarkState with the parent annotation as
    // the target.
    final result = await _runSilently(
      'setAnnotationMarkState',
      () => widget.controller.document.setAnnotationMarkState(
        widget.annotation,
        state,
      ),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
    if (mounted && result == true) {
      setState(() => _annotationMarkState = state);
    }
  }

  Future<void> _setAnnotationReviewState() async {
    final state = await _pickReviewState(title: 'Review');
    if (state == null) {
      return;
    }

    // Calls CPDFDocument.setAnnotationReviewState with the parent annotation as
    // the target.
    final result = await _runSilently(
      'setAnnotationReviewState',
      () => widget.controller.document.setAnnotationReviewState(
        widget.annotation,
        state,
      ),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
    if (mounted && result == true) {
      setState(() => _annotationReviewState = state);
    }
  }

  Future<void> _setReplyMarkState(CPDFReplyAnnotation reply) async {
    final state = await _pickMarkState(title: 'Reply Mark');
    if (state == null) {
      return;
    }

    // Calls CPDFDocument.setAnnotationMarkState with a CPDFReplyAnnotation
    // target. Parent annotation mark-state editing is intentionally omitted
    // from this sample UI.
    final result = await _runSilently(
      'setReplyMarkState',
      () => widget.controller.document.setAnnotationMarkState(reply, state),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
  }

  Future<void> _setReplyReviewState(CPDFReplyAnnotation reply) async {
    final state = await _pickReviewState(title: 'Reply Review');
    if (state == null) {
      return;
    }

    // Calls CPDFDocument.setAnnotationReviewState with a CPDFReplyAnnotation
    // target. Parent annotation review-state editing is intentionally omitted
    // from this sample UI.
    final result = await _runSilently(
      'setReplyReviewState',
      () => widget.controller.document.setAnnotationReviewState(reply, state),
    );

    if (result == true) {
      await _reloadAfterAction();
    }
  }

  Future<void> _reloadAfterAction() async {
    await _loadReplies();
    if (!mounted) {
      return;
    }
    setState(() => _sending = false);
  }

  Future<T?> _runSilently<T>(
    String action,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      debugPrint('$action failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<ReplyEditData?> _showReplyEditDialog(
    CPDFReplyAnnotation reply,
  ) async {
    _dismissKeyboard();
    final titleController = TextEditingController(text: reply.title);
    final contentController = TextEditingController(text: reply.content);

    return showDialog<ReplyEditData>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Reply'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final content = contentController.text.trim();
              if (content.isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                ReplyEditData(
                  title: titleController.text.trim(),
                  content: content,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<CPDFAnnotationMarkState?> _pickMarkState({required String title}) {
    return _pickState<CPDFAnnotationMarkState>(
      title: title,
      values: CPDFAnnotationMarkState.values,
      label: (state) => state.name,
    );
  }

  Future<CPDFAnnotationReviewState?> _pickReviewState({required String title}) {
    return _pickState<CPDFAnnotationReviewState>(
      title: title,
      values: CPDFAnnotationReviewState.values,
      label: (state) => state.name,
    );
  }

  Future<T?> _pickState<T>({
    required String title,
    required List<T> values,
    required String Function(T value) label,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            ...values.map(
              (value) => ListTile(
                title: Text(label(value)),
                onTap: () => Navigator.of(context).pop(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printJson() {
    _dismissKeyboard();
    printJsonString(jsonEncode(widget.annotation));
    debugPrint('--------------------');
    printJsonString(jsonEncode(_replies));
  }

  void _dismissKeyboard() {
    _composerFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildReplyList(context),
          ),
          _buildComposer(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 8, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.forum_outlined, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  annotationDisplayTitle(widget.annotation),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  annotationDisplaySummary(widget.annotation),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    AnnotationStateChip(
                      label: 'Mark',
                      value: _annotationMarkState.name,
                      icon: Icons.flag_outlined,
                    ),
                    AnnotationStateChip(
                      label: 'Review',
                      value: _annotationReviewState.name,
                      icon: Icons.verified_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<ThreadAction>(
            onOpened: _dismissKeyboard,
            onSelected: _handleThreadAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThreadAction.annotationMark,
                child: Text('Mark'),
              ),
              PopupMenuItem(
                value: ThreadAction.annotationReview,
                child: Text('Review'),
              ),
              PopupMenuItem(
                value: ThreadAction.clearReplies,
                child: Text('Clear Replies'),
              ),
              PopupMenuItem(
                value: ThreadAction.printJson,
                child: Text('Print JSON'),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  void _handleThreadAction(ThreadAction action) {
    _dismissKeyboard();
    switch (action) {
      case ThreadAction.annotationMark:
        _setAnnotationMarkState();
        break;
      case ThreadAction.annotationReview:
        _setAnnotationReviewState();
        break;
      case ThreadAction.clearReplies:
        _clearReplies();
        break;
      case ThreadAction.printJson:
        _printJson();
        break;
    }
  }

  Widget _buildReplyList(BuildContext context) {
    if (_replies.isEmpty) {
      return Center(
        child: Text(
          'No replies yet',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: _replies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return ReplyBubble(
          reply: _replies[index],
          onAction: (action) => _handleReplyAction(_replies[index], action),
        );
      },
    );
  }

  void _handleReplyAction(CPDFReplyAnnotation reply, ReplyAction action) {
    _dismissKeyboard();
    switch (action) {
      case ReplyAction.edit:
        _editReply(reply);
        break;
      case ReplyAction.delete:
        _deleteReply(reply);
        break;
      case ReplyAction.mark:
        _setReplyMarkState(reply);
        break;
      case ReplyAction.review:
        _setReplyReviewState(reply);
        break;
    }
  }

  Widget _buildComposer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    controller: _composerController,
                    focusNode: _composerFocusNode,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    onTapOutside: (_) => _dismissKeyboard(),
                    decoration: InputDecoration(
                      hintText: 'Add a reply',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                  disabledForegroundColor: colorScheme.onSurfaceVariant,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: _canSend ? _sendReply : null,
                icon: _sending
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                tooltip: 'Send',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small status chip used in the thread header.
class AnnotationStateChip extends StatelessWidget {
  /// Creates an annotation state chip.
  const AnnotationStateChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  /// State family name, for example Mark or Review.
  final String label;

  /// Current state value.
  final String value;

  /// Leading icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 5),
            Text(
              '$label: $value',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lightweight visual representation of one reply annotation.
class ReplyBubble extends StatelessWidget {
  /// Creates a reply bubble.
  const ReplyBubble({
    super.key,
    required this.reply,
    required this.onAction,
  });

  /// Reply annotation displayed by this bubble.
  final CPDFReplyAnnotation reply;

  /// Called when a menu action is selected for this reply.
  final ValueChanged<ReplyAction> onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = reply.title.isEmpty ? 'Untitled' : reply.title;
    final date = formatReplyDate(reply.modifyDate ?? reply.createDate);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Material(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: PopupMenuButton<ReplyAction>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_horiz),
                        iconSize: 20,
                        tooltip: 'More',
                        onOpened: () =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        onSelected: onAction,
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: ReplyAction.edit,
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: ReplyAction.delete,
                            child: Text('Delete'),
                          ),
                          PopupMenuItem(
                            value: ReplyAction.mark,
                            child: Text('Mark State'),
                          ),
                          PopupMenuItem(
                            value: ReplyAction.review,
                            child: Text('Review State'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(reply.content),
                ),
                const SizedBox(height: 8),
                Text(
                  '$date - ${reply.markState.name} - ${reply.reviewState.name}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Data returned from the edit-reply dialog.
class ReplyEditData {
  /// Creates reply edit data.
  const ReplyEditData({
    required this.title,
    required this.content,
  });

  /// Reply title/author.
  final String title;

  /// Reply content.
  final String content;
}

/// Actions available from the reply-thread overflow menu.
enum ThreadAction {
  /// Set mark state on the parent annotation.
  annotationMark,

  /// Set review state on the parent annotation.
  annotationReview,

  /// Remove all plain replies from the selected annotation.
  clearReplies,

  /// Print the selected annotation and its replies to debug output.
  printJson,
}

/// Actions available for one reply item.
enum ReplyAction {
  /// Edit reply title/content.
  edit,

  /// Delete one reply.
  delete,

  /// Set mark state on one reply annotation.
  mark,

  /// Set review state on one reply annotation.
  review,
}

/// Builds a short display title for an annotation.
String annotationDisplayTitle(CPDFAnnotation annotation) {
  final title = annotation.title.trim();
  return title.isEmpty ? annotation.type.name : title;
}

/// Builds a short display summary for an annotation.
String annotationDisplaySummary(CPDFAnnotation annotation) {
  final content = annotation.content.trim();
  if (content.isNotEmpty) {
    return content;
  }
  return 'Page ${annotation.page + 1} - ${annotation.type.name}';
}

/// Formats reply creation/modification date for compact display.
String formatReplyDate(DateTime? date) {
  if (date == null) {
    return 'No date';
  }
  return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
