// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

/// A fixed position in a document header or footer.
///
/// The native SDK uses indexes from `0` to `5`; this enum prevents callers
/// from depending on those implementation indexes.
enum CPDFHeaderFooterPosition {
  headerLeft,
  headerCenter,
  headerRight,
  footerLeft,
  footerCenter,
  footerRight,
}

/// Content and text style for one [CPDFHeaderFooterPosition].
class CPDFHeaderFooterSlot {
  const CPDFHeaderFooterSlot({
    required this.position,
    required this.text,
    this.fontName = 'Helvetica',
    this.fontSize = 12,
    this.textColor = Colors.black,
  });

  final CPDFHeaderFooterPosition position;
  final String text;
  final String fontName;
  final double fontSize;
  final Color textColor;

  factory CPDFHeaderFooterSlot.fromJson(Map<String, dynamic> json) {
    return CPDFHeaderFooterSlot(
      position: _positionFromNative(json['position']),
      text: json['text'] as String? ?? '',
      fontName: json['font_name'] as String? ?? 'Helvetica',
      fontSize: _asPositiveDouble(json['font_size'], 12),
      textColor: _asColor(json['text_color']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'position': _positionToNative(position),
      'text': text,
      'font_name': fontName,
      'font_size': fontSize,
      'text_color': textColor.toHex(),
    };
  }
}

/// Complete document header and footer configuration.
///
/// Page indexes are zero-based. Updating replaces all six native positions;
/// use an empty [CPDFHeaderFooterSlot.text] to clear an individual position.
class CPDFHeaderFooter {
  const CPDFHeaderFooter({
    required this.pages,
    required this.margin,
    required this.slots,
  });

  final List<int> pages;
  final EdgeInsets margin;
  final List<CPDFHeaderFooterSlot> slots;

  factory CPDFHeaderFooter.fromJson(Map<String, dynamic> json) {
    final rawMargin = json['margin'];
    final margin = rawMargin is Map
        ? EdgeInsets.fromLTRB(
            _asDouble(rawMargin['left'], 0),
            _asDouble(rawMargin['top'], 0),
            _asDouble(rawMargin['right'], 0),
            _asDouble(rawMargin['bottom'], 0),
          )
        : EdgeInsets.zero;
    final rawSlots = json['slots'];
    return CPDFHeaderFooter(
      pages: _pagesFromString(json['pages'] as String? ?? ''),
      margin: margin,
      slots: rawSlots is List
          ? rawSlots
              .whereType<Map>()
              .map(
                (slot) => CPDFHeaderFooterSlot.fromJson(
                  Map<String, dynamic>.from(slot),
                ),
              )
              .toList()
          : const <CPDFHeaderFooterSlot>[],
    );
  }

  /// Returns a validation error, or `null` when this value can be submitted.
  String? validate() {
    if (pages.isEmpty || pages.any((page) => page < 0)) {
      return 'Header/footer pages must contain zero-based page indexes.';
    }
    if (slots.isEmpty) {
      return 'Header/footer slots cannot be empty.';
    }
    final positions = <CPDFHeaderFooterPosition>{};
    for (final slot in slots) {
      if (!positions.add(slot.position)) {
        return 'Header/footer slots cannot use duplicate positions.';
      }
      if (slot.fontSize <= 0) {
        return 'Header/footer fontSize must be greater than zero.';
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pages': pages.join(','),
      'margin': <String, double>{
        'left': margin.left,
        'top': margin.top,
        'right': margin.right,
        'bottom': margin.bottom,
      },
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }
}

String _positionToNative(CPDFHeaderFooterPosition position) {
  switch (position) {
    case CPDFHeaderFooterPosition.headerLeft:
      return 'header_left';
    case CPDFHeaderFooterPosition.headerCenter:
      return 'header_center';
    case CPDFHeaderFooterPosition.headerRight:
      return 'header_right';
    case CPDFHeaderFooterPosition.footerLeft:
      return 'footer_left';
    case CPDFHeaderFooterPosition.footerCenter:
      return 'footer_center';
    case CPDFHeaderFooterPosition.footerRight:
      return 'footer_right';
  }
}

CPDFHeaderFooterPosition _positionFromNative(Object? value) {
  switch (value) {
    case 'header_left':
      return CPDFHeaderFooterPosition.headerLeft;
    case 'header_center':
      return CPDFHeaderFooterPosition.headerCenter;
    case 'header_right':
      return CPDFHeaderFooterPosition.headerRight;
    case 'footer_left':
      return CPDFHeaderFooterPosition.footerLeft;
    case 'footer_center':
      return CPDFHeaderFooterPosition.footerCenter;
    case 'footer_right':
      return CPDFHeaderFooterPosition.footerRight;
    default:
      return CPDFHeaderFooterPosition.headerLeft;
  }
}

double _asDouble(Object? value, double fallback) {
  if (value is num) {
    return value.toDouble();
  }
  return fallback;
}

Color _asColor(Object? value) {
  if (value is String) {
    try {
      return HexColor.fromHex(value);
    } on FormatException {
      return Colors.black;
    }
  }
  return Colors.black;
}

List<int> _pagesFromString(String pages) {
  final result = <int>[];
  for (final rawPart in pages.split(',')) {
    final part = rawPart.trim();
    final range = part.split('-');
    if (range.length == 2) {
      final start = int.tryParse(range.first.trim());
      final end = int.tryParse(range.last.trim());
      if (start != null && end != null && start >= 0 && end >= start) {
        result.addAll(
            List<int>.generate(end - start + 1, (index) => start + index));
      }
      continue;
    }
    final page = int.tryParse(part);
    if (page != null && page >= 0) {
      result.add(page);
    }
  }
  return result;
}

double _asPositiveDouble(Object? value, double fallback) {
  final number = _asDouble(value, fallback);
  return number > 0 ? number : fallback;
}
