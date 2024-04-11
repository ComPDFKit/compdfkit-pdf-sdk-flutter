///
///  Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.
///


import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/cpdf_configuration.dart';

import 'package:flutter/material.dart';

const String _documentPath = 'pdfs/PDF_Document.pdf';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {

    // online license auth
    // Please replace it with your ComPDFKit license
    // ComPDFKit.initialize(androidOnlineLicense: 'android compdfkit key',iosOnlineLicense: 'ios compdfkit key');

    // offline license auth
    ComPDFKit.init('your compdfkit key');

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
              child: Center(
        child: ElevatedButton(
            onPressed: () async {
              showDocument(context);
            },
            child: const Text('Open Document')),
      ))),
    );
  }

  void showDocument(BuildContext context) async {
    final bytes = await DefaultAssetBundle.of(context).load(_documentPath);
    final list = bytes.buffer.asUint8List();
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    var pdfsDir = Directory('${tempDir.path}/pdfs');
    pdfsDir.createSync(recursive: true);
    final tempDocumentPath = '${tempDir.path}/$_documentPath';
    final file = File(tempDocumentPath);
    if (!file.existsSync()) {
      file.create(recursive: true);
      file.writeAsBytesSync(list);
    }

    var configuration = CPDFConfiguration();
    // How to disable functionality:
    // setting the default display mode when opening
    //      configuration.modeConfig = const ModeConfig(initialViewMode: CPreviewMode.digitalSignatures);
    // top toolbar configuration:
    // android:
    //      configuration.toolbarConfig = const ToolbarConfig(androidAvailableActions: [
    //           ToolbarAction.thumbnail, ToolbarAction.bota,
    //           ToolbarAction.search, ToolbarAction.menu
    //      ],
    //      availableMenus: [
    //        ToolbarMenuAction.viewSettings, ToolbarMenuAction.documentInfo, ToolbarMenuAction.security,
    //      ]);
    // iOS:
    //      configuration.toolbarConfig = const ToolbarConfig(iosLeftBarAvailableActions: [
    //          ToolbarAction.back, ToolbarAction.thumbnail
    //      ],
    //      iosRightBarAvailableActions: [
    //        ToolbarAction.bota, ToolbarAction.search, ToolbarAction.menu
    //      ],
    //      availableMenus: [
    //        ToolbarMenuAction.viewSettings, ToolbarMenuAction.documentInfo, ToolbarMenuAction.security,
    //      ]);
    // readerview configuration
    //      configuration.readerViewConfig = const ReaderViewConfig(linkHighlight: true, formFieldHighlight: true);
    ComPDFKit.openDocument(tempDocumentPath,
        password: '', configuration: configuration);
  }
}
