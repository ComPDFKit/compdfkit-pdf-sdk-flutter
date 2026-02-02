/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/page/annotations/tools/cpdf_annotation_history_manager_widget.dart';
import 'package:compdfkit_flutter_example/page/annotations/tools/cpdf_annotation_mode_list_widget.dart';
import 'package:flutter/material.dart';

class CPDFAnnotationToolsWidget extends StatefulWidget {

  final List<CPDFAnnotationType> availableAnnotationTypes;

  final CPDFReaderWidgetController controller;

  const CPDFAnnotationToolsWidget({super.key, required this.controller,this.availableAnnotationTypes = CPDFAnnotationType.values});

  @override
  State<CPDFAnnotationToolsWidget> createState() =>
      _CPDFAnnotationToolsWidgetState();
}

class _CPDFAnnotationToolsWidgetState extends State<CPDFAnnotationToolsWidget> {
  late CPDFAnnotationType currentAnnotationType = CPDFAnnotationType.unknown;

  @override
  void initState() {
    super.initState();
    _initializeCurrentAnnotationType();
  }

  void _initializeCurrentAnnotationType() async {
    CPDFAnnotationType type = await widget.controller.getAnnotationMode();
    setState(() {
      currentAnnotationType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ]),
        width: double.infinity,
        height: 72,
        child: Row(
          children: [
            Expanded(
                child: CpdfAnnotationModeListWidget(
                  availableAnnotationTypes: widget.availableAnnotationTypes,
                    controller: widget.controller)),
            CpdfAnnotationHistoryManagerWidget(controller: widget.controller)
          ],
        ));
  }
}
