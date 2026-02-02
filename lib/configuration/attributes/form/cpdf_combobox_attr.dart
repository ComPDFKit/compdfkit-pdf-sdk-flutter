// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../../../util/extension/cpdf_color_extension.dart';
import '../../cpdf_options.dart';
import 'cpdf_listbox_attr.dart';

class CPDFComboBoxAttr extends CPDFListBoxAttr {
  @override
  String get type => CPDFFormType.comboBox.name;

  const CPDFComboBoxAttr(
      {super.fillColor = const Color(0xFFDDE9FF),
      super.borderColor = const Color(0xFF1460F3),
      super.borderWidth = 2,
      super.fontColor = Colors.black,
      super.fontSize = 20,
      super.familyName = 'Helvetica',
      super.styleName = ''});

  factory CPDFComboBoxAttr.fromJson(Map<String, dynamic> json) {
    return CPDFComboBoxAttr(
        fillColor: HexColor.fromHex(json['fillColor']),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: json['borderWidth'] ?? 2,
        fontColor: HexColor.fromHex(json['fontColor']),
        fontSize: json['fontSize'] ?? 20,
        familyName: json['familyName'] ?? 'Helvetica',
        styleName: json['styleName'] ?? '');
  }

  @override
  CPDFComboBoxAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    Color? fontColor,
    double? fontSize,
    String? familyName,
    String? styleName,
  }) {
    return CPDFComboBoxAttr(
        fillColor: fillColor ?? this.fillColor,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        fontColor: fontColor ?? this.fontColor,
        fontSize: fontSize ?? this.fontSize,
        familyName: familyName ?? this.familyName,
        styleName: styleName ?? this.styleName);
  }
}
