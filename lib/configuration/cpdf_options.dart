// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

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
  light('#FFFFFFFF'),

  /// dark mode, readerview background is black
  dark('#FF000000'),

  /// brown paper color
  sepia('#FFFFEFBE'),

  /// Light green, eye protection mode
  reseda('#FFCDE6D0');

  final String color;

  const CPDFThemes(this.color);

  // 根据 Color 对象获取对应的 CPDFThemes
  static CPDFThemes of(Color color) {
    return CPDFThemes.values.firstWhere(
      (theme) => theme.color == color.toHex().toUpperCase(),
      orElse: () => CPDFThemes.light,
    );
  }

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
  ink_eraser,
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
  sound;

  static CPDFAnnotationType fromString(String typeStr) {
    return CPDFAnnotationType.values.firstWhere(
      (e) => e.name == typeStr.toLowerCase(),
      orElse: () => throw Exception('Unknown annotation type: $typeStr'),
    );
  }
}

enum CPDFConfigTool { setting, undo, redo }

enum CPDFAnnotBorderStyle { solid, dashed }

enum CPDFLineType {
  unknown,
  none,
  openArrow,
  closedArrow,
  square,
  circle,
  diamond;

  static CPDFLineType fromString(String typeStr) {
    return CPDFLineType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown line type: $typeStr'),
    );
  }
}

enum CPDFAlignment {
  left,
  center,
  right;

  static CPDFAlignment fromString(String typeStr) {
    return CPDFAlignment.values.firstWhere(
      (e) => e.name == typeStr.toLowerCase(),
      orElse: () => throw Exception('Unknown alignment type: $typeStr'),
    );
  }
}

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
  pushButton;

  static CPDFFormType fromString(String typeStr) {
    return CPDFFormType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown form type: $typeStr'),
    );
  }
}

enum CPDFCheckStyle {
  check,
  circle,
  cross,
  diamond,
  square,
  star;

  static CPDFCheckStyle fromString(String typeStr) {
    return CPDFCheckStyle.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown check style type: $typeStr'),
    );
  }
}

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

enum CPDFDocumentPermissions { none, user, owner }

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

enum CPDFDocumentEncryptAlgo {
  // RC4 encryption algorithm.
  rc4,

  /// AES encryption with a 128-bit key.
  aes128,

  /// AES encryption with a 256-bit key.
  aes256,

  /// No encryption algorithm selected.
  noEncryptAlgo;
}

enum CPDFWatermarkType { text, image }

/// Configure the signature method for signing in viewer mode, signature mode,
/// electronic signature, digital signature or manual selection of signature method
enum CPDFFillSignatureType {
  /// Manually select electronic signature or digital signature
  manual,

  /// Digital signature
  digital,

  /// Electronic signature
  electronic
}

enum CPDFBorderEffectType {
  solid,
  cloudy;

  static CPDFBorderEffectType fromString(String typeStr) {
    return CPDFBorderEffectType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => throw Exception('Unknown border effect type: $typeStr'),
    );
  }
}
