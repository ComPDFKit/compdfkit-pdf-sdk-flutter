// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import '../../cpdf_options.dart';
import '../cpdf_annot_attr_base.dart';

class CPDFCheckBoxAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFFormType.checkBox.name;

  final Color? fillColor;

  final Color? borderColor;

  /// border thickness, value range:0~10
  final double? borderWidth;

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

  CPDFCheckBoxAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    Color? checkedColor,
    bool? isChecked,
    CPDFCheckStyle? checkedStyle,
  }) {
    return CPDFCheckBoxAttr(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      checkedColor: checkedColor ?? this.checkedColor,
      isChecked: isChecked ?? this.isChecked,
      checkedStyle: checkedStyle ?? this.checkedStyle,
    );
  }

  factory CPDFCheckBoxAttr.fromJson(Map<String, dynamic> json) {
    return CPDFCheckBoxAttr(
      fillColor: HexColor.fromHex(json['fillColor']),
      borderColor: HexColor.fromHex(json['borderColor']),
      borderWidth: json['borderWidth'] ?? 2,
      checkedColor: HexColor.fromHex(json['checkedColor']),
      isChecked: json['isChecked'] ?? false,
      checkedStyle: CPDFCheckStyle.fromString(json['checkedStyle']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
      'checkedColor': checkedColor?.toHex(),
      'isChecked': isChecked,
      'checkedStyle': checkedStyle?.name
    };
  }
}
