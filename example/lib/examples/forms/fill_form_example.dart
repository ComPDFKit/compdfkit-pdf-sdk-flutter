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
/// - Checking required fields ([CPDFWidget.isRequired]) before submitting
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
/// 4. Select "Check Required Fields" to list required fields that are empty
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
  static const List<String> _menuActions = [
    'Fill Form Fields',
    'Check Required Fields',
  ];

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
    } else if (action == 'Check Required Fields') {
      _handleCheckRequiredFields(controller);
    }
  }

  Future<List<CPDFWidget>> _getAllWidgets(
      CPDFReaderWidgetController controller) async {
    final pageCount = await controller.document.getPageCount();
    final widgets = <CPDFWidget>[];
    for (int i = 0; i < pageCount; i++) {
      widgets.addAll(await controller.document.pageAtIndex(i).getWidgets());
    }
    return widgets;
  }

  /// Lists required fields that have no value, e.g. before submitting a form.
  ///
  /// PDF viewers do not enforce the required flag, so the app checks it.
  /// Radio buttons that share a field name form one group: the group counts
  /// as filled when any of its buttons is checked.
  Future<void> _handleCheckRequiredFields(
      CPDFReaderWidgetController controller) async {
    final widgets = await _getAllWidgets(controller);
    final checkedRadioGroups = widgets
        .whereType<CPDFRadioButtonWidget>()
        .where((widget) => widget.isChecked)
        .map((widget) => widget.title)
        .toSet();

    final emptyFields = <String>{};
    for (final widget in widgets.where((widget) => widget.isRequired)) {
      final isEmpty = switch (widget) {
        CPDFTextWidget() => widget.text.trim().isEmpty,
        CPDFCheckBoxWidget() => !widget.isChecked,
        CPDFRadioButtonWidget() => !checkedRadioGroups.contains(widget.title),
        CPDFListBoxWidget() => widget.selectItemAtIndex < 0,
        CPDFComboBoxWidget() => widget.selectItemAtIndex < 0,
        CPDFSignatureWidget() => !widget.isSigned,
        _ => false,
      };
      if (isEmpty) {
        emptyFields.add('${widget.title} (page ${widget.page + 1})');
      }
    }

    if (!mounted) {
      return;
    }
    final requiredCount = widgets.where((widget) => widget.isRequired).length;
    final message = emptyFields.isEmpty
        ? 'All $requiredCount required fields are filled.'
        : 'Required fields still empty:\n${emptyFields.join('\n')}';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleFillForm(CPDFReaderWidgetController controller) async {
    final widgets = await _getAllWidgets(controller);

    for (final widget in widgets) {
      if (widget is CPDFTextWidget) {
        widget.title = 'TextFields---ComPDF';
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
        widget.title = 'CheckBox---ComPDF';
        widget.fillColor = Colors.white;
        widget.borderColor = const Color(0xFF5CB85C);
        widget.borderWidth = 2;
        widget.checkColor = const Color(0xFF5CB85C);
        widget.checkStyle = CPDFCheckStyle.check;
        widget.isChecked = true;
      } else if (widget is CPDFRadioButtonWidget) {
        widget.title = 'RadioButton---ComPDF';
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
          CPDFWidgetItem(text: 'ComPDF-Android', value: 'ComPDF-Android'),
          CPDFWidgetItem(text: 'ComPDF-Flutter', value: 'ComPDF-Flutter'),
          CPDFWidgetItem(text: 'ComPDF-RN', value: 'ComPDF-RN'),
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
          CPDFWidgetItem(text: 'ComPDF-Android', value: 'ComPDF-Android'),
          CPDFWidgetItem(text: 'ComPDF-Flutter', value: 'ComPDF-Flutter'),
          CPDFWidgetItem(text: 'ComPDF-RN', value: 'ComPDF-RN'),
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
        widget.buttonTitle = 'ComPDF';
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
