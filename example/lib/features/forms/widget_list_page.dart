/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:flutter/material.dart';

/// Form widgets list page.
///
/// Displays all form widgets in the PDF document grouped by page.
/// Supports tapping to jump to the widget and removing widgets.
class WidgetListPage extends StatelessWidget {
  final List<CPDFWidget> widgets;

  const WidgetListPage({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Group widgets by page number.
    final groupedWidgets = <int, List<CPDFWidget>>{};
    for (var widget in widgets) {
      groupedWidgets.putIfAbsent(widget.page, () => []).add(widget);
    }

    final pageNumbers = groupedWidgets.keys.toList()..sort();
    final totalCount = widgets.length;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== Header ====================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.dynamic_form_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Form Fields',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalCount',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                // Close button.
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // ==================== Widgets List ====================
          Expanded(
            child: widgets.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: pageNumbers.length,
                    itemBuilder: (context, index) {
                      final pageNumber = pageNumbers[index];
                      final widgetsForPage = groupedWidgets[pageNumber]!;
                      return _buildPageSection(
                          context, pageNumber, widgetsForPage);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Build the empty state view.
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dynamic_form_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Form Fields',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add form fields to your PDF document',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  /// Build a page section.
  Widget _buildPageSection(
      BuildContext context, int pageNumber, List<CPDFWidget> widgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader(context, pageNumber, widgets.length),
        ...widgets.map((w) => _buildWidgetItem(context, w)),
      ],
    );
  }

  /// Build the page header.
  Widget _buildPageHeader(BuildContext context, int pageNumber, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 14,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'Page ${pageNumber + 1}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count ${count == 1 ? 'field' : 'fields'}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a widget item.
  Widget _buildWidgetItem(BuildContext context, CPDFWidget widget) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, {
              'type': 'jump',
              'widget': widget,
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Widget icon with color indicator.
                  Center(child: _buildWidgetIcon(context, widget)),
                  const SizedBox(width: 12),

                  // Widget content area.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Type chip and title.
                        Row(
                          children: [
                            _buildTypeChip(context, widget.type),
                            if (widget.title.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        _buildWidgetDetails(context, widget),
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Delete button.
                  Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'type': 'remove',
                          'widget': widget,
                        });
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      tooltip: 'Delete',
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the widget icon (with color indicator).
  Widget _buildWidgetIcon(BuildContext context, CPDFWidget widget) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = _getWidgetIcon(widget.type);
    final widgetColor = _getWidgetColor(widget);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color:
            widgetColor?.withAlpha(30) ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: widgetColor != null
            ? Border.all(color: widgetColor.withAlpha(100), width: 2)
            : null,
      ),
      child: Icon(
        iconData,
        size: 20,
        color: widgetColor ?? colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Build the type chip.
  Widget _buildTypeChip(BuildContext context, CPDFFormType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getTypeDisplayName(type),
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build widget details (varies by widget type).
  Widget _buildWidgetDetails(BuildContext context, CPDFWidget widget) {
    final detailWidgets = <Widget>[];

    switch (widget) {
      case CPDFTextWidget textWidget:
        if (textWidget.text.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.text_fields,
              textWidget.text,
              maxLines: 2,
            ),
          );
        }
        if (textWidget.isMultiline) {
          detailWidgets.add(
            _buildDetailRow(context, Icons.wrap_text, 'Multiline'),
          );
        }

      case CPDFCheckBoxWidget checkBox:
        detailWidgets.add(
          _buildDetailRow(
            context,
            checkBox.isChecked
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            checkBox.isChecked ? 'Checked' : 'Unchecked',
          ),
        );
        detailWidgets.add(
          _buildDetailRow(
            context,
            Icons.style,
            'Style: ${checkBox.checkStyle.name}',
          ),
        );

      case CPDFRadioButtonWidget radioButton:
        detailWidgets.add(
          _buildDetailRow(
            context,
            radioButton.isChecked
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            radioButton.isChecked ? 'Selected' : 'Unselected',
          ),
        );

      case CPDFListBoxWidget listBox:
        final options = listBox.options;
        if (options != null && options.isNotEmpty) {
          final optionCount = options.length;
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.list,
              '$optionCount ${optionCount == 1 ? 'option' : 'options'}',
            ),
          );
          if (listBox.selectItemAtIndex >= 0 &&
              listBox.selectItemAtIndex < optionCount) {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.check_circle_outline,
                'Selected: ${options[listBox.selectItemAtIndex].text}',
              ),
            );
          }
        }

      case CPDFComboBoxWidget comboBox:
        final options = comboBox.options;
        if (options != null && options.isNotEmpty) {
          final optionCount = options.length;
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.arrow_drop_down_circle_outlined,
              '$optionCount ${optionCount == 1 ? 'option' : 'options'}',
            ),
          );
          if (comboBox.selectItemAtIndex >= 0 &&
              comboBox.selectItemAtIndex < optionCount) {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.check_circle_outline,
                'Selected: ${options[comboBox.selectItemAtIndex].text}',
              ),
            );
          }
        }

      case CPDFPushButtonWidget pushButton:
        if (pushButton.buttonTitle.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.label_outline,
              pushButton.buttonTitle,
            ),
          );
        }
        if (pushButton.action != null) {
          final action = pushButton.action!;
          if (action is CPDFUriAction) {
            detailWidgets.add(
              _buildDetailRow(
                context,
                action.uri.startsWith('mailto:')
                    ? Icons.email_outlined
                    : Icons.link,
                action.uri.startsWith('mailto:')
                    ? action.uri.substring(7)
                    : action.uri,
              ),
            );
          } else if (action is CPDFGoToAction) {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.bookmark_outline,
                'Go to Page ${action.pageIndex + 1}',
              ),
            );
          } else {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.touch_app,
                'Action: ${action.actionType.name}',
              ),
            );
          }
        }

      case CPDFSignatureWidget _:
        detailWidgets.add(
          _buildDetailRow(
            context,
            Icons.draw_outlined,
            'Digital Signature Field',
          ),
        );

      default:
        break;
    }

    if (detailWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detailWidgets,
    );
  }

  /// Build a detail row.
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String value, {
    int maxLines = 1,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 14,
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helpers ====================

  /// Get the icon for a widget type.
  IconData _getWidgetIcon(CPDFFormType type) {
    return switch (type) {
      CPDFFormType.textField => Icons.text_fields,
      CPDFFormType.checkBox => Icons.check_box_outlined,
      CPDFFormType.radioButton => Icons.radio_button_checked,
      CPDFFormType.listBox => Icons.list_alt,
      CPDFFormType.comboBox => Icons.arrow_drop_down_circle_outlined,
      CPDFFormType.pushButton => Icons.smart_button_outlined,
      CPDFFormType.signaturesFields => Icons.draw_outlined,
      CPDFFormType.unknown => Icons.help_outline,
    };
  }

  /// Get the widget color.
  Color? _getWidgetColor(CPDFWidget widget) {
    return widget.borderColor;
  }

  /// Get the display name for a widget type.
  String _getTypeDisplayName(CPDFFormType type) {
    return switch (type) {
      CPDFFormType.textField => 'Text Field',
      CPDFFormType.checkBox => 'Checkbox',
      CPDFFormType.radioButton => 'Radio Button',
      CPDFFormType.listBox => 'List Box',
      CPDFFormType.comboBox => 'Combo Box',
      CPDFFormType.pushButton => 'Button',
      CPDFFormType.signaturesFields => 'Signature',
      CPDFFormType.unknown => 'Unknown',
    };
  }
}
