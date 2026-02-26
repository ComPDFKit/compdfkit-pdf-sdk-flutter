// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../../examples/registry.dart';

/// Category list tile widget
///
/// Displays a single category item with alternating colors based on index.
class CategoryListTile extends StatelessWidget {
  /// Category information to display
  final CategoryInfo category;

  /// Index used for alternating colors
  final int index;

  /// Callback when tile is tapped
  final VoidCallback onTap;

  /// Constructor
  const CategoryListTile({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  Color _iconBackgroundColor(ColorScheme scheme) {
    final colors = [
      scheme.tertiaryContainer,
      scheme.primaryContainer,
      scheme.tertiaryContainer,
      scheme.primaryContainer,
    ];
    return colors[index % colors.length];
  }

  Color _iconColor(ColorScheme scheme) {
    final colors = [
      scheme.tertiary,
      scheme.primary,
      scheme.tertiary,
      scheme.primary,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconBackgroundColor(colorScheme),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    category.icon,
                    size: 20,
                    color: _iconColor(colorScheme),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (category.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          category.description!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
