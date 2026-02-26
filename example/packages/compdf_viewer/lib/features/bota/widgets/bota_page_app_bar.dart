// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';
import 'package:compdf_viewer/features/bota/widgets/bota_page_actions.dart';

/// AppBar widget for the BOTA (Bookmarks, Outlines, Thumbnails, Annotations) panel.
///
/// This widget provides a dynamic app bar with tab navigation and context-aware
/// actions. It shows different UI elements based on the current tab and edit mode.
///
/// **Features:**
/// - Three tabs: Annotations, Outline, Bookmark
/// - Context-aware back button (exits edit mode or closes BOTA)
/// - Dynamic actions (Edit/Select All buttons for annotation tab)
/// - Hides tabs when in annotation edit mode
///
/// **Tab Behavior:**
/// - Annotations tab (index 0): Shows edit/select-all actions
/// - Outline tab (index 1): No actions
/// - Bookmark tab (index 2): No actions
///
/// **Back Button Behavior:**
/// - In annotation edit mode: Exit edit mode
/// - Otherwise: Close BOTA panel
///
/// **Usage:**
/// ```dart
/// BotaPageAppBar(tabController: myTabController)
/// ```
class BotaPageAppBar extends StatefulWidget {
  final TabController tabController;

  const BotaPageAppBar({super.key, required this.tabController});

  @override
  State<BotaPageAppBar> createState() => _BotaPageAppBarState();
}

class _BotaPageAppBarState extends State<BotaPageAppBar> {
  var showAnnotationActions = false.obs;

  AnnotationController annotationListPageController =
      Get.find<AnnotationController>();

  @override
  void initState() {
    super.initState();
    _updateShowActions();
    widget.tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (widget.tabController.indexIsChanging) {
      return;
    }
    _updateShowActions();
  }

  void _updateShowActions() {
    showAnnotationActions.value = widget.tabController.index == 0;
  }

  void _handleBackPressed() {
    final inAnnotationTab = widget.tabController.index == 0;
    final isEditing = annotationListPageController.state.isEdit.value;
    if (inAnnotationTab && isEditing) {
      annotationListPageController.state.isEdit.value = false;
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEditing = annotationListPageController.state.isEdit.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            leading: IconButton(
              onPressed: _handleBackPressed,
              icon: Icon(Icons.arrow_back_outlined),
            ),
            title: Text(PdfLocaleKeys.botaTitle.tr),
            actions: [
              Obx(
                () => showAnnotationActions.value
                    ? BotaPageActions.annotationActions(context)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          // Only show TabBar when not in editing mode
          if (!isEditing)
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: TabBar(
                controller: widget.tabController,
                tabs: [
                  Tab(text: PdfLocaleKeys.annotation.tr),
                  Tab(text: PdfLocaleKeys.outline.tr),
                  Tab(text: PdfLocaleKeys.bookmark.tr),
                ],
              ),
            ),
        ],
      );
    });
  }
}
