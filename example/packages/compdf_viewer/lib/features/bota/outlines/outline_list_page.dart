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
import 'package:compdf_viewer/features/bota/outlines/controller/outline_controller.dart';
import 'package:compdf_viewer/features/bota/outlines/widgets/outline_item.dart';
import 'package:compdf_viewer/features/bota/widgets/bota_page_empty_page.dart';

/// PDF document outline (table of contents) list page.
///
/// Displays the hierarchical structure of PDF bookmarks/outlines defined by the document author.
/// Different from user-created bookmarks, these outlines are embedded in the PDF file.
///
/// Features:
/// - Hierarchical tree structure with expand/collapse
/// - Tap outline to navigate to destination page
/// - Shows empty state if document has no outlines
/// - Maintains state across tab switches (AutomaticKeepAliveClientMixin)
///
/// Example:
/// ```dart
/// // Used within BOTA page TabBarView
/// TabBarView(
///   children: [
///     AnnotationListPage(),
///     OutlineList(), // This widget
///     BookmarkListPage(),
///   ],
/// )
/// ```
class OutlineList extends StatefulWidget {
  const OutlineList({super.key});

  @override
  State<OutlineList> createState() => _OutlineListState();
}

class _OutlineListState extends State<OutlineList>
    with AutomaticKeepAliveClientMixin {
  OutlineController outlineController = Get.find<OutlineController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      outlineController.loadOutline();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (outlineController.isLoading.value) {
        return const SizedBox.shrink();
      }
      final outlineRoot = outlineController.outlineRoot.value;
      if (outlineRoot == null || outlineRoot.childList.isEmpty) {
        return BotaPageEmptyPage(
          imagePath: PdfViewerAssets.icOutlineEmpty,
          message: PdfLocaleKeys.noOutlineYet.tr,
        );
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 0),
        itemCount: outlineRoot.childList.length,
        itemBuilder: (context, index) {
          final rootLevelItem = outlineRoot.childList[index];
          return OutlineItem(outline: rootLevelItem);
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
