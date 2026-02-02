/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../util/extension/cpdf_color_extension.dart';

class CPDFUiStyleConfig {
  final String bookmarkIcon;
  final CPDFUiStyleIcons icons;
  final Color selectTextColor;
  final CPDFUiDisplayPageRectStyle displayPageRect;
  final CPDFUiScreenshotStyle screenshot;
  final CPDFUiFormPreviewStyle formPreview;
  final CPDFUiBorderStyle defaultBorderStyle;
  final CPDFUiBorderStyle focusBorderStyle;
  final CPDFUiBorderStyle cropImageStyle;

  factory CPDFUiStyleConfig.create({
    String? bookmarkIcon,
    CPDFUiStyleIcons? icons,
    Color? selectTextColor,
    CPDFUiDisplayPageRectStyle? displayPageRect,
    CPDFUiScreenshotStyle? screenshot,
    CPDFUiFormPreviewStyle? formPreview,
    CPDFUiBorderStyle? defaultBorderStyle,
    CPDFUiBorderStyle? focusBorderStyle,
    CPDFUiBorderStyle? cropImageStyle,
  }) {
    final base = defaultTargetPlatform == TargetPlatform.iOS
        ? const CPDFUiStyleConfig.ios()
        : const CPDFUiStyleConfig.android();
    return base.copyWith(
      bookmarkIcon: bookmarkIcon,
      icons: icons,
      selectTextColor: selectTextColor,
      displayPageRect: displayPageRect,
      screenshot: screenshot,
      formPreview: formPreview,
      defaultBorderStyle: defaultBorderStyle,
      focusBorderStyle: focusBorderStyle,
      cropImageStyle: cropImageStyle,
    );
  }

  const CPDFUiStyleConfig({
    this.bookmarkIcon = "",
    this.icons = const CPDFUiStyleIcons(),
    this.selectTextColor = const Color(0x33000000),
    this.displayPageRect = const CPDFUiDisplayPageRectStyle(),
    this.screenshot = const CPDFUiScreenshotStyle(),
    this.formPreview = const CPDFUiFormPreviewStyle(),
    this.defaultBorderStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF888888),
        borderWidth: 2,
        borderDashPattern: [10,10]),
    this.focusBorderStyle = const CPDFUiBorderStyle(
        nodeColor: Color(0xFF6499FF),
        borderColor: Color(0xFF6499FF),
        borderWidth: 2,
        borderDashPattern: [10, 10]),
    this.cropImageStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF6499FF),
        borderWidth: 5,
        borderDashPattern: [10, 10]),
  });

  const CPDFUiStyleConfig.android({
    this.bookmarkIcon = "",
    this.icons = const CPDFUiStyleIcons(),
    this.selectTextColor = const Color(0x33000000),
    this.displayPageRect = const CPDFUiDisplayPageRectStyle(),
    this.screenshot = const CPDFUiScreenshotStyle(
      borderWidth: 5,
      borderDashPattern: [30,8]
    ),
    this.formPreview = const CPDFUiFormPreviewStyle(),
    this.defaultBorderStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF888888),
        borderWidth: 2,
        borderDashPattern: [20,10]),
    this.focusBorderStyle = const CPDFUiBorderStyle(
        nodeColor: Color(0xFF6499FF),
        borderColor: Color(0xFF6499FF),
        borderWidth: 2,
        borderDashPattern: [20, 10]),
    this.cropImageStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF6499FF),
        borderWidth: 2,
        borderDashPattern: [20, 10]),
  });

  const CPDFUiStyleConfig.ios({
    this.bookmarkIcon = "",
    this.icons = const CPDFUiStyleIcons(),
    this.selectTextColor = const Color(0x33000000),
    this.displayPageRect = const CPDFUiDisplayPageRectStyle(),
    this.screenshot = const CPDFUiScreenshotStyle(),
    this.formPreview = const CPDFUiFormPreviewStyle(),
    this.defaultBorderStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF888888),
        borderWidth: 1,
        borderDashPattern: [10,10]),
    this.focusBorderStyle = const CPDFUiBorderStyle(
        nodeColor: Color(0xFF6499FF),
        borderColor: Color(0xFF6499FF),
        borderWidth: 1,
        borderDashPattern: [10, 10]),
    this.cropImageStyle = const CPDFUiBorderStyle(
        borderColor: Color(0xFF6499FF),
        borderWidth: 2,
        borderDashPattern: [10, 10]),
  });

  CPDFUiStyleConfig copyWith({
    String? bookmarkIcon,
    CPDFUiStyleIcons? icons,
    Color? selectTextColor,
    CPDFUiDisplayPageRectStyle? displayPageRect,
    CPDFUiScreenshotStyle? screenshot,
    CPDFUiFormPreviewStyle? formPreview,
    CPDFUiBorderStyle? defaultBorderStyle,
    CPDFUiBorderStyle? focusBorderStyle,
    CPDFUiBorderStyle? cropImageStyle,
  }) {
    return CPDFUiStyleConfig(
      bookmarkIcon: bookmarkIcon ?? this.bookmarkIcon,
      icons: icons ?? this.icons,
      selectTextColor: selectTextColor ?? this.selectTextColor,
      displayPageRect: displayPageRect ?? this.displayPageRect,
      screenshot: screenshot ?? this.screenshot,
      formPreview: formPreview ?? this.formPreview,
      defaultBorderStyle: defaultBorderStyle ?? this.defaultBorderStyle,
      focusBorderStyle: focusBorderStyle ?? this.focusBorderStyle,
      cropImageStyle: cropImageStyle ?? this.cropImageStyle,
    );
  }

  factory CPDFUiStyleConfig.fromJson(Map<String, dynamic> json) {
    return CPDFUiStyleConfig(
      bookmarkIcon: json['bookmarkIcon'] as String? ?? '',
      icons: CPDFUiStyleIcons.fromJson(
          (json['icons'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      selectTextColor: HexColor.fromHex(json['selectTextColor']),
      displayPageRect: CPDFUiDisplayPageRectStyle.fromJson(
          (json['displayPageRect'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      screenshot: CPDFUiScreenshotStyle.fromJson(
          (json['screenshot'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      formPreview: CPDFUiFormPreviewStyle.fromJson(
          (json['formPreview'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      defaultBorderStyle: CPDFUiBorderStyle.fromJson(
          (json['defaultBorderStyle'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      focusBorderStyle: CPDFUiBorderStyle.fromJson(
          (json['focusBorderStyle'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
      cropImageStyle: CPDFUiBorderStyle.fromJson(
          (json['cropImageStyle'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bookmarkIcon': bookmarkIcon,
        'icons': icons.toJson(),
        'selectTextColor': selectTextColor.toHex(),
        'displayPageRect': displayPageRect.toJson(),
        'screenshot': screenshot.toJson(),
        'formPreview': formPreview.toJson(),
        'defaultBorderStyle': defaultBorderStyle.toJson(),
        'focusBorderStyle': focusBorderStyle.toJson(),
        'cropImageStyle': cropImageStyle.toJson(),
      };
}

class CPDFUiStyleIcons {
  final String selectTextLeftIcon;
  final String selectTextRightIcon;
  final String selectTextIcon;
  final String rotationAnnotationIcon;

  const CPDFUiStyleIcons({
    this.selectTextLeftIcon = "",
    this.selectTextRightIcon = "",
    this.selectTextIcon = "",
    this.rotationAnnotationIcon = "",
  });

  factory CPDFUiStyleIcons.fromJson(Map<String, dynamic> json) =>
      CPDFUiStyleIcons(
        selectTextLeftIcon: json['selectTextLeftIcon'] as String? ?? '',
        selectTextRightIcon: json['selectTextRightIcon'] as String? ?? '',
        selectTextIcon: json['selectTextIcon'] as String? ?? '',
        rotationAnnotationIcon: json['rotationAnnotationIcon'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'selectTextLeftIcon': selectTextLeftIcon,
        'selectTextRightIcon': selectTextRightIcon,
        'selectTextIcon': selectTextIcon,
        'rotationAnnotationIcon': rotationAnnotationIcon,
      };
}

class CPDFUiDisplayPageRectStyle {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final List<double> borderDashPattern;

  const CPDFUiDisplayPageRectStyle({
    this.fillColor = const Color(0x4D1460F3),
    this.borderColor = const Color(0xFF6499FF),
    this.borderWidth = 2,
    this.borderDashPattern = const [10, 0],
  });

  factory CPDFUiDisplayPageRectStyle.fromJson(Map<String, dynamic> json) =>
      CPDFUiDisplayPageRectStyle(
        fillColor: HexColor.fromHex(json['fillColor']),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 2.0,
        borderDashPattern: (json['borderDashPattern'] as List?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            <double>[],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fillColor': fillColor.toHex(),
        'borderColor': borderColor.toHex(),
        'borderWidth': borderWidth,
        'borderDashPattern': borderDashPattern,
      };
}

class CPDFUiScreenshotStyle {
  final Color outsideColor;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final List<double> borderDashPattern;

  const CPDFUiScreenshotStyle({
    this.outsideColor = Colors.transparent,
    this.fillColor = Colors.transparent,
    this.borderColor = const Color(0xFF6499FF),
    this.borderWidth = 5,
    this.borderDashPattern = const [20, 8],
  });

  factory CPDFUiScreenshotStyle.fromJson(Map<String, dynamic> json) =>
      CPDFUiScreenshotStyle(
        outsideColor: HexColor.fromHex(json['outsideColor']),
        fillColor: HexColor.fromHex(json['fillColor']),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 5.0,
        borderDashPattern: (json['borderDashPattern'] as List?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            <double>[],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'outsideColor': outsideColor.toHex(),
        'fillColor': fillColor.toHex(),
        'borderColor': borderColor.toHex(),
        'borderWidth': borderWidth,
        'borderDashPattern': borderDashPattern,
      };
}

enum CPDFFormPreviewStyleType {
  fill,
  stroke,
}

class CPDFUiFormPreviewStyle {
  final CPDFFormPreviewStyleType style;

  final double strokeWidth;

  final Color color;

  const CPDFUiFormPreviewStyle({
    this.style = CPDFFormPreviewStyleType.fill,
    this.strokeWidth = 2,
    this.color = const Color(0x4D1460F3),
  });

  factory CPDFUiFormPreviewStyle.fromJson(Map<String, dynamic> json) =>
      CPDFUiFormPreviewStyle(
        style: _parseFormPreviewStyleType(json['style']),
        strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2,
        color: HexColor.fromHex(json['color']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'style': style.name,
        'strokeWidth': strokeWidth,
        'color': color.toHex(),
      };
}

CPDFFormPreviewStyleType _parseFormPreviewStyleType(dynamic raw) {
  if (raw is String) {
    switch (raw.toLowerCase()) {
      case 'fill':
        return CPDFFormPreviewStyleType.fill;
      case 'stroke':
        return CPDFFormPreviewStyleType.stroke;
    }
  } else if (raw is CPDFFormPreviewStyleType) {
    return raw;
  }
  return CPDFFormPreviewStyleType.fill;
}

class CPDFUiBorderStyle {
  final Color? nodeColor;

  final Color borderColor;

  final double borderWidth;

  final List<double> borderDashPattern;

  const CPDFUiBorderStyle({
    this.nodeColor = const Color(0xFF6499FF),
    this.borderColor = const Color(0xFF6499FF),
    this.borderWidth = 2,
    this.borderDashPattern = const [10, 10],
  });

  factory CPDFUiBorderStyle.fromJson(Map<String, dynamic> json) =>
      CPDFUiBorderStyle(
        nodeColor: HexColor.fromHex(json['nodeColor'] ?? '#00000000'),
        borderColor: HexColor.fromHex(json['borderColor']),
        borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 2.0,
        borderDashPattern: (json['borderDashPattern'] as List?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            <double>[],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nodeColor': nodeColor?.toHex(),
        'borderColor': borderColor.toHex(),
        'borderWidth': borderWidth,
        'borderDashPattern': borderDashPattern,
      };
}
