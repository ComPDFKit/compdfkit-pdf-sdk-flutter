// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// A header widget for grouping annotations by page in the annotation list.
///
/// This widget displays a styled section header showing the page number
/// and the count of annotations on that page.
///
/// **Displayed Information:**
/// - Page icon (leading)
/// - Page number (bold text)
/// - Annotation count badge (trailing)
///
/// **Visual Style:**
/// - 36px height container
/// - Surface container background with bottom border
/// - Rounded count badge
///
/// **Usage:**
/// ```dart
/// AnnotationHeadItem(pageIndex: 5, count: 3) // "Page 6" with count badge "3"
/// ```
class AnnotationHeadItem extends StatelessWidget {
  final int pageIndex;

  final int count;

  const AnnotationHeadItem(
      {super.key, required this.pageIndex, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.article_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '${PdfLocaleKeys.page.tr} ${pageIndex + 1}',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
