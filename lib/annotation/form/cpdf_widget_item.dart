/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:convert';

/// Option item used by combo box / list box widgets.
///
/// This model represents a selectable item in combo box and list box widgets.
///
/// - [text] is the display label.
/// - [value] is the underlying value.
///
/// Serialization:
/// - Use [CPDFWidgetItem.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category forms}
class CPDFWidgetItem {
  final String text;

  final String value;

  CPDFWidgetItem({
    required this.text,
    required this.value,
  });

  factory CPDFWidgetItem.fromJson(Map<String, dynamic> json) {
    return CPDFWidgetItem(
      text: json['text'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

}