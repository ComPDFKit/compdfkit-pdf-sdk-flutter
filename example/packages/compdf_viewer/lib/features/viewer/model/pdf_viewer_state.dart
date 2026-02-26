// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:get/get.dart';

/// Reactive state for the PDF viewer page.
///
/// Tracks:
/// - [fullScreen] - Whether the viewer is in fullscreen mode (hides app bar)
/// - [pageCount] - Total number of pages in the current document
/// - [currentPage] - Current page index (0-based)
/// - [viewMode] - Current view mode (annotation editing or content editing)
/// - [displayMode] - Page display mode (single/double/cover page)
///
/// All properties are reactive (Rx) and will trigger UI updates when changed.
///
/// Example:
/// ```dart
/// final state = PdfViewerState();
///
/// // Listen to page changes
/// ever(state.currentPage, (page) {
///   print('Page changed to: $page');
/// });
///
/// // Update fullscreen state
/// state.fullScreen.value = true;
/// ```
class PdfViewerState {
  /// Whether current page is in fullscreen mode.
  ///
  /// When true, the app bar is hidden to maximize viewing area.
  final RxBool fullScreen = RxBool(false);

  /// Total page count of current PDF document.
  ///
  /// Updated after the document is loaded and ready.
  final RxInt pageCount = 0.obs;

  /// Current page index (0-based).
  ///
  /// Updated automatically when user navigates through the document.
  final RxInt currentPage = 0.obs;

  /// Current view mode.
  ///
  /// - [CPDFViewMode.annotations]: Annotation editing mode (default)
  /// - [CPDFViewMode.contentEditor]: Content editing mode (text/images)
  final Rx<CPDFViewMode> viewMode = CPDFViewMode.annotations.obs;

  /// Current display mode.
  ///
  /// - [CPDFDisplayMode.singlePage]: Single page display
  /// - [CPDFDisplayMode.doublePage]: Two pages side by side
  /// - [CPDFDisplayMode.coverPage]: Book mode with cover page
  final Rx<CPDFDisplayMode> displayMode = CPDFDisplayMode.singlePage.obs;

  void setDisplayMode(CPDFDisplayMode mode) => displayMode.value = mode;
}
