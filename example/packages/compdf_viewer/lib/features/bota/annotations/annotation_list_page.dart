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
import 'package:compdf_viewer/features/bota/annotations/widgets/annotation_delete_tile.dart';
import 'package:compdf_viewer/features/bota/annotations/widgets/annotation_head_item.dart';
import 'package:compdf_viewer/features/bota/annotations/widgets/annotation_item.dart';
import 'package:compdf_viewer/features/bota/widgets/bota_page_empty_page.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';

/// PDF annotation list page displaying all annotations in the document.
///
/// Features:
/// - Groups annotations by page with page headers showing count
/// - Displays annotation type icon, content preview, and author
/// - Tap annotation to jump to its location in the PDF
/// - Edit mode for batch deletion with checkboxes
/// - Delete action bar at bottom when in edit mode
/// - Shows empty state if document has no annotations
/// - Maintains state across tab switches (AutomaticKeepAliveClientMixin)
///
/// Supported annotation types: note, highlight, underline, strikeout, squiggly,
/// ink, shapes, freetext, stamp, signature, sound, pictures, link.
///
/// Example:
/// ```dart
/// // Used within BOTA page TabBarView
/// TabBarView(
///   children: [
///     AnnotationListPage(), // This widget
///     OutlineList(),
///     BookmarkListPage(),
///   ],
/// )
/// ```
class AnnotationListPage extends StatefulWidget {
  const AnnotationListPage({super.key});

  @override
  State<AnnotationListPage> createState() => _AnnotationListPageState();
}

class _AnnotationListPageState extends State<AnnotationListPage>
    with AutomaticKeepAliveClientMixin {
  final annotationController = Get.find<AnnotationController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load the annotation list after the first frame is rendered, staggered with the opening interface animation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      annotationController.loadAnnotationListItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (annotationController.state.isLoading.value) {
              return const SizedBox.shrink();
            }
            final annotations = annotationController.state.annotationListItems;
            if (annotations.isEmpty) {
              return BotaPageEmptyPage(
                imagePath: PdfViewerAssets.icAnnotationsEmpty,
                message: PdfLocaleKeys.noAnnotationYet.tr,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: annotations.length,
              itemBuilder: (context, index) {
                final item = annotations[index];
                if (item.isHeader) {
                  // If it is a header, return the header component to display the number of annotations and page number on that page
                  return AnnotationHeadItem(
                    pageIndex: item.pageIndex!,
                    count: item.count ?? 0,
                  );
                } else {
                  // Return annotation item
                  return AnnotationItem(item: item);
                }
              },
            );
          }),
        ),
        const AnnotationDeleteTile(),
      ],
    );
  }
}
