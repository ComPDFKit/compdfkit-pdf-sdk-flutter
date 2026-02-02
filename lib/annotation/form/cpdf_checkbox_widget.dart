/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
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
import 'package:flutter/material.dart';

/// Checkbox form widget.
///
/// Extends [CPDFWidget] with checkbox-specific state and appearance.
///
/// Key properties:
/// - [isChecked]: Whether the box is checked.
/// - [checkStyle]: The mark style rendered when checked.
/// - [checkColor]: The mark color.
///
/// Serialization:
/// - Use [CPDFCheckBoxWidget.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category forms}
class CPDFCheckBoxWidget extends CPDFWidget {
  bool isChecked;

  CPDFCheckStyle checkStyle;

  Color checkColor;

  CPDFCheckBoxWidget({
    required super.title,
    required super.page,
    required super.rect,
    required super.borderColor,
    required super.fillColor,
    super.uuid,
    super.createDate,
    super.borderWidth = 2,
    this.isChecked = false,
    this.checkStyle = CPDFCheckStyle.check,
    required this.checkColor,
  }) : super(type: CPDFFormType.checkBox);

  factory CPDFCheckBoxWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFCheckBoxWidget(
        title: common.title,
        page: common.page,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        borderColor: common.borderColor,
        borderWidth: common.borderWidth,
        fillColor: common.fillColor,
        isChecked: json['isChecked'] ?? false,
        checkStyle: CPDFCheckStyle.fromString(json['checkStyle']),
        checkColor: HexColor.fromHex(json['checkColor'] ?? '#000000'));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'isChecked': isChecked,
      'checkStyle': checkStyle.name,
      'checkColor': checkColor.toHex(),
    };
  }
}
