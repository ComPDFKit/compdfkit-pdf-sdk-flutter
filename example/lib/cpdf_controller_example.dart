// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:math';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/cpdf_reader_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_reader_widget_display_setting_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_reader_widget_switch_preview_mode_page.dart';
import 'package:flutter/material.dart';

class CPDFControllerExample extends StatefulWidget {
  final String documentPath;

  const CPDFControllerExample({super.key, required this.documentPath});

  @override
  State<CPDFControllerExample> createState() => _CPDFControllerExampleState();
}

class _CPDFControllerExampleState extends State<CPDFControllerExample> {

  bool pageSameWidth = true;

  bool isFixedScroll = false;

  static const actions = [
    'save',
    'saveAs',
    'openDocument',
    'setScale',
    'setPageSpacing',
    'setMargin',
    'setDisplayPageIndex',
    'isChanged',
    'documentInfo',
    'removeSignFileList',
    'print',
    'setWidgetBackgroundColor',
  ];

  static const actions1 = [
    'PreviewMode',
    'DisplaySettingPage',
    'DisplaySetting',
    'Watermark',
    'Security',
    'Thumbnail',
    'BOTA',
    'SnipMode',
    'ExitSnipMode'
  ];

  @override
  Widget build(BuildContext context) {
    return CPDFReaderPage(
      title: 'Widget Controller Example',
      documentPath: widget.documentPath,
      configuration: CPDFConfiguration(),
      onPageChanged: (pageIndex){
        debugPrint('pageIndex:$pageIndex');
      },
      onSaveCallback: (){
        debugPrint('CPDFDocument: save success');
      },
      onFillScreenChanged: (isFillScreen){
        debugPrint('isFillScreen:$isFillScreen');
      },
      onIOSClickBackPressed: (){
        Navigator.pop(context);
      },
      appBarActions: (controller) => [
        PopupMenuButton<String>(
          icon: const Icon(Icons.settings),
          onSelected: (value) => _handleAction(context, value, controller),
          itemBuilder: (context) => actions1.map((action) {
            return PopupMenuItem(value: action, child: Text(action));
          }).toList(),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleAction(context, value, controller),
          itemBuilder: (context) => actions.map((action) {
            return PopupMenuItem(value: action, child: Text(action));
          }).toList(),
        )
      ],
    );
  }

  void _handleAction(BuildContext context, String value,
      CPDFReaderWidgetController controller) async {
    switch (value) {
      case 'save':
        bool saveResult = await controller.document.save();
        debugPrint('ComPDFKit: save():$saveResult');
        break;
      case 'saveAs':
        final tempDir = await ComPDFKit.getTemporaryDirectory();
        String savePath =
            '${tempDir.path}/${await controller.document.getFileName()}';
        // only android platform
        //   String? savePath = await ComPDFKit.createUri('aaa.pdf', childDirectoryName: 'compdfkit');
        bool saveResult = await controller.document.saveAs(savePath);
        debugPrint('ComPDFKit:saveAs:Result:$saveResult');
        debugPrint('ComPDFKit:saveAs:Path:$savePath');
        break;
      case 'setScale':
        controller.setScale(1.5);
        double scaleValue = await controller.getScale();
        debugPrint('ComPDFKit:CPDFReaderWidget-getScale():$scaleValue');
        break;
      case 'setMargin':
        final Random random = Random();
        int value = random.nextInt(50);
        debugPrint('ComPDFKit:setMargin:$value');
        controller.setMargins(const CPDFEdgeInsets.only(
            left: 20, top: 20, right: 20, bottom: 20));
        break;
      case "setPageSpacing":
        await controller.setPageSpacing(20);
        break;
      case 'setDisplayPageIndex':
        int currentPageIndex = await controller.getCurrentPageIndex();
        debugPrint('ComPDFKit:getCurrentPageIndex:$currentPageIndex');
        int nextPageIndex = currentPageIndex + 1;
        controller.setDisplayPageIndex(nextPageIndex, animated: true);
        break;
      case 'setCoverPageMode':
        bool isCoverPageMode = await controller.isCoverPageMode();
        debugPrint('ComPDFKit:isCoverPageMode:$isCoverPageMode');
        controller.setCoverPageMode(!isCoverPageMode);
        break;
      case 'isChanged':
        bool hasChange = await controller.document.hasChange();
        debugPrint('ComPDFKit:hasChange:$hasChange');
        break;
      case "documentInfo":
        var document = controller.document;
        debugPrint(
            'ComPDFKit:Document: fileName:${await document.getFileName()}');
        debugPrint(
          'ComPDFKit:Document: documentPath:${await document.getDocumentPath()}'
        );
        debugPrint(
            'ComPDFKit:Document: checkOwnerUnlocked:${await document.checkOwnerUnlocked()}');
        debugPrint(
            'ComPDFKit:Document: hasChange:${await document.hasChange()}');
        debugPrint(
            'ComPDFKit:Document: isEncrypted:${await document.isEncrypted()}');
        debugPrint(
            'ComPDFKit:Document: isImageDoc:${await document.isImageDoc()}');
        debugPrint(
            'ComPDFKit:Document: getPermissions:${await document.getPermissions()}');
        debugPrint(
            'ComPDFKit:Document: getPageCount:${await document.getPageCount()}');
        break;
      case "openDocument":
        String? path = await ComPDFKit.pickFile();
        if (path != null) {
          var document = controller.document;
          var error = await document.open(path);
          debugPrint('ComPDFKit:Document: open:$error');
        }
        break;
      case "removeSignFileList":
        bool result = await ComPDFKit.removeSignFileList();
        debugPrint('ComPDFKit:removeSignFileList:$result');
        break;
      case "PreviewMode":
        CPDFViewMode mode = await controller.getPreviewMode();
        if (context.mounted) {
          CPDFViewMode? switchMode = await showModalBottomSheet(
              context: context,
              builder: (context) {
                return CpdfReaderWidgetSwitchPreviewModePage(viewMode: mode);
              });
          if (switchMode != null) {
            await controller.setPreviewMode(switchMode);
          }
        }
        break;
      case 'DisplaySetting':
        await controller.showDisplaySettingView();
        break;
      case 'Watermark':
        await controller.showAddWatermarkView(saveAsNewFile: false);
        break;
      case 'Security':
        await controller.showSecurityView();
        break;
      case 'Thumbnail':
        await controller.showThumbnailView(false);
        break;
      case 'BOTA':
        await controller.showBotaView();
        break;
      case 'SnipMode':
        await controller.enterSnipMode();
        break;
      case 'ExitSnipMode':
        await controller.exitSnipMode();
        break;
      case 'print':
        await controller.document.printDocument();
        break;
      case 'DisplaySettingPage':
        await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return CpdfReaderWidgetDisplaySettingPage(controller: controller);
            });
        break;
      case 'setWidgetBackgroundColor':
        Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        await controller.setWidgetBackgroundColor(color);
        debugPrint('ComPDFKit:setWidgetBackgroundColor:$color');
        break;
    }
  }
}
