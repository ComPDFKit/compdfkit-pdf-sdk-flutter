// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';
import 'dart:ui';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../../util/cpdf_rectf.dart';
import '../../util/extension/cpdf_color_extension.dart';

class CPDFWidget {
  final CPDFFormType type;
  final String title;
  final int page;
  final String uuid;
  final DateTime? createDate;
  final CPDFRectF rect;
  final Color borderColor;
  final Color fillColor;
  final double borderWidth;

  CPDFWidget(
      {required this.type,
      required this.title,
      required this.page,
      required this.uuid,
      this.createDate,
      required this.rect,
      required this.borderColor,
      required this.fillColor,
      required this.borderWidth});

  factory CPDFWidget.fromJson(Map<String, dynamic> json) {
    return CPDFWidget(
      type: CPDFFormType.fromString(json['type']),
      title: json['title'] ?? '',
      page: json['page'] ?? 0,
      uuid: json['uuid'] ?? '',
      createDate: json['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createDate'])
          : null,
      rect: CPDFRectF.fromJson(Map<String, dynamic>.from(json['rect'] ?? {})),
      borderColor: HexColor.fromHex(json['borderColor'] ?? '#000000'),
      fillColor: HexColor.fromHex(json['fillColor'] ?? '#000000'),
      borderWidth: json['borderWidth'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'page': page,
        'uuid': uuid,
        'createDate': createDate?.toString(),
        'rect': rect.toString(),
        'borderColor': borderColor.toHex(),
        'fillColor': fillColor.toHex(),
        'borderWidth': borderWidth,
      };

  @override
  String toString() => jsonEncode(toJson());
}
