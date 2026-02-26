/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_freetext_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_ink_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_line_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_note_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_signature_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_sound_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_stamp_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

/// Annotations list page.
///
/// Displays all annotations in the PDF document grouped by page.
/// Supports tapping to jump to the annotation and removing annotations.
class AnnotationListPage extends StatelessWidget {
  final List<CPDFAnnotation> annotations;

  const AnnotationListPage({super.key, required this.annotations});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Group annotations by page number.
    final groupedAnnotations = <int, List<CPDFAnnotation>>{};
    for (var annotation in annotations) {
      groupedAnnotations.putIfAbsent(annotation.page, () => []).add(annotation);
    }

    final pageNumbers = groupedAnnotations.keys.toList()..sort();
    final totalCount = annotations.length;

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
                  Icons.comment_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Annotations',
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

          // ==================== Annotations List ====================
          Expanded(
            child: annotations.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: pageNumbers.length,
                    itemBuilder: (context, index) {
                      final pageNumber = pageNumbers[index];
                      final annotationsForPage =
                          groupedAnnotations[pageNumber]!;
                      return _buildPageSection(
                          context, pageNumber, annotationsForPage);
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
            Icons.speaker_notes_off_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Annotations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add annotations to your PDF document',
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
      BuildContext context, int pageNumber, List<CPDFAnnotation> annotations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageHeader(context, pageNumber, annotations.length),
        ...annotations.map((a) => _buildAnnotationItem(context, a)),
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
            '$count ${count == 1 ? 'item' : 'items'}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  /// Build an annotation item.
  Widget _buildAnnotationItem(BuildContext context, CPDFAnnotation annotation) {
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
            printJsonString(annotation.toString());
            Navigator.pop(context, {
              'type': 'jump',
              'annotation': annotation,
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
                  // Annotation icon with color indicator.
                  Center(child: _buildAnnotationIcon(context, annotation)),
                  const SizedBox(width: 12),

                  // Annotation content area.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Type chip and timestamp.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTypeChip(context, annotation.type),
                            const Spacer(),
                            if (annotation.createDate != null)
                              Text(
                                _formatDate(annotation.createDate!),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.outline,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Key annotation details.
                        _buildAnnotationDetails(context, annotation),
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
                          'annotation': annotation,
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

  /// Build the annotation icon (with color indicator).
  Widget _buildAnnotationIcon(BuildContext context, CPDFAnnotation annotation) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = _getAnnotationIcon(annotation.type);
    final annotationColor = _getAnnotationColor(annotation);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: annotationColor?.withAlpha(30) ??
            colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: annotationColor != null
            ? Border.all(color: annotationColor.withAlpha(100), width: 2)
            : null,
      ),
      child: Icon(
        iconData,
        size: 20,
        color: annotationColor ?? colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Build the type chip.
  Widget _buildTypeChip(BuildContext context, CPDFAnnotationType type) {
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

  /// Build annotation details (varies by annotation type).
  Widget _buildAnnotationDetails(
      BuildContext context, CPDFAnnotation annotation) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final detailWidgets = <Widget>[];

    // Author/title.
    if (annotation.title.isNotEmpty) {
      detailWidgets.add(
        _buildDetailRow(
          context,
          Icons.person_outline,
          annotation.title,
        ),
      );
    }

    // Add type-specific details.
    switch (annotation) {
      case CPDFMarkupAnnotation markup:
        if (markup.markedText.isNotEmpty) {
          detailWidgets.add(
            _buildQuotedText(context, markup.markedText),
          );
        }

      case CPDFNoteAnnotation note:
        if (note.content.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.notes_outlined,
              note.content,
              maxLines: 2,
            ),
          );
        }

      case CPDFFreeTextAnnotation freeText:
        if (freeText.content.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.text_fields,
              freeText.content,
              maxLines: 2,
            ),
          );
        }

      case CPDFLineAnnotation line:
        final lineInfo = <String>[];
        if (line.lineHeadType != CPDFLineType.none) {
          lineInfo.add('Head: ${line.lineHeadType.name}');
        }
        if (line.lineTailType != CPDFLineType.none) {
          lineInfo.add('Tail: ${line.lineTailType.name}');
        }
        if (lineInfo.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.arrow_forward,
              lineInfo.join(', '),
            ),
          );
        }

      case CPDFStampAnnotation stamp:
        if (stamp.stampType != null) {
          final stampInfo = stamp.stampType == CPDFStampType.text
              ? stamp.textStamp?.content ?? 'Text Stamp'
              : stamp.standardStamp?.name ?? 'Standard Stamp';
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.approval,
              stampInfo,
            ),
          );
        }

      case CPDFLinkAnnotation link:
        if (link.action != null) {
          final action = link.action!;
          if (action is CPDFGoToAction) {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.bookmark_outline,
                'Page ${action.pageIndex + 1}',
              ),
            );
          } else if (action is CPDFUriAction) {
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
          } else {
            detailWidgets.add(
              _buildDetailRow(
                context,
                Icons.link,
                action.actionType.name,
              ),
            );
          }
        }

      case CPDFSignatureAnnotation _:
        detailWidgets.add(
          _buildDetailRow(
            context,
            Icons.draw,
            'Digital Signature',
          ),
        );

      case CPDFSoundAnnotation sound:
        detailWidgets.add(
          _buildDetailRow(
            context,
            Icons.audiotrack,
            sound.soundPath ?? 'Audio Attached',
          ),
        );

      default:
        if (annotation.content.isNotEmpty) {
          detailWidgets.add(
            _buildDetailRow(
              context,
              Icons.notes_outlined,
              annotation.content,
              maxLines: 2,
            ),
          );
        }
    }

    // If no details are available, show the UUID.
    if (detailWidgets.isEmpty) {
      detailWidgets.add(
        Text(
          'ID: ${annotation.uuid.substring(0, annotation.uuid.length.clamp(0, 8))}...',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
            fontFamily: 'monospace',
          ),
        ),
      );
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

  /// Build a quoted text block (for highlight-like annotations).
  Widget _buildQuotedText(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
            color: colorScheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Text(
        '"$text"',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // ==================== Helpers ====================

  /// Get the icon for an annotation type.
  IconData _getAnnotationIcon(CPDFAnnotationType type) {
    return switch (type) {
      CPDFAnnotationType.note => Icons.sticky_note_2_outlined,
      CPDFAnnotationType.highlight => Icons.highlight_outlined,
      CPDFAnnotationType.underline => Icons.format_underlined,
      CPDFAnnotationType.strikeout => Icons.format_strikethrough,
      CPDFAnnotationType.squiggly => Icons.format_underlined,
      CPDFAnnotationType.freetext => Icons.text_fields,
      CPDFAnnotationType.ink => Icons.brush_outlined,
      CPDFAnnotationType.square => Icons.crop_square,
      CPDFAnnotationType.circle => Icons.circle_outlined,
      CPDFAnnotationType.line => Icons.horizontal_rule,
      CPDFAnnotationType.arrow => Icons.arrow_forward,
      CPDFAnnotationType.stamp => Icons.approval,
      CPDFAnnotationType.signature => Icons.draw_outlined,
      CPDFAnnotationType.link => Icons.link,
      CPDFAnnotationType.sound => Icons.volume_up_outlined,
      _ => Icons.comment_outlined,
    };
  }

  /// Get the annotation color.
  Color? _getAnnotationColor(CPDFAnnotation annotation) {
    return switch (annotation) {
      CPDFMarkupAnnotation m => m.color,
      CPDFNoteAnnotation n => n.color,
      CPDFInkAnnotation i => i.color,
      CPDFSquareAnnotation s => s.borderColor,
      CPDFCircleAnnotation c => c.borderColor,
      CPDFLineAnnotation l => l.borderColor,
      _ => null,
    };
  }

  /// Get the display name for an annotation type.
  String _getTypeDisplayName(CPDFAnnotationType type) {
    return switch (type) {
      CPDFAnnotationType.note => 'Note',
      CPDFAnnotationType.highlight => 'Highlight',
      CPDFAnnotationType.underline => 'Underline',
      CPDFAnnotationType.strikeout => 'Strikeout',
      CPDFAnnotationType.squiggly => 'Squiggly',
      CPDFAnnotationType.freetext => 'Free Text',
      CPDFAnnotationType.ink => 'Ink',
      CPDFAnnotationType.square => 'Rectangle',
      CPDFAnnotationType.circle => 'Circle',
      CPDFAnnotationType.line => 'Line',
      CPDFAnnotationType.arrow => 'Arrow',
      CPDFAnnotationType.stamp => 'Stamp',
      CPDFAnnotationType.signature => 'Signature',
      CPDFAnnotationType.link => 'Link',
      CPDFAnnotationType.sound => 'Sound',
      CPDFAnnotationType.unknown => 'Unknown',
      _ => type.name,
    };
  }

  /// Format date time as YYYY-MM-DD HH:mm.
  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}
