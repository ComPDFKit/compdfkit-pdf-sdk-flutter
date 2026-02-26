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

/// Widget for selecting page size (A4, A3, Letter, Legal, Ledger, etc.) in the page editor.
///
/// This widget provides a dropdown menu to choose the page size for the new page being
/// inserted. The available sizes are managed by [PageEditorController] and include
/// standard paper sizes like A4, A3, Letter, Legal, and Ledger.
///
/// Features:
/// - Dropdown menu with standard page sizes
/// - Right-aligned display for compact presentation
/// - Reactive state management via GetX
/// - Localized "Page Size" label
/// - Minimal border styling for clean UI
///
/// Example usage:
/// ```dart
/// // Used in InsertPagesDialog
/// Column(
///   children: [
///     InsertPagePicTypeList(),
///     SizedBox(height: 8),
///     InsertPageSizeSelector(), // A4, Letter, Legal, etc.
///     InsertPageDirectionSelector(),
///   ],
/// )
/// ```
class InsertPageSizeSelector extends GetView<PageEditorController> {
  const InsertPageSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          PdfLocaleKeys.pageSize.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        DropdownMenu(
          textAlign: TextAlign.right,
          width: 200,
          inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero),
          onSelected: (value) {
            if (value != null) {
              controller.state.selectedPageSize.value = value;
            }
          },
          textStyle: Theme.of(context).textTheme.bodyMedium,
          initialSelection: controller.state.selectedPageSize.value,
          dropdownMenuEntries: controller.state.pageSizes.map((item) {
            return DropdownMenuEntry(
                value: item,
                label: item.name,
                style: ButtonStyle(
                    textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
                  (states) => const TextStyle(fontSize: 14),
                )));
          }).toList(),
        ),
      ],
    );
  }
}
