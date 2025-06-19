/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/history/cpdf_history_manager_base.dart';
import 'package:flutter/services.dart';

typedef CPDFAnnotationHistoryChangedCallback = void Function(bool canUndo, bool canRedo);

/// This class manages the history of annotations being edited in the current document,<br/>
/// providing APIs for undo and redo functionality.<br/>
/// It extends from [CPDFHistoryManagerBase] to provide the necessary methods for history management.<br/>
///
/// **example:**
/// ```dart
/// CPDFAnnotationHistoryManager historyManager = widget.controller.annotationHistoryManager;
/// historyManager.setOnHistoryChangedListener((canUndo, canRedo) {
///   // Handle history changes here
///   print('Can Undo: $canUndo, Can Redo: $canRedo');
///   // Update UI or perform other actions based on history state
/// });
/// // To check if undo or redo is possible
/// bool canUndo = await historyManager.canUndo();
/// bool canRedo = await historyManager.canRedo();
///
/// // To perform undo or redo actions
/// await historyManager.undo();
/// await historyManager.redo();
/// ```
class CPDFAnnotationHistoryManager extends CPDFHistoryManagerBase {

  final MethodChannel _channel;

  CPDFAnnotationHistoryChangedCallback? _onHistoryChanged;

  CPDFAnnotationHistoryManager(this._channel);

  /// Sets a callback to be invoked when the annotation history changes.<br/>
  /// This callback will receive two boolean parameters:<br/>
  /// - `canUndo`: Indicates if an undo operation is possible.<br/>
  /// - `canRedo`: Indicates if a redo operation is possible.<br/>
  /// **example:**
  /// ```dart
  /// CPDFAnnotationHistoryManager historyManager = widget.controller.annotationHistoryManager;
  /// historyManager.setOnHistoryChangedListener((canUndo, canRedo) {
  /// // Handle history changes here
  /// print('Can Undo: $canUndo, Can Redo: $canRedo');
  /// });
  /// ```
  void setOnHistoryChangedListener(CPDFAnnotationHistoryChangedCallback callback) {
    _onHistoryChanged = callback;
  }

  void handleMethodCall(MethodCall call) {
    if (call.method == 'onAnnotationHistoryChanged') {
      final Map<dynamic, dynamic> args = call.arguments;
      final bool canUndo = args['canUndo'] ?? false;
      final bool canRedo = args['canRedo'] ?? false;
      _onHistoryChanged?.call(canUndo, canRedo);
    }
  }

  /// Checks if an undo operation is possible.<br/>
  ///
  /// **example:**
  /// ```dart
  /// bool canUndo = await historyManager.canUndo();
  /// ```
  /// Returns a [Future<bool>] that resolves to `true` if undo is possible, otherwise `false`.<br/>
  @override
  Future<bool> canRedo() async {
    return await _channel.invokeMethod('annotation_can_redo');
  }

  /// Checks if a redo operation is possible.<br/>
  ///
  /// **example:**
  /// ```dart
  /// bool canRedo = await historyManager.canRedo();
  /// ```
  ///
  /// Returns a [Future<bool>] that resolves to `true` if redo is possible, otherwise `false`.<br/>
  @override
  Future<bool> canUndo() async {
    return await _channel.invokeMethod('annotation_can_undo');
  }

  /// Performs a redo operation on the annotation history.<br/>
  ///
  /// **example:**
  /// ```dart
  /// await historyManager.redo();
  /// ```
  ///
  @override
  Future<void> redo() async {
    await _channel.invokeMethod('annotation_redo');
  }

  /// Performs an undo operation on the annotation history.<br/>
  /// **example:**
  /// ```dart
  /// await historyManager.undo();
  /// ```
  @override
  Future<void> undo() async {
    await _channel.invokeMethod('annotation_undo');
  }
}
