// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/page_editor_controller.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_option.dart';

/// Widget that displays a horizontal list of page template options for selection.
///
/// This widget renders all available page template types (blank, horizontal lines,
/// musical notation, square grid) as selectable tiles with preview images and titles.
/// The selected template is highlighted with a border using the app's primary color.
///
/// Features:
/// - Horizontal grid of template options
/// - Visual selection feedback with colored borders
/// - Preview images for each template type
/// - Reactive selection state via GetX
/// - Tap to select interaction
///
/// Example usage:
/// ```dart
/// // Used in InsertPagesDialog to show template options
/// Column(
///   children: [
///     InsertPagePicTypeList(), // Shows: Blank, Lines, Music, Grid
///     SizedBox(height: 8),
///     InsertPageSizeSelector(),
///   ],
/// )
/// ```
class InsertPagePicTypeList extends GetView<PageEditorController> {
  const InsertPagePicTypeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: controller.state.pageOptions
          .map((option) => _buildTile(context, option))
          .toList(),
    );
  }

  Widget _buildTile(BuildContext context, InsertPageOption option) {
    return Expanded(
      child: Obx(() {
        final isSelected = option.type == controller.state.insertPageType.value;
        return GestureDetector(
          onTap: () => controller.state.setInsertPageType(option.type),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                child: option.widget,
              ),
              const SizedBox(height: 4),
              Text(
                option.title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
