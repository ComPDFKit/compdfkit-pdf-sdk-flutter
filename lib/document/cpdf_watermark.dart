/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

class CPDFWatermark {
  /// Watermark index in the current document watermark list.
  ///
  /// New watermarks use `-1` until they are read back from a document.
  final int index;

  final CPDFWatermarkType type;

  final String textContent;

  /// Image path for image-type watermark.
  ///
  /// When read from a document, this is non-empty only if image export was
  /// requested and succeeded.
  final String imagePath;

  /// Whether [imagePath] was exported from an existing image watermark.
  final bool isImageExported;

  final Color textColor;

  final int fontSize;

  /// Scaling factor, default is 1.0
  final double scale;

  /// Watermark rotation angle, default is 45°
  final double rotation;

  /// Watermark opacity, default is 1.0, range is 0.0 to 1.0
  final double opacity;

  /// Vertical alignment of the watermark, default is vertical center alignment
  final CPDFWatermarkVerticalAlignment verticalAlignment;

  /// Horizontal alignment of the watermark, default is center alignment
  final CPDFWatermarkHorizontalAlignment horizontalAlignment;

  /// Vertical offset for watermark position
  final double verticalOffset;

  /// Horizontal offset for watermark position
  final double horizontalOffset;

  /// Pages to add the watermark to, e.g., "1,2,3,4,5"
  final List<int> pages;

  /// Position the watermark in front of the content
  final bool isFront;

  /// Enable watermark tiling
  final bool isTilePage;

  /// Set the horizontal spacing for tiled watermarks
  final double horizontalSpacing;

  /// Set the vertical spacing for tiled watermarks
  final double verticalSpacing;

  const CPDFWatermark({
    required this.type,
    required this.pages,
    this.index = -1,
    this.textContent = '',
    this.imagePath = '',
    this.isImageExported = false,
    this.textColor = Colors.black,
    this.fontSize = 24,
    this.scale = 1.0,
    this.rotation = 45,
    this.opacity = 1,
    this.verticalAlignment = CPDFWatermarkVerticalAlignment.center,
    this.horizontalAlignment = CPDFWatermarkHorizontalAlignment.center,
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.isFront = true,
    this.isTilePage = false,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
  });

  /// Text watermark constructor
  ///
  /// This constructor creates a text watermark with customizable properties.
  ///
  /// - [textContent]: The text content of the watermark. (Required)
  /// - [pages]: A list of page indices where the watermark should be applied,
  ///   e.g., `[0, 1, 2, 3]` represents pages 1 through 4. (Required)
  /// - [textColor]: The color of the watermark text. Default is `Colors.black`.
  /// - [fontSize]: The font size of the watermark text. Default is `24`.
  /// - [scale]: Scaling factor for the watermark. Default is 1.0.
  /// - [rotation]: Rotation angle of the watermark in degrees. Default is 45.0.
  /// - [opacity]: The transparency of the watermark, where 1.0 is fully opaque and 0.0 is fully transparent. Default is 1.0.
  /// - [verticalAlignment]: The vertical alignment of the watermark on the page. Default is `CPDFWatermarkVerticalAlignment.center`.
  /// - [horizontalAlignment]: The horizontal alignment of the watermark on the page. Default is `CPDFWatermarkHorizontalAlignment.center`.
  /// - [verticalOffset]: The vertical offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [horizontalOffset]: The horizontal offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [isFront]: Whether the watermark should appear in front of the content. Default is `true`.
  /// - [isTilePage]: Whether to tile the watermark across the page. Default is `false`.
  /// - [horizontalSpacing]: Horizontal spacing between tiled watermarks. Default is 0.0.
  /// - [verticalSpacing]: Vertical spacing between tiled watermarks. Default is 0.0.
  ///
  /// Example:
  /// ```dart
  /// CPDFWatermark.text(
  ///   textContent: 'Confidential',
  ///   pages: [0, 1, 2],
  ///   textColor: Colors.red,
  ///   fontSize: 24,
  /// );
  /// ```
  CPDFWatermark.text({
    required this.textContent,
    required this.pages,
    this.index = -1,
    this.textColor = Colors.black,
    this.fontSize = 24,
    this.scale = 1.0,
    this.rotation = 45,
    this.opacity = 1,
    this.verticalAlignment = CPDFWatermarkVerticalAlignment.center,
    this.horizontalAlignment = CPDFWatermarkHorizontalAlignment.center,
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.isFront = true,
    this.isTilePage = false,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
  })  : type = CPDFWatermarkType.text,
        imagePath = '',
        isImageExported = false;

  /// Image watermark constructor
  ///
  /// This constructor creates an image watermark with customizable properties.
  ///
  /// - [imagePath]: The file path to the image used as a watermark. (Required)
  /// - [pages]: A list of page indices where the watermark should be applied,
  ///   e.g., `[0, 1, 2, 3]` represents pages 1 through 4. (Required)
  /// - [scale]: Scaling factor for the watermark. Default is 1.0.
  /// - [rotation]: Rotation angle of the watermark in degrees. Default is 45.0.
  /// - [opacity]: The transparency of the watermark, where 1.0 is fully opaque and 0.0 is fully transparent. Default is 1.0.
  /// - [verticalAlignment]: The vertical alignment of the watermark on the page. Default is `CPDFWatermarkVerticalAlignment.center`.
  /// - [horizontalAlignment]: The horizontal alignment of the watermark on the page. Default is `CPDFWatermarkHorizontalAlignment.center`.
  /// - [verticalOffset]: The vertical offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [horizontalOffset]: The horizontal offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [isFront]: Whether the watermark should appear in front of the content. Default is `true`.
  /// - [isTilePage]: Whether to tile the watermark across the page. Default is `false`.
  /// - [horizontalSpacing]: Horizontal spacing between tiled watermarks. Default is 0.0.
  /// - [verticalSpacing]: Vertical spacing between tiled watermarks. Default is 0.0.
  ///
  /// Example:
  /// ```dart
  /// CPDFWatermark.image(
  ///   imagePath: '/path/to/image.png',
  ///   pages: [0, 1, 2],
  ///   scale: 0.5,
  /// );
  /// ```
  CPDFWatermark.image({
    required this.imagePath,
    required this.pages,
    this.index = -1,
    this.scale = 1.0,
    this.rotation = 45,
    this.opacity = 1,
    this.verticalAlignment = CPDFWatermarkVerticalAlignment.center,
    this.horizontalAlignment = CPDFWatermarkHorizontalAlignment.center,
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.isFront = true,
    this.isTilePage = false,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
    this.isImageExported = false,
  })  : type = CPDFWatermarkType.image,
        textContent = '',
        textColor = Colors.black,
        fontSize = 24;

  factory CPDFWatermark.fromJson(Map<String, dynamic> json) {
    return CPDFWatermark(
      index: _asInt(json['index'], -1),
      type: _watermarkTypeFromString(json['type']),
      textContent: _asString(json['text_content'], ''),
      imagePath: _asString(json['image_path'], ''),
      isImageExported: _asBool(json['is_image_exported'], false),
      textColor: _asColor(json['text_color']) ?? Colors.black,
      fontSize: _asDouble(json['font_size'], 24).round(),
      scale: _asDouble(json['scale'], 1.0),
      rotation: _asDouble(json['rotation'], 45.0),
      opacity: _asDouble(json['opacity'], 1.0),
      verticalAlignment: _verticalAlignmentFromString(
        json['vertical_alignment'],
      ),
      horizontalAlignment: _horizontalAlignmentFromString(
        json['horizontal_alignment'],
      ),
      verticalOffset: _asDouble(json['vertical_offset'], 0.0),
      horizontalOffset: _asDouble(json['horizontal_offset'], 0.0),
      pages: _pagesFromString(_asString(json['pages'], '')),
      isFront: _asBool(json['is_front'], true),
      isTilePage: _asBool(json['is_tile_page'], false),
      horizontalSpacing: _asDouble(json['horizontal_spacing'], 0.0),
      verticalSpacing: _asDouble(json['vertical_spacing'], 0.0),
    );
  }

  CPDFWatermark copyWith({
    int? index,
    CPDFWatermarkType? type,
    String? textContent,
    String? imagePath,
    bool? isImageExported,
    Color? textColor,
    int? fontSize,
    double? scale,
    double? rotation,
    double? opacity,
    CPDFWatermarkVerticalAlignment? verticalAlignment,
    CPDFWatermarkHorizontalAlignment? horizontalAlignment,
    double? verticalOffset,
    double? horizontalOffset,
    List<int>? pages,
    bool? isFront,
    bool? isTilePage,
    double? horizontalSpacing,
    double? verticalSpacing,
  }) {
    return CPDFWatermark(
      index: index ?? this.index,
      type: type ?? this.type,
      textContent: textContent ?? this.textContent,
      imagePath: imagePath ?? this.imagePath,
      isImageExported: isImageExported ?? this.isImageExported,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      verticalOffset: verticalOffset ?? this.verticalOffset,
      horizontalOffset: horizontalOffset ?? this.horizontalOffset,
      pages: pages ?? this.pages,
      isFront: isFront ?? this.isFront,
      isTilePage: isTilePage ?? this.isTilePage,
      horizontalSpacing: horizontalSpacing ?? this.horizontalSpacing,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'text_content': textContent,
        'image_path': imagePath,
        'text_color': textColor.toHex(),
        'font_size': fontSize,
        'scale': scale,
        'rotation': rotation,
        'opacity': opacity,
        'vertical_alignment': verticalAlignment.name,
        'horizontal_alignment': horizontalAlignment.name,
        'vertical_offset': verticalOffset,
        'horizontal_offset': horizontalOffset,
        'pages': pages.join(','),
        'is_front': isFront,
        'is_tile_page': isTilePage,
        'horizontal_spacing': horizontalSpacing,
        'vertical_spacing': verticalSpacing,
      };

  /// Validates the watermark before creating it in a document.
  ///
  /// Returns `null` when the watermark can be created, or an error message
  /// describing the first validation failure.
  String? validateForCreate() {
    final pagesError = _validatePages();
    if (pagesError != null) {
      return pagesError;
    }
    if (type == CPDFWatermarkType.text && textContent.trim().isEmpty) {
      return 'Text watermark content cannot be empty.';
    }
    if (type == CPDFWatermarkType.image) {
      if (imagePath.trim().isEmpty) {
        return 'Image watermark path cannot be empty.';
      }
      if (!File(imagePath).existsSync()) {
        return 'Image watermark path does not exist.';
      }
    }
    return null;
  }

  /// Validates the watermark before updating it in a document.
  ///
  /// Returns `null` when the watermark can be updated, or an error message
  /// describing the first validation failure.
  String? validateForUpdate() {
    final pagesError = _validatePages();
    if (pagesError != null) {
      return pagesError;
    }
    if (type == CPDFWatermarkType.text && textContent.trim().isEmpty) {
      return 'Text watermark content cannot be empty.';
    }
    if (type == CPDFWatermarkType.image &&
        imagePath.trim().isNotEmpty &&
        !File(imagePath).existsSync()) {
      return 'Image watermark path does not exist.';
    }
    return null;
  }

  String? _validatePages() {
    if (pages.isEmpty) {
      return 'Watermark pages cannot be empty.';
    }
    return null;
  }
}

String _asString(Object? value, String defaultValue) {
  if (value == null) {
    return defaultValue;
  }
  return value.toString();
}

int _asInt(Object? value, int defaultValue) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? defaultValue;
}

double _asDouble(Object? value, double defaultValue) {
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? defaultValue;
}

bool _asBool(Object? value, bool defaultValue) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return defaultValue;
}

Color? _asColor(Object? value) {
  if (value == null) {
    return null;
  }
  final hex = value.toString();
  if (hex.isEmpty) {
    return null;
  }
  return HexColor.fromHex(hex);
}

List<int> _pagesFromString(String pages) {
  final result = <int>[];
  for (final part in pages.split(',')) {
    final trimmed = part.trim();
    if (trimmed.isEmpty) {
      continue;
    }
    if (trimmed.contains('-')) {
      final range = trimmed.split('-');
      if (range.length != 2) {
        continue;
      }
      final start = int.tryParse(range[0].trim());
      final end = int.tryParse(range[1].trim());
      if (start == null || end == null) {
        continue;
      }
      final step = start <= end ? 1 : -1;
      for (var page = start; page != end + step; page += step) {
        result.add(page);
      }
      continue;
    }
    final page = int.tryParse(trimmed);
    if (page != null) {
      result.add(page);
    }
  }
  return result;
}

CPDFWatermarkType _watermarkTypeFromString(Object? value) {
  final name = _asString(value, CPDFWatermarkType.text.name);
  return CPDFWatermarkType.values.firstWhere(
    (type) => type.name == name,
    orElse: () => CPDFWatermarkType.text,
  );
}

CPDFWatermarkVerticalAlignment _verticalAlignmentFromString(Object? value) {
  final name = _asString(value, CPDFWatermarkVerticalAlignment.center.name);
  return CPDFWatermarkVerticalAlignment.values.firstWhere(
    (alignment) => alignment.name == name,
    orElse: () => CPDFWatermarkVerticalAlignment.center,
  );
}

CPDFWatermarkHorizontalAlignment _horizontalAlignmentFromString(Object? value) {
  final name = _asString(value, CPDFWatermarkHorizontalAlignment.center.name);
  return CPDFWatermarkHorizontalAlignment.values.firstWhere(
    (alignment) => alignment.name == name,
    orElse: () => CPDFWatermarkHorizontalAlignment.center,
  );
}

enum CPDFWatermarkVerticalAlignment { top, center, bottom }

enum CPDFWatermarkHorizontalAlignment { left, center, right }
