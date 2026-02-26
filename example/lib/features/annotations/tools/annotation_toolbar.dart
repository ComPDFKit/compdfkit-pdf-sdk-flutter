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
import 'annotation_history_toolbar.dart';
import 'annotation_mode_list.dart';
import 'package:flutter/material.dart';

class AnnotationToolbar extends StatelessWidget {
  final List<CPDFAnnotationType> availableAnnotationTypes;

  final CPDFReaderWidgetController controller;

  const AnnotationToolbar(
      {super.key,
      required this.controller,
      this.availableAnnotationTypes = CPDFAnnotationType.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Expanded(
            child: AnnotationModeList(
              availableAnnotationTypes: availableAnnotationTypes,
              controller: controller,
            ),
          ),
          AnnotationHistoryToolbar(controller: controller),
        ],
      ),
    );
  }
}
