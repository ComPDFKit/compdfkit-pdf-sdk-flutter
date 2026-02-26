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
import 'display_settings_example.dart';
import 'preview_mode_example.dart';
import 'save_document_example.dart';
import 'snip_mode_example.dart';
import 'view_operations_example.dart';
import 'zoom_scale_example.dart';

/// Widget Controller category registry file
///
/// Contains controller related examples
final CategoryInfo widgetControllerCategory = CategoryInfo(
  id: 'widget_controller',
  name: 'Widget Controller',
  icon: Icons.tune,
  description: 'Save, zoom and view control',
  examples: [
    ExampleItem(
      title: 'Save Document',
      description: 'Save and save as',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const SaveDocumentExample(),
      visual: const ExampleVisual(
        icon: Icons.save,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Zoom Scale',
      description: 'Zoom control',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ZoomScaleExample(),
      visual: const ExampleVisual(
        icon: Icons.zoom_in,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF388E3C),
      ),
    ),
    ExampleItem(
      title: 'Display Settings',
      description: 'Show settings entry',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DisplaySettingsExample(),
      visual: const ExampleVisual(
        icon: Icons.settings_display,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
    ExampleItem(
      title: 'View Operations',
      description: 'Show thumbnails, BOTA, search',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ViewOperationsExample(),
      visual: const ExampleVisual(
        icon: Icons.visibility,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Snip Mode',
      description: 'Snip mode',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const SnipModeExample(),
      visual: const ExampleVisual(
        icon: Icons.crop,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Preview Mode',
      description: 'Switch preview modes',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const PreviewModeExample(),
      visual: const ExampleVisual(
        icon: Icons.view_carousel,
        backgroundColor: Color(0xFFE0F7FA),
        iconColor: Color(0xFF00838F),
      ),
    ),
  ],
);
