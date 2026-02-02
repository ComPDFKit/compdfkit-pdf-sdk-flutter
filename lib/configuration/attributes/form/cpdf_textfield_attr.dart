// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

import '../../cpdf_options.dart';
import '../cpdf_annot_attr_base.dart';

class CPDFTextFieldAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFFormType.textField.name;

  final Color? fillColor;

  /// The border color, the default is: [Color(0xFF1460F3)]
  final Color? borderColor;

  /// The border width, the default is: 2
  /// border thickness, value range:0~10
  final double? borderWidth;

  /// The text color, the default is: [Colors.black]
  final Color? fontColor;

  /// The font size, the default is: 20
  /// value range:1~100
  final double? fontSize;

  final CPDFAlignment? alignment;

  /// Whether the text can be multiple lines.
  final bool? multiline;

  final String? familyName;

  final String? styleName;

  const CPDFTextFieldAttr(
      {this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.fontColor = Colors.black,
      this.fontSize = 20,
      this.alignment = CPDFAlignment.left,
      this.multiline = true,
      this.familyName = 'Helvetica',
      this.styleName = ''});

  CPDFTextFieldAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    Color? fontColor,
    double? fontSize,
    CPDFAlignment? alignment,
    bool? multiline,
    String? familyName,
    String? styleName,
  }) {
    return CPDFTextFieldAttr(
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        fontColor: fontColor ?? this.fontColor,
        fontSize: fontSize ?? this.fontSize,
        alignment: alignment ?? this.alignment,
        multiline: multiline ?? this.multiline,
        familyName: familyName ?? this.familyName,
        styleName: styleName ?? this.styleName);
  }

  factory CPDFTextFieldAttr.fromJson(Map<String, dynamic> json) {
    return CPDFTextFieldAttr(
        fillColor: HexColor.fromHex(json['fillColor']),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: json['borderWidth'],
        fontColor: HexColor.fromHex(json['fontColor']),
        fontSize: json['fontSize'],
        alignment: CPDFAlignment.fromString(json['alignment']),
        multiline: json['multiline'],
        familyName: json['familyName'] ?? 'Helvetica',
        styleName: json['styleName'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'fontColor': fontColor?.toHex(),
      'fontSize': fontSize,
      'alignment': alignment?.name,
      'multiline': multiline,
      'familyName': familyName,
      'styleName': styleName
    };
  }
}
