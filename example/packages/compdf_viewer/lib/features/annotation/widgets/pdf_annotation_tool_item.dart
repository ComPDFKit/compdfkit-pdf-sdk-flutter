// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:compdf_viewer/core/constants.dart';

/// Icon mapping for annotation tool types.
///
/// Each annotation type maps to [base icon, color layer icon]:
/// - Base icon: The main shape/outline
/// - Color layer: The colored portion (for text markup tools)
///
/// Tools with only base icon show static graphics (signature, stamp, etc.).
/// Tools with color layer support custom colors (highlight, underline, etc.).
const _iconData = {
  CPDFAnnotationType.note: [PdfViewerAssets.icAnnotNote, null],
  CPDFAnnotationType.highlight: [
    PdfViewerAssets.icAnnotHighlight,
    PdfViewerAssets.icAnnotHighlightColor,
  ],
  CPDFAnnotationType.underline: [
    PdfViewerAssets.icAnnotUnderline,
    PdfViewerAssets.icAnnotUnderlineColor,
  ],
  CPDFAnnotationType.squiggly: [
    PdfViewerAssets.icAnnotSquiggly,
    PdfViewerAssets.icAnnotSquigglyColor,
  ],
  CPDFAnnotationType.strikeout: [
    PdfViewerAssets.icAnnotStrikeout,
    PdfViewerAssets.icAnnotStrikeoutColor,
  ],
  CPDFAnnotationType.ink: [
    PdfViewerAssets.icAnnotInk,
    PdfViewerAssets.icAnnotInkColor,
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

/// Visual representation of an annotation tool icon.
///
/// Renders SVG icons with customizable color and opacity for annotation tools.
/// Supports two-layer rendering:
/// - Base layer: Static shape/outline
/// - Color layer: Colorized portion (for text markup tools)
///
/// Example:
/// ```dart
/// // Highlight tool with yellow color
/// PdfAnnotationToolItem(
///   type: CPDFAnnotationType.highlight,
///   color: Colors.yellow,
///   alpha: 128,
///   width: 24,
///   height: 24,
/// );
///
/// // Note tool with red color
/// PdfAnnotationToolItem(
///   type: CPDFAnnotationType.note,
///   color: Colors.red,
///   alpha: 255,
/// );
/// ```
class PdfAnnotationToolItem extends StatelessWidget {
  /// The annotation type to display.
  final CPDFAnnotationType type;

  /// The color to apply to the icon.
  final Color color;

  /// The opacity (0-255, where 255 is fully opaque).
  final int alpha;

  /// Icon width in logical pixels.
  final double width;

  /// Icon height in logical pixels.
  final double height;

  const PdfAnnotationToolItem({
    super.key,
    required this.type,
    required this.color,
    required this.alpha,
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    final data = _iconData[type] ?? [null, null];
    final base = data[0];
    final colorLayer = data[1];
    final color = _resolveColor();

    return Stack(
      children: [
        if (colorLayer != null)
          SvgPicture.asset(
            width: width,
            height: height,
            colorLayer,
            package: PdfViewerAssets.packageName,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        if (base != null)
          if (type == CPDFAnnotationType.note) ...{
            SvgPicture.asset(
              base,
              package: PdfViewerAssets.packageName,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          } else ...{
            SvgPicture.asset(
              base,
              package: PdfViewerAssets.packageName,
              width: width,
              height: height,
            ),
          },
        if (colorLayer == null && base == null)
          SizedBox(width: width, height: height),
      ],
    );
  }

  Color _resolveColor() => color.withAlpha(alpha.toInt());
}
