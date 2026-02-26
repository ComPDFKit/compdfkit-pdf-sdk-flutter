// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';

/// A model representing an item in the annotation list view.
///
/// This sealed class pattern supports two types of list items:
/// - **Header items:** Display page number and annotation count
/// - **Annotation items:** Display individual annotation details
///
/// **Factory Constructors:**
/// - [AnnotationItemModel.header] - Creates a page header item
/// - [AnnotationItemModel.annotation] - Creates an annotation item
///
/// **Usage:**
/// ```dart
/// // Create header for page 5 with 3 annotations
/// final header = AnnotationItemModel.header(5, 3);
///
/// // Create annotation item
/// final item = AnnotationItemModel.annotation(myAnnotation);
/// ```
///
/// Use [isHeader] to differentiate between item types when rendering.
class AnnotationItemModel {
  final int? pageIndex;
  final CPDFAnnotation? annotation;
  final bool isHeader;
  final int? count;

  AnnotationItemModel.header(this.pageIndex, this.count)
      : annotation = null,
        isHeader = true;

  AnnotationItemModel.annotation(this.annotation)
      : pageIndex = null,
        isHeader = false,
        count = null;
}
