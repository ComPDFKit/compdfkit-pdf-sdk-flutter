// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/page/cpdf_page.dart';

/// Data model representing a page size option for page insertion.
///
/// This model pairs a display name with a [CPDFPageSize] constant to provide
/// user-friendly labels for page size selection in the page editor UI.
///
/// Features:
/// - Display name for UI presentation
/// - Underlying CPDFPageSize value
/// - Value equality comparison
/// - Immutable data structure
///
/// Example:
/// ```dart
/// const a4Size = InsertPageSizeData(
///   name: 'A4',
///   pageSize: CPDFPageSize.a4,
/// );
///
/// const letterSize = InsertPageSizeData(
///   name: 'Letter',
///   pageSize: CPDFPageSize.letter,
/// );
///
/// // Use in dropdown menu
/// final sizes = [a4Size, letterSize];
/// DropdownMenu<InsertPageSizeData>(
///   entries: sizes.map((s) => DropdownMenuEntry(value: s, label: s.name)).toList(),
/// );
/// ```
class InsertPageSizeData {
  final String name;
  final CPDFPageSize pageSize;
  const InsertPageSizeData({
    required this.name,
    required this.pageSize,
  });

  @override
  String toString() {
    return 'InsertPageSizeData{name: $name, pageSize: $pageSize}';
  }

  @override
  bool operator ==(Object other) {
    return other is InsertPageSizeData &&
        other.name == name &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => name.hashCode ^ pageSize.hashCode;
}
