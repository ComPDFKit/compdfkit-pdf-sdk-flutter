// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import '../configuration/cpdf_options.dart';

/// Border style configuration for annotations.
///
/// This model describes how an annotation border should be rendered.
///
/// Key properties:
/// - [style]: Border line style.
/// - [dashGap]: Dash spacing (only meaningful when [style] is dashed).
///
/// Serialization:
/// - Use [CPDFBorderStyle.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFBorderStyle {
  /// default: [CPDFAnnotBorderStyle.solid]
  final CPDFAnnotBorderStyle style;

  /// Dashed gap, only style=[CPDFAnnotBorderStyle.dashed] is valid.
  final double dashGap;

  const CPDFBorderStyle(
      {this.style = CPDFAnnotBorderStyle.solid, this.dashGap = 8.0});

  const CPDFBorderStyle.solid()
      : style = CPDFAnnotBorderStyle.solid,
        dashGap = 0;

  const CPDFBorderStyle.dashed({this.dashGap = 9.0})
      : style = CPDFAnnotBorderStyle.dashed;

  factory CPDFBorderStyle.fromJson(Map<String, dynamic> json) {
    return CPDFBorderStyle(
      style: CPDFAnnotBorderStyle.values.firstWhere(
          (e) => e.name == json['style'],
          orElse: () => CPDFAnnotBorderStyle.solid),
      dashGap: json['dashGap']?.toDouble() ?? 8.0,
    );
  }

  Map<String, dynamic> toJson() => {'style': style.name, 'dashGap': dashGap};
}
