/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';

class CPDFReaderPage extends StatefulWidget {
  final String title;
  final String documentPath;
  final CPDFConfiguration configuration;
  final String password;
  final void Function(CPDFReaderWidgetController controller)? onCreated;
  final void Function(int pageIndex)? onPageChanged;
  final void Function()? onSaveCallback;
  final void Function(bool isFillScreen)? onFillScreenChanged;
  final void Function()? onIOSClickBackPressed;
  final void Function()? onTapMainDocAreaCallback;
  final void Function(String identifier)? onCustomToolbarItemTappedCallback;
  final void Function(CPDFAnnotationType type, CPDFAnnotation? annotation)?
      onAnnotationCreationPreparedCallback;

  final CPDFOnCustomContextMenuItemTappedCallback? onCustomContextMenuItemTappedCallback;

  final List<Widget> Function(CPDFReaderWidgetController controller)?
      appBarActions;
  final bool safeBottom;

  const CPDFReaderPage(
      {super.key,
      this.safeBottom = true,
      required this.title,
      required this.documentPath,
      required this.configuration,
      this.password = '',
      this.onCreated,
      this.appBarActions,
      this.onPageChanged,
      this.onSaveCallback,
      this.onFillScreenChanged,
      this.onIOSClickBackPressed,
      this.onTapMainDocAreaCallback,
      this.onCustomToolbarItemTappedCallback,
      this.onAnnotationCreationPreparedCallback,
      this.onCustomContextMenuItemTappedCallback});

  @override
  State<CPDFReaderPage> createState() => _CPDFReaderPageState();
}

class _CPDFReaderPageState extends State<CPDFReaderPage> {
  CPDFReaderWidgetController? _controller;
  bool _showPDFReader = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      if (mounted) {
        setState(() {
          _showPDFReader = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (_controller != null) {
                bool saveResult = await _controller!.document.save();
                debugPrint('ComPDFKit: saveResult: $saveResult');
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          actions: _controller == null
              ? null
              : widget.appBarActions?.call(_controller!) ?? [],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showPDFReader ? _buildPDFReader() : _buildPlaceholder(),
        ));
  }

  Widget _buildPDFReader() {
    return SafeArea(
        bottom: widget.safeBottom,
        child: CPDFReaderWidget(
            document: widget.documentPath,
            password: widget.password,
            configuration: widget.configuration,
            pageIndex: 0,
            onCreated: (controller) {
              setState(() {
                _controller = controller;
              });
              widget.onCreated?.call(controller);
            },
            onPageChanged: widget.onPageChanged,
            onSaveCallback: widget.onSaveCallback,
            onFillScreenChanged: widget.onFillScreenChanged,
            onIOSClickBackPressed: widget.onIOSClickBackPressed,
            onCustomToolbarItemTappedCallback:
                widget.onCustomToolbarItemTappedCallback,
            onAnnotationCreationPreparedCallback:
                widget.onAnnotationCreationPreparedCallback,
            onPageEditDialogBackPress: () {
              debugPrint('CPDFReaderWidget: onPageEditDialogBackPress');
            },
            onTapMainDocAreaCallback: () {
              widget.onTapMainDocAreaCallback?.call();
            },
            onCustomContextMenuItemTappedCallback: widget.onCustomContextMenuItemTappedCallback,
        ));
  }

  Widget _buildPlaceholder() {
    return const Center();
  }
}
