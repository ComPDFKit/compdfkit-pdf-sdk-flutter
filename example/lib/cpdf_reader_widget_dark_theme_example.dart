// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:flutter/material.dart';

class CPDFDarkThemeExample extends StatefulWidget {
  final String documentPath;

  const CPDFDarkThemeExample({super.key, required this.documentPath});

  @override
  State<CPDFDarkThemeExample> createState() => _CPDFDarkThemeExampleState();
}

class _CPDFDarkThemeExampleState extends State<CPDFDarkThemeExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Dark Theme Example'),
        ),
        body: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: CPDFConfiguration(
              toolbarConfig: const CPDFToolbarConfig(
                  iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail]),
              globalConfig: const CPDFGlobalConfig(themeMode: CPDFThemeMode.dark)
          ),
          onCreated: (controller) {},
        ));
  }
}
