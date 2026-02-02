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

class CPDFPushButtonAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFFormType.pushButton.name;

  final String? title;

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

  final String? familyName;

  final String? styleName;

  const CPDFPushButtonAttr(
      {this.title = 'Button',
      this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.fontColor = Colors.black,
      this.fontSize = 20,
      this.familyName = 'Helvetica',
      this.styleName = ''});

  CPDFPushButtonAttr copyWith({
    String? title,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    Color? fontColor,
    double? fontSize,
    String? familyName,
    String? styleName,
  }) {
    return CPDFPushButtonAttr(
        title: title ?? this.title,
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        fontColor: fontColor ?? this.fontColor,
        fontSize: fontSize ?? this.fontSize,
        familyName: familyName ?? this.familyName,
        styleName: styleName ?? this.styleName);
  }

  factory CPDFPushButtonAttr.fromJson(Map<String, dynamic> json) {
    return CPDFPushButtonAttr(
        title: json['title'] as String?,
        fillColor: HexColor.fromHex(json['fillColor']),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: json['borderWidth'] ?? 2,
        fontColor: HexColor.fromHex(json['fontColor']),
        fontSize: json['fontSize'] ?? 20,
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
      'familyName': familyName,
      'styleName': styleName,
      'title': title
    };
  }
}
