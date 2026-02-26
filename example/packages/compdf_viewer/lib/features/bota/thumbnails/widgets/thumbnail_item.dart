// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_image.dart';
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_index_indicator.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_item_selector.dart';

import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';

/// Single PDF page thumbnail item widget.
///
/// Displays a thumbnail image with page number indicator and optional selection
/// checkbox (in edit mode). Highlights current page with primary color border.
/// Handles tap gestures for selection or navigation.
///
/// Layout structure:
/// - Container with thumbnail image (maintains aspect ratio)
/// - Bottom page number indicator (22px height)
/// - Top-right selection checkbox (edit mode only)
/// - Border: primary color for current page, gray for others
///
/// Key features:
/// - Responsive sizing based on available space
/// - Aspect ratio preservation of page
/// - Current page highlighting
/// - Edit mode: checkbox overlay + selection tap
/// - Normal mode: tap to navigate to page
///
/// Usage example:
/// ```dart
/// // In GridView builder
/// GridView.builder(
///   itemBuilder: (context, index) {
///     final model = pages[index];
///     final isCurrent = index == currentPageIndex;
///     return ThumbnailItem(
///       model: model,
///       isCurrentPageIndex: isCurrent,
///     );
///   },
/// )
/// ```
///
/// Tap behavior:
/// - Edit mode: toggleSelection(model)
/// - Normal mode: Get.back(result: pageIndex) → navigates to page
class ThumbnailItem extends GetView<ThumbnailController> {
  static const spacing = 4.0;

  static final pageIndicatorHeight = 22.0;

  final ThumbnailItemModel model;

  final bool isCurrentPageIndex;

  const ThumbnailItem(
      {super.key, required this.isCurrentPageIndex, required this.model});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final availableImageHeight = maxHeight - pageIndicatorHeight - spacing;

        // Calculate ideal image height based on original aspect ratio
        final aspectRatio = model.size.width / model.size.height;
        double idealImageHeight = itemWidth / aspectRatio;

        // Limit image height to not exceed availableImageHeight
        final imageHeight = idealImageHeight > availableImageHeight
            ? availableImageHeight
            : idealImageHeight;

        final devicePixelRatio = View.of(context).devicePixelRatio;

        final renderImageWidth = itemWidth * devicePixelRatio;
        final renderImageHeight = imageHeight * devicePixelRatio;
        return GestureDetector(
          onTap: () {
            if (controller.state.isThumbnailEditing.value) {
              controller.state.toggleSelection(model);
              return;
            }
            Get.back(result: model.pageIndex);
          },
          child: Stack(
            children: [
              Positioned(
                // Thumbnail
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: itemWidth,
                  height: availableImageHeight,
                  child: Container(
                    width: itemWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isCurrentPageIndex
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black12,
                        width: 1.5,
                      ),
                    ),
                    child: ThumbnailImage(
                      model: model,
                      renderSize: Size(renderImageWidth, renderImageHeight),
                    ),
                  ),
                ),
              ),
              Positioned(
                // Page number info
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const SizedBox(height: spacing),
                    ThumbnailIndexIndicator(
                      isSelected: isCurrentPageIndex,
                      pageIndex: model.pageIndex,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: ((availableImageHeight - imageHeight) / 2) - 10,
                  left: -10,
                  child: ThumbnailItemSelector(item: model))
            ],
          ),
        );
      },
    );
  }
}
