/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

/// Text field form widget.
///
/// A text input form field that extends [CPDFWidget].
///
/// Key properties:
/// - [text]: Current text value.
/// - [alignment]: Text alignment.
/// - [isMultiline]: Whether multiple lines are allowed.
/// - Text appearance: [fontColor], [fontSize], [familyName], [styleName].
///
/// Serialization:
/// - Use [CPDFTextWidget.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category forms}
class CPDFTextWidget extends CPDFWidget {
  String text;
  Color fontColor;
  double fontSize;
  CPDFAlignment alignment;
  bool isMultiline;
  String familyName;
  String styleName;

  CPDFTextWidget({
    required super.title,
    required super.page,
    required super.rect,
    required super.borderColor,
    required super.fillColor,
    super.uuid,
    super.createDate,
    super.borderWidth = 2.0,
    this.text = '',
    this.fontColor = Colors.black,
    this.fontSize = 20,
    this.alignment = CPDFAlignment.left,
    this.isMultiline = true,
    this.familyName = 'Helvetica',
    this.styleName = 'Regular',
  }) : super(type: CPDFFormType.textField);

  factory CPDFTextWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFTextWidget(
        title: common.title,
        page: common.page,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        borderColor: common.borderColor,
        fillColor: common.fillColor,
        borderWidth: common.borderWidth,
        text: json['text'] ?? '',
        fontColor: HexColor.fromHex(json['fontColor'] ?? '#000000'),
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? 0.0,
        alignment: CPDFAlignment.fromString(json['alignment'] ?? ''),
        isMultiline: json['isMultiline'] ?? false,
        familyName: json['familyName'] ?? 'Helvetica',
        styleName: json['styleName'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'text': text,
      'fontColor': fontColor.toHex(),
      'fontSize': fontSize,
      'alignment': alignment.name,
      'isMultiline': isMultiline,
      'familyName': familyName,
      'styleName': styleName
    };
  }
}
