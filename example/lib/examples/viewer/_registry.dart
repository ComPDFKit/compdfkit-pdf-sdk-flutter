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
import 'basic_viewer_example.dart';
import 'dark_theme_example.dart';
import 'modal_viewer_example.dart';
import 'open_external_file_example.dart';

/// Viewer category information
final CategoryInfo viewerCategory = CategoryInfo(
  id: 'viewer',
  name: 'Viewer',
  icon: Icons.chrome_reader_mode,
  description: 'Basic PDF viewing features',
  examples: [
    ExampleItem(
      title: 'Basic Viewer',
      description: 'Basic PDF open and view',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const BasicViewerExample(),
      visual: const ExampleVisual(
        icon: Icons.picture_as_pdf,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Open External File',
      description: 'Select external PDF file to open',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const OpenExternalFileExample(),
      visual: const ExampleVisual(
        icon: Icons.folder_open,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1976D2),
      ),
    ),
    ExampleItem(
      title: 'Modal Viewer',
      description: 'Display PDF in Modal mode',
      routeType: ExampleRouteType.modalCallback,
      modalCallback: openModalViewer,
      visual: const ExampleVisual(
        icon: Icons.open_in_new,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
    ExampleItem(
      title: 'Dark Theme Viewer',
      description: 'CPDFReaderWidget dark theme',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DarkThemeExample(),
      visual: const ExampleVisual(
        icon: Icons.dark_mode,
        backgroundColor: Color(0xFFF5F5F5),
        iconColor: Color(0xFF424242),
      ),
    ),
  ],
);
