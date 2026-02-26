// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/util/cpdf_widget_util.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Create Form Fields Example
///
/// Demonstrates how to programmatically create various form field types in a
/// PDF document using the ComPDFKit Flutter API.
///
/// This example shows:
/// - Creating text fields with custom fonts and alignment
/// - Creating checkboxes and radio buttons with different styles
/// - Creating list boxes and combo boxes with predefined options
/// - Creating signature fields for digital signatures
/// - Creating push buttons with URL and page navigation actions
///
/// Key classes/APIs used:
/// - [CPDFTextWidget]: Text input field with configurable font and styling
/// - [CPDFCheckBoxWidget]: Checkbox with customizable check style and colors
/// - [CPDFRadioButtonWidget]: Radio button for mutually exclusive options
/// - [CPDFListBoxWidget]: Scrollable list for selecting from multiple items
/// - [CPDFComboBoxWidget]: Dropdown menu for single selection
/// - [CPDFSignatureWidget]: Field for capturing digital signatures
/// - [CPDFPushButtonWidget]: Clickable button with associated actions
/// - [CPDFDocument.addWidgets]: Adds multiple form widgets to the document
///
/// Usage:
/// 1. Open the example and tap the menu button
/// 2. Select "Create Form Fields" to add all form types to page 1
/// 3. Interact with the created fields to test their functionality
class CreateFormFieldsExample extends StatelessWidget {
  /// Constructor
  const CreateFormFieldsExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Create Form Fields',
      assetPath: _assetPath,
      builder: (path) => _CreateFormFieldsPage(documentPath: path),
    );
  }
}

class _CreateFormFieldsPage extends ExampleBase {
  const _CreateFormFieldsPage({required super.documentPath});

  @override
  State<_CreateFormFieldsPage> createState() => _CreateFormFieldsPageState();
}

class _CreateFormFieldsPageState
    extends ExampleBaseState<_CreateFormFieldsPage> {
  static const List<String> _menuActions = ['Create Form Fields'];

  @override
  String get pageTitle => 'Create Form Fields';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.forms,
          availableViewModes: [CPDFViewMode.viewer, CPDFViewMode.forms],
        ),
        toolbarConfig: CPDFToolbarConfig(formToolbarVisible: false),
        formsConfig: const CPDFFormsConfig(
          showCreateComboBoxOptionsDialog: false,
          showCreateListBoxOptionsDialog: false,
          showCreatePushButtonOptionsDialog: false,
        ),
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
    if (action == 'Create Form Fields') {
      _handleCreateWidgets(controller);
    }
  }

  Future<void> _handleCreateWidgets(
    CPDFReaderWidgetController controller,
  ) async {
    final widgets = [
      CPDFTextWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.textField),
        page: 0,
        createDate: DateTime.fromMillisecondsSinceEpoch(1735696800000),
        rect: const CPDFRectF(left: 40, top: 799, right: 320, bottom: 701),
        borderColor: Colors.lightGreen,
        alignment: CPDFAlignment.right,
        fillColor: Colors.green,
        borderWidth: 10,
        text: 'This text field is created using the Flutter API.',
        familyName: 'Times',
        styleName: 'Bold',
      ),
      CPDFCheckBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.checkBox),
        page: 0,
        rect: const CPDFRectF(left: 361, top: 778, right: 442, bottom: 704),
        borderColor: Colors.blue,
        fillColor: Colors.white,
        borderWidth: 10,
        checkColor: Colors.blue,
        isChecked: true,
        checkStyle: CPDFCheckStyle.circle,
      ),
      CPDFRadioButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.radioButton),
        page: 0,
        rect: const CPDFRectF(left: 479, top: 789, right: 549, bottom: 715),
        borderColor: Colors.lightGreen,
        fillColor: Colors.yellow,
        borderWidth: 2,
        checkColor: Colors.lightGreen,
        isChecked: true,
        checkStyle: CPDFCheckStyle.diamond,
      ),
      CPDFListBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.listBox),
        page: 0,
        rect: const CPDFRectF(left: 53, top: 294, right: 294, bottom: 191),
        borderColor: Colors.blueAccent,
        fillColor: Colors.white,
        fontColor: Colors.black,
        fontSize: 18,
        familyName: 'Times',
        styleName: 'Bold',
        options: [
          CPDFWidgetItem(text: 'ComPDFKit', value: 'ComPDFKit'),
          CPDFWidgetItem(text: 'Flutter SDK', value: 'Flutter SDK'),
        ],
        selectItemAtIndex: 0,
      ),
      CPDFComboBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.comboBox),
        page: 0,
        borderWidth: 5,
        rect: const CPDFRectF(left: 354, top: 288, right: 557, bottom: 170),
        borderColor: Colors.blueAccent,
        fillColor: Colors.white,
        fontColor: Colors.black,
        fontSize: 18,
        familyName: 'Times',
        styleName: 'Bold',
        options: [
          CPDFWidgetItem(text: 'ComPDFKit', value: 'ComPDFKit'),
          CPDFWidgetItem(text: 'Flutter SDK', value: 'Flutter SDK'),
        ],
        selectItemAtIndex: 0,
      ),
      CPDFSignatureWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.signaturesFields),
        page: 0,
        rect: const CPDFRectF(left: 64, top: 649, right: 319, bottom: 527),
        borderColor: Colors.black,
        fillColor: Colors.white,
        borderWidth: 5,
      ),
      CPDFPushButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.pushButton),
        page: 0,
        rect: const CPDFRectF(left: 366, top: 632, right: 520, bottom: 541),
        borderColor: Colors.amberAccent,
        borderWidth: 5,
        fillColor: Colors.white,
        action: CPDFUriAction(uri: 'https://www.compdf.com'),
        buttonTitle: 'To Web',
      ),
      CPDFPushButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.pushButton),
        page: 0,
        rect: const CPDFRectF(left: 365, top: 503, right: 501, bottom: 413),
        borderColor: Colors.indigoAccent,
        borderWidth: 5,
        fillColor: Colors.white,
        action: CPDFGoToAction(pageIndex: 1),
        buttonTitle: 'Jump Page 1',
        familyName: 'Times',
        styleName: 'Bold',
      ),
    ];

    await controller.document.addWidgets(widgets);
  }
}
