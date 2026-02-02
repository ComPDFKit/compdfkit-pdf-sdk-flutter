// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import '../../util/extension/cpdf_color_extension.dart';
import '../cpdf_options.dart';
import 'cpdf_annot_attr_base.dart';

class CPDFInkAttr extends CPDFAnnotAttrBase {
  @override
  String get type => CPDFAnnotationType.ink.name;

  /// The color of the ink annotation. Defaults to blue (#1460F3).
  final Color color;

  /// Color transparency.<br/>
  /// Value Range:0-255.
  final double alpha;

  /// border width.
  /// Value Range:1~10.
  final double borderWidth;

  const CPDFInkAttr(
      {this.color = const Color(0xFF1460F3),
      this.alpha = 255,
      this.borderWidth = 10});

  CPDFInkAttr copyWith({
    Color? color,
    double? alpha,
    double? borderWidth,
  }) {
    return CPDFInkAttr(
        color: color ?? this.color,
        alpha: alpha ?? this.alpha,
        borderWidth: borderWidth ?? this.borderWidth);
  }

  /// Creates a [CPDFInkAttr] instance from a JSON map.
  /// example:
  /// ```dart
  /// CPDFInkAttr.fromJson({'color': '#FF0000', 'alpha': 128, 'borderWidth': 5});
  /// ```
  factory CPDFInkAttr.fromJson(Map<String, dynamic> json) {
    return CPDFInkAttr(
      color: HexColor.fromHex(json['color']),
      alpha: json['alpha'] ?? 255,
      borderWidth: json['borderWidth'] ?? 10,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'color': color.toHex(),
        'alpha': alpha,
        'borderWidth': borderWidth
      };
}
