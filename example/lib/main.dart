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
    if (Platform.isAndroid) {
      ComPDFKit.init('SsFUBGT6t2g9mu/FmY/tH2rNi83UByh2bEXYl8KViCupYHcuOtXureb7D2SXxrhIrmkfCQn32v/BYFJsmDX4aJKMVRWuo7L9Ek7d4eMslDYWDwbrXq4RA9jjwNhDQpzfKbfv7q845gicZDoORi2xRdyKq9AGP7jfszTSY6fuslbom/ycXHS5JRk6WctpYbD6WK+PeJDyJe/K15GvqbJsr/hRVHJnko6pVpkxBY9hA7DQH0HRm0zE9e+z/s+EtiTCALLTGsRve9jF8Ht2WTg7ddn+iDiiy0avaoZ6m8GTV5Rk0xHzz6vbjGodTtjqjM8cjDALt1E3F3BQTdgJaAKAgGu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj1djOeLrrsCEaYBrVJtuJVPXjjpHv/B36v7bv6BhL0LQkMwgm8pSYa3fBvOAq3l2ib74w2j2b01ku5P245z+W4lq21AE/PTaYZR5F5nWaQfKMzT8HB92qLwarLi0hBbbFEbEUIZUBdN9TIroRmRrzLIx1IzmoMwQENYtUWaDmknkcj4x9yOy/fdSALl+QtcwUmCpi6m0j863I+F86pEzCkHYvQvPdaW+bx8LBHRdmY6CNIX7w5oxO2NAXEkxwnoE85BE++rTWnjdjWjzJ8AcSSxxEaSCXAF6mtqTjjiHAkyJgmbSXDejv0NeYpybCfDkzwO4zL1qOkq+ZtdME0RqR3eI3Sv2hnO4mbco6Kdff5VZlg6/9qDYi/dNTH8GVYVPAtNKhtEbZRIPR9E+4aRXdIL');
    }else if (Platform.isIOS) {
      ComPDFKit.init('t2p6R8/clQc4jpf9A++mB6YfUQ0rrECgKes5bUnW8wGwIf+R1Ot6nRmN4qBoHUqkooBY/9qhRStv0BM95jxXkTj60TiVIXy9WsztqeU33thasOiTK0hdeXMvwYZ4+4BHyQHwkYNf6/3inJiUnRl3xfTNeD8/NENiro+iLdpbEOGBNd7rTzR4p7WNo3bbLVzcvCK0esWkMXZz2+JuzdtwXFXHghkbLejFFVRE3PyIob6iZBawLtt+TUAhnQkbU7Q/Z399YuIiw3ur230H4icn7ZmHHgIJzFTaIYCuluF/QNarTs0Z4eh8ClYm0u6rJz42XHk1PsI10KCfPVxSaVYGvGu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj2iW5vEiAxKL+Hs+L5PEV11WKVc3vOYWIu1AAWEabsmhISUekul02fLSjxwtcXbhwDGmOFer4XQ2gyRUAo+ydpYX/ev3VY2ZrUyXsWGHyrDlSFzQ1nW5cOwbM0BhzyHAZevr3Ct4nrLtc0ELnw3glKoYvGz6OKkWoe6qCgesJOfvzh+A49/TL9Ap760hiQNzceOlL4vWLTvXQ9fSDWVZnRxl3wq0mV7E+lek14llLmD1mQypPqwJiH3RTfITGPxxXIdI8xu/5FEGy6+IZn5YrWaJ1yXfMqkdgp6OZpWDHiImeGHFc9l2ZsRcUpj8kY2r6/TAZboh+ksP4pzCLqDpfkZN5Dnbbn7cBliFty0fcuMFlFqVYuDakXTQBwNPN/SNG4a6ZZwc8lYmSRSxaSHWghm');
    }

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
