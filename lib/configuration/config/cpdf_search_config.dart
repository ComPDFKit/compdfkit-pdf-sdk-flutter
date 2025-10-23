/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/material.dart';

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

class CPDFSearchConfig {

  final CPDFKeywordConfig normalKeyword;
  final CPDFKeywordConfig focusKeyword;

  const CPDFSearchConfig({
    this.normalKeyword = const CPDFKeywordConfig(
      borderColor: Colors.transparent,
      fillColor: Color(0x77FFFF00),
    ),
    this.focusKeyword = const CPDFKeywordConfig(
      borderColor: Colors.transparent,
      fillColor: Color(0xCCFD7338),
    ),
  });

  factory CPDFSearchConfig.fromJson(Map<String, dynamic> json) {
    return CPDFSearchConfig(
      normalKeyword: CPDFKeywordConfig.fromJson(json['normalKeyword']),
      focusKeyword: CPDFKeywordConfig.fromJson(json['focusKeyword']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'normalKeyword': normalKeyword.toJson(),
      'focusKeyword': focusKeyword.toJson(),
    };
  }
}

class CPDFKeywordConfig {

  final Color borderColor;
  final Color fillColor;

  const CPDFKeywordConfig({
    required this.borderColor,
    required this.fillColor,
  });

  factory CPDFKeywordConfig.fromJson(Map<String, dynamic> json) {
    return CPDFKeywordConfig(
      borderColor: HexColor.fromHex(json['borderColor']),
      fillColor:  HexColor.fromHex(json['fillColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderColor': borderColor.toHex(),
      'fillColor': fillColor.toHex(),
    };
  }
}