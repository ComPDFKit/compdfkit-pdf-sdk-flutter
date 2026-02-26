// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Example Registry Center
///
/// Aggregates registration info of all categories and provides a unified entry point
library;

import 'annotations/_registry.dart';
import 'content_editor/_registry.dart';
import 'document_api/_registry.dart';
import 'forms/_registry.dart';
import 'pages/_registry.dart';
import 'search_navigation/_registry.dart';
import 'security/_registry.dart';
import 'shared/category_info.dart';
import 'ui_customization/_registry.dart';
import 'viewer/_registry.dart';
import 'widget_controller/_registry.dart';

export 'shared/category_info.dart';
export 'shared/example_item.dart';
export 'shared/example_route_type.dart';

/// All category list (arranged in display order)
final List<CategoryInfo> allCategories = [
  viewerCategory,
  annotationsCategory,
  formsCategory,
  pagesCategory,
  securityCategory,
  contentEditorCategory,
  widgetControllerCategory,
  searchNavigationCategory,
  uiCustomizationCategory,
  documentApiCategory
];
