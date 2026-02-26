// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

/// Data model for an annotation tool in the toolbar.
///
/// Holds the visual properties for displaying an annotation tool button:
/// - [type] - The annotation type (note, highlight, ink, etc.)
/// - [color] - The default color for this annotation type
/// - [alpha] - The default opacity/alpha value (0-255)
///
/// Used by [PdfAnnotationToolBarState] to build the tool list from
/// default annotation attributes.
///
/// Example:
/// ```dart
/// final toolData = PdfAnnotationToolData(
///   type: CPDFAnnotationType.highlight,
///   color: Colors.yellow,
///   alpha: 128, // 50% opacity
/// );
///
/// // Display in toolbar
/// PdfAnnotationToolItem(
///   type: toolData.type,
///   color: toolData.color,
///   alpha: toolData.alpha,
/// );
/// ```
class PdfAnnotationToolData {
  /// The annotation type this tool represents.
  final CPDFAnnotationType type;

  /// The default color for this annotation type.
  Color color;

  /// The default opacity (0-255, where 255 is fully opaque).
  double alpha;

  PdfAnnotationToolData({
    required this.type,
    this.color = Colors.transparent,
    this.alpha = 255,
  });
}
