// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef CPDFReaderWidgetCreatedCallback = void Function(
    CPDFReaderWidgetController controller);

typedef CPDFPageChangedCallback = void Function(int pageIndex);

typedef CPDFDocumentSaveCallback = void Function();


class CPDFReaderWidget extends StatefulWidget {
  /// pdf file path
  final String document;

  final String? password;

  /// init ComPDFKit SDK configuration
  final CPDFConfiguration configuration;

  final CPDFReaderWidgetCreatedCallback onCreated;

  final CPDFPageChangedCallback? onPageChanged;

  final CPDFDocumentSaveCallback? onSaveCallback;

  /// init callback
  const CPDFReaderWidget(
      {Key? key,
      required this.document,
      this.password = '',
      required this.configuration,
      required this.onCreated,
      this.onPageChanged,
      this.onSaveCallback})
      : super(key: key);

  @override
  State<CPDFReaderWidget> createState() => _CPDFReaderWidgetState();
}

class _CPDFReaderWidgetState extends State<CPDFReaderWidget> {

  @override
  Widget build(BuildContext context) {
    const String viewType = 'com.compdfkit.flutter.ui.pdfviewer';
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'document': widget.document,
      'password': widget.password,
      'configuration': widget.configuration.toJson()
    };

    if (Platform.isAndroid) {
      return PlatformViewLink(
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers: const <Factory<
                    OneSequenceGestureRecognizer>>{});
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: viewType,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                layoutDirection: TextDirection.ltr)
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..create();
          },
          viewType: viewType);
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    } else {
      return const Center(child: Text('only support android and ios'));
    }
  }

  Future<void> _onPlatformViewCreated(int id) async {
    debugPrint('ComPDFKit-Flutter: CPDFReaderWidget created');
    widget.onCreated(CPDFReaderWidgetController(id, onPageChanged: widget.onPageChanged, saveCallback : widget.onSaveCallback));
  }
}
