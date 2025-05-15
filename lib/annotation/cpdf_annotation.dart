// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';

class CPDFAnnotation {
  final CPDFAnnotationType type;

  final String title;

  final int page;

  final String content;

  final String uuid;

  final DateTime? createDate;

  final CPDFRectF rect;

  CPDFAnnotation(
      {required this.type,
      required this.title,
      required this.page,
      required this.content,
      required this.uuid,
      this.createDate,
      required this.rect});

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
        'createDate': createDate?.toString(),
        'rect': rect.toString()
      };

  @override
  String toString() => jsonEncode(toJson());
}
