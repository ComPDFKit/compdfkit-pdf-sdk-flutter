// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/features/annotation/controller/pdf_annotation_tool_bar_controller.dart';

/// Annotation history control bar with undo/redo/properties buttons.
///
/// Displays three action buttons:
/// - **Properties**: Opens properties panel for the selected annotation tool
///   (disabled for tools that don't support properties like signature, stamp)
/// - **Undo**: Reverts the last annotation operation
/// - **Redo**: Re-applies a previously undone operation
///
/// Button states are reactive and update automatically based on:
/// - Whether the current tool supports properties
/// - Whether undo/redo operations are available in history
///
/// Example:
/// ```dart
/// // Used on the right side of annotation toolbar
/// Row(
///   children: [
///     Expanded(child: PdfAnnotationToolTypeList()),
///     PdfAnnotationHistoryManagerBar(), // This widget
///   ],
/// );
/// ```
class PdfAnnotationHistoryManagerBar
    extends GetView<PdfAnnotationToolBarController> {
  const PdfAnnotationHistoryManagerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canUndo = controller.state.canUndo.value;
      final canRedo = controller.state.canRedo.value;
      final canShowProperties = controller.state.canShowProperties.value;
      return Row(
        children: [
          Container(color: Colors.black12, height: 24, width: 1),
          IconButton(
            icon: ImageIcon(
              AssetImage(
                PdfViewerAssets.icProperties,
                package: PdfViewerAssets.packageName,
              ),
              color: canShowProperties
                  ? Theme.of(context).colorScheme.inverseSurface
                  : Colors.black12,
            ),
            onPressed:
                canShowProperties ? controller.showAnnotationProperties : null,
          ),
          IconButton(
            icon: Icon(
              Icons.undo,
              color: canUndo
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black12,
            ),
            onPressed: canUndo ? controller.annotationUndo : null,
          ),
          IconButton(
            icon: Icon(
              Icons.redo,
              color: canRedo
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black12,
            ),
            onPressed: canRedo ? controller.annotationRedo : null,
          ),
        ],
      );
    });
  }
}
