// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

import '../cpdf_options.dart';
import 'cpdf_annot_attr_base.dart';

class CPDFEditorTextAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFContentEditorType.editorText.name;

  final Color fontColor;

  /// text color opacity. value range:0~255
  final double fontColorAlpha;

  /// font size, value range:1~100
  final double fontSize;

  final String? familyName;

  final String? styleName;

  /// Text alignment, [CPDFAlignment.left] aligned by default.
  final CPDFAlignment alignment;

  const CPDFEditorTextAttr(
      {this.fontColor = Colors.black,
      this.fontColorAlpha = 255,
      this.fontSize = 30,
      this.familyName = 'Helvetica',
      this.styleName = '',
      this.alignment = CPDFAlignment.left});

  CPDFEditorTextAttr copyWith({
    Color? fontColor,
    double? fontColorAlpha,
    double? fontSize,
    String? familyName,
    String? styleName,
    CPDFAlignment? alignment,
  }) {
    return CPDFEditorTextAttr(
        fontColor: fontColor ?? this.fontColor,
        fontColorAlpha: fontColorAlpha ?? this.fontColorAlpha,
        fontSize: fontSize ?? this.fontSize,
        familyName: familyName ?? this.familyName,
        styleName: styleName ?? this.styleName,
        alignment: alignment ?? this.alignment);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'fontColor': fontColor.toHex(),
        'fontColorAlpha': fontColorAlpha,
        'fontSize': fontSize,
        'familyName': familyName,
        'styleName': styleName,
        'alignment': alignment.name
      };
}
