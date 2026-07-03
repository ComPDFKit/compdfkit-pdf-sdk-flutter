// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/util/cpdf_rectf.dart';

/// Text line information on a PDF page.
///
/// {@category page}
class CPDFTextLine {
  /// Page index, zero-based.
  final int pageIndex;

  /// Line index in the page line collection, zero-based.
  final int lineIndex;

  /// Start character index of this line in the page text.
  final int location;

  /// Character count of this line.
  final int length;

  /// Bounding rectangle of this line in page coordinates.
  ///
  /// The rectangle follows the same [CPDFRectF] format used by
  /// `CPDFReaderWidgetController.setDisplayPageIndex(rectList: ...)`, so it
  /// can be passed directly to `rectList` to highlight the line in the reader
  /// view.
  final CPDFRectF rect;

  const CPDFTextLine({
    required this.pageIndex,
    required this.lineIndex,
    required this.location,
    required this.length,
    required this.rect,
  });

  factory CPDFTextLine.fromJson(Map<String, dynamic> json) {
    return CPDFTextLine(
      pageIndex: json['page_index'] ?? 0,
      lineIndex: json['line_index'] ?? 0,
      location: json['location'] ?? 0,
      length: json['length'] ?? 0,
      rect: CPDFRectF.fromJson(
        Map<String, dynamic>.from(json['rect'] ?? {}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_index': pageIndex,
      'line_index': lineIndex,
      'location': location,
      'length': length,
      'rect': rect.toJson(),
    };
  }
}
