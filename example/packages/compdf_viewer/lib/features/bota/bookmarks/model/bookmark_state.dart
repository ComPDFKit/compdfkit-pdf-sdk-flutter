// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/bota/bookmarks/widgets/bookmark_item.dart';

/// State model for managing the bookmark list UI and data.
///
/// This class holds the reactive state for the bookmark list feature,
/// including loading status, bookmark data, and animation control.
///
/// **Managed State:**
/// - Loading indicator state
/// - List of bookmarks for the current document
/// - AnimatedList key for smooth add/remove animations
/// - Error messages for failed operations
///
/// **Key Operations:**
/// - [setLoading] - Update loading state
/// - [setBookmarks] - Replace the entire bookmark list
/// - [removeBookmark] - Remove a bookmark with fade/size animation
/// - [updateBookmark] - Update an existing bookmark by UUID
/// - [setError] - Set error message for error handling
///
/// **Usage:**
/// ```dart
/// final state = BookmarkListState();
/// state.setLoading(true);
/// state.setBookmarks(await repository.fetchBookmarks());
/// state.setLoading(false);
/// ```
class BookmarkListState {
  BookmarkListState();

  /// Whether bookmark list is loading
  RxBool isLoading = true.obs;

  /// All bookmarks for current page
  RxList<CPDFBookmark> bookmarks = <CPDFBookmark>[].obs;

  final GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  /// Error message
  String? errorMessage;

  /// Set loading state
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  /// Set bookmarks list
  void setBookmarks(List<CPDFBookmark> newBookmarks) {
    bookmarks.value = newBookmarks;
  }

  void removeBookmark(CPDFBookmark bookmark) {
    final index = bookmarks.indexOf(bookmark);
    if (index != -1) {
      final removedItem = bookmarks[index];
      bookmarks.removeAt(index);
      animatedListKey.currentState?.removeItem(index, (context, animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SizeTransition(
            sizeFactor: curvedAnimation,
            child: BookmarkItem(bookmark: removedItem),
          ),
        );
      }, duration: Duration(milliseconds: 300));
    }
  }

  void updateBookmark(CPDFBookmark bookmark) {
    int index = bookmarks.indexWhere((book) => book.uuid == bookmark.uuid);
    if (index != -1) {
      bookmarks[index] = bookmark;
    }
  }

  /// Set error message
  void setError(String message) {
    errorMessage = message;
  }
}
