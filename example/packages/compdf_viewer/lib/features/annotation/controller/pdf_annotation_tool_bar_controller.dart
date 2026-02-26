// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/annotation/model/pdf_annotation_tool_bar_state.dart';

/// Controller for PDF annotation toolbar functionality.
///
/// Manages:
/// - Available annotation tools and their default styles
/// - Current selected annotation tool type
/// - Annotation history (undo/redo) state
/// - Annotation properties panel visibility
///
/// Automatically syncs with the [CPDFReaderWidgetController] to:
/// - Load default annotation styles when reader is ready
/// - Track history changes for undo/redo buttons
/// - Show/hide properties panel based on tool type
///
/// Example:
/// ```dart
/// final controller = Get.find<PdfAnnotationToolBarController>();
///
/// // Select annotation tool
/// await controller.setSelectionTool(CPDFAnnotationType.highlight);
///
/// // Undo last annotation
/// await controller.annotationUndo();
///
/// // Show properties panel
/// await controller.showAnnotationProperties();
/// ```
class PdfAnnotationToolBarController extends GetxController {
  final PdfViewerController _pdfController = Get.find<PdfViewerController>();

  final PdfAnnotationToolBarState state = PdfAnnotationToolBarState();

  CPDFReaderWidgetController? get _readerController =>
      _pdfController.readerController.value;

  @override
  void onReady() {
    super.onReady();
    if (_readerController != null) {
      _initAnnotationHistory(_readerController!);
    }
    ever<CPDFReaderWidgetController?>(
      _pdfController.readerController,
      (controller) {
        if (controller != null) {
          _initAnnotationHistory(controller);
          _loadAnnotationTools(controller);
        }
      },
    );
    ever(state.selectionTool, (type) {
      PdfViewerGlobal.logger.i('ComPDFKit-Flutter, selectionTool: $type');
      state.canShowProperties.value = !state.notSupportType.contains(type);
    });
  }

  /// Load a list of annotation tools and apply default properties
  Future<void> _loadAnnotationTools(
    CPDFReaderWidgetController controller,
  ) async {
    final annotAttr = await controller.fetchDefaultAnnotationStyle();
    final tools = state.buildAnnotationTools(annotAttr);
    state.annotationTools.assignAll(tools);
  }

  void _initAnnotationHistory(CPDFReaderWidgetController controller) async {
    final manager = controller.annotationHistoryManager;
    state.canUndo.value = await manager.canUndo();
    state.canRedo.value = await manager.canRedo();
    manager.setOnHistoryChangedListener((isCanUndo, isCanRedo) {
      state.canUndo.value = isCanUndo;
      state.canRedo.value = isCanRedo;
    });
  }

  /// Set the selected annotation tool type
  Future<void> setSelectionTool(CPDFAnnotationType type) async {
    if (state.selectionTool.value == type) {
      state.resetSelectionTool();
      await _readerController?.setAnnotationMode(CPDFAnnotationType.unknown);
      return;
    }
    state.setSelectionTool(type);
    await _readerController?.setAnnotationMode(type);
  }

  Future<void> annotationUndo() async {
    final controller = _readerController;
    if (controller == null || !state.canUndo.value) return;
    await controller.annotationHistoryManager.undo();
    state.canUndo.value = await controller.annotationHistoryManager.canUndo();
    state.canRedo.value = await controller.annotationHistoryManager.canRedo();
  }

  Future<void> annotationRedo() async {
    final controller = _readerController;
    if (controller == null || !state.canRedo.value) return;
    await controller.annotationHistoryManager.redo();
    state.canUndo.value = await controller.annotationHistoryManager.canUndo();
    state.canRedo.value = await controller.annotationHistoryManager.canRedo();
  }

  Future<void> showAnnotationProperties() async {
    final controller = _readerController;
    final type = state.selectionTool.value;
    if (controller == null || type == CPDFAnnotationType.unknown) return;
    await controller.showDefaultAnnotationPropertiesView(type);
  }
}
