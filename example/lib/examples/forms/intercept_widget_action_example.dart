// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:async';
import 'dart:convert';

import 'package:compdfkit_flutter/annotation/form/cpdf_checkbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_radiobutton_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_text_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/action/cpdf_named_action.dart';
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
/// 2. Tap a form field on the test page
/// 3. Use the Flutter dialog to complete the intercepted action
class InterceptWidgetActionExample extends StatelessWidget {
  const InterceptWidgetActionExample({super.key});

  static const String _assetPath = AppAssets.formInterceptionTestPdf;

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
            controller.setDisplayPageIndex(pageIndex: 1);
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
  void _handleWidgetAction(CPDFWidget widget) {
    unawaited(_handleWidgetActionAsync(widget));
  }

  Future<void> _handleWidgetActionAsync(CPDFWidget widget) async {
    final type = widget.type;
    debugPrint(
      'Intercepted widget action: type=${widget.type.name}, '
      'title=${widget.title}, uuid=${widget.uuid}',
    );
    try {
      switch (type) {
        case CPDFFormType.textField:
          final textWidget = widget as CPDFTextWidget;
          await _editTextField(textWidget);
          break;

        case CPDFFormType.checkBox:
          final checkBox = widget as CPDFCheckBoxWidget;
          await _toggleCheckBox(checkBox);
          break;

        case CPDFFormType.radioButton:
          final radioButton = widget as CPDFRadioButtonWidget;
          await _toggleRadioButton(radioButton);
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
              if (!mounted || _controller == null) {
                return;
              }
              listBox.selectItemAtIndex = index;
              await _controller!.document.updateWidget(listBox);
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
              if (!mounted || _controller == null) {
                return;
              }
              comboBox.selectItemAtIndex = index;
              await _controller!.document.updateWidget(comboBox);
            },
          );
          break;
        case CPDFFormType.pushButton:
          if (!mounted) {
            return;
          }
          printJsonString(jsonEncode(widget.toJson()));
          final pushButtonWidget = widget as CPDFPushButtonWidget;
          await LinkActionDialog.showFromAction(
            context: context,
            action: pushButtonWidget.action,
            onGoToPage: (pageIndex) {
              if (mounted) {
                _controller?.setDisplayPageIndex(pageIndex: pageIndex);
              }
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
    } catch (error, stackTrace) {
      debugPrint('Failed to handle intercepted widget action: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _editTextField(CPDFTextWidget textWidget) async {
    if (!mounted) {
      return;
    }
    final value = await showDialog<String>(
      context: context,
      builder: (context) => _TextFieldEditDialog(
        title: textWidget.title,
        initialText: textWidget.text,
        multiline: textWidget.isMultiline,
      ),
    );
    if (!mounted || value == null || _controller == null) {
      return;
    }
    textWidget.text = value;
    await _controller!.document.updateWidget(textWidget);
  }

  Future<void> _toggleCheckBox(CPDFCheckBoxWidget checkBox) async {
    final shouldToggle = await _showToggleDialog(
      title: 'Checkbox intercepted',
      message: checkBox.isChecked
          ? 'The checkbox is currently selected.'
          : 'The checkbox is currently not selected.',
    );
    if (!mounted || shouldToggle != true || _controller == null) {
      return;
    }
    checkBox.isChecked = !checkBox.isChecked;
    await _controller!.document.updateWidget(checkBox);
  }

  Future<void> _toggleRadioButton(CPDFRadioButtonWidget radioButton) async {
    final shouldToggle = await _showToggleDialog(
      title: 'Radio button intercepted',
      message: radioButton.isChecked
          ? 'This radio button is currently selected.'
          : 'This radio button is currently not selected.',
    );
    if (!mounted || shouldToggle != true || _controller == null) {
      return;
    }
    radioButton.isChecked = !radioButton.isChecked;
    await _controller!.document.updateWidget(radioButton);
  }

  Future<bool?> _showToggleDialog({
    required String title,
    required String message,
  }) {
    if (!mounted) {
      return Future<bool?>.value();
    }
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('$message\n\nToggle this field?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Toggle'),
          ),
        ],
      ),
    );
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
    if (!mounted) {
      return;
    }
    final result = await showOptionSelectorModal(
      context,
      options: options.cast(),
      selectedIndex: selectedIndex,
      title: title,
    );

    if (mounted && result != null && result != selectedIndex) {
      await onSelected(result);
    }
  }

  Future<void> _showSignaturePicker(CPDFSignatureWidget signatureWidget) async {
    if (!mounted) {
      return;
    }
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
}

class _TextFieldEditDialog extends StatefulWidget {
  final String title;
  final String initialText;
  final bool multiline;

  const _TextFieldEditDialog({
    required this.title,
    required this.initialText,
    required this.multiline,
  });

  @override
  State<_TextFieldEditDialog> createState() => _TextFieldEditDialogState();
}

class _TextFieldEditDialogState extends State<_TextFieldEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit text field'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: widget.multiline ? 4 : 1,
        decoration: InputDecoration(
          labelText: widget.title,
          hintText: 'Enter a value',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
