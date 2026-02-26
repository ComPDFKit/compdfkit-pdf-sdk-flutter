// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/page_editor_controller.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_direction_selector.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_pic_type_list.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_size_selector.dart';

/// Main dialog for configuring and inserting a new page into a PDF document.
///
/// This dialog provides a comprehensive UI for selecting all page insertion parameters:
/// - **Template Type**: Blank, horizontal lines, musical notation, or square grid
/// - **Page Size**: A4, A3, Letter, Legal, or Ledger
/// - **Orientation**: Portrait or landscape
///
/// The dialog uses [PageEditorController] for state management and composes three
/// child widgets for each configuration section: [InsertPagePicTypeList],
/// [InsertPageSizeSelector], and [InsertPageDirectionSelector].
///
/// Callback parameters:
/// - [onConfirm]: Called when user taps the Insert button
/// - [onCancel]: Called when user taps the Cancel button
///
/// Returns:
/// - [InsertPageData] containing the selected configuration when Insert is tapped
/// - `null` if dialog is dismissed or Cancel is tapped
///
/// Example usage:
/// ```dart
/// // Show dialog and get user's page configuration
/// final pageData = await Get.dialog<InsertPageData>(
///   InsertPagesDialog(
///     onConfirm: () => print('Inserting page...'),
///     onCancel: () => print('Cancelled'),
///   ),
/// );
///
/// if (pageData != null) {
///   // Create page with the selected template and size
///   final size = pageData.getPageSizeWithOrientation();
///   final imagePath = await pageData.getImagePagePath();
///   await document.insertPage(index, size, imagePath);
/// }
/// ```
class InsertPagesDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const InsertPagesDialog({
    super.key,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PageEditorController(),
      dispose: (_) => Get.delete<PageEditorController>(),
      builder: (controller) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 8, right: 16),
          title: Text(
            PdfLocaleKeys.insertPages.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              InsertPagePicTypeList(),
              SizedBox(height: 8),
              InsertPageSizeSelector(),
              SizedBox(height: 8),
              InsertPageDirectionSelector(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onCancel?.call();
                Get.back();
              },
              child: Text(PdfLocaleKeys.cancel.tr),
            ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                Get.back(result: controller.state.getInsertPageData());
              },
              child: Text(PdfLocaleKeys.insert.tr),
            ),
          ],
        );
      },
    );
  }
}
