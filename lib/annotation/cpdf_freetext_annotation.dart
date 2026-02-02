// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/cpdf_text_attribute.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Free text annotation model.
///
/// A text-box style annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [textAttribute]: Text style information (font, size, color, etc.).
/// - [alpha]: Overall opacity.
/// - [alignment]: Text alignment.
///
/// Serialization:
/// - Use [CPDFFreeTextAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFFreeTextAnnotation extends CPDFAnnotation {

  CPDFTextAttribute textAttribute;

  double alpha;

  CPDFAlignment alignment;

  CPDFFreeTextAnnotation({
    required super.title,
    required super.page,
    required super.content,
    required super.uuid,
    super.createDate,
    required super.rect,
    required this.textAttribute,
    this.alpha = 255,
    this.alignment = CPDFAlignment.left,
  }) : super(type: CPDFAnnotationType.freetext);

  factory CPDFFreeTextAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFFreeTextAnnotation(
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      textAttribute: CPDFTextAttribute.fromJson(
          Map<String, dynamic>.from(json['textAttribute'] ?? {})),
      alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0,
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
