// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/bota/annotations/model/annotation_item_model.dart';

/// State model for managing the annotation list UI and multi-selection mode.
///
/// This class holds the reactive state for the annotation list feature in the
/// BOTA panel, including edit mode, selection state, and grouped annotation data.
///
/// **Managed State:**
/// - [isEdit] - Edit mode toggle (enables multi-selection checkboxes)
/// - [isSelectAll] - Select all/none toggle
/// - [isLoading] - Loading indicator for async operations
/// - [allAnnotations] - Complete list of annotations (used for select all)
/// - [annotationListItems] - List items with headers and annotations
/// - [selectedAnnotations] - Set of currently selected annotations
///
/// **Key Operations:**
/// - [switchEditMode] - Toggle edit mode
/// - [switchSelectAll] - Toggle select all state
/// - [toggleSelection] - Add/remove individual annotation from selection
/// - [clearSelection] - Deselect all annotations
/// - [setAllAnnotations] - Update the complete annotation list
/// - [isSelected] - Check if an annotation is selected
///
/// **Usage:**
/// ```dart
/// final state = AnnotationState();
/// state.switchEditMode(); // Enable selection mode
/// state.toggleSelection(annotation, true); // Select annotation
/// ```
class AnnotationState {
  /// Whether annotation is in edit mode, used for selecting annotations to delete
  final RxBool isEdit = false.obs;

  final RxBool isSelectAll = false.obs;

  AnnotationState();

  void switchEditMode() {
    isEdit.value = !isEdit.value;
  }

  /// All annotations on current page (for select all)
  final RxList<CPDFAnnotation> allAnnotations = <CPDFAnnotation>[].obs;

  /// Whether annotation list is loading
  final RxBool isLoading = true.obs;

  /// Annotation list items, including annotations and header info
  final RxList<AnnotationItemModel> annotationListItems =
      <AnnotationItemModel>[].obs;

  /// Use CPDFAnnotation objects to record selection state
  var selectedAnnotations = <CPDFAnnotation>{}.obs;

  bool isSelected(CPDFAnnotation annotation) =>
      selectedAnnotations.contains(annotation);

  void switchSelectAll() {
    isSelectAll.value = !isSelectAll.value;
  }

  /// Toggle annotation selection state
  void toggleSelection(CPDFAnnotation annotation, bool selected) {
    if (selected) {
      selectedAnnotations.add(annotation);
    } else {
      selectedAnnotations.remove(annotation);
    }
  }

  /// Clear all selection state
  void clearSelection() => selectedAnnotations.clear();

  /// Set annotation data (called during initialization)
  void setAllAnnotations(List<CPDFAnnotation> annotations) {
    allAnnotations.value = annotations;
  }
}
