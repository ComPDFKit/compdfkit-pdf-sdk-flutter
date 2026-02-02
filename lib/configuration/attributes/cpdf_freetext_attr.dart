// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../../util/extension/cpdf_color_extension.dart';
import '../cpdf_options.dart';
import 'cpdf_annot_attr_base.dart';

class CPDFFreetextAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFAnnotationType.freetext.name;

  final Color fontColor;

  /// text color opacity. value range:0~255
  final double fontColorAlpha;

  /// font size, value range:1~100
  final double fontSize;

  /// Text alignment, [CPDFAlignment.left] aligned by default.
  final CPDFAlignment? alignment;

  final String familyName;

  final String styleName;

  const CPDFFreetextAttr({
    this.fontColor = Colors.black,
    this.fontColorAlpha = 255,
    this.fontSize = 30,
    this.alignment = CPDFAlignment.left,
    this.familyName = 'Helvetica',
    this.styleName = '',
  });

  CPDFFreetextAttr copyWith({
    Color? fontColor,
    double? fontColorAlpha,
    double? fontSize,
    CPDFAlignment? alignment,
    String? familyName,
    String? styleName,
  }) {
    return CPDFFreetextAttr(
      fontColor: fontColor ?? this.fontColor,
      fontColorAlpha: fontColorAlpha ?? this.fontColorAlpha,
      fontSize: fontSize ?? this.fontSize,
      alignment: alignment ?? this.alignment,
      familyName: familyName ?? this.familyName,
      styleName: styleName ?? this.styleName,
    );
  }

  factory CPDFFreetextAttr.fromJson(Map<String, dynamic> json) {
    return CPDFFreetextAttr(
      fontColor: HexColor.fromHex(json['fontColor']),
      fontColorAlpha: json['fontColorAlpha'] ?? 255,
      fontSize: json['fontSize'] ?? 30,
      alignment: json['alignment'] != null
          ? CPDFAlignment.fromString(json['alignment'])
          : CPDFAlignment.left,
      familyName: json['familyName'] ?? 'Helvetica',
      styleName: json['styleName'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'fontColor': fontColor.toHex(),
        'fontColorAlpha': fontColorAlpha,
        'fontSize': fontSize,
        'alignment': alignment?.name,
        'familyName': familyName,
        'styleName': styleName,
      };
}
