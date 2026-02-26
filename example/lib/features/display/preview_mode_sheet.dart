/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

class PreviewModeSheet extends StatelessWidget {
  final CPDFViewMode viewMode;

  const PreviewModeSheet({super.key, required this.viewMode});

  static const Map<CPDFViewMode, _ModeInfo> _modeInfoMap = {
    CPDFViewMode.viewer: _ModeInfo(
      icon: Icons.visibility_outlined,
      title: 'Viewer',
      description: 'Read-only mode',
    ),
    CPDFViewMode.annotations: _ModeInfo(
      icon: Icons.edit_note_outlined,
      title: 'Annotations',
      description: 'Add and edit annotations',
    ),
    CPDFViewMode.contentEditor: _ModeInfo(
      icon: Icons.text_fields_outlined,
      title: 'Content Editor',
      description: 'Edit text and images',
    ),
    CPDFViewMode.forms: _ModeInfo(
      icon: Icons.list_alt_outlined,
      title: 'Forms',
      description: 'Fill and create forms',
    ),
    CPDFViewMode.signatures: _ModeInfo(
      icon: Icons.draw_outlined,
      title: 'Signatures',
      description: 'Add digital signatures',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, colorScheme, textTheme),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: CPDFViewMode.values.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final mode = CPDFViewMode.values[index];
                final info = _modeInfoMap[mode]!;
                final isSelected = viewMode == mode;

                return _ModeCard(
                  info: info,
                  isSelected: isSelected,
                  onTap: () => Navigator.pop(context, mode),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Text(
              'Preview Mode',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeInfo {
  final IconData icon;
  final String title;
  final String description;

  const _ModeInfo({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ModeCard extends StatelessWidget {
  final _ModeInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  info.icon,
                  size: 24,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
