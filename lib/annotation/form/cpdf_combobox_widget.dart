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
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import '../../util/cpdf_rectf.dart';

class CPDFComboBoxWidget extends CPDFWidget {

  final List<CPDFWidgetItem>? options;

  final List<int>? selectedIndexes;

  final Color fontColor;

  final double fontSize;

  final String familyName;

  final String styleName;

  CPDFComboBoxWidget(
      {required CPDFFormType type,
      required String title,
      required int page,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      required borderColor,
      required fillColor,
      required borderWidth,
      this.options,
      this.selectedIndexes,
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

  factory CPDFComboBoxWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFComboBoxWidget(
        type: common.type,
        title: common.title,
        page: common.page,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        borderColor: common.borderColor,
        fillColor: common.fillColor,
        borderWidth: common.borderWidth,
          options: json['options'] != null
              ? (json['options'] as List)
                  .map((e) => CPDFWidgetItem.fromJson(Map<String, dynamic>.from(e)))
                  .toList()
              : null,
      selectedIndexes: json['selectedIndexes'] != null
          ? List<int>.from(json['selectedIndexes'])
          : [],
      fontColor: HexColor.fromHex(json['fontColor'] ?? '#000000'),
      fontSize: double.parse((json['fontSize'] as double).toStringAsFixed(2)),
      familyName: json['familyName'] ?? '',
      styleName: json['styleName'] ?? ''
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'options' : options?.map((e) => e.toJson()).toList(),
      'selectedIndexes': selectedIndexes,
      'fontColor': fontColor.toHex(),
      'fontSize': fontSize,
      'familyName': familyName,
      'styleName': styleName
    };
  }
}
