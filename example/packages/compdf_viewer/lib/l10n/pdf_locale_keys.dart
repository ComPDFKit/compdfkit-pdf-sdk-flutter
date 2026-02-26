// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Localization keys for the PDF viewer package.
///
/// Use these constants with GetX translations to display localized strings.
/// Keys are organized by feature area for easier maintenance.
///
/// Example:
/// ```dart
/// import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
///
/// // Display translated text
/// Text(PdfLocaleKeys.save.tr);
///
/// // Use in button labels
/// ElevatedButton(
///   onPressed: () {},
///   child: Text(PdfLocaleKeys.confirm.tr),
/// );
/// ```
///
/// Supported languages:
/// - English (en_US)
/// - Chinese (zh_CN)
class PdfLocaleKeys {
  // ============================================================
  // Page Navigation
  // ============================================================

  /// Page indicator jump popup
  static const String pageJump = 'page_jump';
  static const String enterPageHint = 'enter_page_hint';
  static const String cancel = 'cancel';
  static const String jump = 'jump';

  // ============================================================
  // File Operations
  // ============================================================

  /// File operation
  static const String fileOperation = 'file_operation';
  static const String pageSetting = 'page_setting';
  static const String selectACustomColor = 'select_a_custom_color';
  static const String save = 'save';
  static const String saveAs = 'save_as';
  static const String saveAsFlattenedCopy = 'save_as_flattened_copy';
  static const String setPwd = 'set_pwd';
  static const String changePwd = 'change_pwd';
  static const String passwordMode = 'password_mode';
  static const String pleaseEnterPassword = 'please_enter_password';
  static const String pleaseEnterPasswordAgain = 'please_enter_password_again';
  static const String password = 'password';
  static const String pdfToJpg = 'pdf_to_jpg';
  static const String addWatermark = 'add_watermark';
  static const String deleteAllAnnotation = 'delete_all_annotation';
  static const String setPasswordEmpty = 'set_password_empty';
  static const String setVerifyPasswordEmpty = 'set_verify_password_empty';
  static const String setPasswordDiff = 'set_password_diff';

  // ============================================================
  // Reading Settings
  // ============================================================

  /// PDF reading page - sidebar reading settings
  static const String cropMode = 'crop_mode';
  static const String rotationSettings = 'rotation_settings';
  static const String fullScreen = 'full_screen';
  static const String scrollPages = 'scroll_pages';
  static const String viewMode = 'view_mode';
  static const String showPageNum = 'show_page_num';
  static const String followSystem = 'follow_system';
  static const String autoRotate = 'auto_rotate';
  static const String lockScreen = 'lock_screen';
  static const String verticalContinuous = 'vertical_continuous';
  static const String verticalDiscontinuous = 'vertical_discontinuous';
  static const String horizontalContinuous = 'horizontal_continuous';
  static const String horizontalDiscontinuous = 'horizontal_discontinuous';
  static const String singlePage = 'single_page';
  static const String twoPage = 'two_page';
  static const String bookMode = 'book_mode';
  static const String pageNumberShown = 'page_number_shown';

  // ============================================================
  // BOTA (Bookmarks, Outlines, Thumbnails, Annotations)
  // ============================================================

  /// BOTA interface related
  static const String botaTitle = 'bota_title';
  static const String annotation = 'annotation';
  static const String outline = 'outline';
  static const String bookmark = 'bookmark';
  static const String page = 'page';

  /// Annotation deletion popup operations
  static const String confirm = 'confirm';
  static const String delete = 'delete';
  static const String deleteAnnotationConfirm = 'delete_annotation_confirm';
  static const String noAnnotationYet = 'no_annotation_yet';
  static const String noOutlineYet = 'no_outline_yet';
  static const String noBookmarkYet = 'no_bookmark_yet';
  static const String deleteBookmarkConfirm = 'delete_bookmark_confirm';
  static const String tips = 'tips';
  static const String pleaseInputBookmarkName = 'please_input_bookmark_name';
  static const String inputBookmarkTextFieldHint =
      'input_bookmark_text_field_hint';
  static const String edit = 'edit';
  static const String thumbnail = 'thumbnail';
  static const String finish = 'finish';
  static const String insert = 'insert';
  static const String rotate = 'rotate';
  static const String extract = 'extract';
  static const String blankPage = 'blank_page';
  static const String pdfPage = 'pdf_page';
  static const String horizontalLine = 'horizontal_line';
  static const String musicalNotation = 'musical_notation';
  static const String square = 'square';

  // ============================================================
  // Page Insertion
  // ============================================================

  /// Page size options
  static const String insertPages = 'insert_pages';
  static const String pageSize = 'page_size';
  static const String pageSizeA4 = 'page_size_a4';
  static const String pageSizeA3 = 'page_size_a3';
  static const String pageSizeLatter = 'page_size_latter';
  static const String pageSizeLegal = 'page_size_legal';
  static const String pageSizeLedger = 'page_size_ledger';
  static const String direction = 'direction';
  static const String portrait = 'portrait';
  static const String landscape = 'landscape';
  static const String inputPassword = 'input_password';
  static const String passwordError = 'password_error';
  static const String extractPDFMsg = 'extract_pdf_msg';
  static const String viewNow = 'check';
  static const String cantDeleteAll = 'cant_delete_all';

  // ============================================================
  // Document Information
  // ============================================================

  /// Document information
  static const String fileInfo = 'file_info';
  static const String abstract = 'abstract';
  static const String createInfo = 'create_info';
  static const String accessPer = 'access_per';
  static const String fileName = 'file_name';
  static const String fileSize = 'file_size';
  static const String title = 'title';
  static const String author = 'author';
  static const String version = 'version';
  static const String pageCount = 'page_count';
  static const String creator = 'creator';
  static const String producer = 'producer';
  static const String creationDate = 'creation_date';
  static const String modificationDate = 'modification_date';
  static const String encrypted = 'encrypted';
  static const String unlocked = 'unlocked';
  static const String allowCopy = 'allow_copy';
  static const String allowPrint = 'allow_print';
  static const String no = 'no';
  static const String yes = 'yes';
  static const String searchText = 'search_text';
  static const String searchResults = 'search_results';
  static const String noSearchResults = 'no_search_results';
  static const String saveSuccess = 'save_success';
  static const String saveFail = 'save_fail';

  // ============================================================
  // PDF to Image
  // ============================================================

  // PDF to image
  static const String pageRange = 'page_range';
  static const String exportAnnotation = 'export_annotation';
  static const String pageChooseTitle = 'page_choose_title';
  static const String pageChooseAll = 'page_choose_all';
  static const String pageChooseOdd = 'page_choose_odd';
  static const String pageChooseEven = 'page_choose_even';
  static const String pageChooseCurrent = 'page_choose_current';
  static const String pageChoosePageRange = 'page_choose_page_range';
  static const String pageChoosePageRangeInputError =
      'page_choose_page_range_input_error';
  static const String savedTo = 'saved_to';
}
