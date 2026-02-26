// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Reusable application toolbar component.
///
/// Provides back button, title, subtitle, and custom action buttons.
class AppToolbar extends StatelessWidget {
  /// The toolbar title (required).
  final String title;

  /// The toolbar subtitle (optional).
  final String? subtitle;

  /// Back button callback.
  /// If null, the back button is not displayed.
  final VoidCallback? onBack;

  /// Custom action buttons list on the right side (optional).
  final List<Widget>? actions;

  /// Horizontal padding, default is 16.
  final double horizontalPadding;

  /// Vertical padding, default is 12.
  final double verticalPadding;

  const AppToolbar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
    this.horizontalPadding = 16,
    this.verticalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ==================== Back Button ====================
          if (onBack != null) ...[
            InkWell(
              onTap: onBack,
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
            const SizedBox(width: 16),
          ],

          // ==================== Title and Subtitle ====================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ==================== Custom Actions on the Right ====================
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  actions![i],
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
