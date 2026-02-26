// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/model/thumbnail_item_model.dart';

/// Reactive state class for PDF thumbnail view feature.
///
/// Manages all UI state for the thumbnail page including loading, edit mode,
/// selection state, and page list. All properties are reactive for automatic
/// UI updates via Obx.
///
/// Key state properties:
/// - `isLoading`: Data loading indicator
/// - `currentPageIndex`: Currently viewing page in main PDF viewer
/// - `showContent`: Delayed visibility flag (300ms animation)
/// - `hasJumpedToPage`: Tracks if initial scroll to current page completed
/// - `isThumbnailEditing`: Edit mode toggle
/// - `pages`: List of all thumbnail models
/// - `selectedThumbnails`: Set of selected thumbnail models
/// - `isSelectAll`: Whether all thumbnails selected
///
/// Selection management:
/// - `isSelected(thumbnail)`: Check if thumbnail selected
/// - `toggleSelection(thumbnail)`: Toggle single selection
/// - `selectAll()`: Select all thumbnails
/// - `clearSelection()`: Clear all selections
/// - `getSelectPageIndexes()`: Get list of selected page indices
///
/// Computed properties:
/// - `showActionBar`: Returns true if in edit mode with selections
///
/// Usage example:
/// ```dart
/// // In controller
/// final state = ThumbnailState();
///
/// // Toggle edit mode
/// state.isThumbnailEditing.value = true;
///
/// // Select thumbnail
/// state.toggleSelection(model);
///
/// // Check if selected
/// bool selected = state.isSelected(model);
///
/// // Get selected pages
/// List<int> pages = state.getSelectPageIndexes();
///
/// // Observe in UI
/// Obx(() => Text('Selected: ${state.selectedThumbnails.length}'));
/// ```

class ThumbnailState {
  final RxBool isLoading = false.obs;

  final RxInt currentPageIndex = 0.obs;

  /// Whether to show thumbnail list component, delay 300ms when opening to show content after animation completes
  final RxBool showContent = false.obs;

  /// Whether already jumped to specified page
  final RxBool hasJumpedToPage = false.obs;

  /// Whether thumbnail list is in edit mode
  final RxBool isThumbnailEditing = false.obs;

  /// The list of thumbnail page models.
  RxList<ThumbnailItemModel> pages = <ThumbnailItemModel>[].obs;

  /// Use ThumbnailItemModel objects to record selection state
  var selectedThumbnails = <ThumbnailItemModel>{}.obs;

  /// Whether select all
  final RxBool isSelectAll = false.obs;

  bool isSelected(ThumbnailItemModel thumbnail) =>
      selectedThumbnails.contains(thumbnail);

  bool get showActionBar =>
      isThumbnailEditing.value && selectedThumbnails.isNotEmpty;

  /// Toggle thumbnail selection state
  void toggleSelection(ThumbnailItemModel thumbnail) {
    final selected = selectedThumbnails.contains(thumbnail);
    if (!selected) {
      selectedThumbnails.add(thumbnail);
    } else {
      selectedThumbnails.remove(thumbnail);
    }
  }

  List<int> getSelectPageIndexes() {
    return selectedThumbnails.map((e) => e.pageIndex).toList();
  }

  void clearSelection() {
    selectedThumbnails.clear();
  }

  void selectAll() {
    selectedThumbnails.assignAll(pages);
  }

  /// Creates a new instance of [ThumbnailState].
  ThumbnailState();
}
