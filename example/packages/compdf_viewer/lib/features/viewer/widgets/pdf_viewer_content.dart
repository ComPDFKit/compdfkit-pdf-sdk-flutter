// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/widgets/cpdf_reader_slider_bar.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/page_jump_dialog.dart';
import 'package:compdf_viewer/shared/widgets/indicators/pdf_indicator.dart';

/// Core PDF viewing widget with integrated controls.
///
/// Displays the PDF document with:
/// - [CPDFReaderWidget] - The main PDF rendering widget
/// - [CPDFReaderSliderBar] - Vertical page slider for quick navigation
/// - [PdfIndicator] - Page number indicator with tap-to-jump functionality
///
/// All overlays respond to user interactions and global settings.
///
/// Example:
/// ```dart
/// PdfViewerContent(
///   documentPath: '/path/to/document.pdf',
///   onTapMainDocArea: () {
///     // Handle main area tap (e.g., toggle fullscreen)
///   },
/// );
/// ```
class PdfViewerContent extends StatelessWidget {
  final String documentPath;

  final VoidCallback? onTapMainDocArea;

  const PdfViewerContent({
    super.key,
    required this.documentPath,
    this.onTapMainDocArea,
  });

  // static const double _sliderBarWidth = 22;

  static const double _indicatorBottomPadding = 76;

  @override
  Widget build(BuildContext context) {
    final pdfController = Get.find<PdfViewerController>();
    final pdfGlobalSettingsController = Get.find<PdfGlobalSettingsController>();
    return Obx(() {
      final config = pdfController.configuration.value;
      if (config == null) {
        return const SizedBox.shrink();
      }
      return SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              _buildPdfReader(pdfController),
              _buildPageIndicator(context, pdfGlobalSettingsController),
            ],
          ));
    });
  }

  Widget _buildPdfReader(PdfViewerController pdfController) {
    return Positioned.fill(
      child: CPDFReaderWidget(
        document: documentPath,
        configuration: pdfController.configuration.value!,
        useHybridComposition: false,
        onCreated: pdfController.setReaderController,
        onPageChanged: pdfController.onPageChanged,
        onTapMainDocAreaCallback: onTapMainDocArea,
      ),
    );
  }

  Widget _buildPageIndicator(
      BuildContext context, PdfGlobalSettingsController controller) {
    return Positioned(
      bottom: _indicatorBottomPadding,
      left: 20,
      child: Obx(() {
        final show = controller.state.isShowPageNum.value;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: show
              ? PdfIndicator(
                  key: const ValueKey(true),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => const PageJumpDialog(),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(200),
                    borderRadius: BorderRadius.circular(6),
                  ),
                )
              : const SizedBox(key: ValueKey(false)),
        );
      }),
    );
  }
}
