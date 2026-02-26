// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/navigation/widgets/expandable_selector.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';

/// Display mode setting widget for the PDF viewer.
///
/// Provides an expandable option to switch between single page, double page,
/// and cover page (book mode) display modes.
///
/// This widget is purely presentational - all business logic is handled by
/// [PdfViewerController.setDisplayMode].
class DisplayModeSetting extends StatelessWidget {
  const DisplayModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final PdfViewerController pdfController = Get.find<PdfViewerController>();
    final PdfGlobalSettingsController globalSettingsController =
        Get.find<PdfGlobalSettingsController>();

    return Obx(
      () => SideNavigationOption(
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icViewMode,
              package: PdfViewerAssets.packageName),
        ),
        title: PdfLocaleKeys.viewMode.tr,
        trailing: Icon(
          globalSettingsController.state.isExpandDisplayModeSetting.value
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
        ),
        onTap: () {
          globalSettingsController.state.toggleExpandDisplayModeSetting();
        },
        children:
            globalSettingsController.state.isExpandDisplayModeSetting.value
                ? [
                    ExpandableSelector(
                      title: PdfLocaleKeys.singlePage.tr,
                      mode: CPDFDisplayMode.singlePage,
                      currentMode: pdfController.state.displayMode,
                      onModeChanged: pdfController.setDisplayMode,
                    ),
                    ExpandableSelector(
                      title: PdfLocaleKeys.twoPage.tr,
                      mode: CPDFDisplayMode.doublePage,
                      currentMode: pdfController.state.displayMode,
                      onModeChanged: pdfController.setDisplayMode,
                    ),
                    ExpandableSelector(
                      title: PdfLocaleKeys.bookMode.tr,
                      mode: CPDFDisplayMode.coverPage,
                      currentMode: pdfController.state.displayMode,
                      onModeChanged: pdfController.setDisplayMode,
                    ),
                  ]
                : null,
      ),
    );
  }
}
