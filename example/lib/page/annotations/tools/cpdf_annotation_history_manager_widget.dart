/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/history/cpdf_annotation_history_manager.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

class CpdfAnnotationHistoryManagerWidget extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const CpdfAnnotationHistoryManagerWidget(
      {super.key, required this.controller});

  @override
  State<CpdfAnnotationHistoryManagerWidget> createState() =>
      _CpdfAnnotationHistoryManagerWidgetState();
}

class _CpdfAnnotationHistoryManagerWidgetState
    extends State<CpdfAnnotationHistoryManagerWidget> {
  bool _canUndo = false;

  bool _canRedo = false;

  @override
  void initState() {
    super.initState();
    _updateHistoryState();
    widget.controller.annotationHistoryManager.setOnHistoryChangedListener((isCanUndo, isCanRedo){
      setState(() {
        _canUndo = isCanUndo;
        _canRedo = isCanRedo;
      });
    });
  }

  void _updateHistoryState() async {
    CPDFAnnotationHistoryManager historyManager = widget.controller.annotationHistoryManager;

    bool canUndoResult = await historyManager.canUndo();
    bool canRedoResult = await historyManager.canRedo();

    if (mounted) {
      setState(() {
        _canUndo = canUndoResult;
        _canRedo = canRedoResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (_canUndo) {
                widget.controller.annotationHistoryManager.undo();
                _updateHistoryState();
              }
            },
            icon: Icon(
              Icons.undo_rounded,
              color: _canUndo ? Colors.black : Colors.black12,
            )),
        IconButton(
            onPressed: () {
              if (_canRedo) {
                widget.controller.annotationHistoryManager.redo();
                _updateHistoryState();
              }
            },
            icon: Icon(
              Icons.redo_rounded,
              color: _canRedo ? Colors.black : Colors.black12,
            )),
      ],
    );
  }
}
