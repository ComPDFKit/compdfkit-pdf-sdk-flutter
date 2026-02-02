/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'dart:ui';

/// A rectangle defined by left, top, right, and bottom coordinates.
/// {@category util}
class CPDFRectF {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const CPDFRectF(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  const CPDFRectF.isEmpty()
      : left = 0,
        top = 0,
        right = 0,
        bottom = 0;

  factory CPDFRectF.fromLTRB(
      double left, double top, double right, double bottom) {
    return CPDFRectF(left: left, top: top, right: right, bottom: bottom);
  }

  factory CPDFRectF.fromJson(Map<String, dynamic> json) {
    return CPDFRectF(
        left: json['left'] ?? 0,
        top: json['top'] ?? 0,
        right: json['right'] ?? 0,
        bottom: json['bottom'] ?? 0);
  }

  Size get size => Size(right - left, bottom - top);

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    };
  }

  @override
  String toString() {
    return [left, top, right, bottom].toString();
  }
}
