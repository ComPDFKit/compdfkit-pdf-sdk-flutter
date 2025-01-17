// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:flutter/material.dart';

import '../cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

abstract class CPDFAnnotAttrBase {
  const CPDFAnnotAttrBase();

  Map<String, dynamic> toJson();
}

/// note annotation attribute parameter class
class CPDFTextAttr extends CPDFAnnotAttrBase {
  /// note icon color
  final Color? color;

  /// Color transparency.<br/>
  /// Value Range:0-255.
  final int? alpha;

  const CPDFTextAttr({this.color = const Color(0xFF1460F3), this.alpha = 255});

  @override
  Map<String, dynamic> toJson() => {'color': color?.toHex(), 'alpha': alpha};
}

class CPDFMarkupAttr extends CPDFAnnotAttrBase {
  /// note icon color
  final Color? color;

  /// Color transparency.<br/>
  /// Value Range:0-255.
  final int? alpha;

  const CPDFMarkupAttr({this.color = const Color(0xFF1460F3), this.alpha = 77});

  @override
  Map<String, dynamic> toJson() => {'color': color?.toHex(), 'alpha': alpha};
}

typedef CPDFHighlightAttr = CPDFMarkupAttr;
typedef CPDFUnderlineAttr = CPDFMarkupAttr;
typedef CPDFStrikeoutAttr = CPDFMarkupAttr;
typedef CPDFSquigglyAttr = CPDFMarkupAttr;

class CPDFInkAttr extends CPDFAnnotAttrBase {
  /// note icon color
  final Color? color;

  /// Color transparency.<br/>
  /// Value Range:0-255.
  final int? alpha;

  /// border width.
  /// Value Range:1~10.
  final int borderWidth;

  const CPDFInkAttr(
      {this.color = const Color(0xFF1460F3),
      this.alpha = 255,
      this.borderWidth = 10});

  @override
  Map<String, dynamic> toJson() =>
      {'color': color?.toHex(), 'alpha': alpha, 'borderWidth': borderWidth};
}

class CPDFShapeAttr extends CPDFAnnotAttrBase {
  final Color? fillColor;

  final Color? borderColor;

  /// Fill color and border color transparency.<br/>
  /// Range: 0-255.
  final int? colorAlpha;

  /// border thickness, value range:1~10
  final int? borderWidth;

  /// Set the border style to dashed or solid.
  final CPDFBorderStyle? borderStyle;

  const CPDFShapeAttr(
      {this.fillColor = const Color(0xFF1460F3),
      this.borderColor = Colors.black,
      this.colorAlpha = 128,
      this.borderWidth = 2,
      this.borderStyle = const CPDFBorderStyle.solid()});

  @override
  Map<String, dynamic> toJson() => {
        'fillColor': fillColor?.toHex(),
        'borderColor': borderColor?.toHex(),
        'colorAlpha': colorAlpha,
        'borderWidth': borderWidth,
        'borderStyle': borderStyle?.toJson()
      };
}

typedef CPDFSquareAttr = CPDFShapeAttr;
typedef CPDFCircleAttr = CPDFShapeAttr;

class CPDFLineAttr extends CPDFShapeAttr {
  const CPDFLineAttr({
    super.fillColor = const Color(0xFF1460F3),
    super.borderColor = Colors.black,
    super.colorAlpha = 128,
    super.borderWidth = 2,
    super.borderStyle = const CPDFBorderStyle.solid(),
  });

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'startLineType': CPDFLineType.none.name,
        'tailLineType': CPDFLineType.none.name
      });
  }
}

class CPDFArrowAttr extends CPDFShapeAttr {
  /// Arrow starting position shape.
  final CPDFLineType? headType;

  /// Arrow tail position shape.
  final CPDFLineType? tailType;

  const CPDFArrowAttr({
    super.fillColor = const Color(0xFF1460F3),
    super.borderColor = Colors.black,
    super.colorAlpha = 128,
    super.borderWidth = 2,
    super.borderStyle = const CPDFBorderStyle.solid(),
    this.headType = CPDFLineType.none,
    this.tailType = CPDFLineType.openArrow,
  });

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll(
          {'startLineType': headType?.name, 'tailLineType': tailType?.name});
  }
}

class CPDFFreetextAttr extends CPDFAnnotAttrBase {
  final Color? fontColor;

  /// text color opacity. value range:0~255
  final int? fontColorAlpha;

  /// font size, value range:1~100
  final int? fontSize;

  /// Whether the font is bold.
  final bool? isBold;

  /// Is the font italicized.
  final bool? isItalic;

  /// Text alignment, [CPDFAlignment.left] aligned by default.
  final CPDFAlignment? alignment;

  /// The font used by default for text. The default is:[CPDFTypeface.helvetica].
  final CPDFTypeface? typeface;

  const CPDFFreetextAttr({
    this.fontColor = Colors.black,
    this.fontColorAlpha = 255,
    this.fontSize = 30,
    this.isBold = false,
    this.isItalic = false,
    this.alignment = CPDFAlignment.left,
    this.typeface = CPDFTypeface.helvetica,
  });

  @override
  Map<String, dynamic> toJson() => {
        'fontColor': fontColor?.toHex(),
        'fontColorAlpha': fontColorAlpha,
        'fontSize': fontSize,
        'isBold': isBold,
        'isItalic': isItalic,
        'alignment': alignment?.name,
        'typeface': typeface?.getFontName(),
      };
}

class CPDFBorderStyle {
  /// default: [CPDFAnnotBorderStyle.solid]
  final CPDFAnnotBorderStyle style;

  /// Dashed gap, only style=[CPDFAnnotBorderStyle.dashed] is valid.
  final double dashGap;

  const CPDFBorderStyle(
      {this.style = CPDFAnnotBorderStyle.solid, this.dashGap = 8.0});

  const CPDFBorderStyle.solid()
      : style = CPDFAnnotBorderStyle.solid,
        dashGap = 0;

  const CPDFBorderStyle.dashed({this.dashGap = 9.0})
      : style = CPDFAnnotBorderStyle.dashed;

  Map<String, dynamic> toJson() => {'style': style.name, 'dashGap': dashGap};
}

class CPDFEditorTextAttr extends CPDFAnnotAttrBase {
  final Color fontColor;

  /// text color opacity. value range:0~255
  final int fontColorAlpha;

  /// font size, value range:1~100
  final int fontSize;

  /// Whether the font is bold.
  final bool isBold;

  /// Is the font italicized.
  final bool isItalic;

  /// The font used by default for text. The default is:[CPDFTypeface.helvetica].
  final CPDFTypeface typeface;

  /// Text alignment, [CPDFAlignment.left] aligned by default.
  final CPDFAlignment alignment;

  const CPDFEditorTextAttr(
      {this.fontColor = Colors.black,
      this.fontColorAlpha = 255,
      this.fontSize = 30,
      this.isBold = false,
      this.isItalic = false,
      this.typeface = CPDFTypeface.helvetica,
      this.alignment = CPDFAlignment.left});

  @override
  Map<String, dynamic> toJson() => {
        'fontColor': fontColor.toHex(),
        'fontColorAlpha': fontColorAlpha,
        'fontSize': fontSize,
        'isBold': isBold,
        'isItalic': isItalic,
        'typeface': typeface.getFontName(),
        'alignment': alignment.name
      };
}

class CPDFTextFieldAttr extends CPDFAnnotAttrBase {
  final Color? fillColor;

  /// The border color, the default is: [Color(0xFF1460F3)]
  final Color? borderColor;

  /// The border width, the default is: 2
  /// border thickness, value range:0~10
  final int? borderWidth;

  /// The text color, the default is: [Colors.black]
  final Color? fontColor;

  /// The font size, the default is: 20
  /// value range:1~100
  final int? fontSize;

  final bool? isBold;

  final bool? isItalic;

  final CPDFAlignment? alignment;

  /// Whether the text can be multiple lines.
  final bool? multiline;

  final CPDFTypeface? typeface;

  const CPDFTextFieldAttr(
      {this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.fontColor = Colors.black,
      this.fontSize = 20,
      this.isBold = false,
      this.isItalic = false,
      this.alignment = CPDFAlignment.left,
      this.multiline = true,
      this.typeface = CPDFTypeface.helvetica});

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'fontColor': fontColor?.toHex(),
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'alignment': alignment?.name,
      'multiline': multiline,
      'typeface': typeface?.getFontName()
    };
  }
}

class CPDFCheckBoxAttr extends CPDFAnnotAttrBase {
  final Color? fillColor;

  final Color? borderColor;

  /// border thickness, value range:0~10
  final int? borderWidth;

  final Color? checkedColor;

  final bool? isChecked;

  final CPDFCheckStyle? checkedStyle;

  const CPDFCheckBoxAttr(
      {this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.checkedColor = const Color(0xFF43474D),
      this.isChecked = false,
      this.checkedStyle = CPDFCheckStyle.check});

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'checkedColor': checkedColor?.toHex(),
      'isChecked': false,
      'checkedStyle': checkedStyle?.name
    };
  }
}

class CPDFRadioButtonAttr extends CPDFCheckBoxAttr {
  const CPDFRadioButtonAttr(
      {super.fillColor = const Color(0xFFDDE9FF),
      super.borderColor = const Color(0xFF1460F3),
      super.borderWidth = 2,
      super.checkedColor = const Color(0xFF43474D),
      super.isChecked = false,
      super.checkedStyle = CPDFCheckStyle.circle});
}

class CPDFListBoxAttr extends CPDFAnnotAttrBase {
  final Color? fillColor;

  /// The border color, the default is: [Color(0xFF1460F3)]
  final Color? borderColor;

  /// The border width, the default is: 2
  /// border thickness, value range:0~10
  final int? borderWidth;

  /// The text color, the default is: [Colors.black]
  final Color? fontColor;

  /// The font size, the default is: 20
  /// value range:1~100
  final int? fontSize;

  final bool? isBold;

  final bool? isItalic;

  final CPDFTypeface? typeface;

  const CPDFListBoxAttr(
      {this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.fontColor = Colors.black,
      this.fontSize = 20,
      this.isBold = false,
      this.isItalic = false,
      this.typeface = CPDFTypeface.helvetica});

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'fontColor': fontColor?.toHex(),
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'typeface': typeface?.getFontName()
    };
  }
}

class CPDFComboBoxAttr extends CPDFListBoxAttr {
  const CPDFComboBoxAttr(
      {super.fillColor = const Color(0xFFDDE9FF),
      super.borderColor = const Color(0xFF1460F3),
      super.borderWidth = 2,
      super.fontColor = Colors.black,
      super.fontSize = 20,
      super.isBold = false,
      super.isItalic = false,
      super.typeface = CPDFTypeface.helvetica});
}

class CPDFPushButtonAttr extends CPDFAnnotAttrBase {
  final String? title;

  final Color? fillColor;

  /// The border color, the default is: [Color(0xFF1460F3)]
  final Color? borderColor;

  /// The border width, the default is: 2
  /// border thickness, value range:0~10
  final int? borderWidth;

  /// The text color, the default is: [Colors.black]
  final Color? fontColor;

  /// The font size, the default is: 20
  /// value range:1~100
  final int? fontSize;

  final bool? isBold;

  final bool? isItalic;

  final CPDFTypeface? typeface;

  const CPDFPushButtonAttr({
    this.title = 'Button',
    this.fillColor = const Color(0xFFDDE9FF),
    this.borderColor = const Color(0xFF1460F3),
    this.borderWidth = 2,
    this.fontColor = Colors.black,
    this.fontSize = 20,
    this.typeface = CPDFTypeface.helvetica,
    this.isBold = false,
    this.isItalic = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'fontColor': fontColor?.toHex(),
      'fontSize': fontSize,
      'typeface': typeface?.getFontName(),
      'isBold': isBold,
      'isItalic': isItalic,
      'title': title
    };
  }
}

class CPDFSignatureWidgetAttr extends CPDFAnnotAttrBase {

  final Color? fillColor;

  final Color? borderColor;

  final int? borderWidth;

  const CPDFSignatureWidgetAttr({
    this.fillColor = const Color(0xFFDDE9FF),
    this.borderColor = const Color(0xFF1460F3),
    this.borderWidth = 2,
  });


  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
    };
  }
}

