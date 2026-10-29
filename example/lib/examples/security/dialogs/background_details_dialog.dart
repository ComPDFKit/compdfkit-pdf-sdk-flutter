// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_background.dart';
import 'package:flutter/material.dart';

/// Displays the current document background configuration.
class BackgroundDetailsDialog extends StatelessWidget {
  /// Creates a document background details dialog.
  const BackgroundDetailsDialog({super.key, required this.value});

  /// The current background, or `null` when none is applied.
  final CPDFBackground? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.wallpaper, color: colors.primary),
          const SizedBox(width: 10),
          const Expanded(child: Text('Document Background')),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.62,
          ),
          child: value == null
              ? const Center(child: Text('No background applied'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryCard(
                        icon: value!.type == CPDFBackgroundType.color
                            ? Icons.palette_outlined
                            : Icons.image_outlined,
                        label: 'Type',
                        value: value!.type == CPDFBackgroundType.color
                            ? 'Color'
                            : 'Image',
                        color: value!.color,
                      ),
                      _SummaryCard(
                        icon: Icons.layers_outlined,
                        label: 'Applied pages',
                        value: value!.pages.isEmpty
                            ? 'None'
                            : value!.pages
                                .map((page) => '${page + 1}')
                                .join(', '),
                      ),
                      _SummaryCard(
                        icon: Icons.opacity,
                        label: 'Appearance',
                        value: 'Opacity ${value!.opacity.toStringAsFixed(2)}  '
                            'Scale ${value!.scale.toStringAsFixed(2)}  '
                            'Rotation ${value!.rotation.toStringAsFixed(1)}°',
                      ),
                      _SummaryCard(
                        icon: Icons.align_horizontal_center,
                        label: 'Position',
                        value:
                            '${_horizontalLabel(value!.horizontalAlignment)} / '
                            '${_verticalLabel(value!.verticalAlignment)}  '
                            'Offset ${value!.horizontalOffset.toStringAsFixed(1)}, '
                            '${value!.verticalOffset.toStringAsFixed(1)}',
                      ),
                      _SummaryCard(
                        icon: Icons.visibility_outlined,
                        label: 'Permissions',
                        value:
                            'View ${value!.allowView ? 'Allowed' : 'Hidden'}  '
                            'Print ${value!.allowPrint ? 'Allowed' : 'Hidden'}',
                      ),
                      if (value!.type == CPDFBackgroundType.image)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'The native SDK does not expose the source path of '
                            'an existing image background.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _horizontalLabel(CPDFBackgroundHorizontalAlignment alignment) {
    switch (alignment) {
      case CPDFBackgroundHorizontalAlignment.left:
        return 'Left';
      case CPDFBackgroundHorizontalAlignment.center:
        return 'Center';
      case CPDFBackgroundHorizontalAlignment.right:
        return 'Right';
    }
  }

  String _verticalLabel(CPDFBackgroundVerticalAlignment alignment) {
    switch (alignment) {
      case CPDFBackgroundVerticalAlignment.top:
        return 'Top';
      case CPDFBackgroundVerticalAlignment.center:
        return 'Center';
      case CPDFBackgroundVerticalAlignment.bottom:
        return 'Bottom';
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        dense: true,
        leading: color == null
            ? Icon(icon, color: theme.colorScheme.primary)
            : Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.dividerColor),
                ),
              ),
        title: Text(label, style: theme.textTheme.labelMedium),
        subtitle: Text(value),
      ),
    );
  }
}
