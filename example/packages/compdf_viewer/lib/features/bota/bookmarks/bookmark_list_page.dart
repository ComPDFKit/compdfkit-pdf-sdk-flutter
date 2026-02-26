// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/bookmarks/controller/bookmark_controller.dart';
import 'package:compdf_viewer/features/bota/bookmarks/widgets/bookmark_item.dart';

/// Bookmark list page displaying all user-created bookmarks.
///
/// Features:
/// - Animated list with smooth add/remove transitions
/// - Displays bookmark name and page number
/// - Tap bookmark to jump to that page
/// - Long press to edit or delete bookmarks
/// - Shows loading indicator while fetching bookmarks
///
/// The list automatically refreshes when bookmarks are added, edited, or removed.
/// Uses [BookmarkController] to manage bookmark operations.
///
/// Example:
/// ```dart
/// // Used within BOTA page TabBarView
/// TabBarView(
///   children: [
///     AnnotationListPage(),
///     OutlineList(),
///     BookmarkListPage(), // This widget
///   ],
/// )
/// ```
class BookmarkListPage extends GetView<BookmarkController> {
  const BookmarkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return CircularProgressIndicator();
      }
      return AnimatedList(
        key: controller.state.animatedListKey,
        initialItemCount: controller.state.bookmarks.length,
        padding: const EdgeInsets.only(top: 0),
        itemBuilder: (context, index, animation) {
          final bookmark = controller.state.bookmarks[index];
          return SizeTransition(
            sizeFactor: animation,
            child: BookmarkItem(bookmark: bookmark),
          );
        },
      );
    });
  }
}
