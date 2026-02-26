// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// A page indicator widget showing current page and total page count.
///
/// This widget displays a floating "current/total" page indicator
/// (e.g., "5/20") that updates reactively as the user navigates the PDF.
///
/// **Features:**
/// - Auto-hides for single-page documents
/// - Animated size transition (200ms)
/// - Customizable decoration and text style
/// - Optional tap handler
///
/// **Default Style:**
/// - Black38 background with 6px border radius
/// - 8px horizontal, 4px vertical padding
/// - White text, medium weight
///
/// **Usage:**
/// ```dart
/// PdfIndicator(
///   onTap: () => showPageJumpDialog(),
///   decoration: BoxDecoration(...), // Optional custom style
///   textStyle: TextStyle(...),      // Optional custom text
/// )
/// ```
class PdfIndicator extends StatelessWidget {
  final Function? onTap;

  final Decoration? decoration;

  final TextStyle? textStyle;

  const PdfIndicator({super.key, this.onTap, this.decoration, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PdfViewerController>();
    return Obx(() {
      if (controller.state.pageCount.value <= 1) {
        return Container();
      }
      return InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          decoration: decoration ??
              BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(6)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Text(
              '${controller.state.currentPage.value + 1}/${controller.state.pageCount.value}',
              style: textStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
        ),
      );
    });
  }
}
