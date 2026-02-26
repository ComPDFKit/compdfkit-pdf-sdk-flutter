/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

class CPDFEditTextArea extends CPDFEditArea {
  final String text;

  final CPDFAlignment alignment;

  final double fontSize;

  final Color color;

  final double alpha;

  final String familyName;

  final String styleName;

  const CPDFEditTextArea({
    required super.uuid,
    required super.page,
    this.text = '',
    this.alignment = CPDFAlignment.left,
    this.fontSize = 12.0,
    this.color = Colors.black,
    this.alpha = 255,
    this.familyName = 'Helvetica',
    this.styleName = 'Regular',
  }) : super(type: CPDFEditAreaType.text);

  factory CPDFEditTextArea.fromJson(Map<String, dynamic> json) {
    return CPDFEditTextArea(
      uuid: json['uuid'] ?? '',
      page: json['page'] ?? 0,
      text: json['text'] ?? '',
      alignment: CPDFAlignment.fromString(json['alignment']),
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 12.0,
      color: HexColor.fromHex(json['color'] ?? '#000000'),
      alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0,
      familyName: json['familyName'] ?? 'Helvetica',
      styleName: json['styleName'] ?? 'Regular',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'uuid': uuid,
        'page': page,
        'text': text,
        'alignment': alignment.name,
        'fontSize': fontSize,
        'color': color.toHex(),
        'alpha': alpha,
        'familyName': familyName,
        'styleName': styleName,
      };
}
