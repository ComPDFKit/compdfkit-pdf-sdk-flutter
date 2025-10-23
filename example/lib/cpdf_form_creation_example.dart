// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/page/annotations/tools/cpdf_annotation_history_manager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
                  toolbarConfig: const CPDFToolbarConfig(
                    formToolbarVisible: false
                  )
                ),
                onCreated: (controller) {
                  setState(() {
                    _controller = controller;
                  });
                })),
        if (_controller != null) ...{_buildAnnotationToolbar()}
      ],
    );
  }

  Widget _buildAnnotationToolbar() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFAFCFF),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(children: [
        Expanded(child:SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildToolButton(
                  CPDFFormType.textField, 'TextField', 'images/ic_textfield.svg'),
              _buildToolButton(
                  CPDFFormType.checkBox, 'CheckBox', 'images/ic_checkbox.svg'),
              _buildToolButton(CPDFFormType.radioButton, 'RadioButton',
                  'images/ic_radiobutton.svg'),
              _buildToolButton(
                  CPDFFormType.listBox, 'ListBox', 'images/ic_listbox.svg'),
              _buildToolButton(
                  CPDFFormType.comboBox, 'ComboBox', 'images/ic_combo_box.svg'),
              _buildToolButton(
                  CPDFFormType.signaturesFields, 'Sign', 'images/ic_sign.svg'),
              _buildToolButton(
                  CPDFFormType.pushButton, 'PushButton', 'images/ic_button.svg')
            ],
          ),
        )),
        CpdfAnnotationHistoryManagerWidget(controller: _controller!)
      ],)
    );
  }

  Widget _buildToolButton(CPDFFormType type, String label, String iconName) {
    final isSelected = _currentType == type;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withAlpha(128) : null,
          borderRadius: BorderRadius.circular(8)
      ),
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
}
