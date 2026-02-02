// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CpdfEventListenerExample extends CPDFExampleBase {
  const CpdfEventListenerExample({super.key, required super.documentPath});

  @override
  State<CpdfEventListenerExample> createState() =>
      _CPDFEventListenerExampleState();
}

class _CPDFEventListenerExampleState
    extends CPDFExampleBaseState<CpdfEventListenerExample> {

  CPDFEditArea? selectArea;

  @override
  List<String>? get menuActions => [
    'Show EditArea View',
    'Remove EditArea',
  ];

  @override
  String get pageTitle => 'Event Listener Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration();

  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);

    controller.addEventListener(CPDFEvent.annotationsCreated, (event) {
      debugPrint(
          'ComPDFKit: Create Annotation: Type:${event.runtimeType} --------->');
      printJsonString(jsonEncode(event));
    });

    controller.addEventListener(CPDFEvent.annotationsSelected, (event) {
      debugPrint(
          'ComPDFKit: Selected Annotation: Type:${event.runtimeType} --------->');
      printJsonString(jsonEncode(event));
    });

    controller.addEventListener(CPDFEvent.annotationsDeselected, (event) {
      debugPrint(
          'ComPDFKit: Deselected Annotation: Type:${event.runtimeType}  --------->');
      if (event != null) {
        printJsonString(jsonEncode(event));
      } else {
        debugPrint('Event data is null');
      }
    });

    controller.addEventListener(CPDFEvent.formFieldsCreated, (event) {
      debugPrint(
          'ComPDFKit: Create Form Field: Type:${event.runtimeType} --------->');
      printJsonString(jsonEncode(event));
    });

    controller.addEventListener(CPDFEvent.formFieldsSelected, (event) {
      debugPrint(
          'ComPDFKit: Selected Form Field: Type:${event.runtimeType} --------->');
      printJsonString(jsonEncode(event));
    });

    controller.addEventListener(CPDFEvent.formFieldsDeselected, (event) {
      debugPrint(
          'ComPDFKit: Deselected Form Field: Type:${event.runtimeType}  --------->');
      if (event != null) {
        printJsonString(jsonEncode(event));
      } else {
        debugPrint('Event data is null');
      }
    });

    controller.addEventListener(CPDFEvent.editorSelectionSelected, (event) {
      debugPrint(
          'ComPDFKit: Selected Editor Selection: Type:${event.runtimeType} --------->');
      printJsonString(jsonEncode(event));
      setState(() {
        selectArea = event;
      });
    });

    controller.addEventListener(CPDFEvent.editorSelectionDeselected, (event) {
      debugPrint(
          'ComPDFKit: Deselected Editor Selection: Type:${event.runtimeType}  --------->');
      if (event != null) {
        printJsonString(jsonEncode(event));
      } else {
        debugPrint('Event data is null');
      }
      setState(() {
        selectArea = null;
      });
    });
  }

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) async {
    super.handleMenuAction(action, controller);
    switch(action){
      case 'Show EditArea View':
        if (selectArea != null){
          await controller.showEditAreaPropertiesView(selectArea!);
        }
        break;
      case 'Remove EditArea':
        if (selectArea != null){
          bool result = await controller.document.removeEditArea(selectArea!);
          debugPrint('ComPDFKit: Remove EditArea result: $result');
          if (result){
            setState(() {
              selectArea = null;
            });
          }
        }
        break;  
    }
  }

  @override
  Widget buildContent() {
    return Column(
      children: [
        Expanded(child: super.buildContent()),
      ],
    );
  }
}
