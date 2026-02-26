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
import 'content_editing_mode_example.dart';
import 'editor_history_example.dart';
import 'image_editing_example.dart';
import 'text_editing_example.dart';

/// Content Editor category registry file
///
/// Contains PDF content editing related examples
final CategoryInfo contentEditorCategory = CategoryInfo(
  id: 'content_editor',
  name: 'Content Editor',
  icon: Icons.text_fields,
  description: 'Text and image content editing',
  examples: [
    ExampleItem(
      title: 'Text Editing',
      description: 'Edit and insert text',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const TextEditingExample(),
      visual: const ExampleVisual(
        icon: Icons.text_fields,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Image Editing',
      description: 'Edit and insert images',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ImageEditingExample(),
      visual: const ExampleVisual(
        icon: Icons.image,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00796B),
      ),
    ),
    ExampleItem(
      title: 'Content Editing Mode',
      description: 'Switch editing mode',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ContentEditingModeExample(),
      visual: const ExampleVisual(
        icon: Icons.edit,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Editor History',
      description: 'Undo/Redo and history listener',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const EditorHistoryExample(),
      visual: const ExampleVisual(
        icon: Icons.history,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
  ],
);
