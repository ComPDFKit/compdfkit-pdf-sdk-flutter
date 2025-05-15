// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
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

class CPDFSquareAnnotation extends CPDFAnnotation {
  final double borderWidth;
  final Color borderColor;
  final double borderAlpha;
  final Color fillColor;
  final double fillAlpha;
  final CPDFBorderEffectType effectType;

  CPDFSquareAnnotation(
      {required CPDFAnnotationType type,
      required String title,
      required int page,
      required String content,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required this.borderWidth,
      required this.borderColor,
      required this.borderAlpha,
      required this.fillColor,
      required this.fillAlpha,
      required this.effectType})
      : super(
            type: type,
            title: title,
            page: page,
            content: content,
            uuid: uuid,
            createDate: createDate,
            rect: rect);

  factory CPDFSquareAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFSquareAnnotation(
      type: common.type,
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      borderWidth: json['borderWidth'] ?? 0,
      borderColor: HexColor.fromHex(json['borderColor'] ?? '#000000'),
      borderAlpha: json['borderAlpha'] ?? 255,
      fillColor: HexColor.fromHex(json['fillColor'] ?? '#000000'),
      fillAlpha: json['fillAlpha'] ?? 255,
      effectType: CPDFBorderEffectType.fromString(json['bordEffectType'])
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
      'bordEffectType': effectType.name
    };
  }
}
