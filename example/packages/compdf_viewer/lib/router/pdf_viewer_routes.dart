// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Route definitions for the PDF viewer package.
///
/// All routes are namespaced under '/pdfpage' to avoid conflicts
/// when integrated into larger applications.
///
/// Example:
/// ```dart
/// // Navigate to PDF viewer
/// Get.toNamed(
///   PdfViewerRoutes.pdfPage,
///   arguments: {'document': '/path/to/file.pdf'},
/// );
///
/// // Navigate to BOTA page (annotations tab)
/// Get.toNamed(
///   PdfViewerRoutes.bota,
///   arguments: 'annotation',
/// );
///
/// // Navigate to thumbnail page
/// final selectedPage = await Get.toNamed(PdfViewerRoutes.thumbnail);
/// if (selectedPage is int) {
///   controller.jumpToPage(selectedPage);
/// }
/// ```
class PdfViewerRoutes {
  /// PDF Viewer main page route.
  ///
  /// Arguments: `{'document': String}` - Absolute path to the PDF document.
  static const pdfPage = '/pdfpage';

  /// BOTA (Bookmarks, Outlines, Thumbnails, Annotations) page route.
  ///
  /// Arguments: `String` - Initial tab: 'annotation', 'outline', or 'bookmark'.
  static const bota = '/pdfpage/bota';

  /// Thumbnail grid view page route.
  ///
  /// Returns: `int?` - Selected page index, or null if cancelled.
  static const thumbnail = '/pdfpage/thumbnail';

  /// PDF document information page route.
  ///
  /// Displays metadata, permissions, and file properties.
  static const documentInfo = '/pdfpage/document_info';

  /// PDF text search page route.
  ///
  /// Provides search input and displays paginated results.
  static const pdfSearch = '/pdfpage/search';
}
