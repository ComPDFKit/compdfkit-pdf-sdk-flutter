// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_config.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_item.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_options.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_form_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/page/cpdf_sign_list_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_stamp_list_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_widget_options_list_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class CPDFCustomAnnotationCreationExample extends CPDFExampleBase {
  const CPDFCustomAnnotationCreationExample(
      {super.key, required super.documentPath});

  @override
  State<CPDFCustomAnnotationCreationExample> createState() =>
      _CPDFCustomAnnotationCreationExampleState();
}

class _CPDFCustomAnnotationCreationExampleState
    extends CPDFExampleBaseState<CPDFCustomAnnotationCreationExample> {

  @override
  String get pageTitle => 'Custom Annotation Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
      modeConfig: const CPDFModeConfig(
        initialViewMode: CPDFViewMode.annotations,
      ),
      toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: true),
      annotationsConfig: const CPDFAnnotationsConfig(
          autoShowSignPicker: false,
          autoShowLinkDialog: false,
          autoShowPicPicker: false,
          autoShowStampPicker: false,
          availableTypes: [
            CPDFAnnotationType.signature,
            CPDFAnnotationType.stamp,
            CPDFAnnotationType.pictures,
            CPDFAnnotationType.link,
          ]),
      formsConfig: const CPDFFormsConfig(
          showCreateComboBoxOptionsDialog: false,
          showCreateListBoxOptionsDialog: false,
          showCreatePushButtonOptionsDialog: false,
          availableTypes: [
            CPDFFormType.listBox,
            CPDFFormType.comboBox,
            CPDFFormType.pushButton
          ]),
      contextMenuConfig: const CPDFContextMenuConfig(
          formMode: CPDFFormModeContextMenu(listBox: [
        CPDFContextMenuItem(CPDFFormListBoxMenuKey.custom,
            title: 'Options', identifier: 'custom_show_list_box_options'),
        CPDFContextMenuItem(CPDFFormListBoxMenuKey.properties),
        CPDFContextMenuItem(CPDFFormListBoxMenuKey.delete),
      ])));


  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);

    controller.addEventListener(CPDFEvent.formFieldsCreated, (event) async {
      await controller.dismissContextMenu();
      printJsonString(jsonEncode(event));
      if (event is CPDFListBoxWidget) {
        setListBoxOptions(event);
      } else if (event is CPDFComboBoxWidget) {
        setComboBoxOptions(event);
      } else if (event is CPDFPushButtonWidget) {
        setPushButtonAction(event);
      }
    });

    controller.addEventListener(CPDFEvent.annotationsSelected, (event) {
      printJsonString(jsonEncode(event));
    });

    controller.addEventListener(CPDFEvent.formFieldsSelected, (event) {
      printJsonString(jsonEncode(event));
    });
  }

  @override
  void onAnnotationCreationPrepared(
      CPDFAnnotationType type, CPDFAnnotation? annotation) {
    super.onAnnotationCreationPrepared(type, annotation);
    switch (type) {
      case CPDFAnnotationType.signature:
        showSignListPage();
        break;
      case CPDFAnnotationType.pictures:
        showPicturePicker();
        break;
      case CPDFAnnotationType.stamp:
        setNextStamp();
        break;
      case CPDFAnnotationType.link:
        _showLinkDialog(annotation);
        break;
      default:
        break;
    }
  }

  void showSignListPage() async {
    String? signPath = await showDialog<String?>(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Signature List'),
            content: CpdfSignListPage(),
          );
        });
    if (signPath != null) {
      debugPrint('ComPDFKit-Flutter: selected signPath:$signPath');
      await controller?.prepareNextSignature(signPath);
    }
  }

  void showPicturePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.first.path;
      if (filePath != null) {
        debugPrint('ComPDFKit-Flutter: selected picture path:$filePath');
        await controller?.prepareNextImage(filePath);
      }
    }
  }

  void setNextStamp() async {
    // Example: set a text stamp as the next stamp annotation
    // File file = await CPDFFileUtil.extractAsset('images/sign/signature_1.png');
    // await controller?.prepareNextStamp(imagePath: file.path);

    // Example: show stamp list page to select a stamp
    Map<String, dynamic>? data =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const CPDFStampListPage();
    }));
    if (data == null) {
      return;
    }
    CPDFStampType type = data['type'];
    if (type == CPDFStampType.standard) {
      CPDFStandardStamp stamp = data['standardStamp'];
      await controller?.prepareNextStamp(standardStamp: stamp);
    } else if (type == CPDFStampType.image) {
      String imagePath = data['imagePath'];
      await controller?.prepareNextStamp(imagePath: imagePath);
    }

    // Example: set a custom text stamp as the next stamp annotation
    // await controller?.prepareNextStamp(
    //     textStamp: CPDFTextStamp(
    //         content: 'ComPDFKit-Flutter',
    //         date:
    //             CPDFDate.getTextStampDate(timeSwitch: false, dateSwitch: true),
    //         shape: CPDFTextStampShape.none,
    //         color: CPDFTextStampColor.white));
  }

  void _showLinkDialog(CPDFAnnotation? annotation) async {
    debugPrint('ComPDFKit-Flutter: show link annotation dialog');
    if (annotation is CPDFLinkAnnotation) {
      // Example: set a URL link
      annotation.action = CPDFUriAction(uri: "https://www.compdf.com");

      // Example: set a URI link to mailto
      // annotation.action = CPDFUriAction(uri: "mailto:support@compdf.com");

      // Example: set a GoTo link to page 0
      // annotation.action = CPDFGoToAction(pageIndex: 2);
      printJsonString(jsonEncode(annotation.toJson()));
      await controller?.document.updateAnnotation(annotation);
    }
  }

  void setListBoxOptions(CPDFListBoxWidget listBox) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CPDFWidgetOptionsListPage(
        document: controller!.document,
        cpdfWidget: listBox,
      );
    }));
  }

  void setComboBoxOptions(CPDFComboBoxWidget comboBox) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CPDFWidgetOptionsListPage(
          document: controller!.document, cpdfWidget: comboBox);
    }));
  }

  void setPushButtonAction(CPDFPushButtonWidget pushButton) async {
    pushButton.buttonTitle = 'To Http';
    pushButton.action = CPDFUriAction(uri: 'https://www.google.com');
    await controller?.document.updateWidget(pushButton);
  }
}
