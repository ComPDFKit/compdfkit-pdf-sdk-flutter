/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

/// Text stamp payload used by [CPDFStampAnnotation] when the stamp type is text.
///
/// A text stamp is rendered using [content] and [date] with a background
/// [shape] and [color].
///
/// Serialization:
/// - Use [CPDFTextStamp.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFTextStamp {
  final String content;

  final String date;

  final CPDFTextStampShape shape;

  final CPDFTextStampColor color;

  const CPDFTextStamp({
    required this.content,
    required this.date,
    this.shape = CPDFTextStampShape.rect,
    this.color = CPDFTextStampColor.white,
  });

  factory CPDFTextStamp.fromJson(Map<String, dynamic> json) {
    return CPDFTextStamp(
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      shape: CPDFTextStampShape.values.firstWhere(
          (e) => e.name == json['shape'],
          orElse: () => CPDFTextStampShape.rect),
      color: CPDFTextStampColor.values.firstWhere(
          (e) => e.name == json['color'],
          orElse: () => CPDFTextStampColor.white),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'shape': shape.name,
      'color': color.name,
    };
  }
}

enum CPDFTextStampShape {
  /// Rectangle background.

  rect,

  /// Left triangle background.
  leftTriangle,

  /// Right triangle background.
  rightTriangle,

  /// No background shape.
  none;
}

enum CPDFTextStampColor {
  /// White.

  white,

  /// Red.
  red,

  /// Green.
  green,

  /// Blue.
  blue;
}
