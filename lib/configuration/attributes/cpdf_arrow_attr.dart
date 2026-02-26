// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/attributes/cpdf_annot_attr_base.dart';
import 'package:flutter/material.dart';

import '../../annotation/cpdf_border_style.dart';
import '../../util/extension/cpdf_color_extension.dart';
import '../cpdf_options.dart';

class CPDFArrowAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFAnnotationType.arrow.name;

  /// The color of the border.
  final Color borderColor;

  /// Fill color and border color transparency.<br/>
  /// Range: 0-255.
  final double borderAlpha;

  /// border thickness, value range:1~10
  final double borderWidth;

  /// Set the border style to dashed or solid.
  final CPDFBorderStyle? borderStyle;

  final CPDFLineType? headType;

  /// Arrow tail position shape.
  final CPDFLineType? tailType;

  const CPDFArrowAttr({
    this.borderColor = Colors.black,
    this.borderAlpha = 128,
    this.borderWidth = 2,
    this.borderStyle = const CPDFBorderStyle.solid(),
    this.headType = CPDFLineType.none,
    this.tailType = CPDFLineType.openArrow,
  });

  CPDFArrowAttr copyWith({
    Color? borderColor,
    double? borderAlpha,
    double? borderWidth,
    CPDFBorderStyle? borderStyle,
    CPDFLineType? headType,
    CPDFLineType? tailType,
  }) {
    return CPDFArrowAttr(
      borderColor: borderColor ?? this.borderColor,
      borderAlpha: borderAlpha ?? this.borderAlpha,
      borderWidth: borderWidth ?? this.borderWidth,
      borderStyle: borderStyle ?? this.borderStyle,
      headType: headType ?? this.headType,
      tailType: tailType ?? this.tailType,
    );
  }

  static CPDFArrowAttr fromJson(Map<String, dynamic> json) {
    return CPDFArrowAttr(
      borderColor: HexColor.fromHex(json['borderColor']),
      borderAlpha: json['borderAlpha'] ?? 128,
      borderWidth: json['borderWidth'] ?? 2.0,
      borderStyle: json['borderStyle'] != null
          ? CPDFBorderStyle(
              style: CPDFAnnotBorderStyle.values
                  .firstWhere((e) => e.name == json['borderStyle']['style']),
              dashGap: json['borderStyle']['dashGap'] ?? 0)
          : const CPDFBorderStyle.solid(),
      headType: CPDFLineType.fromString(json['startLineType']),
      tailType: CPDFLineType.fromString(json['tailLineType']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'borderColor': borderColor.toHex(),
        'borderAlpha': borderAlpha,
        'borderWidth': borderWidth,
        'borderStyle': borderStyle?.toJson(),
        'startLineType': headType?.name,
        'tailLineType': tailType?.name,
      };
}
