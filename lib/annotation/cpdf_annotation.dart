// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';

/// Base annotation model.
///
/// This model describes the common properties shared by all PDF annotations.
/// Concrete annotation types (e.g. ink, highlight, stamp) extend this class to
/// provide type-specific fields.
///
/// Key properties:
/// - [type]: The annotation type.
/// - [title]: The annotation title/subject.
/// - [page]: The page index where the annotation is located.
/// - [content]: The annotation content.
/// - [uuid]: The unique identifier of this annotation.
/// - [createDate]: The creation time, if available.
/// - [rect]: The annotation bounds in page coordinates.
///
/// Serialization:
/// - Use [CPDFAnnotation.fromJson] to parse common fields from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// For polymorphic parsing into concrete subclasses, use
/// [CPDFAnnotationRegistry.fromJson].
///
/// {@category annotations}
class CPDFAnnotation {
  final CPDFAnnotationType type;

  String title;

  final int page;

  String content;

  final String uuid;

  final DateTime? createDate;

  final CPDFRectF rect;

  CPDFAnnotation({
    required this.type,
    this.title = "",
    required this.page,
    this.content = "",
    required this.uuid,
    this.createDate,
    required this.rect,
  });

  factory CPDFAnnotation.fromJson(Map<String, dynamic> json) {
    return CPDFAnnotation(
      type: CPDFAnnotationType.fromString(json['type']),
      title: json['title'] ?? '',
      page: json['page'] ?? 0,
      content: json['content'] ?? '',
      uuid: json['uuid'] ?? '',
      createDate: json['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createDate'])
          : null,
      rect: CPDFRectF.fromJson(Map<String, dynamic>.from(json['rect'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'page': page,
        'content': content,
        'uuid': uuid,
        'createDate': createDate?.millisecondsSinceEpoch,
        'rect': rect.toJson()
      };

  @override
  String toString() => jsonEncode(toJson());
}
