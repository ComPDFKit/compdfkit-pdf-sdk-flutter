// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

/// Note annotation model.
///
/// A sticky-note style annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [color]/[alpha]: Icon color and opacity.
///
/// Serialization:
/// - Use [CPDFNoteAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFNoteAnnotation extends CPDFAnnotation {
  Color color;
  double alpha;

  CPDFNoteAnnotation({
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    required this.color,
    this.alpha = 255,
  }) : super(type: CPDFAnnotationType.note);

  factory CPDFNoteAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFNoteAnnotation(
        title: common.title,
        page: common.page,
        content: common.content,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        color: HexColor.fromHex(json['color'] ?? '#000000'),
        alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'color': color.toHex(), 'alpha': alpha};
  }
}
