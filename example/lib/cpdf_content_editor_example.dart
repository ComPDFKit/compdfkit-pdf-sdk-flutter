/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_manager.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_example_base.dart';
import 'package:flutter/material.dart';

class CPDFContentEditorExample extends CPDFExampleBase {
  const CPDFContentEditorExample({super.key, required super.documentPath});

  @override
  State<CPDFContentEditorExample> createState() => _CPDFContentEditorExampleState();
}

class _CPDFContentEditorExampleState extends CPDFExampleBaseState<CPDFContentEditorExample> {
  static const List<String> _menuActions = [
    'None',
    'Edit Text',
    'Edit Image',
    'Edit Path',
    'Undo',
    'Redo'
  ];

  @override
  String get pageTitle => 'Content Editor Example';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
    modeConfig: const CPDFModeConfig(
      initialViewMode: CPDFViewMode.contentEditor,
    ),
  );

  @override
  List<String> get menuActions => _menuActions;

  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);
    _setupHistoryListener(controller);
  }

  void _setupHistoryListener(CPDFReaderWidgetController controller) {
    controller.editManager.historyManager.setOnHistoryChangedListener(
          (pageIndex, canUndo, canRedo) {
        debugPrint('History changed: page=$pageIndex, canUndo=$canUndo, canRedo=$canRedo');
      },
    );
  }

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'None':
        _changeEditType(controller, [CPDFEditType.none]);
        break;
      case 'Edit Text':
        _changeEditType(controller, [CPDFEditType.text]);
        break;
      case 'Edit Image':
        _changeEditType(controller, [CPDFEditType.image]);
        break;
      case 'Edit Path':
        _changeEditType(controller, [CPDFEditType.path]);
        break;
      case 'Undo':
        _handleUndo(controller);
        break;
      case 'Redo':
        _handleRedo(controller);
        break;
    }
  }

  void _changeEditType(CPDFReaderWidgetController controller, List<CPDFEditType> types) async {
    final editManager = controller.editManager;
    final result = await editManager.changeEditType(types);
    debugPrint('Change edit type to ${types.first}: $result');
  }

  void _handleUndo(CPDFReaderWidgetController controller) async {
    final historyManager = controller.editManager.historyManager;
    final canUndo = await historyManager.canUndo();
    debugPrint('Can undo: $canUndo');

    if (canUndo) {
      await historyManager.undo();
      debugPrint('Undo executed');
    }
  }

  void _handleRedo(CPDFReaderWidgetController controller) async {
    final historyManager = controller.editManager.historyManager;
    final canRedo = await historyManager.canRedo();
    debugPrint('Can redo: $canRedo');

    if (canRedo) {
      await historyManager.redo();
      debugPrint('Redo executed');
    }
  }
}
