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
import 'package:compdfkit_flutter_example/page/cpdf_reader_widget_display_setting_page.dart';
import 'package:compdfkit_flutter_example/page/cpdf_reader_widget_switch_preview_mode_page.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

import 'cpdf_configuration_manager.dart';
import 'model/cpdf_action_item.dart';

enum ActionGroup { document, display, view, interaction }

class CPDFControllerExample extends CPDFExampleBase {
  const CPDFControllerExample({super.key, required super.documentPath});

  @override
  State<CPDFControllerExample> createState() => _CPDFControllerExampleState();
}

class _CPDFControllerExampleState extends CPDFExampleBaseState<CPDFControllerExample> {
  late final ActionHandler _actionHandler;

  @override
  void initState() {
    super.initState();
    _actionHandler = ActionHandler();
  }

  @override
  String get pageTitle => 'Widget Controller Example';

  @override
  CPDFConfiguration get configuration => CPDFConfigurationManager.controllerExampleConfig;

  @override
  List<Widget> Function(CPDFReaderWidgetController)? get appBarActions => (controller) => [
    _buildCompactMenu(context, controller, 'Doc',_documentActions, Icons.description),
    _buildCompactMenu(context, controller, 'Display', _displayActions, Icons.display_settings),
    _buildCompactMenu(context, controller, 'View', _viewActions, Icons.view_list),
    _buildCompactMenu(context, controller, 'Action', _interactionActions, Icons.touch_app),
  ];

  static const List<CPDFActionItem> _documentActions = [
    CPDFActionItem(
      key: 'save',
      displayName: 'Save Document',
      icon: Icons.save,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'saveAs',
      displayName: 'Save As',
      icon: Icons.save_as,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'openDocument',
      displayName: 'Open Document',
      shortName: 'Open Doc',
      icon: Icons.folder_open,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'isChanged',
      displayName: 'Check Changes',
      icon: Icons.check,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'documentInfo',
      displayName: 'Document Info',
      shortName: 'Doc Info',
      icon: Icons.info,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'print',
      displayName: 'Print Document',
      shortName: 'Print',
      icon: Icons.print,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'removeSignFileList',
      displayName: 'Clear Sign List',
      description: 'Remove signature file list',
      icon: Icons.clear,
      group: ActionGroup.document,
    ),
    CPDFActionItem(
      key: 'verifyDigitalSignature',
      displayName: 'Verify Signature',
      description: 'Verify digital signature status',
      icon: Icons.verified,
      group: ActionGroup.document,
    ),
  ];

  static const List<CPDFActionItem> _displayActions = [
    CPDFActionItem(
      key: 'setScale',
      displayName: 'Set Scale',
      icon: Icons.zoom_in,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'setPageSpacing',
      displayName: 'Page Spacing',
      description: 'Set page spacing between pages',
      icon: Icons.space_bar,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'setMargin',
      displayName: 'Set Margins',
      icon: Icons.border_all,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'setDisplayPageIndex',
      displayName: 'Go To Page',
      description: 'Jump to specific page',
      icon: Icons.skip_next,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'PreviewMode',
      displayName: 'Preview Mode',
      icon: Icons.preview,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'DisplaySetting',
      displayName: 'Display Settings',
      shortName: 'Display',
      icon: Icons.display_settings,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'DisplaySettingPage',
      displayName: 'Settings Page',
      description: 'Open display settings page',
      icon: Icons.settings_display,
      group: ActionGroup.display,
    ),
    CPDFActionItem(
      key: 'setWidgetBackgroundColor',
      displayName: 'Background Color',
      shortName: 'BG Color',
      description: 'Set widget background color',
      icon: Icons.color_lens,
      group: ActionGroup.display,
    ),
  ];

  static const List<CPDFActionItem> _viewActions = [
    CPDFActionItem(
      key: 'Watermark',
      displayName: 'Watermark',
      icon: Icons.opacity, // 修复：使用存在的图标
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'Security',
      displayName: 'Security',
      icon: Icons.security,
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'Thumbnail',
      displayName: 'Thumbnail',
      icon: Icons.image,
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'BOTA',
      displayName: 'BOTA View',
      icon: Icons.view_sidebar,
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'showSearchView',
      displayName: 'Show Search',
      icon: Icons.search,
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'hideSearchView',
      displayName: 'Hide Search',
      icon: Icons.search_off,
      group: ActionGroup.view,
    ),
    CPDFActionItem(
      key: 'hideDigitalSignStatusView',
      displayName: 'Hide Sign Status',
      description: 'Hide digital signature status view',
      icon: Icons.visibility_off,
      group: ActionGroup.view,
    ),
  ];

  static const List<CPDFActionItem> _interactionActions = [
    CPDFActionItem(
      key: 'SnipMode',
      displayName: 'Enter Snip',
      description: 'Enter screenshot mode',
      icon: Icons.crop,
      group: ActionGroup.interaction,
    ),
    CPDFActionItem(
      key: 'ExitSnipMode',
      displayName: 'Exit Snip',
      description: 'Exit screenshot mode',
      icon: Icons.crop_free,
      group: ActionGroup.interaction,
    ),
    CPDFActionItem(
      key: 'dismissContextMenu',
      displayName: 'Close Menu',
      description: 'Dismiss context menu',
      icon: Icons.close,
      group: ActionGroup.interaction,
    ),
  ];



  Widget _buildCompactMenu(
      BuildContext context,
      CPDFReaderWidgetController controller,
      String title,
      List<CPDFActionItem> actions,
      IconData icon,
      ) {
    return PopupMenuButton<CPDFActionItem>(
      icon: Icon(icon, size: 20),
      tooltip: title,
      onSelected: (action) => _actionHandler.handleAction(context, action, controller),
      itemBuilder: (context) => [
        PopupMenuItem<CPDFActionItem>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const PopupMenuDivider(height: 8),
        ...actions.map((action) => PopupMenuItem<CPDFActionItem>(
          value: action,
          height: 36,
          child: Row(
            children: [
              if (action.icon != null) ...[
                Icon(action.icon, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action.menuDisplayName,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (action.description != null && action.description != action.displayName)
                      Text(
                        action.description!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class ActionHandler {
  Future<void> handleAction(
      BuildContext context,
      CPDFActionItem action,
      CPDFReaderWidgetController controller,
      ) async {
    debugPrint('Executing action: ${action.displayName}');

    try {
      switch (action.key) {
        case 'save':
          await _handleSave(controller);
          break;
        case 'saveAs':
          await _handleSaveAs(controller);
          break;
        case 'openDocument':
          await _handleOpenDocument(controller);
          break;
        case 'isChanged':
          await _handleCheckChanges(controller);
          break;
        case 'documentInfo':
          await _handleDocumentInfo(controller);
          break;
        case 'print':
          await _handlePrint(controller);
          break;
        case 'removeSignFileList':
          await _handleRemoveSignFileList();
          break;
        case 'verifyDigitalSignature':
          await controller.verifyDigitalSignatureStatus();
          break;
        case 'setScale':
          await _handleSetScale(controller);
          break;
        case 'setPageSpacing':
          await controller.setPageSpacing(20);
          break;
        case 'setMargin':
          await _handleSetMargin(controller);
          break;
        case 'setDisplayPageIndex':
          await _handleSetDisplayPageIndex(controller);
          break;
        case 'PreviewMode':
          await _handlePreviewMode(context, controller);
          break;
        case 'DisplaySetting':
          await controller.showDisplaySettingView();
          break;
        case 'DisplaySettingPage':
          await _handleDisplaySettingPage(context, controller);
          break;
        case 'setWidgetBackgroundColor':
          await _handleSetBackgroundColor(controller);
          break;
        case 'Watermark':
          await _handleWatermark(context, controller);
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
        case 'showSearchView':
          await controller.showTextSearchView();
          break;
        case 'hideSearchView':
          await controller.hideTextSearchView();
          break;
        case 'hideDigitalSignStatusView':
          await controller.hideDigitalSignStatusView();
          break;
        case 'SnipMode':
          await controller.enterSnipMode();
          break;
        case 'ExitSnipMode':
          await controller.exitSnipMode();
          break;
        case 'dismissContextMenu':
          await controller.dismissContextMenu();
          break;
      }
    } catch (e) {
      debugPrint('Action failed: ${action.displayName}, Error: $e');
    }
  }

  Future<void> _handleSave(CPDFReaderWidgetController controller) async {
    final result = await controller.document.save();
    debugPrint('Save result: $result');
  }

  Future<void> _handleSaveAs(CPDFReaderWidgetController controller) async {
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    final fileName = await controller.document.getFileName();
    final savePath = '${tempDir.path}/$fileName';
    final result = await controller.document.saveAs(savePath);
    debugPrint('Save as result: $result, Path: $savePath');
  }

  Future<void> _handleOpenDocument(CPDFReaderWidgetController controller) async {
    final path = await ComPDFKit.pickFile();
    if (path != null) {
      final error = await controller.document.open(path);
      debugPrint('Open document result: $error');
    }
  }

  Future<void> _handleCheckChanges(CPDFReaderWidgetController controller) async {
    final hasChange = await controller.document.hasChange();
    debugPrint('Document has changes: $hasChange');
  }

  Future<void> _handleDocumentInfo(CPDFReaderWidgetController controller) async {
    final document = controller.document;
    debugPrint('Document Info:');
    debugPrint('  File name: ${await document.getFileName()}');
    debugPrint('  Document path: ${await document.getDocumentPath()}');
    debugPrint('  Owner unlocked: ${await document.checkOwnerUnlocked()}');
    debugPrint('  Has changes: ${await document.hasChange()}');
    debugPrint('  Is encrypted: ${await document.isEncrypted()}');
    debugPrint('  Is image doc: ${await document.isImageDoc()}');
    debugPrint('  Permissions: ${await document.getPermissions()}');
    debugPrint('  Page count: ${await document.getPageCount()}');
  }

  Future<void> _handlePrint(CPDFReaderWidgetController controller) async {
    await controller.document.printDocument();
  }

  Future<void> _handleRemoveSignFileList() async {
    final result = await ComPDFKit.removeSignFileList();
    debugPrint('Remove sign file list: $result');
  }

  Future<void> _handleSetScale(CPDFReaderWidgetController controller) async {
    controller.setScale(1.5);
    final scaleValue = await controller.getScale();
    debugPrint('Current scale: $scaleValue');
  }

  Future<void> _handleSetMargin(CPDFReaderWidgetController controller) async {
    final value = Random().nextInt(50);
    debugPrint('Set margin: $value');
    controller.setMargins(const CPDFEdgeInsets.only(
      left: 20, top: 20, right: 20, bottom: 20,
    ));
  }

  Future<void> _handleSetDisplayPageIndex(CPDFReaderWidgetController controller) async {
    final currentPageIndex = await controller.getCurrentPageIndex();
    final nextPageIndex = currentPageIndex + 1;
    debugPrint('Jump from page $currentPageIndex to $nextPageIndex');
    controller.setDisplayPageIndex(pageIndex: nextPageIndex, animated: true);
  }

  Future<void> _handlePreviewMode(BuildContext context, CPDFReaderWidgetController controller) async {
    final mode = await controller.getPreviewMode();
    if (context.mounted) {
      final switchMode = await showModalBottomSheet<CPDFViewMode>(
        context: context,
        builder: (context) => CpdfReaderWidgetSwitchPreviewModePage(viewMode: mode),
      );
      if (switchMode != null) {
        await controller.setPreviewMode(switchMode);
      }
    }
  }

  Future<void> _handleDisplaySettingPage(BuildContext context, CPDFReaderWidgetController controller) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CpdfReaderWidgetDisplaySettingPage(controller: controller),
    );
  }

  Future<void> _handleSetBackgroundColor(CPDFReaderWidgetController controller) async {
    final color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    await controller.setWidgetBackgroundColor(color);
    debugPrint('Set background color: $color');
  }

  /// Add a watermark (text and/or image).
  ///
  /// Image sources can be either:
  /// - **Android**: a drawable resource (copy the image into the `drawable` folder first)
  ///   Example: `image: 'ic_logo'` → `R.drawable.ic_logo`
  /// - **iOS**: an image file in the project bundle
  ///   Example: `image: 'ic_logo'`
  /// - **Both platforms**: a file path on disk
  ///   Example:
  ///   ```dart
  ///   final imagePath = await extractAsset(context, 'images/ic_logo.png');
  ///   ```
  ///
  /// Example usage:
  /// ```dart
  /// await controller.showAddWatermarkView(
  ///   config: CPDFWatermarkConfig(
  ///     saveAsNewFile: true,
  ///     types: [CPDFWatermarkType.text, CPDFWatermarkType.image],
  ///     image: imagePath.path,
  ///     text: 'ComPDFKit Flutter',
  ///     rotation: -45,
  ///     textColor: Colors.red,
  ///     textSize: 50,
  ///     opacity: 200,
  ///     scale: 2.0,
  ///   ),
  /// );
  /// ```
  Future<void> _handleWatermark(BuildContext context, CPDFReaderWidgetController controller) async {

    final imagePath = await extractAsset(context, 'images/ic_logo.png');
    await controller.showAddWatermarkView(
      config: CPDFWatermarkConfig(
        saveAsNewFile: true,
        types: [CPDFWatermarkType.text, CPDFWatermarkType.image],
        image: imagePath.path,
        text: 'ComPDFKit Flutter',
        rotation: -45,
        textColor: Colors.red,
        textSize:50,
        opacity: 200,
        scale: 2.0
      ),
    );
  }
}
