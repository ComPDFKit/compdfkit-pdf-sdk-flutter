// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_header_footer.dart';
import 'package:flutter/material.dart';

/// Bates numbering rule used by the native SDK.
enum CPDFBatesRule {
  v1(1),
  v2(2);

  const CPDFBatesRule(this.value);

  final int value;

  static CPDFBatesRule fromValue(Object? value) {
    return value == 1 ? CPDFBatesRule.v1 : CPDFBatesRule.v2;
  }
}

/// Complete Bates numbering configuration.
class CPDFBates {
  const CPDFBates({
    required this.pages,
    required this.margin,
    required this.pageOffset,
    required this.slots,
    this.rule = CPDFBatesRule.v2,
  });

  final List<int> pages;
  final EdgeInsets margin;
  final int pageOffset;
  final CPDFBatesRule rule;
  final List<CPDFHeaderFooterSlot> slots;

  factory CPDFBates.fromJson(Map<String, dynamic> json) {
    final rawMargin = json['margin'];
    final margin = rawMargin is Map
        ? EdgeInsets.fromLTRB(
            _number(rawMargin['left']),
            _number(rawMargin['top']),
            _number(rawMargin['right']),
            _number(rawMargin['bottom']),
          )
        : EdgeInsets.zero;
    final rawSlots = json['slots'];
    return CPDFBates(
      pages: _pagesFromString(json['pages'] as String? ?? ''),
      margin: margin,
      pageOffset:
          json['page_offset'] is num ? (json['page_offset'] as num).toInt() : 0,
      rule: CPDFBatesRule.fromValue(json['rule']),
      slots: rawSlots is List
          ? rawSlots
              .whereType<Map>()
              .map((slot) => CPDFHeaderFooterSlot.fromJson(
                    Map<String, dynamic>.from(slot),
                  ))
              .toList()
          : const <CPDFHeaderFooterSlot>[],
    );
  }

  String? validate() {
    if (pages.isEmpty || pages.any((page) => page < 0)) {
      return 'Bates pages must contain zero-based page indexes.';
    }
    if (slots.isEmpty) {
      return 'Bates slots cannot be empty.';
    }
    final positions = <CPDFHeaderFooterPosition>{};
    for (final slot in slots) {
      if (!positions.add(slot.position)) {
        return 'Bates slots cannot use duplicate positions.';
      }
      if (slot.fontSize <= 0) {
        return 'Bates fontSize must be greater than zero.';
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
      'page_offset': pageOffset,
      'rule': rule.value,
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }
}

double _number(Object? value) => value is num ? value.toDouble() : 0;

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
    } else {
      final page = int.tryParse(rawPart.trim());
      if (page != null && page >= 0) result.add(page);
    }
  }
  return result;
}
