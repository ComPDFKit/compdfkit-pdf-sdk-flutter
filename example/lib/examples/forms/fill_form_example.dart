// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Fill Form Example
///
/// Demonstrates how to programmatically fill and update PDF form fields.
///
/// This example shows:
/// - Iterating through all pages to collect form widgets
/// - Updating text field properties (text, font, color, alignment)
/// - Setting checkbox and radio button states with custom styles
/// - Configuring listbox and combobox options with selection
/// - Styling signature fields with custom colors
/// - Setting push button actions and appearance
///
/// Each form field type supports different properties:
/// - [CPDFTextWidget]: text content, font settings, multiline, alignment
/// - [CPDFCheckBoxWidget]: check state, check style, check color
/// - [CPDFRadioButtonWidget]: selection state, style, colors
/// - [CPDFListBoxWidget]: options list, selected index, font settings
/// - [CPDFComboBoxWidget]: dropdown options, selection, font settings
/// - [CPDFSignatureWidget]: border and fill colors
/// - [CPDFPushButtonWidget]: button title, action (URI/GoTo), font settings
///
/// Usage:
/// 1. Open a PDF with form fields
/// 2. Tap menu and select "Fill Form Fields"
/// 3. All form fields will be updated with predefined values
class FillFormExample extends StatelessWidget {
  /// Constructor
  const FillFormExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Fill Form',
      assetPath: _assetPath,
      builder: (path) => _FillFormPage(documentPath: path),
    );
  }
}

class _FillFormPage extends ExampleBase {
  const _FillFormPage({required super.documentPath});

  @override
  State<_FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends ExampleBaseState<_FillFormPage> {
  static const List<String> _menuActions = ['Fill Form Fields'];

  @override
  String get pageTitle => 'Fill Form';

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
    if (action == 'Fill Form Fields') {
      _handleFillForm(controller);
    }
  }

  Future<void> _handleFillForm(CPDFReaderWidgetController controller) async {
    final pageCount = await controller.document.getPageCount();
    final widgets = <CPDFWidget>[];

    for (int i = 0; i < pageCount; i++) {
      final page = controller.document.pageAtIndex(i);
      final pageWidgets = await page.getWidgets();
      widgets.addAll(pageWidgets);
    }

    for (final widget in widgets) {
      if (widget is CPDFTextWidget) {
        widget.title = 'TextFields---ComPDFKit';
        widget.fillColor = const Color(0xFFF5F7FA);
        widget.borderColor = const Color(0xFF4A90E2);
        widget.borderWidth = 1;
        widget.text = 'Updated Text';
        widget.fontColor = const Color(0xFF333333);
        widget.fontSize = 14.0;
        widget.alignment = CPDFAlignment.left;
        widget.isMultiline = false;
        widget.familyName = 'Helvetica';
        widget.styleName = 'Regular';
      } else if (widget is CPDFCheckBoxWidget) {
        widget.title = 'CheckBox---ComPDFKit';
        widget.fillColor = Colors.white;
        widget.borderColor = const Color(0xFF5CB85C);
        widget.borderWidth = 2;
        widget.checkColor = const Color(0xFF5CB85C);
        widget.checkStyle = CPDFCheckStyle.check;
        widget.isChecked = true;
      } else if (widget is CPDFRadioButtonWidget) {
        widget.title = 'RadioButton---ComPDFKit';
        widget.fillColor = Colors.white;
        widget.borderColor = const Color(0xFF5BC0DE);
        widget.borderWidth = 2;
        widget.checkColor = const Color(0xFF5BC0DE);
        widget.checkStyle = CPDFCheckStyle.circle;
        widget.isChecked = true;
      } else if (widget is CPDFListBoxWidget) {
        widget.fillColor = const Color(0xFFFAFAFA);
        widget.borderColor = const Color(0xFF9B59B6);
        widget.borderWidth = 1;
        widget.options = [
          CPDFWidgetItem(text: 'ComPDFKit-Android', value: 'ComPDFKit-Android'),
          CPDFWidgetItem(text: 'ComPDFKit-Flutter', value: 'ComPDFKit-Flutter'),
          CPDFWidgetItem(text: 'ComPDFKit-RN', value: 'ComPDFKit-RN'),
        ];
        widget.selectItemAtIndex = 1;
        widget.familyName = 'Helvetica';
        widget.styleName = 'Regular';
        widget.fontSize = 12;
        widget.fontColor = const Color(0xFF444444);
      } else if (widget is CPDFComboBoxWidget) {
        widget.fillColor = const Color(0xFFFAFAFA);
        widget.borderColor = const Color(0xFF3498DB);
        widget.borderWidth = 1;
        widget.options = [
          CPDFWidgetItem(text: 'ComPDFKit-Android', value: 'ComPDFKit-Android'),
          CPDFWidgetItem(text: 'ComPDFKit-Flutter', value: 'ComPDFKit-Flutter'),
          CPDFWidgetItem(text: 'ComPDFKit-RN', value: 'ComPDFKit-RN'),
        ];
        widget.selectItemAtIndex = 2;
        widget.familyName = 'Helvetica';
        widget.styleName = 'Regular';
        widget.fontSize = 12;
        widget.fontColor = const Color(0xFF444444);
      } else if (widget is CPDFSignatureWidget) {
        widget.fillColor = const Color(0xFFFFF8E7);
        widget.borderColor = const Color(0xFFF39C12);
        widget.borderWidth = 2;
      } else if (widget is CPDFPushButtonWidget) {
        widget.fillColor = const Color(0xFF4A90E2);
        widget.borderColor = const Color(0xFF357ABD);
        widget.borderWidth = 1;
        widget.buttonTitle = 'ComPDFKit';
        widget.action = CPDFUriAction(uri: 'http://www.compdf.com');
        widget.fontColor = Colors.white;
        widget.fontSize = 14;
        widget.familyName = 'Helvetica';
        widget.styleName = 'Bold';
      }
      printJsonString(jsonEncode(widget.toJson()));
      await controller.document.updateWidget(widget);
    }
  }
}
