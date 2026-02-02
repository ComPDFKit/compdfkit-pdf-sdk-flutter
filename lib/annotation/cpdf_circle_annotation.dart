// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../util/extension/cpdf_color_extension.dart';
import 'cpdf_annotation.dart';

/// Circle annotation model.
///
/// A circle shape annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - Border: [borderWidth], [borderColor], [borderAlpha].
/// - Fill: [fillColor], [fillAlpha].
/// - Border effect: [effectType], [dashGap].
///
/// Serialization:
/// - Use [CPDFCircleAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFCircleAnnotation extends CPDFAnnotation {
  double borderWidth;
  Color borderColor;
  double borderAlpha;
  Color fillColor;
  double fillAlpha;
  CPDFBorderEffectType effectType;
  double dashGap;

  CPDFCircleAnnotation({
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    this.borderWidth = 0,
    required this.borderColor,
    this.borderAlpha = 255,
    required this.fillColor,
    this.fillAlpha = 255,
    this.effectType = CPDFBorderEffectType.solid,
    this.dashGap = 0,
  }) : super(type: CPDFAnnotationType.circle);

  factory CPDFCircleAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFCircleAnnotation(
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0,
      borderColor: HexColor.fromHex(json['borderColor'] ?? '#000000'),
      borderAlpha: (json['borderAlpha'] as num?)?.toDouble() ?? 255,
      fillColor: HexColor.fromHex(json['fillColor'] ?? '#000000'),
      fillAlpha: (json['fillAlpha'] as num?)?.toDouble() ?? 255,
      effectType: CPDFBorderEffectType.fromString(json['bordEffectType']),
      dashGap: (json['dashGap'] as num?)?.toDouble() ?? 0,
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
      'bordEffectType': effectType.name,
      'dashGap': dashGap,
    };
  }
}
