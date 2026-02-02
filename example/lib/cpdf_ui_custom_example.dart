// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/config/cpdf_ui_style_config.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CpdfUiCustomExample extends CPDFExampleBase {
  const CpdfUiCustomExample({super.key, required super.documentPath});

  @override
  State<CpdfUiCustomExample> createState() =>
      _CPDFUiCustomExampleState();
}

class _CPDFUiCustomExampleState
    extends CPDFExampleBaseState<CpdfUiCustomExample> {

  @override
  String get pageTitle => 'Ui Custom Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
    readerViewConfig: CPDFReaderViewConfig(
      uiStyle: CPDFUiStyleConfig.create(
          bookmarkIcon: 'ic_test_bookmark',
          selectTextColor: Colors.deepOrange.withAlpha(100),
          icons: const CPDFUiStyleIcons(
              selectTextIcon: 'ic_test_cursor',
              selectTextLeftIcon: 'ic_test_cursor_left',
              selectTextRightIcon: 'ic_test_cursor_right',
              rotationAnnotationIcon: 'ic_test_rotate'
          ),
          defaultBorderStyle: const CPDFUiBorderStyle(
              borderColor: Colors.amberAccent,
              borderWidth: 2,
              borderDashPattern: [20, 8]
          ),
          focusBorderStyle: const CPDFUiBorderStyle(
              nodeColor: Colors.pink,
              borderColor: Colors.pink,
              borderWidth: 2,
              borderDashPattern: [0,0]
          ),
          cropImageStyle: const CPDFUiBorderStyle(
              borderColor: Colors.pink,
              borderWidth: 2,
              borderDashPattern: [0,0]
          )
      )
    )
  );

  @override
  Widget buildContent() {
    return Column(
      children: [
        Expanded(child: super.buildContent()),
      ],
    );
  }
}
