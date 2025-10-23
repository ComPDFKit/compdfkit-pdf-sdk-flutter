/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/services.dart';

import 'cpdf_history_manager_base.dart';

typedef CPDFEditorHistoryChangedCallback = void Function(int pageIndex, bool canUndo, bool canRedo);


/// Content Editor History Manager
/// Manages the undo and redo functionality for content editing operations.
/// Provides methods to check if undo/redo is possible and to perform these actions.
/// Also allows setting a listener to be notified when the history state changes.
/// Example usage:
/// ```dart
/// final historyManager = controller.editManager.historyManager;
/// bool canUndo = await historyManager.canUndo();
/// bool canRedo = await historyManager.canRedo();
///
/// await historyManager.undo();
/// await historyManager.redo();
///
/// historyManager.setOnHistoryChangedListener((pageIndex, canUndo, canRedo) {
///   // Handle history change
/// });
/// ```
class CPDFEditorHistoryManager implements CPDFHistoryManagerBase {

  late final MethodChannel _channel;

  CPDFEditorHistoryManager(this._channel);

  CPDFEditorHistoryChangedCallback? _onHistoryChanged;

  /// Sets a listener to be notified when the history state changes.
  /// The callback provides the current page index, and whether undo and redo are possible.
  /// example:
  /// ```dart
  /// historyManager.setOnHistoryChangedListener((pageIndex, canUndo, canRedo) {
  ///   // Handle history change
  /// });
  /// ```
  void setOnHistoryChangedListener(CPDFEditorHistoryChangedCallback callback) {
    _onHistoryChanged = callback;
  }

  void handleMethodCall(MethodCall call) {
    if (call.method == 'onContentEditorHistoryChanged') {
      final Map<dynamic, dynamic> args = call.arguments;
      final bool canUndo = args['canUndo'] ?? false;
      final bool canRedo = args['canRedo'] ?? false;
      final int pageIndex = args['pageIndex'] ?? 0;
      _onHistoryChanged?.call(pageIndex, canUndo, canRedo);
    }
  }

  /// Checks if a redo operation can be performed.
  /// Returns a [Future] that resolves to `true` if redo is possible, otherwise `false`.
  /// example:
  /// ```dart
  /// bool canRedo = await historyManager.canRedo();
  /// ```
  @override
  Future<bool> canRedo() async {
    return await _channel.invokeMethod('content_editor_can_redo');
  }

  /// Checks if an undo operation can be performed.
  /// Returns a [Future] that resolves to `true` if undo is possible, otherwise `false`.
  /// example:
  /// ```dart
  /// bool canUndo = await historyManager.canUndo();
  /// ```
  @override
  Future<bool> canUndo() async {
    return await _channel.invokeMethod('content_editor_can_undo');
  }

  /// Performs a redo operation.
  /// Returns a [Future] that completes when the operation is done.
  /// example:
  /// ```dart
  /// await historyManager.redo();
  /// ```
  @override
  Future<void> redo() async {
    await _channel.invokeMethod('content_editor_redo');
  }

  /// Performs an undo operation.
  /// Returns a [Future] that completes when the operation is done.
  /// example:
  /// ```dart
  /// await historyManager.undo();
  /// ```
  @override
  Future<void> undo() async {
    await _channel.invokeMethod('content_editor_undo');
  }

}
