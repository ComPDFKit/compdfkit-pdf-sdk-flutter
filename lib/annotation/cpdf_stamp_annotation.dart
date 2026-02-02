// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_text_stamp.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Stamp annotation model.
///
/// A stamp annotation that extends [CPDFAnnotation]. It can represent standard
/// stamps or text stamps.
///
/// Key properties:
/// - [stampType]: Determines whether this is a standard stamp or a text stamp.
/// - [standardStamp]: The predefined standard stamp type.
/// - [textStamp]: Text stamp configuration when [stampType] is text.
///
/// Serialization:
/// - Use [CPDFStampAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFStampAnnotation extends CPDFAnnotation {
  /// The standard stamp type for the annotation.
  CPDFStandardStamp? standardStamp;

  /// The type of stamp annotation.
  /// Possible values include:
  /// - standard: standard stamp
  /// - text: text stamp
  CPDFStampType? stampType;

  CPDFTextStamp? textStamp;

  CPDFStampAnnotation({
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    this.standardStamp,
    this.stampType,
    this.textStamp,
  }) : super(type: CPDFAnnotationType.stamp);

  factory CPDFStampAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    final stampType = CPDFStampType.values.firstWhere(
        (e) => e.name == json['stampType'],
        orElse: () => CPDFStampType.unknown);
    return CPDFStampAnnotation(
      title: common.title,
      page: common.page,
      content: common.content,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      standardStamp: CPDFStandardStamp.values.firstWhere(
          (e) => e.name == json['standardStamp'],
          orElse: () => CPDFStandardStamp.unknown),
      stampType: stampType,
      textStamp: stampType == CPDFStampType.text
          ? CPDFTextStamp.fromJson(
              Map<String, dynamic>.from(json['textStamp'] ?? {}))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'standardStamp': standardStamp?.name,
      'stampType': stampType?.name,
      'textStamp': textStamp?.toJson(),
    };
  }
}
