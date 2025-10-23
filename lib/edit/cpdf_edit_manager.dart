/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/history/cpdf_editor_history_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


enum CPDFEditType {
  none(0),
  text(1),
  image(2),
  path(4);

  final int value;
  const CPDFEditType(this.value);
}

/// Content Edit Manager
/// Manages switching between different editing types in content edit mode.
///
/// Supported editing types: text, image, and path.
/// - Multiple types can be enabled at the same time.
///   For example, enabling both text and image allows editing both text and image.
/// - If only path is enabled, only paths can be edited.
/// - If none is selected, no content can be edited.
///
/// Features:
/// - Use [historyManager] to access the edit history manager.
/// - Use [changeEditType] to switch between editing types.
///
/// Examples:
/// * Edit text and image:
/// ```dart
/// final editManager = controller.editManager;
/// editManager.changeEditType([CPDFEditType.text, CPDFEditType.image]);
/// ```
///
/// * Edit path only:
/// ```dart
/// final editManager = controller.editManager;
/// editManager.changeEditType([CPDFEditType.path]);
/// ```
///
/// * Disable editing:
/// ```dart
/// final editManager = controller.editManager;
/// editManager.changeEditType([CPDFEditType.none]);
/// ```
///
/// Accessing the edit history manager:
/// ```dart
/// final editManager = controller.editManager;
/// final historyManager = editManager.historyManager;
/// ```
class CPDFEditManager {

  late final MethodChannel _channel;

  late final CPDFEditorHistoryManager _historyManager;

  CPDFEditManager(this._channel){
    _historyManager = CPDFEditorHistoryManager(_channel);
  }

  CPDFEditorHistoryManager get historyManager => _historyManager;

  /// Change the current editing types.
  /// [types]: List of editing types to enable.
  /// Returns: true if the operation is successful, false otherwise.
  /// example:
  /// ```dart
  /// final editManager = controller.editManager;
  /// bool result = await editManager.changeEditType([CPDFEditType.text, CPDFEditType.image]);
  /// ```
  Future<bool> changeEditType(List<CPDFEditType> types) async {
    final typeValues = types.map((e) => e.value).toList();
    debugPrint('changeEditType: $typeValues');
    final result = await _channel.invokeMethod<bool>(
      'change_edit_type', typeValues,
    );
    return result ?? false;
  }


}
