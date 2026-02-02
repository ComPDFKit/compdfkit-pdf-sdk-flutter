// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:flutter/material.dart';

import '../../annotation/cpdf_border_style.dart';
import '../../util/extension/cpdf_color_extension.dart';
import '../cpdf_options.dart';
import 'cpdf_annot_attr_base.dart';



/// PDF Shape annotation attribute model.
///
/// Includes fill and border color, transparency, border thickness and style.
class CPDFShapeAttr extends CPDFAnnotAttrBase {

  @override
  String get type => '';
  /// The fill color of the shape.
  final Color fillColor;

  /// The color of the border.
  final Color borderColor;

  /// Fill color and border color transparency.<br/>
  /// Range: 0-255.
  final double colorAlpha;

  /// border thickness, value range:1~10
  final double borderWidth;

  /// Set the border style to dashed or solid.
  final CPDFBorderStyle? borderStyle;

  const CPDFShapeAttr(
      {this.fillColor = const Color(0xFF1460F3),
        this.borderColor = Colors.black,
        this.colorAlpha = 128,
        this.borderWidth = 2,
        this.borderStyle = const CPDFBorderStyle.solid()});

  /// Creates a [CPDFShapeAttr] instance from a JSON map.
  /// example:
  /// ```dart
  /// CPDFShapeAttr.fromJson({
  ///  'fillColor': '#FF0000',
  ///  'borderColor': '#00FF00',
  ///  'colorAlpha': 128,
  ///  'borderWidth': 2,
  ///  'borderStyle': {
  ///     'style': 'dashed',
  ///     'dashGap': 5
  ///     }
  ///  });
  /// ```
  static CPDFShapeAttr fromJson(Map<String, dynamic> json) {
    return CPDFShapeAttr(
      fillColor: HexColor.fromHex(json['fillColor']),
      borderColor: HexColor.fromHex(json['borderColor']),
      colorAlpha: json['colorAlpha'] ?? 128,
      borderWidth: json['borderWidth'] ?? 2.0,
      borderStyle: json['borderStyle'] != null
          ? CPDFBorderStyle(
          style: CPDFAnnotBorderStyle.values.firstWhere(
                  (e) => e.name == json['borderStyle']['style']),
          dashGap: json['borderStyle']['dashGap'] ?? 0)
          : const CPDFBorderStyle.solid(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'fillColor': fillColor.toHex(),
    'borderColor': borderColor.toHex(),
    'colorAlpha': colorAlpha,
    'borderAlpha': colorAlpha,
    'borderWidth': borderWidth,
    'borderStyle': borderStyle?.toJson()
  };
}