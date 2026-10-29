// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_text_attribute.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

/// A redaction annotation that marks content for removal.
///
/// This model only creates and styles the redaction mark. Permanently applying
/// redactions is a separate, irreversible document operation.
/// Native quad points and annotation review states are intentionally excluded
/// from this model's constructor and serialized payload.
///
/// {@category annotations}
class CPDFRedactAnnotation extends CPDFAnnotation {
  String overlayText;

  Color fillColor;

  Color? outlineColor;

  CPDFTextAttribute? textAttribute;

  CPDFAlignment alignment;

  CPDFRedactAnnotation({
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    this.overlayText = '',
    this.fillColor = const Color(0xFF000000),
    this.outlineColor,
    this.textAttribute,
    this.alignment = CPDFAlignment.center,
  }) : super(type: CPDFAnnotationType.redact);

  factory CPDFRedactAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    final textAttribute = json['textAttribute'];
    return CPDFRedactAnnotation(
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      overlayText: json['overlayText'] as String? ?? '',
      fillColor: HexColor.fromHex(json['fillColor'] as String? ?? '#FF000000'),
      outlineColor: json['outlineColor'] is String
          ? HexColor.fromHex(json['outlineColor'] as String)
          : null,
      textAttribute: textAttribute is Map
          ? CPDFTextAttribute.fromJson(Map<String, dynamic>.from(textAttribute))
          : null,
      alignment: CPDFAlignment.fromString(
        json['alignment'] as String? ?? 'center',
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson()
      ..remove('markState')
      ..remove('reviewState');
    return {
      ...json,
      'overlayText': overlayText,
      'fillColor': fillColor.toHex(),
      'outlineColor': outlineColor?.toHex(),
      'textAttribute': textAttribute?.toJson(),
      'alignment': alignment.name,
    };
  }
}
