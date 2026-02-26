// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';
import 'package:flutter/material.dart';

import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';

/// Selection checkbox overlay for thumbnail items in edit mode.
///
/// Displays a checkbox in the top-right corner of thumbnails when edit mode
/// is active. Hidden in normal mode. Checkbox state reflects item selection
/// and toggles on change.
///
/// Key features:
/// - Visible only in edit mode
/// - Reactive checkbox state
/// - Toggles selection on change
/// - Positioned in ThumbnailItem's stack
///
/// Usage example:
/// ```dart
/// // In ThumbnailItem stack
/// Positioned(
///   top: 4,
///   right: 4,
///   child: ThumbnailItemSelector(item: model),
/// )
/// ```
///
/// State management:
/// - Observes isThumbnailEditing for visibility
/// - Observes isSelected(item) for checkbox state
/// - Calls toggleSelection(item) on change
class ThumbnailItemSelector extends GetView<ThumbnailController> {
  final ThumbnailItemModel item;

  const ThumbnailItemSelector({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isThumbnailEditing.value) {
        final selected = controller.state.isSelected(item);
        return Checkbox(
          value: selected,
          onChanged: (select) {
            controller.state.toggleSelection(item);
          },
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
