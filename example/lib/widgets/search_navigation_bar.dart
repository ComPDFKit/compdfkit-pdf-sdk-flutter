// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Reusable search navigation bar for navigating through search results.
///
/// Features:
/// - Displays current index and total count
/// - Previous/Next navigation buttons
/// - List button to show all results
/// - Follows Material Design 3 theme
///
/// Example usage:
/// ```dart
/// SearchNavigationBar(
///   currentIndex: 0,
///   totalCount: 10,
///   onPrevious: () => goToPrevious(),
///   onNext: () => goToNext(),
///   onShowList: () => showResultsList(),
/// )
/// ```
class SearchNavigationBar extends StatelessWidget {
  /// Current result index (0-based).
  final int currentIndex;

  /// Total number of results.
  final int totalCount;

  /// Callback when previous button is pressed.
  final VoidCallback? onPrevious;

  /// Callback when next button is pressed.
  final VoidCallback? onNext;

  /// Callback when list button is pressed.
  final VoidCallback? onShowList;

  /// Whether the navigation bar is visible.
  final bool visible;

  /// Constructor
  const SearchNavigationBar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    this.onPrevious,
    this.onNext,
    this.onShowList,
    this.visible = true,
  });

  bool get _canGoPrevious => currentIndex > 0;
  bool get _canGoNext => currentIndex < totalCount - 1;

  @override
  Widget build(BuildContext context) {
    if (!visible || totalCount == 0) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(77),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildResultCounter(colorScheme, textTheme),
          const Spacer(),
          _buildNavigationButtons(colorScheme),
          const SizedBox(width: 8),
          _buildListButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildResultCounter(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(128),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.find_in_page,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '${currentIndex + 1} / $totalCount',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavButton(
            icon: Icons.keyboard_arrow_up_rounded,
            enabled: _canGoPrevious,
            onPressed: onPrevious,
            colorScheme: colorScheme,
            tooltip: 'Previous',
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(10)),
          ),
          Container(
            width: 1,
            height: 24,
            color: colorScheme.outlineVariant.withAlpha(77),
          ),
          _buildNavButton(
            icon: Icons.keyboard_arrow_down_rounded,
            enabled: _canGoNext,
            onPressed: onNext,
            colorScheme: colorScheme,
            tooltip: 'Next',
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(10)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    required String tooltip,
    required BorderRadius borderRadius,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: borderRadius,
          child: Container(
            width: 40,
            height: 36,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant.withAlpha(102),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListButton(ColorScheme colorScheme) {
    return Tooltip(
      message: 'Show all results',
      child: Material(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onShowList,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 36,
            alignment: Alignment.center,
            child: Icon(
              Icons.list_alt_rounded,
              size: 20,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
