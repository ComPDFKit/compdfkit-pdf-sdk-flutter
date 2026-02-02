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

import '../util/cpdf_rectf.dart';

/// Line annotation model.
///
/// A line/arrow annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - Border: [borderWidth], [borderColor], [borderAlpha].
/// - Fill: [fillColor], [fillAlpha].
/// - Line endings: [lineHeadType], [lineTailType].
/// - Dash: [dashGap].
/// - Geometry: [points] representing line segments.
///
/// Note: This class may represent different types via [type] (e.g.
/// [CPDFAnnotationType.line] or [CPDFAnnotationType.arrow]).
///
/// Serialization:
/// - Use [CPDFLineAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFLineAnnotation extends CPDFAnnotation {
  double borderWidth;
  Color borderColor;
  double borderAlpha;
  Color fillColor;
  double fillAlpha;
  CPDFLineType lineHeadType;
  CPDFLineType lineTailType;
  double dashGap;
  List<List<double>>? points;

  CPDFLineAnnotation({
    required super.type,
    super.title,
    required super.page,
    super.content,
    required super.uuid,
    super.createDate,
    super.rect = const CPDFRectF.isEmpty(),
    required this.borderWidth,
    required this.borderColor,
    this.borderAlpha = 255,
    required this.fillColor,
    this.fillAlpha = 255,
    this.lineHeadType = CPDFLineType.none,
    this.lineTailType = CPDFLineType.none,
    this.dashGap = 0,
    this.points,
  });

  factory CPDFLineAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFLineAnnotation(
      type: common.type,
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0,
      borderColor: HexColor.fromHex(json['borderColor'] ?? '#000000'),
      borderAlpha: (json['borderAlpha'] as num?)?.toDouble() ?? 255.0,
      fillColor: HexColor.fromHex(json['fillColor'] ?? '#000000'),
      fillAlpha: (json['fillAlpha'] as num?)?.toDouble() ?? 255.0,
      lineHeadType: CPDFLineType.fromString(json['lineHeadType']),
      lineTailType: CPDFLineType.fromString(json['lineTailType']),
      dashGap: (json['dashGap'] as num?)?.toDouble() ?? 0,
      points: (json['points'] is List)
          ? (json['points'] as List)
              .map((e) => e is List
                  ? e.map((v) => (v as num).toDouble()).toList()
                  : <double>[])
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'borderWidth': borderWidth,
      'borderColor': borderColor.toHex(),
      'borderAlpha': borderAlpha,
      'fillColor': fillColor.toHex(),
      'fillAlpha': fillAlpha,
      'lineHeadType': lineHeadType.name,
      'lineTailType': lineTailType.name,
      'dashGap': dashGap,
      'points': points,
    };
  }
}
