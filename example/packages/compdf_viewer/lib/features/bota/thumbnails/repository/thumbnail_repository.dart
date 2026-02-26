// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';
import 'package:compdf_viewer/features/bota/thumbnails/repository/image_cache_repository.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:get/get.dart';

/// Repository for PDF thumbnail data access and image caching.
///
/// Provides data layer for thumbnail feature including page info fetching,
/// image rendering with caching, and cache key generation. Coordinates with
/// PdfViewerController and ImageCacheRepository.
///
/// Key features:
/// - Fetch current page index and all page data
/// - Render page thumbnails with caching
/// - Generate unique cache keys for images
/// - Clear caches on data refresh
///
/// Cache key strategy:
/// - Full key: `{documentHash}_{pageIndex}_{sizeHash}_{renderWidth}_{renderHeight}`
/// - Model key: `{documentHash}_{pageIndex}_{sizeHash}` (for fuzzy matching)
///
/// Usage example:
/// ```dart
/// final repository = ThumbnailRepository();
///
/// // Get all pages
/// final pages = await repository.getAllPages();
///
/// // Get page image with caching
/// final image = await repository.getPageImage(
///   model: thumbnailModel,
///   renderImageWidth: 200,
///   renderImageHeight: 280,
/// );
///
/// // Check cached image
/// final cached = repository.getCachedImage(model, 200, 280);
///
/// // Clear all caches
/// await repository.clearCaches();
/// ```
///
/// Image caching:
/// - First call renders and caches image
/// - Subsequent calls return cached image
/// - Cache cleared on page modifications
/// - Fuzzy key matching for clearing related caches
class ThumbnailRepository {
  PdfViewerController pdfController = Get.find<PdfViewerController>();

  ImageCacheRepository imageCache = ImageCacheRepository();

  Future<int> getCurrentPageIndex() async {
    final controller = pdfController.readerController.value;
    if (controller == null) {
      return Future.error('PDF reader controller is not initialized');
    }
    return controller.getCurrentPageIndex();
  }

  Future<List<ThumbnailItemModel>> getAllPages() async {
    final controller = pdfController.readerController.value;
    if (controller == null) {
      return Future.error('PDF reader controller is not initialized');
    }

    final int pageCount = await controller.document.getPageCount();

    final List<Future<ThumbnailItemModel?>> tasks = List.generate(pageCount, (
      i,
    ) async {
      final size = await controller.document.getPageSize(i);
      if (size == Size.zero) return null;
      return ThumbnailItemModel(pageIndex: i, size: size);
    });
    final results = await Future.wait(tasks);
    return results.whereType<ThumbnailItemModel>().toList();
  }

  String getImageCacheKey({
    required ThumbnailItemModel model,
    required int renderImageWidth,
    required int renderImageHeight,
  }) {
    final controllerKey =
        pdfController.readerController.value?.document.hashCode;
    final key =
        '${controllerKey}_${model.pageIndex}_${model.size.hashCode}_${renderImageWidth}_$renderImageHeight';
    debugPrint('Cache Key: $key');
    return key;
  }

  String getImageCacheKeyFromModel(ThumbnailItemModel model) {
    final controllerKey =
        pdfController.readerController.value?.document.hashCode;
    return '${controllerKey}_${model.pageIndex}_${model.size.hashCode}';
  }

  Future<Uint8List> getPageImage({
    required ThumbnailItemModel model,
    required int renderImageWidth,
    required int renderImageHeight,
  }) async {
    // Use a unique key for caching
    final key = getImageCacheKey(
      model: model,
      renderImageWidth: renderImageWidth,
      renderImageHeight: renderImageHeight,
    );
    if (imageCache.hasCache(key)) {
      return imageCache.getImage(key)!;
    }

    final controller = pdfController.readerController.value;
    if (controller == null) {
      return Future.error('PDF reader controller is not initialized');
    }
    final image = await controller.document.renderPage(
      pageIndex: model.pageIndex,
      width: renderImageWidth,
      height: renderImageHeight,
    );
    imageCache.cacheImage(key, image);
    return image;
  }

  Uint8List? getCachedImage(
    ThumbnailItemModel model,
    int renderImageWidth,
    int renderImageHeight,
  ) {
    return imageCache.getImage(
      getImageCacheKey(
        model: model,
        renderImageWidth: renderImageWidth,
        renderImageHeight: renderImageHeight,
      ),
    );
  }

  Future<void> clearCaches() async {
    debugPrint('Test---, clearing thumbnail cache');
    imageCache.clearCache();
  }
}
