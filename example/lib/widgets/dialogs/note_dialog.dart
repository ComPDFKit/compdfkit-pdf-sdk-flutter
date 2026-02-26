// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// A sticky note style dialog for displaying note annotation content.
///
/// This widget displays content in a yellow sticky note style dialog,
/// commonly used for showing PDF note annotation content.
///
/// ## Usage Example
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => NoteDialog(
///     content: 'This is a note annotation content.',
///     title: 'Note',  // Optional, defaults to 'Note'
///   ),
/// );
/// ```
///
/// ## Customization
///
/// - [content]: The note content to display
/// - [title]: Optional title for the dialog header (defaults to 'Note')
/// - [headerColor]: Optional custom header color (defaults to yellow)
/// - [backgroundColor]: Optional custom background color (defaults to light yellow)
class NoteDialog extends StatelessWidget {
  /// The content to display in the note dialog.
  final String content;

  /// The title displayed in the header bar.
  final String title;

  /// The color of the header bar.
  final Color headerColor;

  /// The background color of the content area.
  final Color backgroundColor;

  /// The text color for header elements.
  final Color headerTextColor;

  /// The text color for content area.
  final Color contentTextColor;

  const NoteDialog({
    super.key,
    required this.content,
    this.title = 'Note',
    this.headerColor = const Color(0xFFFFEB3B),
    this.backgroundColor = const Color(0xFFFFF9C4),
    this.headerTextColor = const Color(0xFF5D4037),
    this.contentTextColor = const Color(0xFF4E342E),
  });

  /// Shows a [NoteDialog] as a modal dialog.
  ///
  /// This is a convenience method that wraps [showDialog] for easier usage.
  ///
  /// ```dart
  /// NoteDialog.show(
  ///   context: context,
  ///   content: 'Note content here',
  /// );
  /// ```
  static Future<void> show({
    required BuildContext context,
    required String content,
    String title = 'Note',
    Color? headerColor,
    Color? backgroundColor,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => NoteDialog(
        content: content,
        title: title,
        headerColor: headerColor ?? const Color(0xFFFFEB3B),
        backgroundColor: backgroundColor ?? const Color(0xFFFFF9C4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(77),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Row(
        children: [
          Icon(Icons.note, size: 20, color: headerTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: headerTextColor,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, size: 20, color: headerTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          content.isEmpty ? 'No content' : content,
          style: TextStyle(
            color: contentTextColor,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
