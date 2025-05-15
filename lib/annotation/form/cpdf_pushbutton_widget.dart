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
import 'package:compdfkit_flutter/document/action/cpdf_action.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import '../../util/cpdf_rectf.dart';

class CPDFPushButtonWidget extends CPDFWidget {
  final String buttonTitle;

  final CPDFAction? action;

  final Color fontColor;

  final double fontSize;

  final String familyName;

  final String styleName;

  CPDFPushButtonWidget(
      {required CPDFFormType type,
      required String title,
      required int page,
      required String uuid,
      DateTime? modifyDate,
      DateTime? createDate,
      required CPDFRectF rect,
      required borderColor,
      required fillColor,
      required borderWidth,
      required this.buttonTitle,
      this.action,
      required this.fontColor,
      required this.fontSize,
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

  factory CPDFPushButtonWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFPushButtonWidget(
        type: common.type,
        title: common.title,
        page: common.page,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        borderColor: common.borderColor,
        fillColor: common.fillColor,
        borderWidth: common.borderWidth,
        buttonTitle: json['buttonTitle'],
        action: json['action'] != null
            ? CPDFAction.fromJson(
                Map<String, dynamic>.from(json['action'] ?? {}))
            : null,
        fontColor: HexColor.fromHex(json['fontColor'] ?? '#000000'),
        fontSize: double.parse((json['fontSize'] as double).toStringAsFixed(2)),
        familyName: json['familyName'] ?? 'Helvetica',
        styleName: json['styleName'] ?? 'Regular');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'buttonTitle': buttonTitle,
      'action': action?.toJson(),
      'fontColor' : fontColor.toHex(),
      'fontSize' : fontSize,
      'familyName' : familyName,
      'styleName' : styleName
    };
  }
}
