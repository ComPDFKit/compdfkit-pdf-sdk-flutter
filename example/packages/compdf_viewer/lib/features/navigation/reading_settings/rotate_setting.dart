// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/utils/screen_util.dart';
import 'package:compdf_viewer/features/navigation/widgets/expandable_selector.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';

/// Screen rotation setting widget for the PDF viewer.
///
/// Provides an expandable option to control screen rotation behavior.
class RotateSetting extends StatefulWidget {
  const RotateSetting({super.key});

  @override
  State<RotateSetting> createState() => _RotateSettingState();
}

class _RotateSettingState extends State<RotateSetting> {
  final PdfGlobalSettingsController _globalSettingsController =
      Get.find<PdfGlobalSettingsController>();
  final Rx<ScreenRotationMode> _rotateMode =
      ScreenRotationMode.followSystem.obs;

  @override
  void initState() {
    super.initState();
    _initScreenRotationMode();
  }

  Future<void> _initScreenRotationMode() async {
    _rotateMode.value = await ScreenUtil.getRotationMode();
  }

  Future<void> _handleTap(ScreenRotationMode mode) async {
    await ScreenUtil.setRotationMode(mode,
        orientation: MediaQuery.of(context).orientation);
    ScreenUtil.applyRotationMode();
    _rotateMode.value = mode;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SideNavigationOption(
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icScreenRotation,
              package: PdfViewerAssets.packageName),
        ),
        title: PdfLocaleKeys.rotationSettings.tr,
        trailing: Icon(
          _globalSettingsController.state.isExpandRotateSetting.value
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
        ),
        onTap: () {
          _globalSettingsController.state.toggleExpandRotateSetting();
        },
        children: _globalSettingsController.state.isExpandRotateSetting.value
            ? [
                ExpandableSelector(
                  title: PdfLocaleKeys.followSystem.tr,
                  mode: ScreenRotationMode.followSystem,
                  currentMode: _rotateMode,
                  onModeChanged: _handleTap,
                ),
                ExpandableSelector(
                  title: PdfLocaleKeys.autoRotate.tr,
                  mode: ScreenRotationMode.autoRotate,
                  currentMode: _rotateMode,
                  onModeChanged: _handleTap,
                ),
                ExpandableSelector(
                  title: PdfLocaleKeys.lockScreen.tr,
                  mode: ScreenRotationMode.lockRotation,
                  currentMode: _rotateMode,
                  onModeChanged: _handleTap,
                ),
              ]
            : null,
      ),
    );
  }
}
