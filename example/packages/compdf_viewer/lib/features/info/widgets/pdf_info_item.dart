// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single row displaying a label-value pair of PDF document information.
///
/// This widget presents a modern vertical layout with:
/// - Top: Muted label text (smaller, secondary color)
/// - Bottom: Primary content text (larger, emphasis color)
/// - Long press to copy content
///
/// Features:
/// - Theme-aware styling with proper text hierarchy
/// - Vertical label-value layout for better readability
/// - Optional badge styling for boolean/status values
/// - Copy to clipboard on long press
///
/// Example usage:
/// ```dart
/// Column(
///   children: [
///     PdfInfoItem(title: 'File Name', content: 'sample.pdf'),
///     PdfInfoItem(
///       title: 'Encrypted',
///       content: 'Yes',
///       isBadge: true,
///       isPositive: true,
///     ),
///   ],
/// )
/// ```
class PdfInfoItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isBadge;

  /// When [isBadge] is true, this determines the badge style:
  /// - true: green checkmark (positive/allowed)
  /// - false: gray X mark (negative/denied)
  /// - null: defaults to false
  final bool? isPositive;

  const PdfInfoItem({
    super.key,
    required this.title,
    required this.content,
    this.isBadge = false,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayContent = content.isEmpty ? '-' : content;

    return InkWell(
      onLongPress: content.isNotEmpty
          ? () {
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied: $content'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            isBadge
                ? _buildBadge(context, displayContent, isPositive ?? false)
                : Text(
                    displayContent,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, bool isPositive) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.12)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 14,
            color: isPositive ? Colors.green : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      isPositive ? Colors.green : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
