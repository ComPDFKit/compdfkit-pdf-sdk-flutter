// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';

/// State model for the side navigation drawer.
///
/// This class holds the reactive state for the side navigation panel,
/// tracking bookmark status and document encryption information.
///
/// **Managed State:**
/// - [currentPageHasBookmark] - Whether the current page has a bookmark
/// - [isEncrypted] - Whether the document is password-encrypted
///
/// **Key Operations:**
/// - [updateBookmarkStatus] - Update the bookmark status for current page
///
/// **Usage:**
/// ```dart
/// final state = SideNavigationState();
/// state.updateBookmarkStatus(true); // Current page has bookmark
/// ```
class SideNavigationState {
  /// Whether current page has bookmark
  final RxBool currentPageHasBookmark = false.obs;

  /// Whether document is encrypted
  final RxBool isEncrypted = false.obs;

  /// Update current page bookmark status
  void updateBookmarkStatus(bool value) {
    currentPageHasBookmark.value = value;
  }
}
