/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

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
  final List<Widget> Function(CPDFReaderWidgetController controller)? appBarActions;

  const CPDFReaderPage({
    super.key,
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
    this.onTapMainDocAreaCallback
  });

  @override
  State<CPDFReaderPage> createState() => _CPDFReaderPageState();
}

class _CPDFReaderPageState extends State<CPDFReaderPage> {
  CPDFReaderWidgetController? _controller;
  bool _showPDFReader = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350), () {
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
        title: Text(widget.title, style: Theme.of(context).textTheme.titleSmall,),
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
        child: _showPDFReader
            ? _buildPDFReader()
            : _buildPlaceholder(),
      )
    );
  }

  Widget _buildPDFReader(){
    return CPDFReaderWidget(
        document: widget.documentPath,
        password: widget.password,
        configuration: widget.configuration,
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
        onPageEditDialogBackPress: () {
          debugPrint('CPDFReaderWidget: onPageEditDialogBackPress');
        },
        onTapMainDocAreaCallback: (){
          widget.onTapMainDocAreaCallback?.call();
        }
    );
  }

  Widget _buildPlaceholder(){
    return const Center();
  }
}