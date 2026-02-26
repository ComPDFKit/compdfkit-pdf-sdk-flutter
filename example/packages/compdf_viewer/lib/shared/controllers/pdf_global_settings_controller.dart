// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/shared/controllers/pdf_global_settings_state.dart';
import 'package:compdf_viewer/utils/pdf_global_settings_data.dart';
import 'package:compdf_viewer/utils/screen_util.dart';

/// Controller for PDF viewer global settings and preferences.
///
/// Manages UI state and persistence for:
/// - Page number indicator visibility
/// - Crop mode toggle
/// - Fullscreen default setting
/// - Sidebar section expansion states (rotation, scroll, display mode)
/// - Screen orientation settings
///
/// All settings are automatically synced to persistent storage via [PdfGlobalSettingsData].
/// Changes are reactive and trigger UI updates immediately.
///
/// Example:
/// ```dart
/// final controller = Get.find<PdfGlobalSettingsController>();
///
/// // Toggle page number indicator via state setter
/// controller.state.setShowPageNum(false);
///
/// // Enable crop mode
/// controller.state.setCropMode(true);
///
/// // Check sidebar expansion state
/// if (controller.state.isExpandRotateSetting.value) {
///   // Show rotation options
/// }
/// ```
class PdfGlobalSettingsController extends GetxController {
  /// Reactive state for global settings
  final PdfGlobalSettingsState state = PdfGlobalSettingsState();

  // ------------------- Lifecycle -------------------

  @override
  void onInit() {
    super.onInit();
    _initSettingBindings();
  }

  @override
  void onReady() {
    super.onReady();
    _initialize();
  }

  @override
  void onClose() {
    // Restore system default screen rotation setting
    ScreenUtil.enableAutoRotation();
    super.onClose();
  }

  // ------------------- Initialization -------------------

  Future<void> _initialize() async {
    // Initialize screen rotation mode
    ScreenUtil.applyRotationMode();
    // Load previously saved settings state
    await _loadSettings();
  }

  void _initSettingBindings() {
    ever(state.isExpandRotateSetting,
        (value) => PdfGlobalSettingsData.setIsExpandRotateSetting(value));
    ever(state.isExpandScrollPagesSetting,
        (value) => PdfGlobalSettingsData.setIsExpandScrollPagesSetting(value));
    ever(state.isExpandDisplayModeSetting,
        (value) => PdfGlobalSettingsData.setIsExpandDisplayModeSetting(value));
    ever(state.isShowPageNum,
        (value) => PdfGlobalSettingsData.setIsShowPageNum(value));
    ever(state.isCropMode,
        (value) => PdfGlobalSettingsData.setIsCropMode(value));
  }

  Future<void> _loadSettings() async {
    state.setExpandRotateSetting(
        await PdfGlobalSettingsData.getIsExpandRotateSetting());
    state.setExpandScrollPagesSetting(
        await PdfGlobalSettingsData.getIsExpandScrollPagesSetting());
    state.setExpandDisplayModeSetting(
        await PdfGlobalSettingsData.getIsExpandDisplayModeSetting());
    state.setShowPageNum(await PdfGlobalSettingsData.getIsShowPageNum());
    state.setCropMode(await PdfGlobalSettingsData.getIsCropMode());
  }

  Future<CPDFThemes> getReadBackgroundColor() async {
    return await PdfGlobalSettingsData.getReadBackgroundColor();
  }
}
