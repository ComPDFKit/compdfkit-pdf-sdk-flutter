// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

/// Reactive state class for PDF viewer global settings.
///
/// Manages UI state for:
/// - Page number indicator visibility
/// - Crop mode toggle
/// - Fullscreen default setting
/// - Sidebar section expansion states (rotation, scroll, display mode)
///
/// Example:
/// ```dart
/// final state = PdfGlobalSettingsState();
///
/// // Toggle via setter
/// state.setShowPageNum(false);
///
/// // Toggle via toggle method
/// state.toggleExpandRotateSetting();
///
/// // Read value
/// if (state.isShowPageNum.value) { ... }
/// ```
class PdfGlobalSettingsState {
  // ------------------- Settings State -------------------

  /// Whether to default fullscreen display
  final RxBool isDefaultFullScreen = false.obs;

  /// Whether to show page number indicator
  final RxBool isShowPageNum = true.obs;

  /// Whether crop mode is enabled
  final RxBool isCropMode = false.obs;

  // ------------------- Sidebar Expansion State -------------------

  /// Whether to expand sidebar rotation setting
  final RxBool isExpandRotateSetting = false.obs;

  /// Whether to expand sidebar scroll setting
  final RxBool isExpandScrollPagesSetting = false.obs;

  /// Whether to expand sidebar display setting
  final RxBool isExpandDisplayModeSetting = false.obs;

  // ------------------- Settings Setters -------------------

  void setDefaultFullScreen(bool value) => isDefaultFullScreen.value = value;

  void setShowPageNum(bool value) => isShowPageNum.value = value;

  void setCropMode(bool value) => isCropMode.value = value;

  // ------------------- Expansion Setters -------------------

  void setExpandRotateSetting(bool value) =>
      isExpandRotateSetting.value = value;

  void setExpandScrollPagesSetting(bool value) =>
      isExpandScrollPagesSetting.value = value;

  void setExpandDisplayModeSetting(bool value) =>
      isExpandDisplayModeSetting.value = value;

  // ------------------- Toggle Methods -------------------

  void toggleExpandRotateSetting() => isExpandRotateSetting.toggle();

  void toggleExpandScrollPagesSetting() => isExpandScrollPagesSetting.toggle();

  void toggleExpandDisplayModeSetting() => isExpandDisplayModeSetting.toggle();
}
