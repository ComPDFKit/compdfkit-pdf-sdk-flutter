// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/annotations/model/annotation_item_model.dart';
import 'package:compdf_viewer/features/bota/annotations/model/annotation_state.dart';
import 'package:compdf_viewer/features/bota/annotations/repository/annotation_repository.dart';

/// GetX controller for managing the PDF annotation list in the BOTA panel.
///
/// This controller handles loading, grouping, and batch operations on annotations,
/// including selection mode and delete functionality.
///
/// **Managed State:**
/// - Annotation list items (grouped by page with headers)
/// - Edit mode toggle (enables multi-selection)
/// - Select all/none toggle
/// - Selected annotations set
///
/// **Key Operations:**
/// - [loadAnnotationListItems] - Fetch and group annotations by page
/// - [deleteSelectedAnnotations] - Batch delete selected annotations
///
/// **Reactive Behaviors:**
/// - Exiting edit mode clears selection
/// - Toggling "select all" selects/deselects all annotations
///
/// **Usage:**
/// ```dart
/// final controller = Get.put(AnnotationController(repository));
/// await controller.loadAnnotationListItems();
/// controller.state.isEdit.value = true; // Enable selection mode
/// ```
class AnnotationController extends GetxController {
  final AnnotationRepository repository;

  final AnnotationState state = AnnotationState();

  AnnotationController(this.repository);

  /// Load annotation list items
  Future<void> loadAnnotationListItems() async {
    state.isLoading.value = true;
    final annotations = await repository.fetchAnnotations();
    state.setAllAnnotations(annotations);
    final grouped = <int, List<CPDFAnnotation>>{};
    for (var annotation in annotations) {
      grouped.putIfAbsent(annotation.page, () => []).add(annotation);
    }

    final items = <AnnotationItemModel>[];
    final sortedPages = grouped.keys.toList()..sort();
    for (final page in sortedPages) {
      final anns = grouped[page]!;
      items.add(AnnotationItemModel.header(page, anns.length));
      for (final ann in anns) {
        items.add(AnnotationItemModel.annotation(ann));
      }
    }
    state.annotationListItems.value = items;
    state.isLoading.value = false;
  }

  /// Delete currently selected annotations
  Future<void> deleteSelectedAnnotations() async {
    try {
      final selected = state.selectedAnnotations.toList();
      if (selected.isEmpty) return;

      // Remove from remote/document
      await repository.removeAnnotations(selected);

      // Remove from local list for smooth UI update
      _removeAnnotationsFromLocalList(selected);

      // Clear selection but keep edit mode
      state.clearSelection();
    } catch (e) {
      e.printInfo();
    }
  }

  /// Remove annotations from local list without re-fetching
  /// Updates headers count and removes empty page headers
  void _removeAnnotationsFromLocalList(List<CPDFAnnotation> toRemove) {
    // Remove from allAnnotations
    state.allAnnotations.removeWhere((a) => toRemove.contains(a));

    // Build page -> remaining count map
    final pageCountMap = <int, int>{};
    for (final item in state.annotationListItems) {
      if (item.isHeader) {
        pageCountMap[item.pageIndex!] = item.count ?? 0;
      }
    }

    // Decrease count for removed annotations
    for (final ann in toRemove) {
      if (pageCountMap.containsKey(ann.page)) {
        pageCountMap[ann.page] = pageCountMap[ann.page]! - 1;
      }
    }

    // Filter and update items
    final newItems = <AnnotationItemModel>[];
    for (final item in state.annotationListItems) {
      if (item.isHeader) {
        final newCount = pageCountMap[item.pageIndex!] ?? 0;
        // Skip header if no annotations left on this page
        if (newCount > 0) {
          newItems.add(AnnotationItemModel.header(item.pageIndex!, newCount));
        }
      } else if (item.annotation != null &&
          !toRemove.contains(item.annotation)) {
        newItems.add(item);
      }
    }

    state.annotationListItems.value = newItems;
  }

  @override
  void onInit() {
    super.onInit();

    /// Clear selection when isEdit changes from true -> false
    ever<bool>(state.isEdit, (editMode) {
      if (!editMode) {
        state.clearSelection();
      }
    });

    /// Execute select all or deselect all when toggle select all
    ever<bool>(state.isSelectAll, (selectAll) {
      if (selectAll) {
        state.selectedAnnotations.addAll(state.allAnnotations);
      } else {
        state.clearSelection();
      }
    });
  }
}
