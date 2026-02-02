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
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

/// Combo box form widget.
///
/// A drop-down selection form field that extends [CPDFWidget].
///
/// Key properties:
/// - [options]: Available items for selection.
/// - [selectItemAtIndex]: Selected item index.
/// - Text appearance: [fontColor], [fontSize], [familyName], [styleName].
///
/// Serialization:
/// - Use [CPDFComboBoxWidget.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category forms}
class CPDFComboBoxWidget extends CPDFWidget {
  List<CPDFWidgetItem>? options;

  int selectItemAtIndex;

  Color fontColor;

  double fontSize;

  String familyName;

  String styleName;

  CPDFComboBoxWidget({
    required super.title,
    required super.page,
    required super.rect,
    required super.borderColor,
    required super.fillColor,
    super.uuid,
    super.createDate,
    super.borderWidth = 2,
    this.options,
    this.selectItemAtIndex = 0,
    this.fontColor = Colors.black,
    this.fontSize = 20,
    this.familyName = 'Helvetica',
    this.styleName = 'Regular',
  }) : super(type: CPDFFormType.comboBox);

  factory CPDFComboBoxWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFComboBoxWidget(
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
                .map((e) =>
                    CPDFWidgetItem.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : null,
        selectItemAtIndex: json['selectedIndexes'] ?? 0,
        fontColor: HexColor.fromHex(json['fontColor'] ?? '#000000'),
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? 20.0,
        familyName: json['familyName'] ?? 'Helvetica',
        styleName: json['styleName'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'options': options?.map((e) => e.toJson()).toList(),
      'selectItemAtIndex': selectItemAtIndex,
      'fontColor': fontColor.toHex(),
      'fontSize': fontSize,
      'familyName': familyName,
      'styleName': styleName
    };
  }
}
