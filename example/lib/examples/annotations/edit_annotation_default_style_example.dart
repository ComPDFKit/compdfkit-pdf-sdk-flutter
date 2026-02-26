// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Edit Annotation Default Style Example
///
/// Demonstrates reading and updating default annotation styles.
///
/// This example shows:
/// - Reading current default styles for annotation types
/// - Updating default colors, opacity, and other properties
/// - Using [CPDFReaderWidgetController.getAnnotationDefaultAttribute]
/// - Using [CPDFReaderWidgetController.setAnnotationDefaultAttribute]
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.getAnnotationDefaultAttribute]: Read defaults
/// - [CPDFReaderWidgetController.setAnnotationDefaultAttribute]: Update defaults
/// - [CPDFAnnotationType]: Annotation type enum
/// - Default attribute maps for each annotation type
///
/// Usage:
/// 1. Open the example
/// 2. Tap "Read Default Style" to view current defaults
/// 3. Tap "Update Default Style" to change defaults
/// 4. New annotations will use the updated defaults
class EditAnnotationDefaultStyleExample extends StatelessWidget {
  /// Constructor
  const EditAnnotationDefaultStyleExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Edit Default Style',
      assetPath: _assetPath,
      builder: (path) => _EditDefaultStylePage(documentPath: path),
    );
  }
}

class _EditDefaultStylePage extends ExampleBase {
  const _EditDefaultStylePage({required super.documentPath});

  @override
  State<_EditDefaultStylePage> createState() => _EditDefaultStylePageState();
}

class _EditDefaultStylePageState
    extends ExampleBaseState<_EditDefaultStylePage> {
  static const List<String> _menuActions = [
    'Read Default Style',
    'Update Default Style',
  ];

  @override
  String get pageTitle => 'Edit Default Style';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig:
            const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Read Default Style':
        _handleReadDefaultStyle(controller);
        break;
      case 'Update Default Style':
        _handleUpdateDefaultStyle(controller);
        break;
    }
  }

  Future<void> _handleReadDefaultStyle(
    CPDFReaderWidgetController controller,
  ) async {
    final attrs = await controller.fetchDefaultAnnotationStyle();
    printJsonString(jsonEncode(attrs.toJson()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default style logged to console')),
      );
    }
  }

  Future<void> _handleUpdateDefaultStyle(
    CPDFReaderWidgetController controller,
  ) async {
    final attrs = await controller.fetchDefaultAnnotationStyle();

    // Update Note annotation style
    final noteAttr = attrs.noteAttr.copyWith(color: Colors.red, alpha: 200);
    await controller.updateDefaultAnnotationStyle(noteAttr);

    // Update Highlight annotation style
    final highlightAttr = attrs.highlightAttr.copyWith(
      color: Colors.yellow,
      alpha: 220,
    );
    await controller.updateDefaultAnnotationStyle(highlightAttr);

    // Update Underline annotation style
    final underlineAttr = attrs.underlineAttr.copyWith(
      color: Colors.blue,
      alpha: 220,
    );
    await controller.updateDefaultAnnotationStyle(underlineAttr);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default styles updated successfully')),
      );
    }
  }
}
