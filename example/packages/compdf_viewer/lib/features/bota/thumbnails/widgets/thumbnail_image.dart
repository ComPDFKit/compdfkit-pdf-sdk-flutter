// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';
import 'package:compdf_viewer/shared/widgets/fade_in_memory_image.dart';

import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';

/// Thumbnail image widget with caching and progressive loading.
///
/// Renders PDF page thumbnail with cache-first strategy. Shows cached image
/// immediately if available, otherwise fetches and displays with fade-in
/// animation. Handles loading states gracefully.
///
/// Key features:
/// - Cache-first rendering (instant display)
/// - Async fetch with FutureBuilder fallback
/// - Fade-in animation for newly loaded images
/// - Rounded corners (4px radius)
///
/// Usage example:
/// ```dart
/// // In ThumbnailItem
/// ThumbnailImage(
///   model: thumbnailModel,
///   renderSize: Size(
///     itemWidth * devicePixelRatio,
///     imageHeight * devicePixelRatio,
///   ),
/// )
/// ```
///
/// Loading sequence:
/// 1. Check cache via repository.getCachedImage()
/// 2. If cached: immediate Image.memory display
/// 3. If not: FutureBuilder → fetch → FadeInMemoryImage
/// 4. While loading: empty SizedBox (container handles sizing)
class ThumbnailImage extends GetView<ThumbnailController> {
  final Size renderSize;
  final ThumbnailItemModel model;

  const ThumbnailImage({
    super.key,
    required this.model,
    required this.renderSize,
  });

  @override
  Widget build(BuildContext context) {
    final imageBytes = controller.repository.getCachedImage(
      model,
      renderSize.width.toInt(),
      renderSize.height.toInt(),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: imageBytes != null
          ? Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
          : FutureBuilder<Uint8List?>(
              future: controller.getPageImage(
                model,
                renderSize.width.toInt(),
                renderSize.height.toInt(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return FadeInMemoryImage(imageBytes: snapshot.data!);
                }
                return const SizedBox();
              },
            ),
    );
  }
}
