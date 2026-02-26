// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_item.dart';

import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';

/// Grid view list of PDF page thumbnails.
///
/// Displays thumbnails in a responsive grid (3 columns portrait, 6 landscape)
/// with automatic scroll to current page on first load. Handles loading states
/// and delayed content display for smooth animations.
///
/// Key features:
/// - Responsive grid layout (3/6 columns)
/// - Auto-scroll to current page
/// - Loading indicator during data fetch
/// - Delayed content reveal (300ms)
/// - Tap handling: edit mode selection or navigation
///
/// Usage example:
/// ```dart
/// // In ThumbnailPage body
/// Column(
///   children: [
///     Expanded(child: ThumbnailList()),
///     ThumbnailActionBar(),
///   ],
/// )
/// ```
///
/// State management:
/// - Uses GetBuilder for list updates
/// - Observes showContent and isLoading flags
/// - Auto-scrolls once on hasJumpedToPage flag
class ThumbnailList extends StatefulWidget {
  const ThumbnailList({super.key});

  @override
  State<ThumbnailList> createState() => _ThumbnailListState();
}

class _ThumbnailListState extends State<ThumbnailList> {
  final ThumbnailController controller = Get.find<ThumbnailController>();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey globalKey = GlobalKey();

  final childAspectRatio = 0.62;

  void scrollToTarget(int crossAxisCount) {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (!mounted) return;
      controller.state.hasJumpedToPage.value = true;
      final deviceScreenSize = MediaQuery.of(context).size;
      final itemWidth = (deviceScreenSize.width - 32) / crossAxisCount;
      final itemHeight = (itemWidth / childAspectRatio);
      final index = controller.state.currentPageIndex.value;
      const spacing = 8;
      final offset = (index ~/ crossAxisCount) * (itemHeight + spacing);
      if (offset > (deviceScreenSize.height - kToolbarHeight)) {
        _scrollController.jumpTo(offset.toDouble());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThumbnailController>(
        id: 'thumbnail_list_builder',
        builder: (context) {
          return Obx(() {
            final showContent = controller.state.showContent.value;
            final isLoading = controller.state.isLoading.value;

            if (!showContent) {
              return const SizedBox.shrink();
            }
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildGridView();
          });
        });
  }

  Widget _buildGridView() {
    return OrientationBuilder(
      builder: (context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 3 : 6;

        if (!controller.state.hasJumpedToPage.value) {
          scrollToTarget(crossAxisCount);
        }
        final pages =
            controller.state.pages; // Avoid accessing pages inside Obx
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shrinkWrap: true,
          itemCount: pages.length,
          key: globalKey,
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final model = controller.state.pages[index];
            return ThumbnailItem(
                key: ValueKey(model.pageIndex),
                isCurrentPageIndex:
                    controller.state.currentPageIndex.value == model.pageIndex,
                model: model);
          },
        );
      },
    );
  }
}
