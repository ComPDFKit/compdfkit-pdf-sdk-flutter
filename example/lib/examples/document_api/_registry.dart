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
import 'bookmarks_example.dart';
import 'document_info_example.dart';
import 'import_export_xfdf_example.dart';
import 'open_document_example.dart';
import 'render_page_example.dart';
import 'search_text_example.dart';

/// Document API category information
final CategoryInfo documentApiCategory = CategoryInfo(
  id: 'document_api',
  name: 'Document API',
  icon: Icons.api,
  description: 'Pure API examples using CPDFDocument (no UI widget)',
  examples: [
    ExampleItem(
      title: 'Open Document',
      description: 'Open PDF using CPDFDocument',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const OpenDocumentExample(),
      visual: const ExampleVisual(
        icon: Icons.folder_open,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Document Info',
      description: 'Get document info and permissions',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DocumentInfoExample(),
      visual: const ExampleVisual(
        icon: Icons.info,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF388E3C),
      ),
    ),
    ExampleItem(
      title: 'Import/Export XFDF',
      description: 'Import and export XFDF',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ImportExportXfdfExample(),
      visual: const ExampleVisual(
        icon: Icons.sync,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00796B),
      ),
    ),
    ExampleItem(
      title: 'Bookmarks',
      description: 'Bookmark CRUD operations',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const BookmarksExample(),
      visual: const ExampleVisual(
        icon: Icons.bookmark_add,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Render Page',
      description: 'Render page as image',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const RenderPageExample(),
      visual: const ExampleVisual(
        icon: Icons.image,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Search Text',
      description: 'Search PDF text content',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const SearchTextExample(),
      visual: const ExampleVisual(
        icon: Icons.find_in_page,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
  ],
);
