// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_ink_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_line_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:compdf_viewer/core/constants.dart';

/// Icon mapping for all supported PDF annotation types
const _iconData = {
  CPDFAnnotationType.note: [PdfViewerAssets.icAnnotNote, null],
  CPDFAnnotationType.highlight: [
    PdfViewerAssets.icAnnotHighlight,
    PdfViewerAssets.icAnnotHighlightColor
  ],
  CPDFAnnotationType.underline: [
    PdfViewerAssets.icAnnotUnderline,
    PdfViewerAssets.icAnnotUnderlineColor
  ],
  CPDFAnnotationType.squiggly: [
    PdfViewerAssets.icAnnotSquiggly,
    PdfViewerAssets.icAnnotSquigglyColor
  ],
  CPDFAnnotationType.strikeout: [
    PdfViewerAssets.icAnnotStrikeout,
    PdfViewerAssets.icAnnotStrikeoutColor
  ],
  CPDFAnnotationType.ink: [
    PdfViewerAssets.icAnnotInk,
    PdfViewerAssets.icAnnotInkColor
  ],
  CPDFAnnotationType.square: [null, PdfViewerAssets.icAnnotRec],
  CPDFAnnotationType.circle: [null, PdfViewerAssets.icAnnotOval],
  CPDFAnnotationType.arrow: [null, PdfViewerAssets.icAnnotArrow],
  CPDFAnnotationType.line: [null, PdfViewerAssets.icAnnotLine],
  CPDFAnnotationType.signature: [PdfViewerAssets.icAnnotSign, null],
  CPDFAnnotationType.freetext: [PdfViewerAssets.icAnnotText, null],
  CPDFAnnotationType.stamp: [PdfViewerAssets.icAnnotStamp, null],
  CPDFAnnotationType.sound: [PdfViewerAssets.icAnnotVoice, null],
  CPDFAnnotationType.link: [PdfViewerAssets.icAnnotLink, null],
  CPDFAnnotationType.pictures: [PdfViewerAssets.icAnnotImage, null],
};

/// A widget that displays a type-specific icon for PDF annotations.
///
/// This widget renders a visual representation of the annotation type using
/// SVG icons. Many annotation types use two-layer icons (base + color layer)
/// to show both the annotation type and its configured color.
///
/// **Supported Annotation Types:**
/// - Note, Highlight, Underline, Squiggly, Strikeout
/// - Ink, Square, Circle, Arrow, Line
/// - Signature, Freetext, Stamp, Sound, Link, Pictures
///
/// **Icon Rendering:**
/// - Single-layer icons: Fixed color icons (e.g., note, signature)
/// - Two-layer icons: Base icon + color layer (e.g., highlight, ink)
/// - Color extraction: Reads color from annotation properties
///
/// **Usage:**
/// ```dart
/// AnnotationItemIcon(annotation: myAnnotation)
/// ```
class AnnotationItemIcon extends StatelessWidget {
  final CPDFAnnotation annotation;

  const AnnotationItemIcon({super.key, required this.annotation});

  @override
  Widget build(BuildContext context) {
    final data = _iconData[annotation.type] ?? [null, null];
    final base = data[0];
    final colorLayer = data[1];
    final color = _resolveColor(annotation);

    return Stack(
      children: [
        if (colorLayer != null)
          SvgPicture.asset(colorLayer,
              package: PdfViewerAssets.packageName,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
        if (base != null)
          SvgPicture.asset(base, package: PdfViewerAssets.packageName),
        if (colorLayer == null && base == null)
          const SizedBox(width: 24, height: 24),
      ],
    );
  }

  Color _resolveColor(CPDFAnnotation annotation) {
    switch (annotation.type) {
      case CPDFAnnotationType.highlight:
      case CPDFAnnotationType.underline:
      case CPDFAnnotationType.squiggly:
      case CPDFAnnotationType.strikeout:
        final markup = annotation as CPDFMarkupAnnotation;
        return markup.color.withAlpha(markup.alpha.toInt());
      case CPDFAnnotationType.ink:
        final ink = annotation as CPDFInkAnnotation;
        return ink.color.withAlpha(ink.alpha.toInt());
      case CPDFAnnotationType.square:
        final square = annotation as CPDFSquareAnnotation;
        return square.borderColor.withAlpha(square.borderAlpha.toInt());
      case CPDFAnnotationType.circle:
        final circle = annotation as CPDFCircleAnnotation;
        return circle.fillColor.withAlpha(circle.fillAlpha.toInt());
      case CPDFAnnotationType.arrow:
      case CPDFAnnotationType.line:
        final line = annotation as CPDFLineAnnotation;
        return line.borderColor.withAlpha(line.borderAlpha.toInt());
      default:
        return Colors.black54;
    }
  }
}
