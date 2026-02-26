// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_pushbutton_widget.dart';
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

import '../shared/example_document_loader.dart';

/// Intercept Widget Action Example
///
/// Demonstrates how to intercept form widget (ListBox/ComboBox) actions in Flutter.
///
/// This example shows:
/// - Configuring [CPDFFormsConfig.interceptListBoxAction] to intercept list box selections
/// - Configuring [CPDFFormsConfig.interceptComboBoxAction] to intercept combo box selections
/// - Handling intercepted events via [CPDFReaderWidget.onInterceptWidgetActionCallback]
///
/// Key classes/APIs used:
/// - [CPDFFormsConfig]: Configuration for form widget interception
/// - [CPDFOnInterceptWidgetActionCallback]: Callback for widget actions
/// - [CPDFListBoxWidget]: List box widget with options and selected index
/// - [CPDFComboBoxWidget]: Combo box widget with options and selected index
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

  CPDFConfiguration get _configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.viewer,
        ),
        formsConfig: const CPDFFormsConfig(
          // Enable interception of list box selection actions
          interceptListBoxAction: true,
          // Enable interception of combo box selection actions
          interceptComboBoxAction: true,
          interceptPushButtonAction: true,
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
          },
          // ==================== Widget Action Interception ====================
          // This callback handles intercepted form widget actions (ListBox/ComboBox)
          // When interceptListBoxAction or interceptComboBoxAction is true in config,
          // selecting items in these widgets will trigger this callback instead of
          // the default native behavior.
          onInterceptWidgetActionCallback: _handleWidgetAction,
        ),
      ),
    );
  }

  /// Handle intercepted form widget actions.
  ///
  /// This method is called when:
  /// - A list box item is selected (when interceptListBoxAction is true)
  /// - A combo box item is selected (when interceptComboBoxAction is true)
  void _handleWidgetAction(CPDFWidget widget) async {
    final type = widget.type;

    switch (type) {
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
}
