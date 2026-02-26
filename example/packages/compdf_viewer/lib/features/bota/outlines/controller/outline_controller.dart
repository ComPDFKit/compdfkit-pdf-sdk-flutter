// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/outlines/repository/outline_repository.dart';

/// GetX controller for managing PDF document outline (table of contents) data.
///
/// This controller handles loading and managing the hierarchical outline structure
/// of a PDF document, providing reactive state management for the outline view.
///
/// **Managed State:**
/// - [outlineRoot] - The root outline node containing the hierarchical structure
/// - [isLoading] - Loading indicator for async outline fetch operations
///
/// **Key Operations:**
/// - [loadOutline] - Fetch outline tree from the document via repository
///
/// **Usage:**
/// ```dart
/// final controller = Get.put(OutlineController(repository));
/// await controller.loadOutline();
/// ```
class OutlineController extends GetxController {
  final OutlineRepository repository;

  OutlineController(this.repository);

  /// All outlines on current page (for select all)
  final Rx<CPDFOutline?> outlineRoot = Rx<CPDFOutline?>(null);

  /// Whether outline list is loading
  final RxBool isLoading = true.obs;

  /// Load outline data
  Future<void> loadOutline() async {
    isLoading.value = true;
    final outline = await repository.fetchOutlineRoot();
    outlineRoot.value = outline;
    isLoading.value = false;
  }
}
