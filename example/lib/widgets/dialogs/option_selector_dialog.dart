// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:flutter/material.dart';

/// Shows the option selector as a modal bottom sheet.
///
/// This is the preferred way to show option selection UI, providing a
/// consistent modal bottom sheet experience similar to other picker modals.
///
/// **Parameters:**<br/>
///   [context] - Build context for showing the modal.
///   [options] - List of [CPDFWidgetItem] to display.
///   [selectedIndex] - Currently selected index (default: -1).
///   [title] - Modal title (default: 'Select Option').
///   [subtitle] - Optional subtitle text.
///
/// **Returns:** The selected index, or `null` if dismissed.
///
/// ## Usage Example
///
/// ```dart
/// final selectedIndex = await showOptionSelectorModal(
///   context,
///   options: widget.options ?? [],
///   selectedIndex: widget.selectItemAtIndex,
///   title: 'Select Item',
/// );
///
/// if (selectedIndex != null) {
///   widget.selectItemAtIndex = selectedIndex;
///   await controller.document.updateWidget(widget);
/// }
/// ```
Future<int?> showOptionSelectorModal(
  BuildContext context, {
  required List<CPDFWidgetItem> options,
  int selectedIndex = -1,
  String title = 'Select Option',
  String? subtitle,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _OptionSelectorContent(
      options: options,
      selectedIndex: selectedIndex,
      title: title,
      subtitle: subtitle ?? 'Tap an option to select',
    ),
  );
}

/// Internal content widget for the option selector modal.
class _OptionSelectorContent extends StatelessWidget {
  final List<CPDFWidgetItem> options;
  final int selectedIndex;
  final String title;
  final String subtitle;

  const _OptionSelectorContent({
    required this.options,
    required this.selectedIndex,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Calculate max height (60% of screen height)
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== Drag indicator bar ====================
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ==================== Title ====================
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              // ==================== Options List ====================
              if (options.isEmpty)
                _buildEmptyState(colors)
              else
                Flexible(
                  child: _buildOptionsList(context, colors),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'No options available',
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context, ColorScheme colors) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = index == selectedIndex;

        return _OptionCard(
          option: option,
          isSelected: isSelected,
          colors: colors,
          onTap: () => Navigator.of(context).pop(index),
        );
      },
    );
  }
}

/// Individual option card widget styled like _PdfPickerContent options.
class _OptionCard extends StatelessWidget {
  final CPDFWidgetItem option;
  final bool isSelected;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryContainer.withValues(alpha: 0.5) : null,
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.outline.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primaryContainer : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? colors.primary : colors.onSurface,
                          ),
                    ),
                    if (option.value.isNotEmpty && option.value != option.text) ...[
                      const SizedBox(height: 2),
                      Text(
                        option.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing indicator
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: colors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}