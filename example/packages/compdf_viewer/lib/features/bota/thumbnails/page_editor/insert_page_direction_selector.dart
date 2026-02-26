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

/// Widget for selecting page orientation (portrait or landscape) in the page editor.
///
/// This widget provides a radio button group for choosing between portrait and
/// landscape orientations when inserting a new page. The selection is managed by
/// [PageEditorController] and updates reactively using GetX state management.
///
/// Features:
/// - Portrait and landscape radio options
/// - Reactive UI updates via Obx
/// - Localized labels
/// - Integrated with PageEditorController
///
/// Example usage:
/// ```dart
/// // Used in InsertPagesDialog
/// Column(
///   children: [
///     InsertPageSizeSelector(),
///     SizedBox(height: 8),
///     InsertPageDirectionSelector(), // Portrait/Landscape selection
///   ],
/// )
/// ```
class InsertPageDirectionSelector extends GetView<PageEditorController> {
  const InsertPageDirectionSelector({super.key});

  void _onSelect(Orientation value) {
    controller.state.selectOrientation.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(PdfLocaleKeys.direction.tr),
        Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Orientation>(
                contentPadding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                dense: true,
                title: Text(PdfLocaleKeys.portrait.tr),
                value: Orientation.portrait,
                groupValue: controller.state.selectOrientation.value,
                onChanged: (value) {
                  if (value != null) _onSelect(value);
                },
              ),
              RadioListTile<Orientation>(
                contentPadding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                dense: true,
                title: Text(PdfLocaleKeys.landscape.tr),
                value: Orientation.landscape,
                groupValue: controller.state.selectOrientation.value,
                onChanged: (value) {
                  if (value != null) _onSelect(value);
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
