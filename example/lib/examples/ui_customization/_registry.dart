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
import 'context_menu_customization_example.dart';
import 'event_listeners_example.dart';
import 'toolbar_customization_example.dart';
import 'ui_style_customization_example.dart';

/// UI Customization category registry file
///
/// Contains UI customization related examples
final CategoryInfo uiCustomizationCategory = CategoryInfo(
  id: 'ui_customization',
  name: 'UI Customization',
  icon: Icons.palette,
  description: 'Toolbar, menu and style customization',
  examples: [
    ExampleItem(
      title: 'Toolbar Customization',
      description: 'Customize toolbar buttons',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ToolbarCustomizationExample(),
      visual: const ExampleVisual(
        icon: Icons.build,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00796B),
      ),
    ),
    ExampleItem(
      title: 'Context Menu Customization',
      description: 'Customize context menu',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ContextMenuCustomizationExample(),
      visual: const ExampleVisual(
        icon: Icons.more_vert,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
    ExampleItem(
      title: 'UI Style Customization',
      description: 'Customize UI style configuration',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const UiStyleCustomizationExample(),
      visual: const ExampleVisual(
        icon: Icons.style,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Event Listeners',
      description: 'Listen to UI events',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const EventListenersExample(),
      visual: const ExampleVisual(
        icon: Icons.touch_app,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
  ],
);
