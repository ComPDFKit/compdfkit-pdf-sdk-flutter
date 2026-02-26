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
import 'package:compdf_viewer/router/pdf_viewer_routes.dart';
import 'package:compdf_viewer/shared/widgets/buttons/file_action_button.dart';
import 'package:compdf_viewer/features/navigation/file_operations/file_menu_actions.dart';
import 'package:compdf_viewer/features/navigation/controller/side_navigation_controller.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_title.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/confirm_alert_dialog.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/input_alert_dialog.dart';

/// File action buttons section for the PDF viewer sidebar.
///
/// Displays a row of quick action buttons (share, bookmark, print, info) with
/// the file operation title header. Part of the side navigation drawer's file
/// operations area.
///
/// Key features:
/// - Share PDF document
/// - Toggle bookmark for current page (dynamic icon based on bookmark state)
/// - Print PDF document
/// - View document information
/// - Automatic bookmark state refresh on initialization
///
/// Usage example:
/// ```dart
/// // Part of SideNavigationPage layout
/// Column(
///   children: [
///     FileActions(),  // Action buttons section
///     FileMenuActions(),  // Menu options list
///   ],
/// )
/// ```
///
/// Dialogs:
/// - Add bookmark: Input dialog for bookmark name
/// - Delete bookmark: Confirmation dialog before removal
class FileActions extends StatefulWidget {
  const FileActions({super.key});

  @override
  State<FileActions> createState() => _FileActionsState();
}

class _FileActionsState extends State<FileActions> {
  final SideNavigationController _controller =
      Get.find<SideNavigationController>();

  @override
  void initState() {
    super.initState();
    _controller.refreshHasBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
            child: SideNavigationTitle(title: PdfLocaleKeys.fileOperation.tr)),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FileActionButton(
                imagePath: PdfViewerAssets.icShare,
                onTap: () => _controller.shareDocument(),
              ),
              Obx(() {
                bool hasBookmark =
                    _controller.state.currentPageHasBookmark.value;
                return FileActionButton(
                  imagePath: hasBookmark
                      ? PdfViewerAssets.icHasBookmark
                      : PdfViewerAssets.icBookmark,
                  onTap: _handleBookmarkTap,
                );
              }),
              FileActionButton(
                imagePath: PdfViewerAssets.icPrint,
                onTap: () {
                  Scaffold.of(context).closeEndDrawer();
                  _controller.printDocument();
                },
              ),
              FileActionButton(
                imagePath: PdfViewerAssets.icPdfInfo,
                onTap: () {
                  Get.toNamed(PdfViewerRoutes.documentInfo);
                  Scaffold.of(context).closeEndDrawer();
                },
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: const FileMenuActions())
      ],
    );
  }

  void _handleBookmarkTap() {
    bool hasBookmark = _controller.state.currentPageHasBookmark.value;
    if (hasBookmark) {
      _showDeleteBookmarkDialog();
    } else {
      _showAddBookmarkDialog();
    }
  }

  void _showDeleteBookmarkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmAlertDialog(
          title: PdfLocaleKeys.tips.tr,
          content: PdfLocaleKeys.deleteBookmarkConfirm.tr,
          onCancel: () => Get.back(),
          onConfirm: () async {
            await _controller.removeCurrentPageBookmark();
            Get.back();
          },
        );
      },
    );
  }

  void _showAddBookmarkDialog() async {
    String? text = await showDialog<String?>(
      context: context,
      builder: (context) {
        return InputAlertDialog(
          title: PdfLocaleKeys.pleaseInputBookmarkName.tr,
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          hintText: PdfLocaleKeys.inputBookmarkTextFieldHint.tr,
        );
      },
    );
    if (text != null) {
      await _controller.addBookmark(text);
    }
  }
}
