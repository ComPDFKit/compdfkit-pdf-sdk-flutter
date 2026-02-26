// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Centralized asset path constants for the ComPDFViewer package.
///
/// Provides type-safe access to all image and icon assets used in the viewer.
/// Use these constants instead of hardcoded strings to ensure consistency
/// and easier maintenance of asset references throughout the codebase.
///
/// Asset categories:
/// - Navigation & Menu Icons: Page edit, BOTA, search, side menu
/// - File Action Icons: Save, share, encrypt, print, bookmark
/// - Settings Icons: Color picker, page number, fullscreen, view modes
/// - Page Editor Icons: Insert, rotate, extract, delete, select
/// - Paper Templates: Line, music, grid paper thumbnails
/// - Empty State Icons: For outline, annotations, bookmark empty states
/// - Annotation Icons: Note, highlight, ink, shapes, stamps (SVG format)
///
/// Example:
/// ```dart
/// import 'package:compdf_viewer/core/constants.dart';
///
/// // Using PNG icons
/// Image.asset(
///   PdfViewerAssets.icSearch,
///   package: PdfViewerAssets.packageName,
/// );
///
/// // Using SVG icons
/// SvgPicture.asset(
///   PdfViewerAssets.icAnnotNote,
///   package: PdfViewerAssets.packageName,
///   width: 24,
/// );
/// ```
class PdfViewerAssets {
  PdfViewerAssets._();

  static const String baseFolderName = 'ComPDF Flutter Example';

  /// Package name for asset loading.
  ///
  /// Must be specified when loading assets from this package in external apps.
  static const String packageName = 'compdf_viewer';

  // ============================================================
  // Navigation & Menu Icons
  // ============================================================

  /// Page edit icon
  static const String icPageEdit = 'assets/ic_page_edit.png';

  /// BOTA (Bookmarks, Outline, Thumbnails, Annotations) icon
  static const String icBota = 'assets/ic_bota.png';

  /// Search icon
  static const String icSearch = 'assets/ic_search.png';

  /// Side menu icon
  static const String icSideMenu = 'assets/ic_side_menu.png';

  /// Edit PDF icon
  static const String icEditPdf = 'assets/ic_edit_pdf.png';

  /// Edit icon
  static const String icEdit = 'assets/ic_edit.png';

  // ============================================================
  // File Action Icons
  // ============================================================

  /// Save icon
  static const String icSave = 'assets/ic_save.png';

  /// Save as icon
  static const String icSaveAs = 'assets/ic_save_as.png';

  /// Flatten icon
  static const String icFlatten = 'assets/ic_flatten.png';

  /// Encrypt icon
  static const String icEncrypt = 'assets/ic_encrypt.png';

  /// PDF to image icon
  static const String icPdfToImg = 'assets/ic_pdf_to_img.png';

  /// Add watermark icon
  static const String icAddWatermark = 'assets/ic_add_watermark.png';

  /// Delete annotation icon
  static const String icDeleteAnnotation = 'assets/ic_delete_annotation.png';

  /// Share icon
  static const String icShare = 'assets/ic_share.png';

  /// Bookmark icon (not bookmarked)
  static const String icBookmark = 'assets/ic_bookmark.png';

  /// Bookmark icon (bookmarked)
  static const String icHasBookmark = 'assets/ic_has_bookmark.png';

  /// Print icon
  static const String icPrint = 'assets/ic_print.png';

  /// PDF info icon
  static const String icPdfInfo = 'assets/ic_pdf_info.png';

  // ============================================================
  // Settings Icons
  // ============================================================

  /// Color picker icon
  static const String icColorPicker = 'assets/ic_color_picker.png';

  /// Page number icon
  static const String icPageNumber = 'assets/ic_page_number.png';

  /// Fullscreen icon
  static const String icFullscreen = 'assets/ic_fullscreen.png';

  /// Turn pages icon
  static const String icTurnPages = 'assets/ic_turnpages.png';

  /// Screen rotation icon
  static const String icScreenRotation = 'assets/ic_screenrotation.png';

  /// View mode icon
  static const String icViewMode = 'assets/ic_viewmode.png';

  /// Crop mode icon
  static const String icCropMode = 'assets/ic_crop_mode.png';

  // ============================================================
  // Page Editor Icons
  // ============================================================

  /// Page insert icon
  static const String icPageInsert = 'assets/ic_page_insert.png';

  /// Page rotate icon
  static const String icPageRotate = 'assets/ic_page_rotate.png';

  /// Page extract icon
  static const String icPageExtract = 'assets/ic_page_extract.png';

  /// Delete icon
  static const String icDelete = 'assets/ic_delete.png';

  /// Select icon
  static const String icSelect = 'assets/ic_select.png';

  /// Select all icon
  static const String icSelectedAll = 'assets/ic_selected_all.png';

  // ============================================================
  // Paper Templates
  // ============================================================

  /// Line paper thumbnail
  static const String icPaperLineThumbnail =
      'assets/ic_paper_line_thumbnail.png';

  /// Music paper thumbnail
  static const String icPaperMusicThumbnail =
      'assets/ic_paper_music_thumbnail.png';

  /// Grid paper thumbnail
  static const String icPaperGridThumbnail =
      'assets/ic_paper_grid_thumbnail.png';

  // ============================================================
  // Empty State Icons
  // ============================================================

  /// Outline empty icon
  static const String icOutlineEmpty = 'assets/ic_outline_empty.png';

  /// Annotations empty icon
  static const String icAnnotationsEmpty = 'assets/ic_annotations_empty.png';

  /// Bookmark empty icon
  static const String icBookmarkEmpty = 'assets/ic_bookmark_empty.png';

  // ============================================================
  // Annotation Icons (SVG)
  // ============================================================

  /// Note annotation icon
  static const String icAnnotNote = 'assets/ic_annot_note.svg';

  /// Highlight annotation icon
  static const String icAnnotHighlight = 'assets/ic_annot_highlight.svg';

  /// Highlight annotation color icon
  static const String icAnnotHighlightColor =
      'assets/ic_annot_highlight_color.svg';

  /// Underline annotation icon
  static const String icAnnotUnderline = 'assets/ic_annot_underline.svg';

  /// Underline annotation color icon
  static const String icAnnotUnderlineColor =
      'assets/ic_annot_underline_color.svg';

  /// Squiggly annotation icon
  static const String icAnnotSquiggly = 'assets/ic_annot_squiggly.svg';

  /// Squiggly annotation color icon
  static const String icAnnotSquigglyColor =
      'assets/ic_annot_squiggly_color.svg';

  /// Strikeout annotation icon
  static const String icAnnotStrikeout = 'assets/ic_annot_strikeout.svg';

  /// Strikeout annotation color icon
  static const String icAnnotStrikeoutColor =
      'assets/ic_annot_strikeout_color.svg';

  /// Ink annotation icon
  static const String icAnnotInk = 'assets/ic_annot_ink.svg';

  /// Ink annotation color icon
  static const String icAnnotInkColor = 'assets/ic_annot_ink_color.svg';

  /// Rectangle annotation icon
  static const String icAnnotRec = 'assets/ic_annot_rec.svg';

  /// Oval annotation icon
  static const String icAnnotOval = 'assets/ic_annot_oval.svg';

  /// Arrow annotation icon
  static const String icAnnotArrow = 'assets/ic_annot_arrow.svg';

  /// Line annotation icon
  static const String icAnnotLine = 'assets/ic_annot_line.svg';

  /// Signature annotation icon
  static const String icAnnotSign = 'assets/ic_annot_sign.svg';

  /// Text annotation icon
  static const String icAnnotText = 'assets/ic_annot_text.svg';

  /// Stamp annotation icon
  static const String icAnnotStamp = 'assets/ic_annot_stamp.svg';

  /// Voice annotation icon
  static const String icAnnotVoice = 'assets/ic_annot_voice.svg';

  /// Link annotation icon
  static const String icAnnotLink = 'assets/ic_annot_link.svg';

  /// Image annotation icon
  static const String icAnnotImage = 'assets/ic_annot_image.svg';

  // ============================================================
  // Other Icons
  // ============================================================

  /// Properties icon
  static const String icProperties = 'assets/ic_properties.png';
}
