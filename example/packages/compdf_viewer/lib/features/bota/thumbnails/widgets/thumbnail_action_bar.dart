// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/core/constants.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_data.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_type_picker_dialog.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_pages_dialog.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/input_alert_dialog.dart';
import 'package:compdf_viewer/shared/widgets/buttons/icon_text_button.dart';
import 'package:compdf_viewer/utils/snackbar_util.dart';

/// Bottom action bar for thumbnail page operations.
///
/// Displays four action buttons (Insert, Rotate, Extract, Delete) for batch
/// operations on selected pages. Only visible in edit mode when pages are
/// selected. Each action shows dialogs for confirmation or options.
///
/// Actions:
/// - **Insert**: Choose blank page or template, import from PDF file
/// - **Rotate**: Rotate selected pages by 90 degrees
/// - **Extract**: Split selected pages into new PDF file with sharing options
/// - **Delete**: Remove selected pages with confirmation
///
/// Usage example:
/// ```dart
/// // In ThumbnailPage (conditionally visible)
/// Obx(() {
///   final show = controller.state.showActionBar;
///   return AnimatedSize(
///     child: Visibility(
///       visible: show,
///       child: ThumbnailActionBar(),
///     ),
///   );
/// })
/// ```
///
/// Action flows:
/// - Insert → InsertPageTypePickerDialog → (Blank: InsertPagesDialog | Import: File picker)
/// - Rotate → Immediate rotation with confirmation snackbar
/// - Extract → Extract to temp file → Save/Share dialog
/// - Delete → Confirmation dialog → Remove pages
///
/// Post-operation:
/// - All actions call `controller.refreshData()` to reload thumbnails
/// - Success/error feedback via SnackbarUtil
class ThumbnailActionBar extends GetView<ThumbnailController> {
  const ThumbnailActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(
        icon: PdfViewerAssets.icPageInsert,
        label: PdfLocaleKeys.insert.tr,
        onTap: () => _handleInsert(context),
      ),
      _Action(
        icon: PdfViewerAssets.icPageRotate,
        label: PdfLocaleKeys.rotate.tr,
        onTap: _handleRotate,
      ),
      _Action(
        icon: PdfViewerAssets.icPageExtract,
        label: PdfLocaleKeys.extract.tr,
        onTap: () => _handleExtract(context),
      ),
      _Action(
        icon: PdfViewerAssets.icDelete,
        label: PdfLocaleKeys.delete.tr,
        onTap: _handleDelete,
      ),
    ];
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions
            .map(
              (action) => Expanded(
                child: IconTextButton(
                  icon: action.icon,
                  label: action.label,
                  onTap: action.onTap,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ==== Action Handlers ====
  void _handleExtract(BuildContext context) async {
    String? path = await controller.extractPages();
    if (path != null && context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return ConfirmAlertDialog(
            title: PdfLocaleKeys.tips.tr,
            content: PdfLocaleKeys.extractPDFMsg.trParams({'path': path}),
            confirmText: PdfLocaleKeys.viewNow.tr,
            onCancel: () {
              Get.back();
            },
            onConfirm: () {
              Get.back();
              ComPDFKit.openDocument(path);
            },
          );
        },
      );
    }
  }

  void _handleDelete() async {
    if (controller.state.isSelectAll.value) {
      // Cannot delete when all selected
      Get.dialog(
        ConfirmAlertDialog(
          title: PdfLocaleKeys.tips.tr,
          content: PdfLocaleKeys.cantDeleteAll.tr,
          onConfirm: () {
            Get.back();
          },
        ),
      );
      return;
    }

    // Delete selected pages
    if (await controller.removePages()) {
      // Refresh data after successful deletion
      controller.refreshData();
    }
  }

  /// Rotate selected pages
  void _handleRotate() async {
    bool result = await controller.rotatePages();
    if (result) {
      await controller.refreshData();
    }
  }

  void _handleInsert(BuildContext context) async {
    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => InsertPageTypePickerDialog(),
    );
    if (!context.mounted) {
      return;
    }
    switch (type) {
      case 'blank_page':
        _showInsertBlankPageDialog(context);
        break;
      case 'pdf_page':
        _showSelectPDFFileDialog(context);
        break;
      default:
        break;
    }
  }

  // ==== Dialogs & Utilities ====

  /// Show insert blank page dialog
  Future<void> _showInsertBlankPageDialog(BuildContext context) async {
    final insertPageData = await showDialog<InsertPageData?>(
      context: context,
      builder: (_) => InsertPagesDialog(),
    );
    if (insertPageData != null) {
      await _insertBlankPage(insertPageData);
    }
  }

  /// Actually insert blank page
  Future<void> _insertBlankPage(InsertPageData insertPageData) async {
    if (await controller.insertPage(pageData: insertPageData)) {
      controller.refreshData();
    }
  }

  Future<void> _showSelectPDFFileDialog(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.path == null) {
      return;
    }

    final filePath = result.files.first.path!;
    final document = await CPDFDocument.createInstance();
    final error = await document.open(filePath);

    if (error == CPDFDocumentError.success) {
      int pageCount = await document.getPageCount();
      List<int> insertPages = List.generate(pageCount, (i) => i);
      bool inserted = await controller.insertPDFFile(
        filePath: filePath,
        pages: insertPages,
      );
      if (inserted) controller.refreshData();
    } else if (error == CPDFDocumentError.errorPassword) {
      if (!context.mounted) {
        return;
      }
      final password = await _showInputPasswordDialog(
        context,
        filePath,
        document,
      );
      if (password != null) {
        await _insertPDFDocument(document, filePath, password: password);
      }
    }
  }

  /// Insert all pages of PDF file
  Future<void> _insertPDFDocument(
    CPDFDocument document,
    String filePath, {
    String? password,
  }) async {
    final pageCount = await document.getPageCount();
    final insertPages = List.generate(pageCount, (i) => i);
    final inserted = await controller.insertPDFFile(
      filePath: filePath,
      pages: insertPages,
      password: password,
    );
    await document.close();
    if (inserted) controller.refreshData();
  }

  Future<String?> _showInputPasswordDialog(
    BuildContext context,
    String filePath,
    CPDFDocument document,
  ) async {
    return await showDialog<String?>(
      context: context,
      builder: (context) {
        return InputAlertDialog(
          title: PdfLocaleKeys.tips.tr,
          hintText: PdfLocaleKeys.inputPassword.tr,
          onConfirm: (password) async {
            final error = await document.open(filePath, password: password);
            if (error == CPDFDocumentError.success) {
              Get.back(result: password);
            } else if (error == CPDFDocumentError.errorPassword) {
              SnackbarUtil.showTips(PdfLocaleKeys.passwordError.tr);
            }
          },
        );
      },
    );
  }
}

// ==== Action simple wrapper ====
class _Action {
  final String icon;
  final String label;
  final VoidCallback onTap;

  _Action({required this.icon, required this.label, required this.onTap});
}
