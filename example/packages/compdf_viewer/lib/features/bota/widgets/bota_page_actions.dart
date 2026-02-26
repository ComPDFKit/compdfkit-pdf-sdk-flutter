// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';

/// Factory class for creating context-aware action buttons for BOTA app bar.
///
/// This class provides static methods to generate appropriate action buttons
/// based on the current BOTA tab and its state.
///
/// **Available Actions:**
/// - [annotationActions] - Creates edit/select-all toggle button for annotation tab
///
/// **Annotation Actions Behavior:**
/// - **Normal mode:** Shows "Edit" button to enter selection mode
/// - **Edit mode:** Shows "Select All/None" toggle button
///   - Unchecked icon: Select all annotations
///   - Checked icon: Deselect all annotations
///
/// **Usage:**
/// ```dart
/// // In AppBar actions
/// actions: [
///   BotaPageActions.annotationActions(context),
/// ]
/// ```
class BotaPageActions {
  static Widget annotationActions(BuildContext context) {
    AnnotationController controller = Get.find<AnnotationController>();
    return Obx(() {
      // Non-editing mode: Show "Edit" button
      if (!controller.state.isEdit.value) {
        return IconButton(
          icon: ImageIcon(
            AssetImage(
              PdfViewerAssets.icEdit,
              package: PdfViewerAssets.packageName,
            ),
          ),
          onPressed: () {
            controller.state.isEdit.value = true;
          },
        );
      }
      return IconButton(
        onPressed: () {
          controller.state.switchSelectAll();
        },
        icon: ImageIcon(
          AssetImage(
            controller.state.isSelectAll.value
                ? PdfViewerAssets.icSelectedAll
                : PdfViewerAssets.icSelect,
            package: PdfViewerAssets.packageName,
          ),
        ),
      );
    });
  }
}
