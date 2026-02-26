// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../../util/extension/cpdf_color_extension.dart';
import 'cpdf_annot_attr_base.dart';

/// Represents the attributes for text annotations in a PDF document.
/// This class extends [CPDFAnnotAttrBase] and includes properties for
/// the color and transparency of the text annotation.
/// The [color] property defines the color of the text annotation,
/// while the [alpha] property defines its transparency level.
class CPDFTextAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFAnnotationType.note.name;

  /// note icon color
  final Color color;

  /// Color transparency.<br/>
  /// Value Range:0-255.
  final double alpha;

  const CPDFTextAttr({this.color = const Color(0xFF1460F3), this.alpha = 255});

  CPDFTextAttr copyWith({
    Color? color,
    double? alpha,
  }) {
    return CPDFTextAttr(
      color: color ?? this.color,
      alpha: alpha ?? this.alpha,
    );
  }

  /// Creates a [CPDFTextAttr] instance from a JSON map.
  /// example:
  /// ```dart
  /// CPDFTextAttr.fromJson({'color': '#FF0000', 'alpha': 128});
  /// ```
  factory CPDFTextAttr.fromJson(Map<String, dynamic> json) {
    return CPDFTextAttr(
      color: HexColor.fromHex(json['color']),
      alpha: json['alpha'] ?? 255,
    );
  }

  @override
  Map<String, dynamic> toJson() => {'color': color.toHex(), 'alpha': alpha};
}
