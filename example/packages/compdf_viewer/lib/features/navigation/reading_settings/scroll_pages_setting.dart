// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/navigation/model/scroll_mode.dart';
import 'package:compdf_viewer/features/navigation/widgets/expandable_selector.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';
import 'package:compdf_viewer/utils/pdf_global_settings_data.dart';

/// Scroll mode setting widget for the PDF viewer.
///
/// Provides an expandable option to control PDF scrolling direction and behavior.
class ScrollPagesSetting extends StatefulWidget {
  const ScrollPagesSetting({super.key});

  @override
  State<ScrollPagesSetting> createState() => _ScrollPagesSettingState();
}

class _ScrollPagesSettingState extends State<ScrollPagesSetting> {
  final PdfGlobalSettingsController _globalSettingsController =
      Get.find<PdfGlobalSettingsController>();
  final PdfViewerController _pdfController = Get.find<PdfViewerController>();
  final Rx<ScrollMode> _scrollMode = ScrollMode.verticalContinuous.obs;

  CPDFReaderWidgetController? get _readerController =>
      _pdfController.readerController.value;

  @override
  void initState() {
    super.initState();
    _initScrollMode();
  }

  Future<void> _initScrollMode() async {
    final controller = _readerController;
    if (controller == null) return;

    try {
      final isVertical = await controller.isVerticalMode();
      final isContinuous = await controller.isContinueMode();
      _scrollMode.value = ScrollModeExtension.fromFlags(
        isVertical: isVertical,
        isContinuous: isContinuous,
      );
    } catch (e) {
      PdfViewerGlobal.logger.e('Failed to init scroll mode: $e');
    }
  }

  Future<void> _handleScrollMode(ScrollMode mode) async {
    final controller = _readerController;
    if (controller == null) return;

    try {
      await Future.wait([
        controller.setVerticalMode(mode.isVertical),
        controller.setContinueMode(mode.isContinuous),
        PdfGlobalSettingsData.setValue(
          PdfGlobalSettingsData.isVerticalMode,
          mode.isVertical,
        ),
        PdfGlobalSettingsData.setValue(
          PdfGlobalSettingsData.isContinueMode,
          mode.isContinuous,
        ),
      ]);
      _scrollMode.value = mode;
    } catch (e) {
      PdfViewerGlobal.logger.e('Failed to set scroll mode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SideNavigationOption(
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icTurnPages,
              package: PdfViewerAssets.packageName),
        ),
        title: PdfLocaleKeys.scrollPages.tr,
        trailing: Icon(
          _globalSettingsController.state.isExpandScrollPagesSetting.value
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
        ),
        onTap: () {
          _globalSettingsController.state.toggleExpandScrollPagesSetting();
        },
        children:
            _globalSettingsController.state.isExpandScrollPagesSetting.value
                ? [
                    ExpandableSelector(
                      title: PdfLocaleKeys.verticalContinuous.tr,
                      mode: ScrollMode.verticalContinuous,
                      currentMode: _scrollMode,
                      onModeChanged: _handleScrollMode,
                    ),
                    ExpandableSelector(
                      title: PdfLocaleKeys.verticalDiscontinuous.tr,
                      mode: ScrollMode.verticalDiscontinuous,
                      currentMode: _scrollMode,
                      onModeChanged: _handleScrollMode,
                    ),
                    ExpandableSelector(
                      title: PdfLocaleKeys.horizontalContinuous.tr,
                      mode: ScrollMode.horizontalContinuous,
                      currentMode: _scrollMode,
                      onModeChanged: _handleScrollMode,
                    ),
                    ExpandableSelector(
                      title: PdfLocaleKeys.horizontalDiscontinuous.tr,
                      mode: ScrollMode.horizontalDiscontinuous,
                      currentMode: _scrollMode,
                      onModeChanged: _handleScrollMode,
                    ),
                  ]
                : null,
      ),
    );
  }
}
