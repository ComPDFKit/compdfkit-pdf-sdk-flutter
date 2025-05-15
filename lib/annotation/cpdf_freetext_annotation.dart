// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/cpdf_text_attribute.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../util/cpdf_rectf.dart';

class CPDFFreeTextAnnotation extends CPDFAnnotation {
  final CPDFTextAttribute textAttribute;

  final double alpha;

  final CPDFAlignment alignment;

  CPDFFreeTextAnnotation(
      {required CPDFAnnotationType type,
      required String title,
      required int page,
      required String content,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required this.textAttribute,
      required this.alpha,
      required this.alignment})
      : super(
            type: type,
            title: title,
            page: page,
            content: content,
            uuid: uuid,
            createDate: createDate,
            rect: rect);

  factory CPDFFreeTextAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFFreeTextAnnotation(
      type: common.type,
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      textAttribute: CPDFTextAttribute.fromJson(
          Map<String, dynamic>.from(json['textAttribute'] ?? {})),
      alpha: json['alpha'] ?? 255.0,
      alignment: CPDFAlignment.fromString(json['alignment']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'textAttribute': textAttribute.toJson(),
      'alpha': alpha,
      'alignment': alignment.name,
    };
  }
}
