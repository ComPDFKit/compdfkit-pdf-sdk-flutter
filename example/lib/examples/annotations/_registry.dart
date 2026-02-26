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
import 'add_annotation_example.dart';
import 'api_annotation_mode_example.dart';
import 'custom_annotation_creation_example.dart';
import 'delete_annotation_example.dart';
import 'edit_annotation_default_style_example.dart';
import 'edit_annotation_example.dart';
import 'intercept_annotation_action_example.dart';
import 'list_annotations_example.dart';
import 'xfdf_operations_example.dart';

/// Annotations category registry file
///
/// Contains PDF annotation related examples
final CategoryInfo annotationsCategory = CategoryInfo(
  id: 'annotations',
  name: 'Annotations',
  icon: Icons.edit_note,
  description: 'Annotation creation, editing, import and export',
  examples: [
    ExampleItem(
      title: 'Add Annotation',
      description: 'Add common annotation types',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const AddAnnotationExample(),
      visual: const ExampleVisual(
        icon: Icons.note_add,
        backgroundColor: Color(0xFFFFEBEE),
        iconColor: Color(0xFFC62828),
      ),
    ),
    ExampleItem(
      title: 'List Annotations',
      description: 'List and navigate to annotations',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ListAnnotationsExample(),
      visual: const ExampleVisual(
        icon: Icons.list,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32),
      ),
    ),
    ExampleItem(
      title: 'Edit Annotation',
      description: 'Modify annotation properties',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const EditAnnotationExample(),
      visual: const ExampleVisual(
        icon: Icons.edit,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Edit Default Style',
      description: 'Get and modify default annotation styles',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const EditAnnotationDefaultStyleExample(),
      visual: const ExampleVisual(
        icon: Icons.style,
        backgroundColor: Color(0xFFEDE7F6),
        iconColor: Color(0xFF5E35B1),
      ),
    ),
    ExampleItem(
      title: 'Delete Annotation',
      description: 'Delete annotations',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DeleteAnnotationExample(),
      visual: const ExampleVisual(
        icon: Icons.delete_outline,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFF880E4F),
      ),
    ),
    ExampleItem(
      title: 'XFDF Operations',
      description: 'Import and export XFDF',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const XfdfOperationsExample(),
      visual: const ExampleVisual(
        icon: Icons.compare_arrows,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00695C),
      ),
    ),
    ExampleItem(
      title: 'Custom Annotation',
      description: 'Custom signatures, images, stamps',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const CustomAnnotationCreationExample(),
      visual: const ExampleVisual(
        icon: Icons.palette,
        backgroundColor: Color(0xFFEFEBE9),
        iconColor: Color(0xFF5D4037),
      ),
    ),
    ExampleItem(
      title: 'API Annotation Mode',
      description: 'Enter annotation mode via API and annotate documents',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ApiAnnotationModeExample(),
      visual: const ExampleVisual(
        icon: Icons.build,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Intercept Action',
      description: 'Intercept link and note annotation actions',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const InterceptAnnotationActionExample(),
      visual: const ExampleVisual(
        icon: Icons.touch_app,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
  ],
);
