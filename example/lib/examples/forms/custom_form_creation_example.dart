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
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_config.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_item.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_options.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_form_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/link_config_dialog.dart';
import 'package:compdfkit_flutter_example/features/forms/form_field_options_page.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Custom Form Creation Example
///
/// Demonstrates how to intercept form field creation events and customize the
/// post-creation workflow using callbacks and custom context menus.
///
/// This example shows:
/// - Listening to [CPDFEvent.formFieldsCreated] for newly created form fields
/// - Suppressing default options dialogs via [CPDFFormsConfig]
/// - Showing custom options dialog for ListBox and ComboBox fields
/// - Setting custom actions on PushButton fields after creation
/// - Adding custom context menu items for form field editing
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.addEventListener]: Listens for form events
/// - [CPDFEvent.formFieldsCreated]: Event fired when a form field is created
/// - [CPDFFormsConfig]: Configuration for form creation behavior
/// - [CPDFContextMenuConfig]: Custom context menu configuration
/// - [CPDFContextMenuItem]: Defines custom menu items with identifiers
/// - [CPDFDocument.updateWidget]: Updates widget properties after creation
///
/// Usage:
/// 1. Open the example in form editing mode
/// 2. Create a ListBox, ComboBox, or PushButton field
/// 3. Observe the custom dialog appearing instead of the default one
/// 4. Long-press a field to see custom context menu options
class CustomFormCreationExample extends StatelessWidget {
  /// Constructor
  const CustomFormCreationExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Custom Form Creation',
      assetPath: _assetPath,
      builder: (path) => _CustomFormCreationPage(documentPath: path),
    );
  }
}

class _CustomFormCreationPage extends ExampleBase {
  const _CustomFormCreationPage({required super.documentPath});

  @override
  State<_CustomFormCreationPage> createState() =>
      _CustomFormCreationPageState();
}

class _CustomFormCreationPageState
    extends ExampleBaseState<_CustomFormCreationPage> {
  @override
  String get pageTitle => 'Custom Form Creation';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(initialViewMode: CPDFViewMode.forms),
        toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: true),
        formsConfig: const CPDFFormsConfig(
          showCreateComboBoxOptionsDialog: false,
          showCreateListBoxOptionsDialog: false,
          showCreatePushButtonOptionsDialog: false,
          availableTypes: [
            CPDFFormType.listBox,
            CPDFFormType.comboBox,
            CPDFFormType.pushButton,
          ],
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
        contextMenuConfig: const CPDFContextMenuConfig(
          formMode: CPDFFormModeContextMenu(
            listBox: [
              CPDFContextMenuItem(
                CPDFFormListBoxMenuKey.custom,
                identifier: 'custom_show_options',
                title: 'Options',
              ),
              CPDFContextMenuItem(CPDFFormListBoxMenuKey.properties),
              CPDFContextMenuItem(CPDFFormListBoxMenuKey.delete),
            ],
            comboBox: [
              CPDFContextMenuItem(
                CPDFFormComboBoxMenuKey.custom,
                identifier: 'custom_show_options',
                title: 'Options',
              ),
              CPDFContextMenuItem(CPDFFormComboBoxMenuKey.properties),
              CPDFContextMenuItem(CPDFFormComboBoxMenuKey.delete),
            ],
          ),
        ),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
      );

  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);

    controller.addEventListener(CPDFEvent.formFieldsCreated, (event) async {
      await controller.dismissContextMenu();
      printJsonString(jsonEncode(event));
      if (event is CPDFListBoxWidget || event is CPDFComboBoxWidget) {
        _showWidgetOptions(event);
      } else if (event is CPDFPushButtonWidget) {
        _setPushButtonAction(event);
      }
    });
  }

  @override
  void onCustomContextMenuItemTapped(String identifier, event) {
    super.onCustomContextMenuItemTapped(identifier, event);
    final widget = event['widget'];
    printJsonString(jsonEncode(event));
    switch (identifier) {
      case 'custom_show_options':
        _showWidgetOptions(widget);
        break;
    }
  }

  void _showWidgetOptions(CPDFWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormFieldOptionsPage(
          document: controller!.document,
          cpdfWidget: widget,
        ),
      ),
    );
  }

  Future<void> _setPushButtonAction(CPDFPushButtonWidget pushButton) async {
    if (!mounted) return;
    final action = await showDialog(
      context: context,
      builder: (context) =>
          LinkConfigDialog(enabledTypes: const [LinkType.url, LinkType.page]),
    );
    if (action == null) return;
    pushButton.action = action;
    await controller?.document.updateWidget(pushButton);
  }
}
