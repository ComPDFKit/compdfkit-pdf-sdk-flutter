/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:ui';

import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import '../../util/cpdf_rectf.dart';

class CPDFTextWidget extends CPDFWidget {
  final String text;
  final Color fontColor;
  final double fontSize;
  final CPDFAlignment alignment;
  final bool isMultiline;
  final String familyName;

  final String styleName;

  CPDFTextWidget(
      {required CPDFFormType type,
      required String title,
      required int page,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required borderColor,
      required fillColor,
      required borderWidth,
      required this.text,
      required this.fontColor,
      required this.fontSize,
      required this.alignment,
      required this.isMultiline,
      required this.familyName,
      required this.styleName})
      : super(
            type: type,
            title: title,
            page: page,
            uuid: uuid,
            createDate: createDate,
            rect: rect,
            borderColor: borderColor,
            fillColor: fillColor,
            borderWidth: borderWidth);

  factory CPDFTextWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFTextWidget(
        type: common.type,
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
        fontSize: json['fontSize'] ?? 0.0,
        alignment: CPDFAlignment.fromString(json['alignment'] ?? ''),
        isMultiline: json['isMultiline'] ?? false,
    familyName: json['familyName'] ?? '',
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
