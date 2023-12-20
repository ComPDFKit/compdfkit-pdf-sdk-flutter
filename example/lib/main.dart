///  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/cpdf_configuration.dart';

import 'package:flutter/material.dart';

const String DOCUMENT_PATH = 'pdfs/PDF_Document.pdf';

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
    // Please replace it with your ComPDFKit license
    ComPDFKit.init(
        '77/0LbrlNGNUEKWCmu4/iG3ZlSv4+47zdgsGOxDX3vGx64O2BtvxJyDzgqNvAmqU8eM0G0ALjeYHtV3vrL7mNtev5BHDGmg2ye3WigSqpN8y0gOPPutXKAQyW9vM+cC81ws4sjcXt2vphQXKjRGeVnQodoe+0FbKzffywJ2DORo32GO9qJ51qIKGmXhokKOuQIDJ2eDgQDkIwUChC+yVz088AjTSDSYOe0UobLHOpkP6Ou4qbkx6pKJ+WexOqFxIb90cAQVVa02NpLJdSu8VPIDJNzuwds1y2RLVD6lgBj8Zez+CGDL4JzeYnYhQhlOZNLXJQ4ZqkN/eHcvgIlpzL2u0lH1oY17eVN2TRW5amzqOuoo5orgnAvMGFLdEwMLlC+K5dn2h1bB4RjP9ZTqgoNaGtyKiQ+FhqHLgPV+faNMUdCBlrq4FNafN5ZoZwbHn4fzUh88DO0481O/H5F0zHak/PQJR7Gu1OfN94Q2uALpL4t3i0S76cdEeJ6wRw44AH0PQikF7jWqqmAB1bqcqsgePNE97RigZwYiDA0p2AGWxhBg2+pgZD9EPOOjdtWPXK9LTAop75OQ9whjDWL1y0LTP/JhOPQIOghNPepj3VtjzSVrUbTBFktXeDGlz0NH9TnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1r9UpDZNXkuRC5cqSCOndk3WcAQjbXfQ4Bb9zwxbcvORsTU9lFmAbRS4KFSnCfN/gMqYb0QzhAKt6Wube1sAVkj4n7AvEss/0SdC9zk5m0/E/c0dDshJ3XKSLU/PaI1wbf/SnQhn+gZICJWg9lWCAi16kSStNvD+Tlg8iXYGXcUT967Gjfe/7Au1tVEU3oE60OBrEnSCSSJJt3MWbr/52CRpTtQ6bC+eZK0ijaRGZnS60G4A4sqfUpH3dRQ0juEnz0zrfyaQi4TKGCC1SzT5YPtsIEy4Stbdh3CCWoYV8SehrEkB58JHrolHhy5cVPV2RRYE30JXG5sJOlwb6wuhHVLlanJ7OE5ewEJCtZIHMkJ/rlfinOunS0G9GL2IMBwsyfOB1Cxl+yXx4V3li2ymawe');
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
            child: const Text(
              'Open Document',
              style: TextStyle(color: Colors.white),
            )),
      ))),
    );
  }

  void showDocument(BuildContext context) async {
    final bytes = await DefaultAssetBundle.of(context).load(DOCUMENT_PATH);
    final list = bytes.buffer.asUint8List();
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    var pdfsDir = Directory('${tempDir.path}/pdfs');
    pdfsDir.createSync(recursive: true);

    final tempDocumentPath = '${tempDir.path}/$DOCUMENT_PATH';
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
