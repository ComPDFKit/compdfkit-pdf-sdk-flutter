// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/viewer/model/pdf_viewer_state.dart';
import 'package:compdf_viewer/utils/pdf_global_settings_data.dart';

/// Main controller for the PDF viewer functionality.
///
/// Manages:
/// - PDF document loading and configuration
/// - Reader widget lifecycle and state
/// - Page navigation and current page tracking
/// - View mode switching (annotation/content editor)
/// - Fullscreen mode toggle
/// - Back navigation handling with state cleanup
///
/// Example:
/// ```dart
/// final controller = Get.put(PdfViewerController());
///
/// // Jump to specific page
/// controller.jumpToPage(5);
///
/// // Toggle fullscreen
/// controller.toggleFullScreen();
///
/// // Switch view mode
/// controller.toggleViewMode();
/// ```
class PdfViewerController extends GetxController {
  final Rx<CPDFReaderWidgetController?> readerController =
      Rx<CPDFReaderWidgetController?>(null);

  /// PDF reader configuration, non-null after async loading completes
  final Rx<CPDFConfiguration?> configuration = Rx<CPDFConfiguration?>(null);

  final PdfViewerState state = PdfViewerState();

  PdfSearchController get _searchController => Get.find<PdfSearchController>();

  @override
  void onInit() {
    super.onInit();
    ever(state.viewMode, (mode) {
      readerController.value?.setPreviewMode(mode);
    });
    _loadConfiguration();
  }

  // ------------------- Configuration Loading -------------------

  Future<void> _loadConfiguration() async {
    configuration.value = await getCpdfConfig();
  }

  // ------------------- Reader Control -------------------

  void setReaderController(CPDFReaderWidgetController controller) async {
    readerController.value = controller;
    readerController.value?.ready.then((_) async {
      final count = await controller.document.getPageCount();
      state.pageCount.value = count;
      await initDisplayMode();
    });
  }

  /// Jump to specified page
  void jumpToPage(int page) {
    readerController.value?.setDisplayPageIndex(pageIndex: page);
  }

  /// Refresh page count by re-fetching from native side
  Future<void> refreshPageCount() async {
    if (readerController.value != null) {
      final count = await readerController.value!.document.getPageCount();
      state.pageCount.value = count;
    }
  }

  // ------------------- Display Mode -------------------

  /// Initialize display mode from reader controller
  Future<void> initDisplayMode() async {
    final controller = readerController.value;
    if (controller == null) return;

    try {
      final isDoublePageMode = await controller.isDoublePageMode();
      final isCoverPageMode = await controller.isCoverPageMode();

      if (!isDoublePageMode) {
        state.setDisplayMode(CPDFDisplayMode.singlePage);
      } else if (isCoverPageMode) {
        state.setDisplayMode(CPDFDisplayMode.coverPage);
      } else {
        state.setDisplayMode(CPDFDisplayMode.doublePage);
      }
    } catch (e) {
      PdfViewerGlobal.logger.e('Failed to init display mode: $e');
    }
  }

  /// Set display mode and persist to settings
  Future<void> setDisplayMode(CPDFDisplayMode mode) async {
    final controller = readerController.value;
    if (controller == null) return;

    try {
      switch (mode) {
        case CPDFDisplayMode.singlePage:
          await controller.setDoublePageMode(false);
          await controller.setCoverPageMode(false);
          break;
        case CPDFDisplayMode.doublePage:
          await controller.setCoverPageMode(false);
          await controller.setDoublePageMode(true);
          break;
        case CPDFDisplayMode.coverPage:
          await controller.setDoublePageMode(true);
          await controller.setCoverPageMode(true);
          break;
      }
      state.setDisplayMode(mode);
      await PdfGlobalSettingsData.setValue(
          PdfGlobalSettingsData.displayMode, mode.name);
    } catch (e) {
      PdfViewerGlobal.logger.e('Failed to set display mode: $e');
    }
  }

  // ------------------- Page Behavior -------------------

  /// Toggle view mode (annotations / content editor)
  void toggleViewMode() {
    state.viewMode.value = state.viewMode.value == CPDFViewMode.annotations
        ? CPDFViewMode.contentEditor
        : CPDFViewMode.annotations;
  }

  /// Toggle fullscreen mode
  void toggleFullScreen() {
    state.fullScreen.value = !state.fullScreen.value;
  }

  /// Page change callback
  void onPageChanged(int page) {
    state.currentPage.value = page;
  }

  /// Handle back action: exit search mode if active, switch back to annotation mode if in content editor mode, otherwise save and return
  Future<bool> handleBack() async {
    // Exit search mode first if active
    if (_searchController.state.searchResults.isNotEmpty) {
      _searchController.clearSearch();
      return false;
    }
    if (state.viewMode.value == CPDFViewMode.contentEditor) {
      toggleViewMode();
      return false;
    }
    await readerController.value?.document.save();
    return true;
  }
}
