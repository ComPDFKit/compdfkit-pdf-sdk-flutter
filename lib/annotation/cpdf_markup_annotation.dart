// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

/// Markup annotation model.
///
/// A text markup annotation (highlight/underline/strikeout/squiggly) that
/// extends [CPDFAnnotation].
///
/// Key properties:
/// - [markedText]: The text content that is marked up.
/// - [color]/[alpha]: Markup color and opacity.
///
/// Note: This class may represent different markup types via [type] (e.g.
/// highlight/underline/strikeout/squiggly).
///
/// Serialization:
/// - Use [CPDFMarkupAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFMarkupAnnotation extends CPDFAnnotation {
  final String markedText;

  Color color;

  double alpha;

  CPDFMarkupAnnotation({
    required super.type,
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    required this.markedText,
    required this.color,
    this.alpha = 255,
  });

  factory CPDFMarkupAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFMarkupAnnotation(
      type: common.type,
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      markedText: json['markedText'] ?? '',
      color: HexColor.fromHex(json['color'] ?? '#000000'),
      alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'markedText': markedText,
      'color': color.toHex(),
      'alpha': alpha,
    };
  }
}
