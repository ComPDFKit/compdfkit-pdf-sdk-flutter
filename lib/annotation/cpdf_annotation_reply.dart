// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_annotation_state.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';

/// A reply attached to a PDF annotation.
///
/// Reply annotations expose the common annotation fields such as [uuid],
/// [page], [title], [content], [createDate], [modifyDate], [rect],
/// [markState], and [reviewState].
///
/// {@category annotations}
class CPDFReplyAnnotation extends CPDFAnnotation {
  CPDFReplyAnnotation({
    super.type = CPDFAnnotationType.unknown,
    super.title = '',
    required super.page,
    super.content = '',
    required super.uuid,
    super.createDate,
    this.modifyDate,
    super.markState,
    super.reviewState,
    required super.rect,
  });

  /// The last modified time of this reply, if provided by the native SDK.
  final DateTime? modifyDate;

  factory CPDFReplyAnnotation.fromJson(Map<String, dynamic> json) {
    CPDFAnnotationType type = CPDFAnnotationType.unknown;
    final typeValue = json['type'];
    if (typeValue is String) {
      try {
        type = CPDFAnnotationType.fromString(typeValue);
      } catch (_) {
        type = CPDFAnnotationType.unknown;
      }
    }

    return CPDFReplyAnnotation(
      type: type,
      title: json['title'] ?? '',
      page: json['page'] ?? 0,
      content: json['content'] ?? '',
      uuid: json['uuid'] ?? '',
      createDate: json['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createDate'])
          : null,
      modifyDate: json['modifyDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['modifyDate'])
          : null,
      markState:
          CPDFAnnotationMarkState.fromString(json['markState'] as String?),
      reviewState:
          CPDFAnnotationReviewState.fromString(json['reviewState'] as String?),
      rect: CPDFRectF.fromJson(Map<String, dynamic>.from(json['rect'] ?? {})),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'modifyDate': modifyDate?.millisecondsSinceEpoch,
      };

  @override
  String toString() => jsonEncode(toJson());
}
