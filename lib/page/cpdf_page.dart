// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/page/cpdf_text_range.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../annotation/cpdf_annotation_registry.dart';
import '../annotation/form/cpdf_widget_registry.dart';

class CPDFPage {
  final MethodChannel _channel;

  final int pageIndex;

  CPDFPage(this._channel, this.pageIndex);

  /// Retrieves all annotations on the current page.
  ///
  /// This method fetches all annotations present on the current page of the PDF document
  /// and returns a list of corresponding CPDFAnnotation instances.
  ///
  /// The returned annotations can include different types, such as:
  /// - Basic annotations: [CPDFAnnotation]
  /// - Markup annotations:
  ///   - Highlight: [CPDFMarkupAnnotation]
  ///   - Underline: [CPDFMarkupAnnotation]
  ///   - Strikeout: [CPDFMarkupAnnotation]
  ///   - Squiggly: [CPDFMarkupAnnotation]
  ///
  /// example:
  /// ```dart
  /// int pageIndex = 0;
  /// CPDFPage page = controller.document.pageAtIndex(pageIndex);
  /// List<CPDFAnnotation> annotations = await page.getAnnotations();
  /// ```
  ///  Returns a list of [CPDFAnnotation] objects for the current page. If no annotations
  /// are found, an empty list is returned. If an error occurs during parsing, it logs the error
  /// and skips the invalid annotation data.
  ///
  /// **Note**: The list is filtered to exclude any invalid or malformed annotations.
  Future<List<CPDFAnnotation>> getAnnotations() async {
    final rawList = await _channel.invokeMethod('get_annotations', pageIndex);
    if (rawList is! List) return [];
    return rawList
        .whereType<Map>()
        .map((item) {
          try {
            final map = Map<String, dynamic>.from(item);
            return CPDFAnnotationRegistry.fromJson(map);
          } catch (e, stack) {
            debugPrint('CPDFAnnotation parse error: $e\n$stack');
            return null;
          }
        })
        .whereType<CPDFAnnotation>()
        .toList();
  }

  Future<List<CPDFWidget>> getWidgets() async {
    dynamic rawList = await _channel.invokeMethod('get_widgets', pageIndex);
    if (rawList is! List) return [];
    return rawList
        .whereType<Map>()
        .map((item) {
          try {
            final map = Map<String, dynamic>.from(item);
            return CPDFWidgetRegistry.fromJson(map);
          } catch (e, stack) {
            debugPrint('CPDFWidget parse error: $e\n$stack');
            return null;
          }
        })
        .whereType<CPDFWidget>()
        .toList();
  }

  /// Removes an annotation from the current page.
  ///
  /// example:
  /// ```dart
  /// bool result = page.removeAnnotation(annotation);
  /// ```
  Future<bool> removeAnnotation(CPDFAnnotation annotation) async {
    return await _channel.invokeMethod('remove_annotation', {
      'page_index': pageIndex,
      'uuid': annotation.uuid,
    });
  }

  /// Removes a widget from the current page.
  ///
  /// example:
  /// ```dart
  /// bool result = page.removeWidget(widget);
  /// ```
  Future<bool> removeWidget(CPDFWidget widget) async {
    return await _channel.invokeMethod('remove_widget', {
      'page_index': pageIndex,
      'uuid': widget.uuid,
    });
  }


  /// Retrieves a text snippet from the current PDF page based on the specified range.
  ///
  /// This method calls the native side to extract a substring of text from the page,
  /// starting at the given `location` and reading `length` number of characters.
  ///
  /// Typically used with a [CPDFTextRange], which can be adjusted using the `expanded`
  /// method to include surrounding context for better readability in search results.
  ///
  /// Parameters:
  /// - [range]: A CPDFTextRange object that specifies the pageIndex, start location, and length.
  ///
  /// Returns:
  /// A [String] containing the extracted text. Returns an empty string if no result is found.
  ///
  /// Usage Example:
  /// ```dart
  /// final searcher = cpdfDocument.getTextSearcher();
  /// List<CPDFTextRange> results = await searcher.searchText(
  ///  'keywords', searchOptions: CPDFSearchOptions.caseInsensitive);
  ///
  /// // then: select the first result
  /// CPDFTextRange range = searcher.searchResults[0];
  ///
  /// // With context (before and after)
  /// final expandedRange = range.expanded(before: 20, after: 20);
  /// final contextText = await page.getText(expandedRange);
  /// print("Text with context: $contextText");
  /// ```
  Future<String> getText(CPDFTextRange range) async {
    final result = await _channel.invokeMethod('get_search_text', {
      'page_index': pageIndex,
      'location': range.location,
      'length': range.length,
    });
    return result ?? '';
  }

}

class CPDFPageSize {
  final int width;
  final int height;
  final String name;
  final bool isCustom;

  const CPDFPageSize._(this.name, this.width, this.height,
      {this.isCustom = false});

  CPDFPageSize withOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      return CPDFPageSize._(name, height, width, isCustom: isCustom);
    }
    return this;
  }


  static const letter = CPDFPageSize._('letter', 612, 792);
  static const note = CPDFPageSize._('note', 540, 720);
  static const legal = CPDFPageSize._('legal', 612, 1008);
  static const a0 = CPDFPageSize._('a0', 2380, 3368);
  static const a1 = CPDFPageSize._('a1', 1684, 2380);
  static const a2 = CPDFPageSize._('a2', 1190, 1684);
  static const a3 = CPDFPageSize._('a3', 842, 1190);
  static const a4 = CPDFPageSize._('a4', 595, 842);
  static const a5 = CPDFPageSize._('a5', 421, 595);
  static const a6 = CPDFPageSize._('a6', 297, 421);
  static const a7 = CPDFPageSize._('a7', 210, 297);
  static const a8 = CPDFPageSize._('a8', 148, 210);
  static const a9 = CPDFPageSize._('a9', 105, 148);
  static const a10 = CPDFPageSize._('a10', 74, 105);
  static const b0 = CPDFPageSize._('b0', 2836, 4008);
  static const b1 = CPDFPageSize._('b1', 2004, 2836);
  static const b2 = CPDFPageSize._('b2', 1418, 2004);
  static const b3 = CPDFPageSize._('b3', 1002, 1418);
  static const b4 = CPDFPageSize._('b4', 709, 1002);
  static const b5 = CPDFPageSize._('b5', 501, 709);
  static const archE = CPDFPageSize._('archE', 2592, 3456);
  static const archD = CPDFPageSize._('archD', 1728, 2592);
  static const archC = CPDFPageSize._('archC', 1296, 1728);
  static const archB = CPDFPageSize._('archB', 864, 1296);
  static const archA = CPDFPageSize._('archA', 648, 864);
  static const flsa = CPDFPageSize._('flsa', 612, 936);
  static const flse = CPDFPageSize._('flse', 612, 936);
  static const halfLetter = CPDFPageSize._('halfLetter', 396, 612);
  static const s11x17 = CPDFPageSize._('11x17', 792, 1224);
  static const ledger = CPDFPageSize._('ledger', 1224, 792);

  static const values = [
    letter,
    note,
    legal,
    a0,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    a7,
    a8,
    a9,
    a10,
    b0,
    b1,
    b2,
    b3,
    b4,
    b5,
    archE,
    archD,
    archC,
    archB,
    archA,
    flsa,
    flse,
    halfLetter,
    s11x17,
    ledger
  ];

  factory CPDFPageSize.custom(int width, int height) {
    return CPDFPageSize._('custom', width, height, isCustom: true);
  }

  @override
  String toString() => isCustom ? 'custom($width x $height)' : name;
}
