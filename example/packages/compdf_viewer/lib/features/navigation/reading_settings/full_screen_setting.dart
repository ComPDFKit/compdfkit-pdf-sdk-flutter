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
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';

/// Full screen mode toggle setting for the PDF viewer.
///
/// Provides a switch to enable/disable default full screen mode when opening PDFs.
class FullScreenSetting extends StatelessWidget {
  const FullScreenSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PdfGlobalSettingsController>();
    return SideNavigationOptionSwitchItem(
      icon: ImageIcon(AssetImage(PdfViewerAssets.icFullscreen,
          package: PdfViewerAssets.packageName)),
      title: PdfLocaleKeys.fullScreen.tr,
      isChecked: controller.state.isDefaultFullScreen,
      onChanged: (value) {
        controller.state.setDefaultFullScreen(value);
      },
    );
  }
}
