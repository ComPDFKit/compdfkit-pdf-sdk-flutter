// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/confirm_alert_dialog.dart';

/// A bottom action bar widget for batch annotation deletion.
///
/// This widget displays a styled delete button at the bottom of the annotation
/// list when in edit mode with selections. Features a prominent error-colored
/// design to indicate destructive action.
///
/// **Visibility Conditions:**
/// - Only visible when `isEdit` mode is active
/// - Only visible when at least one annotation is selected
///
/// **Visual Features:**
/// - Error color theme for delete action emphasis
/// - Selection count display
/// - Elevated container with top border
///
/// **User Interaction:**
/// - Tap to show confirmation dialog
/// - Confirmation triggers batch deletion via [AnnotationController]
/// - List updates smoothly without full refresh
///
/// **Usage:**
/// ```dart
/// AnnotationDeleteTile()
/// ```
class AnnotationDeleteTile extends StatelessWidget {
  const AnnotationDeleteTile({super.key});

  @override
  Widget build(BuildContext context) {
    final annotationController = Get.find<AnnotationController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: Obx(() {
        final isEdit = annotationController.state.isEdit.value;
        final selectedCount =
            annotationController.state.selectedAnnotations.length;
        final hasSelected = selectedCount > 0;

        if (!isEdit || !hasSelected) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: colorScheme.error,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _showDeleteDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${PdfLocaleKeys.delete.tr} ($selectedCount)',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    var annotationController = Get.find<AnnotationController>();

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmAlertDialog(
          title: PdfLocaleKeys.delete.tr,
          content: PdfLocaleKeys.deleteAnnotationConfirm.tr,
          onCancel: () => Navigator.pop(context),
          onConfirm: () async {
            Navigator.pop(context);
            await annotationController.deleteSelectedAnnotations();
          },
        );
      },
    );
  }
}
