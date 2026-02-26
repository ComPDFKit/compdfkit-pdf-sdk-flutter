// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// PDF scroll mode options.
enum ScrollMode {
  verticalContinuous,
  verticalDiscontinuous,
  horizontalContinuous,
  horizontalDiscontinuous,
}

/// Extension methods for [ScrollMode].
extension ScrollModeExtension on ScrollMode {
  /// Whether this mode uses vertical scrolling.
  bool get isVertical =>
      this == ScrollMode.verticalContinuous ||
      this == ScrollMode.verticalDiscontinuous;

  /// Whether this mode uses continuous scrolling.
  bool get isContinuous =>
      this == ScrollMode.verticalContinuous ||
      this == ScrollMode.horizontalContinuous;

  /// Creates a [ScrollMode] from vertical and continuous flags.
  static ScrollMode fromFlags({
    required bool isVertical,
    required bool isContinuous,
  }) {
    if (isVertical) {
      return isContinuous
          ? ScrollMode.verticalContinuous
          : ScrollMode.verticalDiscontinuous;
    } else {
      return isContinuous
          ? ScrollMode.horizontalContinuous
          : ScrollMode.horizontalDiscontinuous;
    }
  }
}
