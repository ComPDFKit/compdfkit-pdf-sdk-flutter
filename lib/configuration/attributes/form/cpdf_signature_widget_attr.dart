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

class CPDFSignatureWidgetAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFFormType.signaturesFields.name;

  final Color? fillColor;

  final Color? borderColor;

  final double? borderWidth;

  const CPDFSignatureWidgetAttr({
    this.fillColor = const Color(0xFFDDE9FF),
    this.borderColor = const Color(0xFF1460F3),
    this.borderWidth = 2,
  });

  CPDFSignatureWidgetAttr copyWith({
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
  }) {
    return CPDFSignatureWidgetAttr(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  factory CPDFSignatureWidgetAttr.fromJson(Map<String, dynamic> json) {
    return CPDFSignatureWidgetAttr(
      fillColor: HexColor.fromHex(json['fillColor']),
      borderColor: HexColor.fromHex(json['borderColor']),
      borderWidth: json['borderWidth'] ?? 2,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor?.toHex(),
      'borderColor': borderColor?.toHex(),
      'borderWidth': borderWidth,
    };
  }
}
