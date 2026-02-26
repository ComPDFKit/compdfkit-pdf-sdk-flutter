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
import 'package:compdf_viewer/features/convert/widgets/pdf_convert_image_page.dart';
import 'package:compdf_viewer/features/navigation/controller/side_navigation_controller.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option.dart';
import 'package:compdf_viewer/features/security/pdf_encrypt_page.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/loading_dialog.dart';

/// File menu actions list for the PDF viewer sidebar.
///
/// Provides a vertical list of file operation options including save, encryption,
/// conversion, watermark, and annotation management.
///
/// Key features:
/// - Save operations: Save, Save As, Save As Flattened Copy
/// - Security: Set/Change password (dynamic label based on encryption state)
/// - Conversion: PDF to JPG with page selection
/// - Watermark: Add watermark overlay
/// - Cleanup: Delete all annotations
class FileMenuActions extends GetView<SideNavigationController> {
  const FileMenuActions({super.key});

  void _closeDrawer(BuildContext context) {
    Scaffold.of(context).closeEndDrawer();
  }

  SideNavigationOption _buildOption({
    required String asset,
    required String title,
    required VoidCallback onTap,
  }) {
    return SideNavigationOption(
      icon: Image.asset(asset, package: PdfViewerAssets.packageName),
      title: title,
      onTap: onTap,
    );
  }

  void _handleEncrypt(BuildContext context) async {
    _closeDrawer(context);
    final isEncrypted = controller.state.isEncrypted.value;
    final title =
        isEncrypted ? PdfLocaleKeys.changePwd.tr : PdfLocaleKeys.setPwd.tr;
    final password = await Get.to<String>(PdfEncryptPage(title: title));
    await controller.setPassword(password);
  }

  void _handlePDFToImage(BuildContext context) async {
    _closeDrawer(context);
    final pages = await Get.dialog<List<int>>(PdfConvertImagePage());
    if (pages == null || pages.isEmpty) return;

    _showLoadingDialog();
    final dir = await controller.pdfToImage(pages);
    _dismissDialog();

    if (dir != null) {
      _showResultDialog(
        title: PdfLocaleKeys.tips.tr,
        content: '${PdfLocaleKeys.savedTo.tr} $dir',
      );
    }
  }

  void _showLoadingDialog() {
    Get.dialog(const LoadingDialog(), barrierColor: Colors.black12);
  }

  void _dismissDialog() {
    if (Get.isDialogOpen == true) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(
          asset: PdfViewerAssets.icSave,
          title: PdfLocaleKeys.save.tr,
          onTap: () {
            controller.save();
            _closeDrawer(context);
          },
        ),
        _buildOption(
          asset: PdfViewerAssets.icSaveAs,
          title: PdfLocaleKeys.saveAs.tr,
          onTap: () async {
            _closeDrawer(context);
            await Future.delayed(const Duration(milliseconds: 200));
            controller.saveAs();
          },
        ),
        _buildOption(
          asset: PdfViewerAssets.icFlatten,
          title: PdfLocaleKeys.saveAsFlattenedCopy.tr,
          onTap: () async {
            _closeDrawer(context);
            _showLoadingDialog();
            final resultPath = await controller.saveAsFlatten();
            _dismissDialog();
            if (resultPath == null) return;
            _showResultDialog(
              title: PdfLocaleKeys.saveSuccess.tr,
              content: resultPath,
            );
          },
        ),
        Obx(
          () => _buildOption(
            asset: PdfViewerAssets.icEncrypt,
            title: controller.state.isEncrypted.value
                ? PdfLocaleKeys.changePwd.tr
                : PdfLocaleKeys.setPwd.tr,
            onTap: () => _handleEncrypt(context),
          ),
        ),
        _buildOption(
          asset: PdfViewerAssets.icPdfToImg,
          title: PdfLocaleKeys.pdfToJpg.tr,
          onTap: () => _handlePDFToImage(context),
        ),
        _buildOption(
          asset: PdfViewerAssets.icAddWatermark,
          title: PdfLocaleKeys.addWatermark.tr,
          onTap: () async {
            _closeDrawer(context);
            await controller.showAddWatermarkView();
          },
        ),
        _buildOption(
          asset: PdfViewerAssets.icDeleteAnnotation,
          title: PdfLocaleKeys.deleteAllAnnotation.tr,
          onTap: () async {
            _closeDrawer(context);
            await controller.removeAllAnnotations();
          },
        ),
      ],
    );
  }

  void _showResultDialog({required String title, required String content}) {
    Get.dialog(
      barrierDismissible: false,
      ConfirmAlertDialog(
        title: title,
        content: content,
        confirmText: PdfLocaleKeys.confirm.tr,
        cancelText: PdfLocaleKeys.cancel.tr,
        onConfirm: () => Get.back(),
        onCancel: () => Get.back(),
      ),
    );
  }
}
