/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_options.dart';

import 'cpdf_context_menu_item.dart';

class CPDFFormModeContextMenu {

  final List<CPDFContextMenuItem<CPDFFormTextFieldMenuKey>> textField;
  final List<CPDFContextMenuItem<CPDFFormCheckBoxMenuKey>> checkBox;
  final List<CPDFContextMenuItem<CPDFFormRadioButtonMenuKey>> radioButton;
  final List<CPDFContextMenuItem<CPDFFormListBoxMenuKey>> listBox;
  final List<CPDFContextMenuItem<CPDFFormComboBoxMenuKey>> comboBox;
  final List<CPDFContextMenuItem<CPDFFormSignatureFieldMenuKey>> signatureField;
  final List<CPDFContextMenuItem<CPDFFormPushButtonMenuKey>> pushButton;

  const CPDFFormModeContextMenu({
    this.textField = const [
      CPDFContextMenuItem(CPDFFormTextFieldMenuKey.properties),
      CPDFContextMenuItem(CPDFFormTextFieldMenuKey.delete),
    ],
    this.checkBox = const [
      CPDFContextMenuItem(CPDFFormCheckBoxMenuKey.properties),
      CPDFContextMenuItem(CPDFFormCheckBoxMenuKey.delete),
    ],
    this.radioButton = const [
      CPDFContextMenuItem(CPDFFormRadioButtonMenuKey.properties),
      CPDFContextMenuItem(CPDFFormRadioButtonMenuKey.delete),
    ],
    this.listBox = const [
      CPDFContextMenuItem(CPDFFormListBoxMenuKey.options),
      CPDFContextMenuItem(CPDFFormListBoxMenuKey.properties),
      CPDFContextMenuItem(CPDFFormListBoxMenuKey.delete),
    ],
    this.comboBox = const [
      CPDFContextMenuItem(CPDFFormComboBoxMenuKey.options),
      CPDFContextMenuItem(CPDFFormComboBoxMenuKey.properties),
      CPDFContextMenuItem(CPDFFormComboBoxMenuKey.delete),
    ],
    this.signatureField = const [
      CPDFContextMenuItem(CPDFFormSignatureFieldMenuKey.startToSign),
      CPDFContextMenuItem(CPDFFormSignatureFieldMenuKey.delete),
    ],
    this.pushButton = const [
      CPDFContextMenuItem(CPDFFormPushButtonMenuKey.properties),
      CPDFContextMenuItem(CPDFFormPushButtonMenuKey.delete),
    ],
  });

  Map<String, dynamic> toJson() {
    return {
      'textField': textField.map((item) => item.toJson()).toList(),
      'checkBox': checkBox.map((item) => item.toJson()).toList(),
      'radioButton': radioButton.map((item) => item.toJson()).toList(),
      'listBox': listBox.map((item) => item.toJson()).toList(),
      'comboBox': comboBox.map((item) => item.toJson()).toList(),
      'signatureField': signatureField.map((item) => item.toJson()).toList(),
      'pushButton': pushButton.map((item) => item.toJson()).toList(),
    };
  }

}