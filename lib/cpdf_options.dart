///
///  Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.
///

enum CPreviewMode { viewer, annotations, contentEditor, forms, signatures }

/// The [ToolbarAction.back] button will only be displayed on the leftmost side of the top toolbar on the Android platform
enum ToolbarAction { back, thumbnail, search, bota, menu }

enum ToolbarMenuAction {
  viewSettings,
  documentEditor,
  security,
  watermark,
  flattened,
  documentInfo,
  save,
  share,
  openDocument
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

enum CPDFFormConfigTool { undo, redo }

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
