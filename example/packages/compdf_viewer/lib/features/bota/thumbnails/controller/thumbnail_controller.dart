// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/bota/thumbnails/repository/thumbnail_repository.dart';
import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_state.dart';

import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_data.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_type.dart';

/// GetX controller for PDF thumbnail management and page operations.
///
/// Manages thumbnail data, selection state, and executes PDF page operations
/// like insert, delete, rotate, and extract. Coordinates with repository for
/// data access and image caching.
///
/// Key features:
/// - Fetch and display all page thumbnails
/// - Multi-selection management
/// - Page operations: insert, delete, rotate, extract
/// - Image caching with auto-refresh on changes
/// - Current page tracking and navigation
///
/// Page operations:
/// - **Insert**: Blank pages or pages with images (musical notation, lines, squares)
/// - **Import**: Insert pages from another PDF file
/// - **Delete**: Remove selected pages
/// - **Rotate**: Rotate selected pages by 90 degrees
/// - **Extract**: Split selected pages into new PDF file
///
/// Usage example:
/// ```dart
/// // In ThumbnailPage or widgets
/// final controller = Get.find<ThumbnailController>();
///
/// // Fetch thumbnails
/// await controller.fetchAllPages();
///
/// // Get page image
/// final image = await controller.getPageImage(model, width, height);
///
/// // Delete selected pages
/// final success = await controller.removePages();
/// await controller.refreshData();
///
/// // Rotate selected pages
/// await controller.rotatePages();
/// await controller.refreshData();
/// ```
///
/// State management:
/// - Uses ThumbnailState for reactive state
/// - Observes edit mode and selection changes
/// - Auto-updates select all state
/// - Triggers UI updates via update() and GetBuilder
///
/// Image caching:
/// - Caches rendered page images by key
/// - Clears cache on page modifications
/// - Refreshes thumbnails after operations
class ThumbnailController extends GetxController {
  ThumbnailRepository repository;

  ThumbnailState state = ThumbnailState();

  ThumbnailController(this.repository);

  @override
  void onInit() {
    super.onInit();
    // Get current viewing page
    _init();
    // Fetch all page data
    fetchAllPages();
    // Delay showing content after page rendering completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        state.showContent.value = true;
      });
    });

    ever<bool>(state.isThumbnailEditing, (isEditing) {
      if (!isEditing) {
        // Clear selection when exiting edit mode
        state.clearSelection();
      }
    });
    everAll([state.selectedThumbnails, state.pages], (_) {
      bool needSelectAll = state.selectedThumbnails.isNotEmpty &&
          state.selectedThumbnails.length == state.pages.length;
      if (needSelectAll != state.isSelectAll.value) {
        state.isSelectAll.value = needSelectAll;
        update(['app_bar_actions']);
      }
    });
  }

  /// Fetch all page size data
  Future<void> fetchAllPages() async {
    state.isLoading.value = true;
    try {
      // Clear cache
      await repository.clearCaches();
      final pages = await repository.getAllPages();
      state.pages.assignAll(pages);
    } catch (e) {
      e.printInfo();
    } finally {
      state.isLoading.value = false;
    }
  }

  void _init() async {
    try {
      final currentPageIndex = await repository.getCurrentPageIndex();
      state.currentPageIndex.value = currentPageIndex;
    } catch (e) {
      e.printInfo();
    } finally {}
  }

  /// Get page image
  Future<Uint8List?> getPageImage(
    ThumbnailItemModel model,
    int renderImageWidth,
    int renderImageHeight,
  ) async {
    int pageIndex = model.pageIndex;
    if (pageIndex < 0 || pageIndex >= state.pages.length) {
      return null;
    }
    try {
      final image = await repository.getPageImage(
        model: model,
        renderImageWidth: renderImageWidth,
        renderImageHeight: renderImageHeight,
      );
      return image;
    } catch (e) {
      e.printInfo();
    }
    return null;
  }

  List<int> _getSortedSelectedPages() {
    var pages = state.getSelectPageIndexes();
    pages.sort((a, b) => b.compareTo(a)); // Descending order
    return pages;
  }

  /// Insert page
  Future<bool> insertPage({
    required InsertPageData pageData,
  }) async {
    CPDFReaderWidgetController? widgetController =
        repository.pdfController.readerController.value;
    if (widgetController == null) return false;
    List<int> pages = _getSortedSelectedPages();
    if (pages.isEmpty) return false;

    for (int pageIndex in pages) {
      bool result = false;
      switch (pageData.type) {
        case InsertPageType.blankPage:
          result = await widgetController.document.insertBlankPage(
            pageIndex: pageIndex + 1,
            pageSize: pageData.getPageSizeWithOrientation(),
          );
          break;
        case InsertPageType.musicalNotation:
        case InsertPageType.horizontalLine:
        case InsertPageType.square:
          String imagePath = await pageData.getImagePagePath();
          result = await widgetController.document.insertPageWithImagePath(
            pageIndex: pageIndex + 1,
            pageSize: pageData.getPageSizeWithOrientation(),
            imagePath: imagePath,
          );
          break;
        default:
          break;
      }
      PdfViewerGlobal.logger.i('Insert page result: $result');
    }
    return true;
  }

  /// Insert entire PDF file
  Future<bool> insertPDFFile({
    required String filePath,
    required List<int> pages,
    String? password,
  }) async {
    CPDFReaderWidgetController? widgetController =
        repository.pdfController.readerController.value;
    if (widgetController == null || pages.isEmpty) {
      return false;
    }
    int insertPosition =
        _getSortedSelectedPages().first + 1; // Insert after selected page
    bool insertResult = await widgetController.document.importDocument(
      filePath: filePath,
      insertPosition: insertPosition,
      pages: pages,
      password: password,
    );
    PdfViewerGlobal.logger.i('Insert page result: $insertResult');
    return insertResult;
  }

  /// Delete selected pages
  Future<bool> removePages() async {
    List<int> pages = _getSortedSelectedPages();
    CPDFReaderWidgetController widgetController =
        repository.pdfController.readerController.value!;
    return await widgetController.document.removePages(pages);
  }

  Future<bool> rotatePages() async {
    List<int> pagesToRotate = _getSortedSelectedPages();
    final controller = repository.pdfController.readerController.value;
    if (controller == null) return false;
    final document = controller.document;
    for (final pageIndex in pagesToRotate) {
      final page = controller.document.pageAtIndex(pageIndex);
      final angle = await page.getRotation();
      final success = await page.setRotation(angle + 90);
      debugPrint(
          'Rotate page: $pageIndex, current angle: $angle, rotated angle: ${angle + 90}, success: $success');
    }
    // Update size info for selected items and total pages list
    await _refreshSelectedThumbnailSizes(document);
    return true;
  }

  Future<void> refreshData() async {
    // Reload external CPDFReaderWidget page
    await repository.pdfController.readerController.value?.reloadPages2();
    // Clear all selected page indexes
    state.clearSelection();
    // Re-fetch thumbnail list
    await fetchAllPages();
    // Refresh page count
    await repository.pdfController.refreshPageCount();
  }

  Future<void> _refreshSelectedThumbnailSizes(CPDFDocument document) async {
    for (final thumbnail in state.selectedThumbnails) {
      // Clear image cache
      final oldKey = repository.getImageCacheKeyFromModel(thumbnail);
      repository.imageCache.clearCacheByKey(oldKey);
      final newSize = await document.getPageSize(thumbnail.pageIndex);
      thumbnail.size = newSize;
      // Only update corresponding index in pages, no need to reassign entire list
      if (thumbnail.pageIndex >= 0 &&
          thumbnail.pageIndex < state.pages.length) {
        state.pages[thumbnail.pageIndex].size = newSize;
      }
    }
    update(['thumbnail_list_builder']);
  }

  Future<String?> extractPages() async {
    CPDFReaderWidgetController? widgetController =
        repository.pdfController.readerController.value;
    var pages = state.getSelectPageIndexes();

    if (widgetController == null || pages.isEmpty) {
      return null;
    }
    final document = widgetController.document;
    final tempDir = await ComPDFKit.getTemporaryDirectory();

    String fileNameNoExtension = await document
        .getFileName()
        .then((fileName) => fileName.substring(0, fileName.lastIndexOf('.')));

    String fileName = '${fileNameNoExtension}_(${pages.join(',')}).pdf';
    String savePath = '${tempDir.path}/$fileName';
    bool splitResult = await document.splitDocumentPages(savePath, pages);
    return splitResult ? savePath : null;
  }
}
