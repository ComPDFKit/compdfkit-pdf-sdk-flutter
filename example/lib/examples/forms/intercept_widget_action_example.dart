// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_named_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/util/cpdf_widget_util.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/constants/asset_paths.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/utils/preferences_service.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/link_action_dialog.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/option_selector_dialog.dart';
import 'package:flutter/material.dart';

import '../../features/annotations/signature_list_page.dart';
import '../shared/example_document_loader.dart';

/// Intercept Widget Action Example
///
/// Demonstrates how to intercept form widget actions in Flutter.
///
/// This example shows:
/// - Configuring [CPDFFormsConfig.interceptFormWidgetActions] to intercept widget actions
/// - Handling intercepted events via [CPDFReaderWidget.onInterceptWidgetActionCallback]
///
/// Key classes/APIs used:
/// - [CPDFFormsConfig]: Configuration for form widget interception
/// - [CPDFOnInterceptWidgetActionCallback]: Callback for widget actions
/// - [CPDFDocument.updateWidget]: Applies custom handling for standard form widgets
/// - [CPDFDocument.addSignatureImage]: Adds a selected image to a signature widget
///
/// Usage:
/// 1. Open the example
/// 2. Navigate to pages with ListBox or ComboBox form fields
/// 3. Select items in list box or combo box to see the intercepted events
class InterceptWidgetActionExample extends StatelessWidget {
  const InterceptWidgetActionExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Intercept Action',
      assetPath: _assetPath,
      builder: (path) => _InterceptWidgetActionPage(documentPath: path),
    );
  }
}

class _InterceptWidgetActionPage extends StatefulWidget {
  final String documentPath;

  const _InterceptWidgetActionPage({required this.documentPath});

  @override
  State<_InterceptWidgetActionPage> createState() =>
      _InterceptWidgetActionPageState();
}

class _InterceptWidgetActionPageState
    extends State<_InterceptWidgetActionPage> {
  CPDFReaderWidgetController? _controller;
  bool _didAddDemoWidgets = false;

  CPDFConfiguration get _configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.viewer,
        ),
        formsConfig: const CPDFFormsConfig(
          // Enable interception of selected form widget actions.
          interceptFormWidgetActions: [
            CPDFFormType.textField,
            CPDFFormType.checkBox,
            CPDFFormType.radioButton,
            CPDFFormType.listBox,
            CPDFFormType.comboBox,
            CPDFFormType.signaturesFields,
            CPDFFormType.pushButton
          ],
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Intercept Action',
            onBack: () async {
              if (_controller != null) {
                await _controller!.document.save();
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        child: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: _configuration,
          onCreated: (controller) {
            setState(() {
              _controller = controller;
            });
            _addDemoWidgets(controller);
          },
          // ==================== Widget Action Interception ====================
          // This callback handles intercepted form widget actions configured in
          // interceptFormWidgetActions.
          onInterceptWidgetActionCallback: _handleWidgetAction,
        ),
      ),
    );
  }

  /// Handle intercepted form widget actions.
  ///
  /// This method is called when:
  /// - A configured form widget action is intercepted
  void _handleWidgetAction(CPDFWidget widget) async {
    final type = widget.type;
    debugPrint(
      'Intercepted widget action: type=${widget.type.name}, '
      'title=${widget.title}, uuid=${widget.uuid}',
    );
    switch (type) {
      case CPDFFormType.textField:
        final textWidget = widget as CPDFTextWidget;
        textWidget.text = 'Handled by Flutter';
        await _controller?.document.updateWidget(textWidget);
        break;

      case CPDFFormType.checkBox:
        final checkBox = widget as CPDFCheckBoxWidget;
        checkBox.isChecked = !checkBox.isChecked;
        await _controller?.document.updateWidget(checkBox);
        break;

      case CPDFFormType.radioButton:
        final radioButton = widget as CPDFRadioButtonWidget;
        radioButton.isChecked = !radioButton.isChecked;
        await _controller?.document.updateWidget(radioButton);
        break;

      case CPDFFormType.listBox:
        final listBox = widget as CPDFListBoxWidget;
        final selectItemIndex = listBox.selectItemAtIndex;
        debugPrint('Intercepted ListBox action. '
            'Current selected index: $selectItemIndex');
        await _showOptionSelector(
          title: 'Select Option',
          options: listBox.options ?? [],
          selectedIndex: selectItemIndex,
          onSelected: (index) async {
            listBox.selectItemAtIndex = index;
            await _controller?.document.updateWidget(listBox);
          },
        );
        break;

      case CPDFFormType.comboBox:
        final comboBox = widget as CPDFComboBoxWidget;
        final selectItemIndex = comboBox.selectItemAtIndex;
        debugPrint('Intercepted ComboBox action. '
            'Current selected index: $selectItemIndex');
        await _showOptionSelector(
          title: 'Select Option',
          options: comboBox.options ?? [],
          selectedIndex: selectItemIndex,
          onSelected: (index) async {
            comboBox.selectItemAtIndex = index;
            await _controller?.document.updateWidget(comboBox);
          },
        );
        break;
      case CPDFFormType.pushButton:
        printJsonString(jsonEncode(widget.toJson()));
        final pushButtonWidget = widget as CPDFPushButtonWidget;
        LinkActionDialog.showFromAction(
          context: context,
          action: pushButtonWidget.action,
          onGoToPage: (pageIndex) {
            _controller?.setDisplayPageIndex(pageIndex: pageIndex);
          },
          onNamedAction: (type) => _handleNamedAction(type),
        );
        break;

      case CPDFFormType.signaturesFields:
        final signatureWidget = widget as CPDFSignatureWidget;
        await _showSignaturePicker(signatureWidget);
        break;

      default:
        break;
    }
  }

  /// Handle named actions (first/last/next/prev page).
  Future<void> _handleNamedAction(CPDFNamedActionType type) async {
    final pageCount = await _controller?.document.getPageCount() ?? 0;
    final currentPage = await _controller?.getCurrentPageIndex() ?? 0;

    switch (type) {
      case CPDFNamedActionType.firstPage:
        _controller?.setDisplayPageIndex(pageIndex: 0);
        break;
      case CPDFNamedActionType.lastPage:
        if (pageCount > 0) {
          _controller?.setDisplayPageIndex(pageIndex: pageCount - 1);
        }
        break;
      case CPDFNamedActionType.nextPage:
        if (currentPage < pageCount - 1) {
          _controller?.setDisplayPageIndex(pageIndex: currentPage + 1);
        }
        break;
      case CPDFNamedActionType.prevPage:
        if (currentPage > 0) {
          _controller?.setDisplayPageIndex(pageIndex: currentPage - 1);
        }
        break;
      case CPDFNamedActionType.print:
        break;
      case CPDFNamedActionType.none:
        break;
    }
  }

  /// Show option selector dialog and handle selection.
  Future<void> _showOptionSelector({
    required String title,
    required List options,
    required int selectedIndex,
    required Future<void> Function(int index) onSelected,
  }) async {
    final result = await showOptionSelectorModal(
      context,
      options: options.cast(),
      selectedIndex: selectedIndex,
      title: title,
    );

    if (result != null && result != selectedIndex) {
      await onSelected(result);
    }
  }

  Future<void> _showSignaturePicker(CPDFSignatureWidget signatureWidget) async {
    final signPath = await showDialog<String?>(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Signature List'),
        content: SignatureListPage(),
      ),
    );
    if (signPath == null) {
      return;
    }
    final success = await _controller?.document.addSignatureImage(
      signatureWidget,
      signPath,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success == true
            ? 'Signature image added'
            : 'Failed to add signature image'),
      ),
    );
  }

  Future<void> _addDemoWidgets(CPDFReaderWidgetController controller) async {
    if (_didAddDemoWidgets) {
      return;
    }
    _didAddDemoWidgets = true;
    final widgets = [
      CPDFTextWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.textField),
        page: 0,
        rect: const CPDFRectF(left: 40, top: 799, right: 320, bottom: 701),
        createDate: DateTime.fromMillisecondsSinceEpoch(1735696800000),
        text: 'This is Text Fields',
        isMultiline: true,
        fillColor: const Color(0xFFBEBEBE),
        borderColor: const Color(0xFF8BC34A),
        borderWidth: 5,
        fontColor: Colors.black,
        fontSize: 14,
        familyName: 'Times',
        styleName: 'Bold',
        alignment: CPDFAlignment.right,
      ),
      CPDFCheckBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.checkBox),
        page: 0,
        rect: const CPDFRectF(left: 361, top: 778, right: 442, bottom: 704),
        isChecked: true,
        checkStyle: CPDFCheckStyle.circle,
        checkColor: const Color(0xFF3CE930),
        fillColor: const Color(0xFFE0E0E0),
        borderColor: Colors.black,
        borderWidth: 5,
      ),
      CPDFRadioButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.radioButton),
        page: 0,
        rect: const CPDFRectF(left: 479, top: 789, right: 549, bottom: 715),
        isChecked: true,
        checkStyle: CPDFCheckStyle.cross,
        checkColor: Colors.red,
        fillColor: Colors.green,
        borderColor: Colors.black,
        borderWidth: 5,
      ),
      CPDFListBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.listBox),
        page: 0,
        rect: const CPDFRectF(left: 53, top: 294, right: 294, bottom: 191),
        selectItemAtIndex: 0,
        options: [
          CPDFWidgetItem(text: 'options-1', value: 'options-1'),
          CPDFWidgetItem(text: 'options-2', value: 'options-2'),
        ],
        familyName: 'Times',
        styleName: 'Bold',
        fillColor: Colors.yellow,
        borderColor: Colors.red,
        borderWidth: 3,
      ),
      CPDFComboBoxWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.comboBox),
        page: 0,
        rect: const CPDFRectF(left: 354, top: 288, right: 557, bottom: 170),
        selectItemAtIndex: 1,
        options: [
          CPDFWidgetItem(text: 'options-1', value: 'options-1'),
          CPDFWidgetItem(text: 'options-2', value: 'options-2'),
        ],
        familyName: 'Times',
        styleName: 'Bold',
        fillColor: Colors.yellow,
        borderColor: Colors.red,
        borderWidth: 3,
      ),
      CPDFSignatureWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.signaturesFields),
        page: 0,
        rect: const CPDFRectF(left: 64, top: 649, right: 319, bottom: 527),
        fillColor: const Color(0xFFE0E0E0),
        borderColor: Colors.red,
        borderWidth: 5,
      ),
      CPDFPushButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.pushButton),
        page: 0,
        rect: const CPDFRectF(left: 366, top: 632, right: 520, bottom: 541),
        fillColor: const Color(0xFFE0E0E0),
        borderColor: Colors.red,
        borderWidth: 5,
        fontSize: 14,
        buttonTitle: 'Jump Page 2',
        action: CPDFGoToAction(pageIndex: 1),
      ),
      CPDFPushButtonWidget(
        title: CPDFWidgetUtil.createFieldName(CPDFFormType.pushButton),
        page: 0,
        rect: const CPDFRectF(left: 365, top: 503, right: 501, bottom: 413),
        fillColor: const Color(0xFFE0E0E0),
        borderColor: Colors.red,
        borderWidth: 5,
        fontSize: 14,
        buttonTitle: 'Click Me',
        action: CPDFUriAction(uri: 'https://www.compdf.com'),
      ),
    ];
    await controller.document.addWidgets(widgets);
  }
}
