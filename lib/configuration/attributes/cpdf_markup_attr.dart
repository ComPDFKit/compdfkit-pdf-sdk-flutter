// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import '../../util/extension/cpdf_color_extension.dart';
import 'cpdf_annot_attr_base.dart';


/// Represents the attributes for markup annotations in a PDF document.
/// This class extends [CPDFAnnotAttrBase] and includes properties for
/// the color and transparency of the markup annotation.
/// The [color] property defines the color of the markup annotation,
/// while the [alpha] property defines its transparency level.
class CPDFMarkupAttr extends CPDFAnnotAttrBase {


  /// The color of the annotation. Defaults to blue (#1460F3).
  final Color color;

  ///  Transparency of the color. Range: 0 (transparent) - 255 (opaque).
  final double alpha;

  const CPDFMarkupAttr({this.color = const Color(0xFF1460F3), this.alpha = 77});

  /// Creates a [CPDFMarkupAttr] instance from a JSON map.
  /// The map should contain the keys 'color' and 'alpha'.
  /// example:
  /// ```dart
  ///  CPDFMarkupAttr.fromJson({'color': '#FF0000', 'alpha': 128});
  /// ```
  factory CPDFMarkupAttr.fromJson(Map<String, dynamic> json) {
    return CPDFMarkupAttr(
      color: HexColor.fromHex(json['color']),
      alpha: json['alpha'] ?? 255,
    );
  }

  @override
  Map<String, dynamic> toJson() => {'type' : type, 'color': color.toHex(), 'alpha': alpha};

  @override
  String get type => throw UnimplementedError();
}