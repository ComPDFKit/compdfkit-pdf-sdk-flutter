// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

/// The content used to draw a document background.
enum CPDFBackgroundType {
  color('color'),
  image('image');

  const CPDFBackgroundType(this.value);

  final String value;

  static CPDFBackgroundType fromValue(Object? value) {
    return value == CPDFBackgroundType.image.value
        ? CPDFBackgroundType.image
        : CPDFBackgroundType.color;
  }
}

/// Horizontal placement of a document background.
enum CPDFBackgroundHorizontalAlignment {
  left('left'),
  center('center'),
  right('right');

  const CPDFBackgroundHorizontalAlignment(this.value);

  final String value;

  static CPDFBackgroundHorizontalAlignment fromValue(Object? value) {
    return CPDFBackgroundHorizontalAlignment.values.firstWhere(
      (alignment) => alignment.value == value,
      orElse: () => CPDFBackgroundHorizontalAlignment.center,
    );
  }
}

/// Vertical placement of a document background.
enum CPDFBackgroundVerticalAlignment {
  top('top'),
  center('center'),
  bottom('bottom');

  const CPDFBackgroundVerticalAlignment(this.value);

  final String value;

  static CPDFBackgroundVerticalAlignment fromValue(Object? value) {
    return CPDFBackgroundVerticalAlignment.values.firstWhere(
      (alignment) => alignment.value == value,
      orElse: () => CPDFBackgroundVerticalAlignment.center,
    );
  }
}

/// Complete document background configuration.
///
/// Native SDKs do not expose the source image of an existing image
/// background. Consequently, [imagePath] is a write-only input and is `null`
/// when an image background is read from a document.
class CPDFBackground {
  const CPDFBackground({
    required this.pages,
    required this.type,
    this.color,
    this.imagePath,
    this.opacity = 1,
    this.scale = 1,
    this.rotation = 0,
    this.horizontalAlignment = CPDFBackgroundHorizontalAlignment.center,
    this.verticalAlignment = CPDFBackgroundVerticalAlignment.center,
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.allowView = true,
    this.allowPrint = true,
  });

  const CPDFBackground.color({
    required this.pages,
    required Color this.color,
    this.opacity = 1,
    this.scale = 1,
    this.rotation = 0,
    this.horizontalAlignment = CPDFBackgroundHorizontalAlignment.center,
    this.verticalAlignment = CPDFBackgroundVerticalAlignment.center,
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.allowView = true,
    this.allowPrint = true,
  })  : type = CPDFBackgroundType.color,
        imagePath = null;

  const CPDFBackground.image({
    required this.pages,
    required String this.imagePath,
    this.opacity = 1,
    this.scale = 1,
    this.rotation = 0,
    this.horizontalAlignment = CPDFBackgroundHorizontalAlignment.center,
    this.verticalAlignment = CPDFBackgroundVerticalAlignment.center,
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.allowView = true,
    this.allowPrint = true,
  })  : type = CPDFBackgroundType.image,
        color = null;

  final List<int> pages;
  final CPDFBackgroundType type;
  final Color? color;

  /// Local image path used when applying an image background.
  ///
  /// This value cannot be recovered from an existing native background.
  final String? imagePath;
  final double opacity;
  final double scale;
  final double rotation;
  final CPDFBackgroundHorizontalAlignment horizontalAlignment;
  final CPDFBackgroundVerticalAlignment verticalAlignment;
  final double horizontalOffset;
  final double verticalOffset;
  final bool allowView;
  final bool allowPrint;

  factory CPDFBackground.fromJson(Map<String, dynamic> json) {
    return CPDFBackground(
      pages: _pagesFromString(json['pages'] as String? ?? ''),
      type: CPDFBackgroundType.fromValue(json['type']),
      color: _color(json['color']),
      imagePath: _nonEmptyString(json['image_path']),
      opacity: _number(json['opacity'], 1),
      scale: _number(json['scale'], 1),
      rotation: _number(json['rotation'], 0),
      horizontalAlignment: CPDFBackgroundHorizontalAlignment.fromValue(
        json['horizontal_alignment'],
      ),
      verticalAlignment: CPDFBackgroundVerticalAlignment.fromValue(
        json['vertical_alignment'],
      ),
      horizontalOffset: _number(json['horizontal_offset'], 0),
      verticalOffset: _number(json['vertical_offset'], 0),
      allowView: json['allow_view'] is bool ? json['allow_view'] as bool : true,
      allowPrint:
          json['allow_print'] is bool ? json['allow_print'] as bool : true,
    );
  }

  /// Validates this value before it is sent to a native SDK.
  String? validateForUpdate() {
    if (pages.isEmpty || pages.any((page) => page < 0)) {
      return 'Background pages must contain zero-based page indexes.';
    }
    if (opacity < 0 || opacity > 1) {
      return 'Background opacity must be between 0 and 1.';
    }
    if (scale <= 0) {
      return 'Background scale must be greater than zero.';
    }
    if (rotation < 0 || rotation > 360) {
      return 'Background rotation must be between 0 and 360.';
    }
    if (type == CPDFBackgroundType.color && color == null) {
      return 'A color background requires color.';
    }
    if (type == CPDFBackgroundType.image &&
        (imagePath == null || imagePath!.trim().isEmpty)) {
      return 'An image background requires imagePath.';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pages': pages.join(','),
      'type': type.value,
      if (color != null) 'color': color!.withValues(alpha: 1).toHex(),
      if (imagePath != null) 'image_path': imagePath,
      'opacity': opacity,
      'scale': scale,
      'rotation': rotation,
      'horizontal_alignment': horizontalAlignment.value,
      'vertical_alignment': verticalAlignment.value,
      'horizontal_offset': horizontalOffset,
      'vertical_offset': verticalOffset,
      'allow_view': allowView,
      'allow_print': allowPrint,
    };
  }
}

double _number(Object? value, double fallback) {
  return value is num ? value.toDouble() : fallback;
}

String? _nonEmptyString(Object? value) {
  return value is String && value.isNotEmpty ? value : null;
}

Color? _color(Object? value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  try {
    return HexColor.fromHex(value);
  } on FormatException {
    return null;
  }
}

List<int> _pagesFromString(String pages) {
  final result = <int>[];
  for (final rawPart in pages.split(',')) {
    final range = rawPart.trim().split('-');
    if (range.length == 2) {
      final start = int.tryParse(range[0]);
      final end = int.tryParse(range[1]);
      if (start != null && end != null && start >= 0 && end >= start) {
        result.addAll(List<int>.generate(end - start + 1, (i) => start + i));
      }
      continue;
    }
    final page = int.tryParse(rawPart.trim());
    if (page != null && page >= 0) {
      result.add(page);
    }
  }
  return result;
}
