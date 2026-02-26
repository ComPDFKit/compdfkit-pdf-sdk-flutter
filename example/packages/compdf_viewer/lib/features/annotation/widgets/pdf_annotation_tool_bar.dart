// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/annotation/controller/pdf_annotation_tool_bar_controller.dart';
import 'package:compdf_viewer/features/annotation/widgets/pdf_annotation_history_manager_bar.dart';
import 'package:compdf_viewer/features/annotation/widgets/pdf_annotation_tool_type_list.dart';

/// Bottom toolbar for PDF annotation tools.
///
/// Displays:
/// - [PdfAnnotationToolTypeList] - Scrollable list of annotation tools (left side)
/// - [PdfAnnotationHistoryManagerBar] - Undo/redo/properties buttons (right side)
///
/// Fixed height of 52px with safe area padding at the bottom.
/// Uses [PdfAnnotationToolBarController] for state management.
///
/// Example:
/// ```dart
/// // Used at the bottom of PDF viewer in annotation mode
/// Scaffold(
///   body: PdfViewerContent(...),
///   bottomNavigationBar: PdfAnnotationToolBar(),
/// );
/// ```
class PdfAnnotationToolBar extends GetView<PdfAnnotationToolBarController> {
  const PdfAnnotationToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          width: double.infinity,
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: PdfAnnotationToolTypeList()),
              PdfAnnotationHistoryManagerBar()
            ],
          ),
        ));
  }
}
