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
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/page/annotations/tools/cpdf_annotation_history_manager_widget.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:compdfkit_flutter/util/cpdf_widget_util.dart';

class CPDFFormCreationExample extends StatefulWidget {
  final String documentPath;

  const CPDFFormCreationExample({super.key, required this.documentPath});

  @override
  State<CPDFFormCreationExample> createState() =>
      _CpdfFormCreationExampleState();
}

class _CpdfFormCreationExampleState extends State<CPDFFormCreationExample> {
  CPDFReaderWidgetController? _controller;
  CPDFFormType _currentType = CPDFFormType.unknown;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CPDFReaderPage(
          title: 'Form Creation Example',
          documentPath: widget.documentPath,
          configuration: CPDFConfiguration(
              modeConfig:
                  const CPDFModeConfig(initialViewMode: CPDFViewMode.forms),
              toolbarConfig: CPDFToolbarConfig(formToolbarVisible: false),
              formsConfig: const CPDFFormsConfig(
                  showCreateComboBoxOptionsDialog: false,
                  showCreateListBoxOptionsDialog: false,
                  showCreatePushButtonOptionsDialog: false)),
          onCreated: (controller) async {
            setState(() {
              _controller = controller;
            });
            controller.addEventListener(CPDFEvent.formFieldsSelected, (event) {
              debugPrint(
                  'ComPDFKit: Create Form Field: Type:${event.runtimeType} --------->');
              printJsonString(jsonEncode(event));
            });
          },
          appBarActions: (controller) {
            return [
              IconButton(
                  onPressed: () async {
                    _handleAddWidgets(controller);
                  },
                  icon: const Icon(Icons.add))
            ];
          },
        )),
        if (_controller != null) ...{_buildAnnotationToolbar()}
      ],
    );
  }

  Widget _buildAnnotationToolbar() {
    return Container(
        width: double.infinity,
        color: const Color(0xFFFAFCFF),
        padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 16),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildToolButton(CPDFFormType.textField, 'TextField',
                      'images/ic_textfield.svg'),
                  _buildToolButton(CPDFFormType.checkBox, 'CheckBox',
                      'images/ic_checkbox.svg'),
                  _buildToolButton(CPDFFormType.radioButton, 'RadioButton',
                      'images/ic_radiobutton.svg'),
                  _buildToolButton(
                      CPDFFormType.listBox, 'ListBox', 'images/ic_listbox.svg'),
                  _buildToolButton(CPDFFormType.comboBox, 'ComboBox',
                      'images/ic_combo_box.svg'),
                  _buildToolButton(CPDFFormType.signaturesFields, 'Sign',
                      'images/ic_sign.svg'),
                  _buildToolButton(CPDFFormType.pushButton, 'PushButton',
                      'images/ic_button.svg')
                ],
              ),
            )),
            CpdfAnnotationHistoryManagerWidget(controller: _controller!)
          ],
        ));
  }

  Widget _buildToolButton(CPDFFormType type, String label, String iconName) {
    final isSelected = _currentType == type;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withAlpha(128) : null,
          borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        onPressed: () {
          if (isSelected) {
            _exitFormCreationMode();
          } else {
            _enterFormMode(type);
          }
        },
        icon: SvgPicture.asset(iconName, width: 24, height: 24),
        color: isSelected ? Colors.blue : Colors.black87,
      ),
    );
  }

  Future<void> _enterFormMode(CPDFFormType type) async {
    try {
      await _controller!.setFormCreationMode(type);
      final mode = await _controller!.getFormCreationMode();
      setState(() {
        _currentType = mode;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _exitFormCreationMode() async {
    try {
      await _controller?.exitFormCreationMode();
      setState(() {
        _currentType = CPDFFormType.unknown;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _handleAddWidgets(CPDFReaderWidgetController controller) async {
    final exampleWidgets = [
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
          styleName: 'Bold'),

      CPDFCheckBoxWidget(
          title: CPDFWidgetUtil.createFieldName(CPDFFormType.checkBox),
          page: 0,
          rect: const CPDFRectF(left: 361, top: 778, right: 442, bottom: 704),
          borderColor: Colors.blue,
          fillColor: Colors.white,
          borderWidth: 10,
          checkColor: Colors.blue,
          isChecked: true,
          checkStyle: CPDFCheckStyle.circle),
      CPDFRadioButtonWidget(
          title: CPDFWidgetUtil.createFieldName(CPDFFormType.radioButton),
          page: 0,
          rect: const CPDFRectF(left: 479, top: 789, right: 549, bottom: 715),
          borderColor: Colors.lightGreen,
          fillColor: Colors.yellow,
          borderWidth: 2,
          checkColor: Colors.lightGreen,
          isChecked: true,
          checkStyle: CPDFCheckStyle.diamond),
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
          selectItemAtIndex: 0),
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
          selectItemAtIndex: 0),
      CPDFSignatureWidget(
          title: CPDFWidgetUtil.createFieldName(CPDFFormType.signaturesFields),
          page: 0,
          rect: const CPDFRectF(left: 64, top: 649, right: 319, bottom: 527),
          borderColor: Colors.black,
          fillColor: Colors.white,
          borderWidth: 5),
      CPDFPushButtonWidget(
          title: CPDFWidgetUtil.createFieldName(CPDFFormType.pushButton),
          page: 0,
          rect: const CPDFRectF(left: 366, top: 632, right: 520, bottom: 541),
          borderColor: Colors.amberAccent,
          borderWidth: 5,
          fillColor: Colors.white,
          action: CPDFUriAction(uri: 'https://www.compdf.com'),
          buttonTitle: 'To Web'),
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
          styleName: 'Bold')
    ];
    await controller.document.addWidgets(exampleWidgets);
  }
}
