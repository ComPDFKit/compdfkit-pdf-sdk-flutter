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
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option_switch_item.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';

/// Crop mode toggle setting for the PDF viewer.
///
/// Provides a switch option to enable/disable crop mode, which automatically
/// removes white margins from PDF pages for better screen utilization.
class CropModeSetting extends StatefulWidget {
  const CropModeSetting({super.key});

  @override
  State<CropModeSetting> createState() => _CropModeSettingState();
}

class _CropModeSettingState extends State<CropModeSetting> {
  final PdfGlobalSettingsController _globalSettingsController =
      Get.find<PdfGlobalSettingsController>();

  final PdfViewerController _pdfController = Get.find<PdfViewerController>();

  @override
  Widget build(BuildContext context) {
    return SideNavigationOptionSwitchItem(
        icon: ImageIcon(AssetImage(PdfViewerAssets.icCropMode,
            package: PdfViewerAssets.packageName)),
        title: PdfLocaleKeys.cropMode.tr,
        isChecked: _globalSettingsController.state.isCropMode,
        onChanged: (crop) async {
          _globalSettingsController.state.setCropMode(crop);
          await _pdfController.readerController.value?.setCropMode(crop);
        });
  }
}
