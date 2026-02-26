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
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_action_bar.dart';
import 'package:compdf_viewer/features/bota/thumbnails/widgets/thumbnail_list.dart';

import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';

/// PDF thumbnail view page with editing capabilities.
///
/// Displays a grid of PDF page thumbnails with support for viewing, selecting,
/// editing, and managing pages. Features dual modes: normal view mode and
/// edit mode with multi-selection and batch operations.
///
/// Key features:
/// - Grid view of all PDF page thumbnails
/// - Normal mode: view and navigate to pages
/// - Edit mode: multi-select with select all/finish actions
/// - Bottom action bar for batch operations (insert, delete, rotate, extract)
/// - Animated transitions between modes
/// - Current page highlighting
///
/// Modes:
/// - **Normal Mode**: Edit button in app bar, single-tap navigation
/// - **Edit Mode**: Select all/finish buttons, multi-selection enabled,
///   action bar appears when selections made
///
/// Usage example:
/// ```dart
/// // Navigate to thumbnails page
/// Get.toNamed(
///   PdfViewerRoutes.thumbnails,
///   binding: ThumbnailBinding(),
/// );
/// ```
///
/// App bar actions:
/// - Normal: Edit button → enters edit mode
/// - Edit: Select all/deselect all + Finish button → exits edit mode
///
/// State management:
/// - Uses ThumbnailController with GetView
/// - Reactive state for edit mode and selections
/// - GetBuilder for app bar action updates
class ThumbnailPage extends GetView<ThumbnailController> {
  const ThumbnailPage({super.key});

  void _handleBackButtonPressed() {
    final state = controller.state;
    if (state.isThumbnailEditing.value) {
      state.isThumbnailEditing.value = false;
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<ThumbnailController>(
          id: 'app_bar_actions',
          builder: (_) => AppBar(
            title: Text(PdfLocaleKeys.thumbnail.tr),
            actions: _buildActions(context),
            leading: IconButton(
              onPressed: _handleBackButtonPressed,
              icon: Icon(Icons.arrow_back_outlined),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Expanded(child: ThumbnailList()),
          Obx(() {
            final show = controller.state.showActionBar;
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: show,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: false,
                  child: const ThumbnailActionBar(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final state = controller.state;
    final isEditing = state.isThumbnailEditing.value;
    final isSelectAll = state.isSelectAll.value;

    if (!isEditing) {
      return [
        IconButton(
          icon: ImageIcon(
            AssetImage(
              PdfViewerAssets.icEdit,
              package: PdfViewerAssets.packageName,
            ),
          ),
          onPressed: () {
            state.isThumbnailEditing.value = true;
            controller.update(['app_bar_actions']);
          },
        ),
      ];
    }

    return [
      IconButton(
        icon: ImageIcon(
          AssetImage(
            isSelectAll
                ? PdfViewerAssets.icSelectedAll
                : PdfViewerAssets.icSelect,
            package: PdfViewerAssets.packageName,
          ),
        ),
        onPressed: () {
          if (isSelectAll) {
            state.clearSelection();
          } else {
            state.selectAll();
          }
          controller.update(['app_bar_actions']);
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: OutlinedButton(
          onPressed: () {
            state.isThumbnailEditing.value = false;
            state.clearSelection();
            controller.update(['app_bar_actions']);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(0, 28),
          ),
          child: Text(PdfLocaleKeys.finish.tr),
        ),
      ),
    ];
  }
}
