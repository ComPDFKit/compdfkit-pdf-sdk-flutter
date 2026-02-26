// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../shared/category_info.dart';
import '../shared/example_item.dart';
import '../shared/example_route_type.dart';
import 'bookmark_operations_example.dart';
import 'outline_navigation_example.dart';
import 'page_navigation_example.dart';
import 'text_search_api_example.dart';
import 'text_search_example.dart';

/// Search & Navigation category registry file
///
/// Contains search and navigation related examples
final CategoryInfo searchNavigationCategory = CategoryInfo(
  id: 'search_navigation',
  name: 'Search & Navigation',
  icon: Icons.search,
  description: 'Search and navigation features',
  examples: [
    ExampleItem(
      title: 'Show/Hide Search View',
      description: 'Show or hide text search view',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const TextSearchExample(),
      visual: const ExampleVisual(
        icon: Icons.search,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Text Search API',
      description: 'Search text using API and display results in list',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const TextSearchApiExample(),
      visual: const ExampleVisual(
        icon: Icons.manage_search,
        backgroundColor: Color(0xFFE8EAF6),
        iconColor: Color(0xFF3949AB),
      ),
    ),
    ExampleItem(
      title: 'Outline Navigation',
      description: 'Open document outline list',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const OutlineNavigationExample(),
      visual: const ExampleVisual(
        icon: Icons.list_alt,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF388E3C),
      ),
    ),
    ExampleItem(
      title: 'Bookmark Operations',
      description: 'Bookmark add and delete',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const BookmarkOperationsExample(),
      visual: const ExampleVisual(
        icon: Icons.bookmark,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Page Navigation',
      description: 'Page navigation',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const PageNavigationExample(),
      visual: const ExampleVisual(
        icon: Icons.navigate_next,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
  ],
);
