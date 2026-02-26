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

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Edit Form Default Style Example
///
/// Demonstrates how to read and update the default styles applied to newly
/// created form fields using the ComPDFKit Flutter API.
///
/// This example shows:
/// - Fetching current default styles for all form field types
/// - Updating text field defaults (font, colors, alignment, multiline)
/// - Updating checkbox defaults (check style, colors, border width)
/// - Updating push button defaults (title, colors, font styling)
/// - Applying consistent styling across form creation workflows
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.fetchDefaultWidgetStyle]: Gets current defaults
/// - [CPDFReaderWidgetController.updateDefaultWidgetStyle]: Applies new defaults
/// - [CPDFWidgetStyleConfig]: Container for all form field style attributes
/// - [CPDFTextFieldAttr]: Text field appearance configuration
/// - [CPDFCheckBoxAttr]: Checkbox appearance configuration
/// - [CPDFPushButtonAttr]: Push button appearance configuration
///
/// Usage:
/// 1. Open the example and tap the menu button
/// 2. Select "Read Default Style" to log current defaults to console
/// 3. Select "Update Default Style" to apply custom professional styling
/// 4. Create new form fields to see the updated default styles applied
class EditFormDefaultStyleExample extends StatelessWidget {
  /// Constructor
  const EditFormDefaultStyleExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Edit Form Default Style',
      assetPath: _assetPath,
      builder: (path) => _EditFormDefaultStylePage(documentPath: path),
    );
  }
}

class _EditFormDefaultStylePage extends ExampleBase {
  const _EditFormDefaultStylePage({required super.documentPath});

  @override
  State<_EditFormDefaultStylePage> createState() =>
      _EditFormDefaultStylePageState();
}

class _EditFormDefaultStylePageState
    extends ExampleBaseState<_EditFormDefaultStylePage> {
  static const List<String> _menuActions = [
    'Read Default Style',
    'Update Default Style',
  ];

  @override
  String get pageTitle => 'Edit Form Default Style';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(initialViewMode: CPDFViewMode.forms),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        )
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
    final attrs = await controller.fetchDefaultWidgetStyle();
    printJsonString(jsonEncode(attrs.toJson()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default styles logged to console')),
      );
    }
  }

  Future<void> _handleUpdateDefaultStyle(
    CPDFReaderWidgetController controller,
  ) async {
    final attrs = await controller.fetchDefaultWidgetStyle();

    final textFieldAttr = attrs.textFieldAttr.copyWith(
      fillColor: const Color(0xFFF5F7FA),
      borderColor: const Color(0xFF4A90E2),
      borderWidth: 1,
      fontColor: const Color(0xFF333333),
      fontSize: 14,
      alignment: CPDFAlignment.left,
      multiline: false,
      familyName: 'Helvetica',
      styleName: 'Regular',
    );

    final checkBoxAttr = attrs.checkBoxAttr.copyWith(
      fillColor: const Color(0xFFF5F7FA),
      borderColor: const Color(0xFF5CB85C),
      borderWidth: 1,
      checkedColor: const Color(0xFF2E7D32),
      checkedStyle: CPDFCheckStyle.check,
    );

    final pushButtonAttr = attrs.pushButtonAttr.copyWith(
      title: 'Submit',
      fillColor: const Color(0xFF4A90E2),
      borderColor: const Color(0xFF4A90E2),
      borderWidth: 1,
      fontColor: Colors.white,
      fontSize: 14,
      familyName: 'Helvetica',
      styleName: 'Regular',
    );

    await controller.updateDefaultWidgetStyle(textFieldAttr);
    await controller.updateDefaultWidgetStyle(checkBoxAttr);
    await controller.updateDefaultWidgetStyle(pushButtonAttr);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default styles updated successfully')),
      );
    }
  }
}
