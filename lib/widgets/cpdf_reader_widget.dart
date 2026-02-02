// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
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

import 'cpdf_reader_widget_callbacks.dart';

export 'cpdf_reader_widget_callbacks.dart';

/// PDF reader widget for viewing and interacting with documents.
///
/// This widget embeds a native PDF viewer using Flutter platform views.
///
/// - Android: [PlatformViewLink] with [AndroidViewSurface]
/// - iOS: [UiKitView]
///
/// Note: This widget only supports Android and iOS.
///
/// {@category viewer-ui}
class CPDFReaderWidget extends StatefulWidget {
  /// Local PDF file path.
  final String document;

  /// Optional document password.
  final String? password;

  /// Whether to use hybrid composition on Android.
  final bool useHybridComposition;

  /// Initial page index.
  final int pageIndex;

  /// Initial ComPDFKit SDK configuration.
  final CPDFConfiguration configuration;

  final CPDFReaderWidgetCreatedCallback onCreated;

  final CPDFPageChangedCallback? onPageChanged;

  final CPDFDocumentSaveCallback? onSaveCallback;

  final CPDFPageEditDialogBackPressCallback? onPageEditDialogBackPress;

  final CPDFFillScreenChangedCallback? onFillScreenChanged;

  final CPDFIOSClickBackPressedCallback? onIOSClickBackPressed;

  final CPDFOnTapMainDocAreaCallback? onTapMainDocAreaCallback;

  final CPDFOnCustomToolbarItemTappedCallback?
      onCustomToolbarItemTappedCallback;

  final CPDFOnAnnotationCreationPreparedCallback?
      onAnnotationCreationPreparedCallback;

  final CPDFOnCustomContextMenuItemTappedCallback?
      onCustomContextMenuItemTappedCallback;

  /// init callback
  const CPDFReaderWidget(
      {Key? key,
      required this.document,
      this.password = '',
      required this.configuration,
      this.pageIndex = 0,
      required this.onCreated,
      this.useHybridComposition = false,
      this.onPageChanged,
      this.onSaveCallback,
      this.onPageEditDialogBackPress,
      this.onFillScreenChanged,
      this.onIOSClickBackPressed,
      this.onTapMainDocAreaCallback,
      this.onCustomToolbarItemTappedCallback,
      this.onAnnotationCreationPreparedCallback,
      this.onCustomContextMenuItemTappedCallback})
      : super(key: key);

  @override
  State<CPDFReaderWidget> createState() => _CPDFReaderWidgetState();
}

class _CPDFReaderWidgetState extends State<CPDFReaderWidget> {
  CPDFReaderWidgetController? _controller;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'com.compdfkit.flutter.ui.pdfviewer';
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'document': widget.document,
      'password': widget.password ?? '',
      'configuration': widget.configuration.toJson(),
      'pageIndex': widget.pageIndex
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
            final creation = widget.useHybridComposition
                ? PlatformViewsService.initExpensiveAndroidView(
                    id: params.id,
                    viewType: viewType,
                    creationParams: creationParams,
                    creationParamsCodec: const StandardMessageCodec(),
                    layoutDirection: TextDirection.ltr,
                  )
                : PlatformViewsService.initSurfaceAndroidView(
                    id: params.id,
                    viewType: viewType,
                    creationParams: creationParams,
                    creationParamsCodec: const StandardMessageCodec(),
                    layoutDirection: TextDirection.ltr,
                  );
            return creation
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
    final controller = CPDFReaderWidgetController(id,
        onPageChanged: widget.onPageChanged,
        saveCallback: widget.onSaveCallback,
        onPageEditBackPress: widget.onPageEditDialogBackPress,
        onFillScreenChanged: widget.onFillScreenChanged,
        onIOSClickBackPressed: widget.onIOSClickBackPressed,
        onTapMainDocArea: widget.onTapMainDocAreaCallback,
        onCustomToolbarItemTapped: widget.onCustomToolbarItemTappedCallback,
        onAnnotationCreationPrepared:
            widget.onAnnotationCreationPreparedCallback,
        onCustomContextMenuItemTapped:
            widget.onCustomContextMenuItemTappedCallback);

    _controller = controller;
    try {
      await controller.ready;
    } catch (e) {
      debugPrint('ComPDFKit-Flutter: CPDFReaderWidget ready error: $e');
      return;
    }

    if (!mounted || _controller != controller) {
      return;
    }
    widget.onCreated(controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
