// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/category_info.dart';
import '../shared/example_item.dart';
import '../shared/example_route_type.dart';
import 'create_form_fields_example.dart';
import 'custom_form_creation_example.dart';
import 'edit_form_default_style_example.dart';
import 'fill_form_example.dart';
import 'form_data_import_export_example.dart';
import 'form_field_operations_example.dart';
import 'intercept_widget_action_example.dart';
import 'api_form_creation_mode_example.dart';

/// Forms category registry file
///
/// Contains PDF forms related examples
final CategoryInfo formsCategory = CategoryInfo(
  id: 'forms',
  name: 'Forms',
  icon: Icons.dynamic_form,
  description: 'Form creation, filling and data import/export',
  examples: [
    ExampleItem(
      title: 'Create Form Fields',
      description: 'Create common form fields',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const CreateFormFieldsExample(),
      visual: const ExampleVisual(
        icon: Icons.add_box,
        backgroundColor: Color(0xFFF3E5F5),
        iconColor: Color(0xFF7B1FA2),
      ),
    ),
    ExampleItem(
      title: 'Fill Form',
      description: 'Programmatically fill form fields',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const FillFormExample(),
      visual: const ExampleVisual(
        icon: Icons.edit_attributes,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    ExampleItem(
      title: 'Edit Form Default Style',
      description: 'Get and modify default form styles',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const EditFormDefaultStyleExample(),
      visual: const ExampleVisual(
        icon: Icons.style,
        backgroundColor: Color(0xFFEDE7F6),
        iconColor: Color(0xFF5E35B1),
      ),
    ),
    ExampleItem(
      title: 'Form Data Import/Export',
      description: 'Import and export form data',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const FormDataImportExportExample(),
      visual: const ExampleVisual(
        icon: Icons.cloud_upload,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00796B),
      ),
    ),
    ExampleItem(
      title: 'Form Field Operations',
      description: 'Get and view form fields',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const FormFieldOperationsExample(),
      visual: const ExampleVisual(
        icon: Icons.preview,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Custom Form Creation',
      description:
          'Custom handling for ListBox, ComboBox and PushButton creation',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const CustomFormCreationExample(),
      visual: const ExampleVisual(
        icon: Icons.tune,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'API Form Creation Mode',
      description: 'Enter form creation mode via API and create fields',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const ApiFormCreationModeExample(),
      visual: const ExampleVisual(
        icon: Icons.build,
        backgroundColor: Color(0xFFE3F2FD),
        iconColor: Color(0xFF1565C0),
      ),
    ),
    if (defaultTargetPlatform == TargetPlatform.android) ...[
      ExampleItem(
        title: 'Intercept Action',
        description: 'Intercept ListBox and ComboBox click actions',
        routeType: ExampleRouteType.pageBuilder,
        pageBuilder: (context) => const InterceptWidgetActionExample(),
        visual: const ExampleVisual(
          icon: Icons.touch_app,
          backgroundColor: Color(0xFFF3E5F5),
          iconColor: Color(0xFF7B1FA2),
        ),
      ),
    ]
  ],
);
