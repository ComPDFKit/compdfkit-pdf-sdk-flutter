/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

class CPDFTextRange {

  final int pageIndex;

  final int location;

  final int length;

  final int textRangeIndex;

  const CPDFTextRange({
    required this.pageIndex,
    required this.location,
    required this.length,
     this.textRangeIndex = 0,
  });

  factory CPDFTextRange.fromJson(Map<String, dynamic> map) {
    return CPDFTextRange(
      pageIndex: map['page_index']?? 0,
      location: map['location'] ?? 0,
      length: map['length'] ?? 0,
      textRangeIndex: map['text_range_index'] ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'page_index': pageIndex,
      'location': location,
      'length': length,
      'text_range_index': textRangeIndex,
    };
  }

}

extension CPDFTextRangeExtension on CPDFTextRange {

  /// Returns a new CPDFTextRange that expands the current range by the given number of characters
  /// before and after the original range.
  ///
  /// If the `before` value causes the start position to be less than 0, it will automatically
  /// clamp the start to 0 and reduce the total length accordingly to avoid overflow.
  ///
  /// Parameters:
  /// - [before]: The number of characters to include before the original range. Default is 0.
  /// - [after]: The number of characters to include after the original range. Default is 0.
  ///
  /// Returns:
  /// A new CPDFTextRange instance with adjusted `location` and `length`.
  CPDFTextRange expanded({int before = 0, int after = 0}) {
    int newStart = location - before;
    int newLength = length + before + after;

    if (newStart < 0) {
      newLength += newStart;
      newStart = 0;
    }

    return CPDFTextRange(
      pageIndex: pageIndex,
      location: newStart,
      length: newLength,
    );
  }
}