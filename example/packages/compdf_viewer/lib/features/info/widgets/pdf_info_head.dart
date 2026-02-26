// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Section header widget for PDF information panels.
///
/// Displays a clean section header with icon and title.
/// Uses subtle styling to separate sections without being obtrusive.
///
/// Features:
/// - Leading icon with tinted background
/// - Semibold title text
/// - Subtle top padding for section separation
///
/// Example usage:
/// ```dart
/// Column(
///   children: [
///     PdfInfoHead(title: 'Basic Information', icon: Icons.description),
///     PdfInfoItem(title: 'File Name', content: 'document.pdf'),
///   ],
/// )
/// ```
class PdfInfoHead extends StatelessWidget {
  final String title;
  final IconData icon;

  const PdfInfoHead({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: colorScheme.surface,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
