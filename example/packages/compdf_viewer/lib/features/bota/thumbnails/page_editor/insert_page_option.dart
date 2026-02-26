// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import 'insert_page_type.dart';

/// Immutable data model representing a single page template option in the page editor.
///
/// This model defines the visual presentation of a page template option, including:
/// - A preview widget showing the template appearance
/// - A title for display
/// - The associated page type enum value
///
/// Used to populate the template selection grid in [InsertPagePicTypeList].
///
/// Example:
/// ```dart
/// const blankOption = InsertPageOption(
///   widget: Icon(Icons.description, size: 48),
///   title: 'Blank Page',
///   type: InsertPageType.blank,
/// );
///
/// const lineOption = InsertPageOption(
///   widget: Image.asset('assets/line_template.png'),
///   title: 'Horizontal Lines',
///   type: InsertPageType.horizontalLine,
/// );
///
/// // Use in option list
/// final options = [blankOption, lineOption];
/// ```
@immutable
class InsertPageOption {
  final Widget widget;
  final String title;
  final InsertPageType type;

  const InsertPageOption({
    required this.widget,
    required this.title,
    required this.type,
  });
}
