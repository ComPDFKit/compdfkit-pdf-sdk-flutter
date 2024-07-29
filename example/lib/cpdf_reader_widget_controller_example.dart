// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:math';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

class CPDFReaderWidgetControllerExample extends StatefulWidget {
  final String documentPath;

  const CPDFReaderWidgetControllerExample({super.key, required this.documentPath});

  @override
  State<CPDFReaderWidgetControllerExample> createState() =>
      _CPDFReaderWidgetControllerExampleState();
}

class _CPDFReaderWidgetControllerExampleState
    extends State<CPDFReaderWidgetControllerExample> {

  CPDFReaderWidgetController? _controller;

  bool canScale = true;

  bool pageSameWidth = true;

  bool isFixedScroll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('CPDFReaderWidget Example'),
          leading: IconButton(
              onPressed: () {
                _save();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: null == _controller
              ? []
              : [
                  PopupMenuButton(onSelected: (value) {
                    handleClick(value, _controller!);
                  }, itemBuilder: (context) {
                    return actions
                        .map((e) => PopupMenuItem(value: e, child: Text(e)))
                        .toList();
                  })
                ],
        ),
        body: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: CPDFConfiguration(toolbarConfig: const CPDFToolbarConfig(
            iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail]
          )),
          onCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
        ));
  }

  void _save() async {
    bool saveResult = await _controller!.save();
    debugPrint('ComPDFKit-Flutter: saveResult:$saveResult');
  }

  void handleClick(String value, CPDFReaderWidgetController controller) async {
    switch (value) {
      case 'setScale':
        controller.setScale(1.5);
        break;
      case 'getScale':
        double scaleValue = await controller.getScale();
        debugPrint('ComPDFKit:CPDFReaderWidget-getScale():$scaleValue');
        break;
      case 'setCanScale':
        canScale = !canScale;
        await controller.setCanScale(canScale);
        break;
      case 'setFormHighlight':
        bool isFormFieldHighlight = await controller.isFormFieldHighlight();
        debugPrint('ComPDFKit:isFormFieldHighlight:$isFormFieldHighlight');
        controller.setFormFieldHighlight(!isFormFieldHighlight);
        break;
      case 'setLinkHighlight':
        bool isLinkHighlight = await controller.isLinkHighlight();
        debugPrint('ComPDFKit:isLinkHighlight:$isLinkHighlight');
        controller.setLinkHighlight(!isLinkHighlight);
        break;
      case 'setVerticalMode':
        bool isVerticalMode = await controller.isVerticalMode();
        debugPrint('ComPDFKit:isVerticalMode:$isVerticalMode');
        controller.setVerticalMode(!isVerticalMode);
        break;
      case 'setMargin':
        final Random random = Random();
        int value = random.nextInt(50);
        debugPrint('ComPDFKit:setMargin:$value');
        controller.setMargins(const CPDFEdgeInsets.symmetric(horizontal: 100, vertical: 10));
        break;
      case 'setContinueMode':
        bool isContinueMode = await controller.isContinueMode();
        debugPrint('ComPDFKit:isContinueMode:$isContinueMode');
        controller.setContinueMode(!isContinueMode);
        break;
      case 'setDoublePageMode':
        bool isDoublePageMode = await controller.isDoublePageMode();
        debugPrint('ComPDFKit:isDoublePageMode:$isDoublePageMode');
        controller.setDoublePageMode(!isDoublePageMode);
        break;
      case 'setCropMode':
        bool isCropMode = await controller.isCropMode();
        debugPrint('ComPDFKit:isCropMode:$isCropMode');
        controller.setCropMode(!isCropMode);
        break;
      case 'setDisplayPageIndex':
        int nextPageIndex = await controller.getCurrentPageIndex() + 1;
        controller.setDisplayPageIndex(nextPageIndex, animated: false);
        break;
      case 'getCurrentPageIndex':
        debugPrint('ComPDFKit:getCurrentPageIndex:${await controller.getCurrentPageIndex()}');
        break;
      case 'setCoverPageMode':
        bool isCoverPageMode = await controller.isCoverPageMode();
        debugPrint('ComPDFKit:isCoverPageMode:$isCoverPageMode');
        controller.setCoverPageMode(!isCoverPageMode);
        break;
      case 'pageSameWidth':
        pageSameWidth = !pageSameWidth;
        await controller.setPageSameWidth(pageSameWidth);
        break;
      case 'isPageInScreen':
        bool isPageInScreen = await controller.isPageInScreen(0);
        debugPrint('ComPDFKit:first page is in screen:$isPageInScreen');
        break;
      case 'setFixedScroll':
        isFixedScroll = !isFixedScroll;
        await controller.setFixedScroll(isFixedScroll);
        break;
      case 'isChanged':
        bool hasChange = await controller.hasChange();
        debugPrint('ComPDFKit:hasChange:$hasChange');
        break;
    }
  }
}

var actions = [
  'setScale',
  'getScale',
  if(Platform.isAndroid) ...[
    'setCanScale',
    'pageSameWidth',
    'isPageInScreen',
    'setFixedScroll'
  ],
  'setFormHighlight',
  'setLinkHighlight',
  'setVerticalMode',
  'setMargin',
  'setContinueMode',
  'setDoublePageMode',
  'setCropMode',
  'setDisplayPageIndex',
  'getCurrentPageIndex',
  'setCoverPageMode',
  'isChanged'
];

Color randomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha value (fully opaque)
    random.nextInt(256), // Red value
    random.nextInt(256), // Green value
    random.nextInt(256), // Blue value
  );
}
