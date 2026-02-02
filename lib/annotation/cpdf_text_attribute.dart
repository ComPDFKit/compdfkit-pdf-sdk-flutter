// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';
import 'dart:ui';

import '../util/extension/cpdf_color_extension.dart';

/// Text styling attributes used by text-based annotations.
///
/// This model is commonly referenced by annotations such as
/// [CPDFFreeTextAnnotation] to describe text appearance.
///
/// Key properties:
/// - [color]: Text color.
/// - [familyName]: Font family name.
/// - [styleName]: Font style name.
/// - [fontSize]: Font size.
///
/// Serialization:
/// - Use [CPDFTextAttribute.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFTextAttribute {
  Color color;

  String familyName;

  String styleName;

  double fontSize;

  CPDFTextAttribute(
      {required this.color,
      required this.familyName,
      required this.styleName,
      required this.fontSize});

  factory CPDFTextAttribute.fromJson(Map<String, dynamic> json) {
    return CPDFTextAttribute(
        color: HexColor.fromHex(json['color'] ?? '#000000'),
        familyName: json['familyName'],
        styleName: json['styleName'],
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? 0.0);
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
