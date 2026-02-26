// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../../util/extension/cpdf_color_extension.dart';
import 'cpdf_markup_attr.dart';

class CPDFStrikeoutAttr extends CPDFMarkupAttr {
  @override
  String get type => CPDFAnnotationType.strikeout.name;

  const CPDFStrikeoutAttr({super.color, super.alpha});

  CPDFStrikeoutAttr copyWith({
    Color? color,
    double? alpha,
  }) {
    return CPDFStrikeoutAttr(
      color: color ?? this.color,
      alpha: alpha ?? this.alpha,
    );
  }

  factory CPDFStrikeoutAttr.fromJson(Map<String, dynamic> json) {
    return CPDFStrikeoutAttr(
      color: HexColor.fromHex(json['color']),
      alpha: json['alpha'] ?? 255,
    );
  }
}
