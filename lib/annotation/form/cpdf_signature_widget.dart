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

/// Signature form widget.
///
/// A signature field placeholder that extends [CPDFWidget].
///
/// Serialization:
/// - Use [CPDFSignatureWidget.fromJson] to create an instance from a JSON map.
/// - Use [toJson] inherited from [CPDFWidget] to convert this instance to JSON.
///
/// {@category forms}
class CPDFSignatureWidget extends CPDFWidget {
  CPDFSignatureWidget({
    required super.title,
    required super.page,
    required super.rect,
    required super.borderColor,
    required super.fillColor,
    super.uuid,
    super.createDate,
    super.borderWidth = 2,
  }) : super(type: CPDFFormType.signaturesFields);

  factory CPDFSignatureWidget.fromJson(Map<String, dynamic> json) {
    CPDFWidget common = CPDFWidget.fromJson(json);
    return CPDFSignatureWidget(
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
