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

class CPDFMarkupAnnotation extends CPDFAnnotation {
  final String markedText;
  final Color color;
  final double alpha;

  CPDFMarkupAnnotation(
      {required CPDFAnnotationType type,
      required String title,
      required int page,
      required String content,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required this.markedText,
      required this.color,
      required this.alpha})
      : super(
            type: type,
            title: title,
            page: page,
            content: content,
            uuid: uuid,
            createDate: createDate,
            rect: rect);

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
      alpha: json['alpha'] ?? 255,
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
