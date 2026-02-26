// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/bookmarks/model/bookmark_state.dart';
import 'package:compdf_viewer/features/bota/bookmarks/repository/bookmark_repository.dart';

/// Controller for PDF bookmark management.
///
/// Manages:
/// - Fetching all bookmarks from the PDF document
/// - Adding new bookmarks at specific pages
/// - Editing bookmark labels
/// - Removing bookmarks
/// - Animated list state for smooth UI transitions
///
/// Uses [BookmarkRepository] for data access and [BookmarkListState] for reactive state.
///
/// Example:
/// ```dart
/// final controller = Get.find<BookmarkController>();
///
/// // Fetch bookmarks
/// controller.fetchBookmarks();
///
/// // Remove a bookmark
/// controller.removeBookmark(bookmark);
///
/// // Edit bookmark label
/// controller.editBookmark(updatedBookmark);
/// ```
class BookmarkController extends GetxController {
  final BookmarkRepository repository;

  final BookmarkListState state = BookmarkListState();

  BookmarkController(this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  /// Fetch all bookmarks data
  void fetchBookmarks() async {
    state.setLoading(true);
    try {
      final bookmarks = await repository.fetchBookmarks();
      state.setBookmarks(bookmarks);
    } catch (e) {
      state.setError(e.toString());
    } finally {
      state.setLoading(false);
    }
  }

  /// Remove specified bookmark
  void removeBookmark(CPDFBookmark bookmark) async {
    try {
      final success = await repository.removeBookmark(bookmark.pageIndex);
      if (success) {
        state.removeBookmark(bookmark);
      }
    } catch (e) {
      e.printInfo();
    }
  }

  /// Edit bookmark
  void editBookmark(CPDFBookmark bookmark) async {
    try {
      final success = await repository.editBookmark(bookmark);
      if (success) {
        state.updateBookmark(bookmark);
      }
    } catch (e) {
      e.printInfo();
    }
  }
}
