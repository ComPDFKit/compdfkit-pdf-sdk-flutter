// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

import '../util/cpdf_rectf.dart';

/// Ink annotation model.
///
/// A freehand drawing annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [color]/[alpha]: Stroke color and opacity.
/// - [borderWidth]: Stroke width.
/// - [inkPath]: Stroke data (list of strokes -> points -> coordinates).
///
/// Serialization:
/// - Use [CPDFInkAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFInkAnnotation extends CPDFAnnotation {
  Color color;

  double alpha;

  double borderWidth;

  final List<List<List<double>>>? inkPath;

  CPDFInkAnnotation({
    super.title,
    required super.page,
    super.content,
    super.uuid = '',
    super.createDate,
    super.rect = const CPDFRectF(left: 0, top: 0, right: 0, bottom: 0),
    required this.color,
    this.alpha = 255,
    required this.borderWidth,
    this.inkPath,
  }) : super(type: CPDFAnnotationType.ink);

  factory CPDFInkAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    final List<List<List<double>>> strokes = [];
    final dynamic rawInkPath = json['inkPath'];
    if (rawInkPath != null && rawInkPath is List) {
      for (final stroke in rawInkPath) {
        final List<List<double>> points = [];
        if (stroke is List) {
          for (final point in stroke) {
            if (point is List && point.length >= 2) {
              final double x = _toDouble(point[0], fallback: 0.0);
              final double y = _toDouble(point[1], fallback: 0.0);
              points.add([x,y]);
            }
          }
        }
        strokes.add(points);
      }
    }

    return CPDFInkAnnotation(
        title: common.title,
        page: common.page,
        content: common.content,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        color: HexColor.fromHex(json['color'] ?? '#000000'),
        alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0,
        borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0,
        inkPath: strokes);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'color': color.toHex(),
      'alpha': alpha,
      'borderWidth': borderWidth,
      'inkPath': inkPath,
    };
  }

  static double _toDouble(dynamic v, {required double fallback}) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) {
      final parsed = double.tryParse(v);
      if (parsed != null) return parsed;
    }
    return fallback;
  }
}
