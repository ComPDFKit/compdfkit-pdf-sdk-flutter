/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Signature annotation model.
///
/// An image-based signature annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [image]: Base64-encoded image string for the signature appearance.
///
/// Serialization:
/// - Use [CPDFSignatureAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFSignatureAnnotation extends CPDFAnnotation {
  /// Base64 encoded image string representing the signature.
  ///
  /// for example: iVBORw0KGgoAAAANSUhEUgAAAgIAAABzCAY...
  final String? image;

  CPDFSignatureAnnotation(
      {super.title,
      super.content,
      super.createDate,
      required super.page,
      super.uuid = '',
      required super.rect,
      this.image})
      : super(type: CPDFAnnotationType.signature);

  factory CPDFSignatureAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFSignatureAnnotation(
      title: common.title,
      content: common.content,
      createDate: common.createDate,
      page: common.page,
      uuid: common.uuid,
      rect: common.rect,
      image: json['image'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'image': image,
      'stampType': 'image',
      'isStampSignature': true
    };
  }
}
