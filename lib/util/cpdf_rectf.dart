/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'dart:ui';

class CPDFRectF {
  final double left;
  final double top;
  final double right;
  final double bottom;

  CPDFRectF(this.left, this.top, this.right, this.bottom);

  factory CPDFRectF.fromLTRB(
      double left, double top, double right, double bottom) {
    return CPDFRectF(left, top, right, bottom);
  }

  factory CPDFRectF.fromJson(Map<String, dynamic> json) {
    return CPDFRectF(json['left'], json['top'], json['right'], json['bottom']);
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
