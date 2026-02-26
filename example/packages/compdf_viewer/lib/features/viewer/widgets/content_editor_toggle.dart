// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// A toggle button for switching between viewer and content editor modes.
///
/// This widget displays an icon button that toggles the PDF view mode
/// between normal viewing and content editing. The button shows a
/// highlighted background when content editor mode is active.
///
/// **View Modes:**
/// - **Viewer Mode:** Normal PDF viewing and annotation
/// - **Content Editor Mode:** Edit PDF content (text, images, etc.)
///
/// **Visual Feedback:**
/// - Normal state: No background
/// - Active state: Primary color background with opacity
/// - 38x38px size
/// - 4px border radius
///
/// **Usage:**
/// ```dart
/// ContentEditorToggle() // Auto-connects to PdfViewerController
/// ```
class ContentEditorToggle extends StatelessWidget {
  const ContentEditorToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PdfViewerController>();
    return Obx(() {
      final isContentEditor =
          controller.state.viewMode.value == CPDFViewMode.contentEditor;
      return Container(
        width: 38,
        height: 38,
        decoration: isContentEditor
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(78),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: controller.toggleViewMode,
          icon: Image.asset(
            PdfViewerAssets.icEditPdf,
            package: PdfViewerAssets.packageName,
            width: 24,
            height: 24,
          ),
        ),
      );
    });
  }
}
