// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
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

/// Base model for a PDF form field (widget).
///
/// This model describes the common properties for all PDF form widgets and is
/// used as the base data structure when reading/writing form field information.
///
/// Key properties:
/// - [type]: The form field type.
/// - [title]: The field name/title.
/// - [page]: The page index where the widget is located.
/// - [uuid]: The unique identifier of this widget.
/// - [createDate]: The creation time, if available.
/// - [rect]: The widget bounds in page coordinates.
/// - [borderColor]/[fillColor]/[borderWidth]: Appearance settings.
///
/// Serialization:
/// - Use [CPDFWidget.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category forms}
class CPDFWidget {
  final CPDFFormType type;
  String title;
  final int page;
  final String uuid;
  final DateTime? createDate;
  final CPDFRectF rect;
  Color borderColor;
  Color fillColor;
  double borderWidth;

  CPDFWidget({
    required this.type,
    required this.title,
    required this.page,
    required this.rect,
    this.uuid = '',
    this.createDate,
    required this.borderColor,
    required this.fillColor,
    this.borderWidth = 0,
  });

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
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'page': page,
        'uuid': uuid,
        'createDate': createDate?.millisecondsSinceEpoch,
        'rect': rect.toJson(),
        'borderColor': borderColor.toHex(),
        'fillColor': fillColor.toHex(),
        'borderWidth': borderWidth,
      };

  @override
  String toString() => jsonEncode(toJson());
}
