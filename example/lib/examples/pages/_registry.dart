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
import 'delete_page_example.dart';
import 'insert_page_example.dart';
import 'move_page_example.dart';
import 'rotate_page_example.dart';
import 'split_document_example.dart';
import 'page_thumbnails_example.dart';

/// Pages category registry file
///
/// Contains PDF page management related examples
final CategoryInfo pagesCategory = CategoryInfo(
  id: 'pages',
  name: 'Pages',
  icon: Icons.pages,
  description: 'Insert, delete, rotate and split pages',
  examples: [
    ExampleItem(
      title: 'Insert Page',
      description: 'Insert blank or image page',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const InsertPageExample(),
      visual: const ExampleVisual(
        icon: Icons.post_add,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF388E3C),
      ),
    ),
    ExampleItem(
      title: 'Delete Page',
      description: 'Delete specified page',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DeletePageExample(),
      visual: const ExampleVisual(
        icon: Icons.delete_forever,
        backgroundColor: Color(0xFFFFEBEE),
        iconColor: Color(0xFFC62828),
      ),
    ),
    ExampleItem(
      title: 'Rotate Page',
      description: 'Rotate page angle',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const RotatePageExample(),
      visual: const ExampleVisual(
        icon: Icons.rotate_right,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Move Page',
      description: 'Adjust page order',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const MovePageExample(),
      visual: const ExampleVisual(
        icon: Icons.swap_vert,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF512DA8),
      ),
    ),
    ExampleItem(
      title: 'Split Document',
      description: 'Split document pages',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const SplitDocumentExample(),
      visual: const ExampleVisual(
        icon: Icons.call_split,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Page Thumbnails',
      description: 'Render PDF pages as thumbnail images',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const PageThumbnailsExample(),
      visual: const ExampleVisual(
        icon: Icons.photo_library,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
  ],
);
