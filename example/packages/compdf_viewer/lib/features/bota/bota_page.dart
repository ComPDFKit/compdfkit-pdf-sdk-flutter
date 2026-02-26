// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/annotations/annotation_list_page.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';
import 'package:compdf_viewer/features/bota/bookmarks/bookmark_list_page.dart';
import 'package:compdf_viewer/features/bota/outlines/outline_list_page.dart';
import 'package:compdf_viewer/features/bota/widgets/bota_page_app_bar.dart';

/// BOTA (Bookmarks, Outlines, Thumbnails, Annotations) navigation page.
///
/// A tabbed interface providing access to:
/// - **Annotations Tab**: List all annotations with edit/delete capabilities
/// - **Outline Tab**: Navigate PDF document structure/table of contents
/// - **Bookmark Tab**: View and manage user-created bookmarks
///
/// Features:
/// - Tab switching via swipe or tap
/// - Edit mode for batch annotation deletion
/// - Smart back navigation (exits edit mode before closing)
/// - Initial tab selection via [Get.arguments] ('annotation'/'outline'/'bookmark')
///
/// Example:
/// ```dart
/// // Navigate to annotations tab
/// Get.toNamed(
///   PdfViewerRoutes.bota,
///   arguments: 'annotation',
/// );
///
/// // Navigate to bookmarks tab
/// Get.toNamed(
///   PdfViewerRoutes.bota,
///   arguments: 'bookmark',
/// );
/// ```
class BotaPage extends StatefulWidget {
  const BotaPage({super.key});

  @override
  State<BotaPage> createState() => _BotaPageState();
}

class _BotaPageState extends State<BotaPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  late final AnnotationController annotationController;

  @override
  void initState() {
    super.initState();
    annotationController = Get.find<AnnotationController>();

    // Parse initial tab from arguments
    int initialIndex = 0;
    final initTab = Get.arguments;
    switch (initTab) {
      case 'annotation':
        initialIndex = 0;
        break;
      case 'outline':
        initialIndex = 1;
        break;
      case 'bookmark':
        initialIndex = 2;
        break;
    }

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (annotationController.state.isEdit.value) {
            // In edit mode -> exit edit mode
            annotationController.state.isEdit.value = false;
          } else {
            // Not in edit mode -> normal return
            Navigator.of(context).pop(result);
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            BotaPageAppBar(tabController: _tabController),
            Expanded(
              child: Obx(
                () => TabBarView(
                  physics: annotationController.state.isEdit.value
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  controller: _tabController,
                  children: const [
                    AnnotationListPage(),
                    OutlineList(),
                    BookmarkListPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
