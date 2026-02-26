// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/annotation/controller/pdf_annotation_tool_bar_controller.dart';
import 'package:compdf_viewer/features/annotation/model/pdf_annotation_tool_data.dart';
import 'package:compdf_viewer/features/annotation/widgets/pdf_annotation_tool_item.dart';

/// A horizontal list widget that displays all available annotation tool types.
///
/// This widget provides a scrollable horizontal list of annotation tools,
/// each represented by [PdfAnnotationToolItem]. Users can tap on any tool
/// to select it as the active annotation mode.
///
/// **Features:**
/// - Horizontal scrolling for multiple annotation types
/// - Visual indication of the currently selected tool (highlighted background)
/// - Reactive UI updates when tool selection changes
/// - 44x44 touch target for each tool item
///
/// **Usage:**
/// ```dart
/// PdfAnnotationToolTypeList()
/// ```
///
/// The widget automatically observes the [PdfAnnotationToolBarController]
/// state and updates when the selected tool or available tools change.
class PdfAnnotationToolTypeList
    extends GetView<PdfAnnotationToolBarController> {
  const PdfAnnotationToolTypeList({super.key});

  void handleTap(BuildContext context, PdfAnnotationToolData data) {
    controller.setSelectionTool(data.type);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tools = controller.state.annotationTools;
      final selectedType = controller.state.selectionTool.value;
      if (tools.isEmpty) {
        return SizedBox.shrink();
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final item = tools[index];
          final isSelected = selectedType == item.type;
          return GestureDetector(
            onTap: () {
              handleTap(context, item);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              alignment: Alignment.center,
              width: 44,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withAlpha(128)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PdfAnnotationToolItem(
                width: 24,
                height: 24,
                type: item.type,
                color: item.color,
                alpha: item.alpha.toInt(),
              ),
            ),
          );
        },
      );
    });
  }
}
