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

class CPDFInkAnnotation extends CPDFAnnotation {
  final Color color;
  final double alpha;
  final double borderWidth;

  CPDFInkAnnotation(
      {required CPDFAnnotationType type,
      required String title,
      required int page,
      required String content,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required this.color,
      required this.alpha,
      required this.borderWidth})
      : super(
            type: type,
            title: title,
            page: page,
            content: content,
            uuid: uuid,
            createDate: createDate,
            rect: rect);

  factory CPDFInkAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFInkAnnotation(
      type: common.type,
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      color: HexColor.fromHex(json['color'] ?? '#000000'),
      alpha: json['alpha'] ?? 255.0,
      borderWidth: json['borderWidth'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'color': color.toHex(),
      'alpha': alpha,
      'borderWidth': borderWidth,
    };
  }
}
