/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../../util/cpdf_rectf.dart';

class CPDFSignatureWidget extends CPDFWidget {

  CPDFSignatureWidget({
    required CPDFFormType type,
    required String title,
    required int page,
    required String uuid,
    DateTime? createDate,
    required CPDFRectF rect,
    required borderColor,
    required fillColor,
    required borderWidth
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

  factory CPDFSignatureWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFSignatureWidget(
      type: common.type,
      title: common.title,
      page: common.page,
      uuid: common.uuid,
      createDate: common.createDate,
      rect: common.rect,
      borderColor: common.borderColor,
      borderWidth: common.borderWidth,
      fillColor: common.fillColor,
    );
  }
}
