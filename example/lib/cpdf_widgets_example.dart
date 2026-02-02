// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';
import 'dart:io';

import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_checkbox_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_combobox_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_listbox_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_pushbutton_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_radiobutton_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_signature_widget_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/form/cpdf_textfield_attr.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/page/cpdf_widget_list_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CPDFWidgetsExample extends CPDFExampleBase {
  const CPDFWidgetsExample({super.key, required super.documentPath});

  @override
  State<CPDFWidgetsExample> createState() => _CPDFWidgetsExampleState();
}

class _CPDFWidgetsExampleState
    extends CPDFExampleBaseState<CPDFWidgetsExample> {
  static const List<String> _menuActions = [
    'Open Document',
    'Import Widgets',
    'Export Widgets',
    'Get Widgets',
    'Get Widget Attr',
    'Set Widget Attr',
    'Get Fonts'
  ];

  @override
  String get pageTitle => 'Widgets Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
      toolbarConfig: CPDFToolbarConfig(toolbarLeftItems: [
        if (Platform.isIOS) ...[
          CPDFToolbarAction.thumbnail,
        ]
      ], toolbarRightItems: [
        if (Platform.isAndroid) ...[
          CPDFToolbarAction.thumbnail,
        ],
        CPDFToolbarAction.search,
        CPDFToolbarAction.bota,
        CPDFToolbarAction.menu
      ]),
      formsConfig: const CPDFFormsConfig(
          initAttribute: CPDFFormAttribute(
              textFieldAttr: CPDFTextFieldAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 10,
                  fontSize: 20,
                  borderColor: Colors.pink,
                  fontColor: Colors.white,
                  alignment: CPDFAlignment.right,
                  familyName: 'Times',
                  styleName: 'Bold'),
              checkBoxAttr: CPDFCheckBoxAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 8,
                  borderColor: Colors.pink,
                  checkedColor: Colors.deepOrange,
                  isChecked: true,
                  checkedStyle: CPDFCheckStyle.circle),
              radioButtonAttr: CPDFRadioButtonAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 8,
                  borderColor: Colors.pink,
                  checkedColor: Colors.deepOrange,
                  isChecked: true,
                  checkedStyle: CPDFCheckStyle.circle),
              pushButtonAttr: CPDFPushButtonAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 8,
                  borderColor: Colors.pink,
                  title: 'Test-ComPDFKit',
                  fontColor: Colors.deepOrange,
                  fontSize: 20,
                  familyName: 'Academy Engraved LET',
                  styleName: 'Plain'),
              listBoxAttr: CPDFListBoxAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 8,
                  borderColor: Colors.pink,
                  fontColor: Colors.white,
                  familyName: 'Academy Engraved LET',
                  styleName: 'Plain',
                  fontSize: 20),
              comboBoxAttr: CPDFComboBoxAttr(
                  fillColor: Colors.lightBlue,
                  borderWidth: 8,
                  borderColor: Colors.pink,
                  fontColor: Colors.white,
                  familyName: 'Academy Engraved LET',
                  styleName: 'Plain',
                  fontSize: 20),
              signaturesFieldsAttr: CPDFSignatureWidgetAttr(
                fillColor: Colors.lightBlue,
                borderWidth: 8,
                borderColor: Colors.pink,
              ))));

  @override
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Open Document':
        _handleOpenDocument(controller);
        break;
      case 'Import Widgets':
        _handleImportWidgets(controller);
        break;
      case 'Export Widgets':
        _handleExportWidgets(controller);
        break;
      case 'Get Widgets':
        _handleGetWidgets(controller);
        break;
      case 'Get Widget Attr':
        _handleGetWidgetAttr(controller);
        break;
      case 'Set Widget Attr':
        _handleSetWidgetAttr(controller);
        break;
      case 'Get Fonts':
        _handleGetFonts(controller);
        break;
    }
  }

  void _handleGetFonts(CPDFReaderWidgetController controller) async {
    final fonts = await ComPDFKit.getFonts();
    final familyName = fonts[0].familyName;
    final styleName = fonts[0].styleNames[0];
    debugPrint('ComPDFKit-Flutter: font:$familyName - $styleName');
  }

  void _handleOpenDocument(CPDFReaderWidgetController controller) async {
    final path = await ComPDFKit.pickFile();
    if (path != null) {
      final error = await controller.document.open(path);
      debugPrint('Open document result: $error');
    }
  }

  void _handleImportWidgets(CPDFReaderWidgetController controller) async {
    final xfdfFile = await extractAsset(
      'pdfs/annot_test_widgets.xfdf',
      shouldOverwrite: false,
    );
    final importResult = await controller.document.importWidgets(xfdfFile.path);
    debugPrint('Import widgets result: $importResult');
  }

  void _handleExportWidgets(CPDFReaderWidgetController controller) async {
    final xfdfPath = await controller.document.exportWidgets();
    debugPrint('Export widgets path: $xfdfPath');
  }

  void _handleGetWidgets(CPDFReaderWidgetController controller) async {
    final pageCount = await controller.document.getPageCount();
    final List<CPDFWidget> widgets = [];

    for (int i = 0; i < pageCount; i++) {
      final page = controller.document.pageAtIndex(i);
      final pageWidgets = await page.getWidgets();
      widgets.addAll(pageWidgets);
    }

    if (!mounted) {
      return;
    }

    final data = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (sheetContext) => CpdfWidgetListPage(widgets: widgets),
    );

    if (data != null) {
      final type = data['type'] as String;
      final widget = data['widget'] as CPDFWidget;
      if (type == 'jump') {
        // await controller.setDisplayPageIndex(
        //     pageIndex: widget.page, rectList: [widget.rect]);
        if (widget is CPDFTextWidget) {
          widget.title = 'TextFields---ComPDFKit';
          widget.fillColor = Colors.green;
          widget.borderColor = Colors.red;
          widget.borderWidth = 10;
          widget.text = 'Updated Text';
          widget.fontColor = Colors.black;
          widget.fontSize = 20.0;
          widget.alignment = CPDFAlignment.center;
          widget.isMultiline = true;
          widget.familyName = 'Times';
          widget.styleName = 'Bold';
        } else if (widget is CPDFCheckBoxWidget) {
          widget.title = 'CheckBox---ComPDFKit';
          widget.fillColor = Colors.green;
          widget.borderColor = Colors.red;
          widget.borderWidth = 10;
          widget.checkColor = Colors.amber;
          widget.checkStyle = CPDFCheckStyle.circle;
          widget.isChecked = true;
        } else if (widget is CPDFRadioButtonWidget) {
          widget.title = 'RadioButton---ComPDFKit';
          widget.fillColor = Colors.red;
          widget.borderColor = Colors.green;
          widget.borderWidth = 5;
          widget.checkColor = Colors.pink;
          widget.checkStyle = CPDFCheckStyle.diamond;
          widget.isChecked = true;
        } else if (widget is CPDFListBoxWidget) {
          widget.fillColor = Colors.deepPurple;
          widget.borderColor = Colors.green;
          widget.borderWidth = 5;
          widget.options = [
            CPDFWidgetItem(
                text: 'ComPDFKit-Android', value: 'ComPDFKit-Android'),
            CPDFWidgetItem(
                text: 'ComPDFKit-Flutter', value: 'ComPDFKit-Flutter'),
            CPDFWidgetItem(text: 'ComPDFKit-RN', value: 'ComPDFKit-RN'),
          ];
          widget.selectItemAtIndex = 1;
          widget.familyName = 'Times';
          widget.styleName = 'Bold';
          widget.fontSize = 18;
          widget.fontColor = Colors.lightBlue;
        } else if (widget is CPDFComboBoxWidget) {
          widget.fillColor = Colors.deepPurple;
          widget.borderColor = Colors.green;
          widget.borderWidth = 5;
          widget.options = [
            CPDFWidgetItem(
                text: 'ComPDFKit-Android', value: 'ComPDFKit-Android'),
            CPDFWidgetItem(
                text: 'ComPDFKit-Flutter', value: 'ComPDFKit-Flutter'),
            CPDFWidgetItem(text: 'ComPDFKit-RN', value: 'ComPDFKit-RN'),
          ];
          widget.selectItemAtIndex = 2;
          widget.familyName = 'Times';
          widget.styleName = 'Bold';
          widget.fontSize = 16;
          widget.fontColor = Colors.lightBlue;
        } else if (widget is CPDFSignatureWidget) {
          widget.fillColor = Colors.deepOrangeAccent;
          widget.borderColor = Colors.green;
          widget.borderWidth = 5;
        } else if (widget is CPDFPushButtonWidget) {
          widget.fillColor = Colors.blueAccent;
          widget.borderColor = Colors.green;
          widget.borderWidth = 5;
          widget.buttonTitle = 'ComPDFKit';
          widget.action = CPDFUriAction(uri: 'http://www.compdf.com');
          // widget.action = CPDFGoToAction(pageIndex: 0);
          widget.fontColor = Colors.red;
          widget.fontSize = 18;
          widget.familyName = 'Times';
          widget.styleName = 'Bold';
        }
        printJsonString(jsonEncode(widget.toJson()));
        await controller.document.updateWidget(widget);
      } else if (type == 'remove') {
        final page = controller.document.pageAtIndex(widget.page);
        final result = await page.removeWidget(widget);
        debugPrint('Remove widget result: $result');
      }
    }
  }

  void _handleGetWidgetAttr(CPDFReaderWidgetController controller) async {
    final widgetAttr = await controller.fetchDefaultWidgetStyle();
    printJsonString(jsonEncode(widgetAttr.toJson()));
  }

  void _handleSetWidgetAttr(CPDFReaderWidgetController controller) async {
    const familyName = 'Times';
    const styleName = 'Bold';
    debugPrint('ComPDFKit-Flutter: font:$familyName - $styleName');
    final defaultAttr = await controller.fetchDefaultWidgetStyle();

    final textFieldAttr = defaultAttr.textFieldAttr.copyWith(
      fillColor: Colors.lightGreen,
      borderColor: Colors.deepOrange,
      borderWidth: 5,
      fontColor: Colors.black,
      fontSize: 20,
      alignment: CPDFAlignment.center,
      multiline: true,
      familyName: familyName,
      styleName: styleName,
    );

    await controller.updateDefaultWidgetStyle(textFieldAttr);

    final checkBoxAttr = defaultAttr.checkBoxAttr.copyWith(
      fillColor: Colors.yellow,
      borderColor: Colors.blue,
      borderWidth: 5,
      checkedColor: Colors.red,
      isChecked: false,
      checkedStyle: CPDFCheckStyle.diamond,
    );
    await controller.updateDefaultWidgetStyle(checkBoxAttr);

    final radioButtonAttr = defaultAttr.radioButtonAttr.copyWith(
      fillColor: Colors.yellow,
      borderColor: Colors.blue,
      borderWidth: 5,
      checkedColor: Colors.red,
      isChecked: true,
      checkedStyle: CPDFCheckStyle.square,
    );
    await controller.updateDefaultWidgetStyle(radioButtonAttr);

    final listBoxAttr = defaultAttr.listBoxAttr.copyWith(
      fillColor: Colors.purple,
      borderColor: Colors.orange,
      borderWidth: 5,
      fontColor: Colors.white,
      fontSize: 16,
      familyName: familyName,
      styleName: styleName,
    );
    await controller.updateDefaultWidgetStyle(listBoxAttr);

    final comboBoxAttr = defaultAttr.comboBoxAttr.copyWith(
      fillColor: Colors.purple,
      borderColor: Colors.orange,
      borderWidth: 5,
      fontColor: Colors.white,
      fontSize: 16,
      familyName: familyName,
      styleName: styleName,
    );
    await controller.updateDefaultWidgetStyle(comboBoxAttr);

    final signAttr = defaultAttr.signaturesFieldsAttr.copyWith(
      fillColor: Colors.purple,
      borderColor: Colors.orange,
      borderWidth: 5,
    );
    await controller.updateDefaultWidgetStyle(signAttr);

    final pushButtonAttr = defaultAttr.pushButtonAttr.copyWith(
      fillColor: Colors.purple,
      borderColor: Colors.orange,
      borderWidth: 5,
      fontColor: Colors.white,
      fontSize: 16,
      familyName: familyName,
      styleName: styleName,
      title: 'ComPDFKit-Flutter',
    );
    await controller.updateDefaultWidgetStyle(pushButtonAttr);
  }
}
