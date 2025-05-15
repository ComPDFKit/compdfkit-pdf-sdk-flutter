// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import 'cpdf_text_widget.dart';


typedef CPDFWidgetFactory = CPDFWidget Function(Map<String, dynamic> json);

class CPDFWidgetRegistry {
  static final Map<CPDFFormType, CPDFWidgetFactory> _factories = {
    CPDFFormType.textField: CPDFTextWidget.fromJson,
    CPDFFormType.checkBox: CPDFCheckBoxWidget.fromJson,
    CPDFFormType.radioButton: CPDFRadioButtonWidget.fromJson,
    CPDFFormType.comboBox: CPDFComboBoxWidget.fromJson,
    CPDFFormType.listBox: CPDFListBoxWidget.fromJson,
    CPDFFormType.pushButton: CPDFPushButtonWidget.fromJson,
    CPDFFormType.signaturesFields: CPDFSignatureWidget.fromJson,
  };

  static CPDFWidget fromJson(Map<String, dynamic> json) {
    final type = CPDFFormType.fromString(json['type']);
    final factory = _factories[type] ?? CPDFWidget.fromJson;
    return factory(json);
  }
}
