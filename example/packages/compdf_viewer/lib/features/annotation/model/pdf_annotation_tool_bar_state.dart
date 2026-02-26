// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/annotation/model/pdf_annotation_tool_data.dart';

/// Reactive state for the PDF annotation toolbar.
///
/// Manages:
/// - List of available annotation tools with default styles
/// - Currently selected tool type
/// - Annotation history state (undo/redo availability)
/// - Properties panel visibility based on tool type
///
/// Example:
/// ```dart
/// final state = PdfAnnotationToolBarState();
///
/// // Build tools from annotation attributes
/// final tools = state.buildAnnotationTools(annotAttr);
/// state.annotationTools.assignAll(tools);
///
/// // Select a tool
/// state.setSelectionTool(CPDFAnnotationType.highlight);
///
/// // Check if properties can be shown
/// if (state.canShowProperties.value) {
///   // Show properties panel
/// }
/// ```
class PdfAnnotationToolBarState {
  /// Supported annotation types list.
  ///
  /// Includes common annotation tools like note, highlight, ink, shapes, etc.
  static const _supportedTypes = [
    CPDFAnnotationType.note,
    CPDFAnnotationType.highlight,
    CPDFAnnotationType.underline,
    CPDFAnnotationType.strikeout,
    CPDFAnnotationType.squiggly,
    CPDFAnnotationType.ink,
    CPDFAnnotationType.square,
    CPDFAnnotationType.circle,
    CPDFAnnotationType.line,
    CPDFAnnotationType.arrow,
    CPDFAnnotationType.freetext,
    CPDFAnnotationType.signature,
    CPDFAnnotationType.stamp,
    CPDFAnnotationType.sound,
    CPDFAnnotationType.pictures,
    CPDFAnnotationType.link,
  ];

  /// Reactive list of available annotation tools.
  ///
  /// Each tool includes its type, color, and alpha values from default styles.
  final RxList<PdfAnnotationToolData> annotationTools =
      <PdfAnnotationToolData>[].obs;

  /// Build tool list based on annotation attributes.
  ///
  /// Extracts default color and alpha values for each supported annotation type
  /// from the provided [CPDFAnnotAttribute] configuration.
  ///
  /// Returns a list of [PdfAnnotationToolData] ready for toolbar display.
  List<PdfAnnotationToolData> buildAnnotationTools(
    CPDFAnnotAttribute attribute,
  ) {
    return _supportedTypes.map((type) {
      final data = PdfAnnotationToolData(type: type);
      switch (type) {
        case CPDFAnnotationType.note:
          data.color = attribute.noteAttr.color;
          data.alpha = attribute.noteAttr.alpha;
          break;
        case CPDFAnnotationType.highlight:
          data.color = attribute.highlightAttr.color;
          data.alpha = attribute.highlightAttr.alpha;
          break;
        case CPDFAnnotationType.underline:
          data.color = attribute.underlineAttr.color;
          data.alpha = attribute.underlineAttr.alpha;
          break;
        case CPDFAnnotationType.strikeout:
          data.color = attribute.strikeoutAttr.color;
          data.alpha = attribute.strikeoutAttr.alpha;
          break;
        case CPDFAnnotationType.squiggly:
          data.color = attribute.squigglyAttr.color;
          data.alpha = attribute.squigglyAttr.alpha;
          break;
        case CPDFAnnotationType.ink:
          data.color = attribute.inkAttr.color;
          data.alpha = attribute.inkAttr.alpha;
          break;
        case CPDFAnnotationType.square:
          data.color = attribute.squareAttr.borderColor;
          data.alpha = attribute.squareAttr.colorAlpha;
          break;
        case CPDFAnnotationType.circle:
          data.color = attribute.circleAttr.borderColor;
          data.alpha = attribute.circleAttr.colorAlpha;
          break;
        case CPDFAnnotationType.line:
          data.color = attribute.lineAttr.borderColor;
          data.alpha = attribute.lineAttr.borderAlpha;
          break;
        case CPDFAnnotationType.arrow:
          data.color = attribute.arrowAttr.borderColor;
          data.alpha = attribute.arrowAttr.borderAlpha;
          break;
        default:
          break;
      }
      return data;
    }).toList();
  }

  /// Currently selected annotation tool type.
  ///
  /// Defaults to [CPDFAnnotationType.unknown] (no tool selected).
  final Rx<CPDFAnnotationType> selectionTool = CPDFAnnotationType.unknown.obs;

  /// Types that do not support properties popup.
  ///
  /// Tools like signature, stamp, sound, etc. have custom selection dialogs
  /// instead of the standard properties panel.
  final notSupportType = const {
    CPDFAnnotationType.ink_eraser,
    CPDFAnnotationType.unknown,
    CPDFAnnotationType.signature,
    CPDFAnnotationType.stamp,
    CPDFAnnotationType.sound,
    CPDFAnnotationType.pictures,
    CPDFAnnotationType.link,
  };

  /// Whether the properties panel can be shown for the current tool.
  ///
  /// Automatically updated when [selectionTool] changes.
  final RxBool canShowProperties = false.obs;

  /// Set the selected annotation tool type.
  void setSelectionTool(CPDFAnnotationType type) => selectionTool.value = type;

  /// Reset tool selection to unknown (deselect current tool).
  void resetSelectionTool() => selectionTool.value = CPDFAnnotationType.unknown;

  // ------------------- Annotation History -------------------

  /// Whether undo is available in annotation history.
  final canUndo = false.obs;

  /// Whether redo is available in annotation history.
  final canRedo = false.obs;
}
