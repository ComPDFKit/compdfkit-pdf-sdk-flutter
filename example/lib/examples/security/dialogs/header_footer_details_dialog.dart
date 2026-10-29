// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_header_footer.dart';
import 'package:flutter/material.dart';

/// Displays the current header and footer configuration.
class HeaderFooterDetailsDialog extends StatelessWidget {
  /// Creates a header and footer details dialog.
  const HeaderFooterDetailsDialog({super.key, required this.value});

  /// The current header and footer, or `null` when none is applied.
  final CPDFHeaderFooter? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.view_headline, color: colors.primary),
          const SizedBox(width: 10),
          const Expanded(child: Text('Header & Footer')),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.62,
          ),
          child: value == null
              ? const Center(child: Text('No header/footer applied'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        icon: Icons.space_bar,
                        label: 'Margins',
                        value: 'Left ${value!.margin.left.toStringAsFixed(1)}  '
                            'Top ${value!.margin.top.toStringAsFixed(1)}  '
                            'Right ${value!.margin.right.toStringAsFixed(1)}  '
                            'Bottom ${value!.margin.bottom.toStringAsFixed(1)}',
                      ),
                      const SizedBox(height: 16),
                      Text('Positions', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...value!.slots.map(
                        (slot) => _SlotCard(slot: slot),
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
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label, style: theme.textTheme.labelMedium),
        subtitle: Text(value),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot});

  final CPDFHeaderFooterSlot slot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = slot.text.isEmpty ? 'Empty' : slot.text;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 5, right: 10),
              decoration: BoxDecoration(
                color: slot.textColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _positionLabel(slot.position),
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(text, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 3),
                  Text(
                    '${slot.fontName} · ${slot.fontSize.toStringAsFixed(1)} pt',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _positionLabel(CPDFHeaderFooterPosition position) {
    switch (position) {
      case CPDFHeaderFooterPosition.headerLeft:
        return 'Header · Left';
      case CPDFHeaderFooterPosition.headerCenter:
        return 'Header · Center';
      case CPDFHeaderFooterPosition.headerRight:
        return 'Header · Right';
      case CPDFHeaderFooterPosition.footerLeft:
        return 'Footer · Left';
      case CPDFHeaderFooterPosition.footerCenter:
        return 'Footer · Center';
      case CPDFHeaderFooterPosition.footerRight:
        return 'Footer · Right';
    }
  }
}
