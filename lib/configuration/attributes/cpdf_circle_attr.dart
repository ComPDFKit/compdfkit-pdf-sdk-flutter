// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/configuration/attributes/cpdf_shape_attr.dart';

import '../../annotation/cpdf_border_style.dart';
import '../../util/extension/cpdf_color_extension.dart';
import '../cpdf_options.dart';

class CPDFCircleAttr extends CPDFShapeAttr {
  @override
  String get type => CPDFAnnotationType.circle.name;

  const CPDFCircleAttr(
      {super.fillColor,
      super.borderColor,
      super.colorAlpha,
      super.borderWidth,
      super.borderStyle});

  CPDFCircleAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? colorAlpha,
    double? borderWidth,
    CPDFBorderStyle? borderStyle,
  }) {
    return CPDFCircleAttr(
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        colorAlpha: colorAlpha ?? this.colorAlpha,
        borderWidth: borderWidth ?? this.borderWidth,
        borderStyle: borderStyle ?? this.borderStyle);
  }

  static CPDFCircleAttr fromJson(Map<String, dynamic> json) {
    return CPDFCircleAttr(
      fillColor: HexColor.fromHex(json['fillColor']),
      borderColor: HexColor.fromHex(json['borderColor']),
      colorAlpha: json['colorAlpha'] ?? 128,
      borderWidth: json['borderWidth'] ?? 2.0,
      borderStyle: json['borderStyle'] != null
          ? CPDFBorderStyle(
              style: CPDFAnnotBorderStyle.values
                  .firstWhere((e) => e.name == json['borderStyle']['style']),
              dashGap: json['borderStyle']['dashGap'] ?? 0)
          : const CPDFBorderStyle.solid(),
    );
  }
}
