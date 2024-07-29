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
  light,

  /// dark mode, readerview background is black
  dark,

  /// brown paper color
  sepia,

  /// Light green, eye protection mode
  reseda
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

/// The [CPDFEdgeInsets] is used to set the padding of the PDF document.
///
/// [Android] can only set horizontal margins, [top] and [bottom] margins.
/// Horizontal spacing cannot be set independently.
/// The horizontal spacing value is set using the [left] attribute,
/// the spacing between two pages is the same as the top spacing.
///
/// The [iOS] platform can set the [top], [bottom], [left] and [right] margins,
/// and the spacing between two pages is the same as the top spacing.
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