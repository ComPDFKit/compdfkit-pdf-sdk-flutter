// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


enum CPDFViewMode { viewer, annotations, contentEditor, forms, signatures }

/// The [CPDFToolbarAction.back] button will only be displayed on the leftmost side of the top toolbar on the Android platform
enum CPDFToolbarAction { back, thumbnail, search, bota, menu }

enum CPDFToolbarMenuAction {
  viewSettings,
  documentEditor,
  security,
  watermark,
  flattened,
  documentInfo,
  save,
  share,
  openDocument,

  /// The PDF capture function allows you to capture an area
  /// in the PDF document and convert it into an image.
  snip
}

enum CPDFDisplayMode { singlePage, doublePage, coverPage }

/// readerView background themes
enum CPDFThemes {
  /// Bright mode, readerview background is white
  light('#FFFFFF'),

  /// dark mode, readerview background is black
  dark('#000000'),

  /// brown paper color
  sepia('#FFEFBE'),

  /// Light green, eye protection mode
  reseda('#CDE6D0');

  final String color;

  const CPDFThemes(this.color);

  // 获取颜色值
  String getColor() {
    return color;
  }

}

enum CPDFAnnotationType {
  note,
  highlight,
  underline,
  squiggly,
  strikeout,
  ink,
  // only ios platform
  pencil,
  circle,
  square,
  arrow,
  line,
  freetext,
  signature,
  stamp,
  pictures,
  link,
  sound
}

enum CPDFConfigTool { setting, undo, redo }

enum CPDFAnnotBorderStyle { solid, dashed }

enum CPDFLineType { none, openArrow, closedArrow, square, circle, diamond }

enum CPDFAlignment { left, center, right }

enum CPDFTypeface { courier, helvetica, timesRoman }

extension CPDFTypefaceExtension on CPDFTypeface {
  String getFontName() {
    switch (name) {
      case 'courier':
        return 'Courier';
      case 'helvetica':
        return 'Helvetica';
      case 'timesRoman':
        return 'Times-Roman';
      default:
        return 'Courier';
    }
  }
}

extension CPDFTypefaceEnumExten on Iterable<CPDFTypeface> {
  CPDFTypeface byFontName(String fontName) {
    switch (fontName.toLowerCase()) {
      case 'courier':
        return CPDFTypeface.courier;
      case 'helvetica':
        return CPDFTypeface.helvetica;
      case 'times-roman':
        return CPDFTypeface.timesRoman;
      default:
        return CPDFTypeface.courier;
    }
  }
}

enum CPDFContentEditorType { editorText, editorImage }

enum CPDFFormType {
  textField,
  checkBox,
  radioButton,
  listBox,
  comboBox,
  signaturesFields,
  pushButton
}

enum CPDFCheckStyle { check, circle, cross, diamond, square, star }

enum CPDFThemeMode { light, dark, system }

/// [CPDFEdgeInsets] defines the padding for a PDF document.
///
/// - On **Android**, you can set individual margins for [top], [bottom], [left], and [right].
///   To adjust the spacing between pages, use the `setPageSpacing()` method.
///
/// - On **iOS**, you can also configure [top], [bottom], [left], and [right] margins.
///   The spacing between pages is equal to the [top] margin.
class CPDFEdgeInsets {

  final int left;

  final int top;

  final int right;

  final int bottom;

  const CPDFEdgeInsets.all(int value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const CPDFEdgeInsets.symmetric(
      {required int horizontal, required int vertical})
      : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const CPDFEdgeInsets.only(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
      };
}


enum CPDFDocumentPermissions {

  none,

  user,

  owner

}

/// Error types of the opening document.
enum CPDFDocumentError {
  /// No read permission.
  noReadPermission,

  /// SDK No verified license
  notVerifyLicense,

  /// open document success.
  success,

  /// Unknown error
  unknown,

  /// File not found or could not be opened.
  errorFile,

  /// File not in PDF format or corrupted.
  errorFormat,

  /// Password required or incorrect password.
  errorPassword,

  /// Unsupported security scheme.
  errorSecurity,

  /// Error page.
  errorPage

}