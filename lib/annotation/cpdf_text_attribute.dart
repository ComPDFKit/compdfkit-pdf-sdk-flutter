// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'dart:convert';
import 'dart:ui';

import '../util/extension/cpdf_color_extension.dart';

class CPDFTextAttribute {

  final Color color;

  final String familyName;

  final String styleName;

  final double fontSize;

  CPDFTextAttribute(this.color, this.familyName, this.styleName, this.fontSize);

  factory CPDFTextAttribute.fromJson(Map<String, dynamic> json) {
    return CPDFTextAttribute(
      HexColor.fromHex(json['color'] ?? '#000000'),
      json['familyName'],
      json['styleName'],
      double.parse((json['fontSize'] as double).toStringAsFixed(2))
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.toHex(),
      'familyName': familyName,
      'styleName': styleName,
      'fontSize': fontSize
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}


