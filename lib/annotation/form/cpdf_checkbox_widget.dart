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

class CPDFCheckBoxWidget extends CPDFWidget {
  final bool isChecked;
  final CPDFCheckStyle checkStyle;
  final Color checkColor;

  CPDFCheckBoxWidget({
    required CPDFFormType type,
    required String title,
    required int page,
    required String uuid,
    DateTime? createDate,
    required CPDFRectF rect,
    required borderColor,
    required fillColor,
    required borderWidth,
    required this.isChecked,
    required this.checkStyle,
    required this.checkColor
  }) : super(
            type: type,
            title: title,
            page: page,
            uuid: uuid,
            createDate: createDate,
            rect: rect,
            borderColor: borderColor,
            borderWidth: borderWidth,
            fillColor: fillColor);

  factory CPDFCheckBoxWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFCheckBoxWidget(
      type: common.type,
      title: common.title,
      page: common.page,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      borderColor: common.borderColor,
      borderWidth: common.borderWidth,
      fillColor: common.fillColor,
      isChecked: json['isChecked'],
      checkStyle: CPDFCheckStyle.fromString(json['checkStyle']),
      checkColor: HexColor.fromHex(json['checkColor'] ?? '#000000')
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'isChecked': isChecked,
      'checkStyle': checkStyle.name,
      'checkColor' : checkColor.toHex(),
    };
  }
}
