// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/bota/annotations/widgets/annotation_item_icon.dart';
import 'package:compdf_viewer/features/bota/annotations/model/annotation_item_model.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';

/// A list item widget representing a single PDF annotation.
///
/// This widget displays annotation details with a modern card-like design
/// and handles both navigation mode and selection mode behaviors.
///
/// **Displayed Information:**
/// - Annotation type icon (leading) - Shows annotation type with color
/// - Annotation content (main text) - Up to 3 lines with ellipsis
/// - Formatted creation date (subtitle)
/// - Page number badge (trailing)
/// - Selection checkbox (trailing, only in edit mode)
///
/// **User Interactions:**
/// - **Normal mode:** Tap to navigate to the annotation's page and close BOTA
/// - **Edit mode:** Tap to toggle annotation selection for batch deletion
///
/// **Usage:**
/// ```dart
/// AnnotationItem(item: AnnotationItemModel.annotation(myAnnotation))
/// ```
///
/// Requires [AnnotationController] and [PdfViewerController] to be registered
/// in GetX dependency injection.
class AnnotationItem extends StatelessWidget {
  final AnnotationItemModel item;

  const AnnotationItem({super.key, required this.item});

  void _handleTap() async {
    var annotationController = Get.find<AnnotationController>();
    if (annotationController.state.isEdit.value) {
      // If in edit mode, toggle selection state
      final selected = annotationController.state.isSelected(
        item.annotation!,
      );
      annotationController.state.toggleSelection(item.annotation!, !selected);
      return;
    }
    // Not in edit mode, navigate to page
    PdfViewerController pdfController = Get.find<PdfViewerController>();
    await pdfController.readerController.value?.setDisplayPageIndex(
      pageIndex: item.annotation!.page,
    );
    Get.back();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final annotationController = Get.find<AnnotationController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Annotation type icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: AnnotationItemIcon(annotation: item.annotation!),
              ),
            ),
            const SizedBox(width: 12),
            // Content and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.annotation!.content.isNotEmpty
                        ? item.annotation!.content
                        : '(No content)',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: item.annotation!.content.isNotEmpty
                          ? null
                          : colorScheme.onSurfaceVariant,
                      fontStyle: item.annotation!.content.isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                  if (item.annotation!.createDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.annotation!.createDate),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Checkbox or page badge
            _buildTrailing(annotationController, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing(
      AnnotationController controller, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.state.isEdit.value) {
        final selected = controller.state.isSelected(item.annotation!);
        return SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: selected,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (select) {
              controller.state.toggleSelection(item.annotation!, select!);
            },
          ),
        );
      }
      // Page badge
      return Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: Text(
          '${item.annotation!.page + 1}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    });
  }
}
