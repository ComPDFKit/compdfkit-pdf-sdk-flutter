// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import '../../../util/extension/cpdf_color_extension.dart';
import '../../cpdf_options.dart';
import 'cpdf_checkbox_attr.dart';

class CPDFRadioButtonAttr extends CPDFCheckBoxAttr {
  @override
  String get type => CPDFFormType.radioButton.name;

  const CPDFRadioButtonAttr(
      {super.fillColor = const Color(0xFFDDE9FF),
      super.borderColor = const Color(0xFF1460F3),
      super.borderWidth = 2,
      super.checkedColor = const Color(0xFF43474D),
      super.isChecked = false,
      super.checkedStyle = CPDFCheckStyle.circle});

  @override
  CPDFRadioButtonAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    Color? checkedColor,
    bool? isChecked,
    CPDFCheckStyle? checkedStyle,
  }) {
    return CPDFRadioButtonAttr(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      checkedColor: checkedColor ?? this.checkedColor,
      isChecked: isChecked ?? this.isChecked,
      checkedStyle: checkedStyle ?? this.checkedStyle,
    );
  }

  factory CPDFRadioButtonAttr.fromJson(Map<String, dynamic> json) {
    return CPDFRadioButtonAttr(
      fillColor: HexColor.fromHex(json['fillColor']),
      borderColor: HexColor.fromHex(json['borderColor']),
      borderWidth: json['borderWidth'] ?? 2,
      checkedColor: HexColor.fromHex(json['checkedColor']),
      isChecked: json['isChecked'] ?? false,
      checkedStyle: CPDFCheckStyle.fromString(json['checkedStyle']),
    );
  }
}
