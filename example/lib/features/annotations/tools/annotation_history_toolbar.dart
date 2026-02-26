/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

class AnnotationHistoryToolbar extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const AnnotationHistoryToolbar({super.key, required this.controller});

  @override
  State<AnnotationHistoryToolbar> createState() =>
      _AnnotationHistoryToolbarState();
}

class _AnnotationHistoryToolbarState extends State<AnnotationHistoryToolbar> {
  CPDFAnnotation? selectAnnotation;

  CPDFWidget? selectWidget;

  bool _canUndo = false;

  bool _canRedo = false;

  @override
  void initState() {
    super.initState();
    _updateHistoryState();
    widget.controller.annotationHistoryManager
        .setOnHistoryChangedListener((isCanUndo, isCanRedo) {
      if (!mounted) return;
      setState(() {
        _canUndo = isCanUndo;
        _canRedo = isCanRedo;
      });
    });
    widget.controller.addEventListener(CPDFEvent.annotationsSelected, (event) {
      if (!mounted) return;
      setState(() {
        selectAnnotation = event;
      });
    });

    widget.controller.addEventListener(CPDFEvent.annotationsDeselected,
        (event) {
      if (!mounted) return;
      setState(() {
        selectAnnotation = null;
      });
    });

    widget.controller.addEventListener(CPDFEvent.formFieldsSelected, (event) {
      if (!mounted) return;
      setState(() {
        selectWidget = event;
      });
    });

    widget.controller.addEventListener(CPDFEvent.formFieldsDeselected, (event) {
      if (!mounted) return;
      setState(() {
        selectWidget = null;
      });
    });
  }

  void _updateHistoryState() async {
    final historyManager = widget.controller.annotationHistoryManager;
    final canUndoResult = await historyManager.canUndo();
    final canRedoResult = await historyManager.canRedo();

    if (mounted) {
      setState(() {
        _canUndo = canUndoResult;
        _canRedo = canRedoResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSelection = selectAnnotation != null || selectWidget != null;
    final enabledColor = colorScheme.onSurface;
    final disabledColor = colorScheme.outline;

    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (selectAnnotation != null) {
                widget.controller
                    .showAnnotationPropertiesView(selectAnnotation!);
              }
              if (selectWidget != null) {
                widget.controller.showWidgetPropertiesView(selectWidget!);
              }
            },
            icon: Icon(
              Icons.tune_rounded,
              color: hasSelection ? enabledColor : disabledColor,
            )),
        IconButton(
            onPressed: () {
              if (_canUndo) {
                widget.controller.annotationHistoryManager.undo();
                _updateHistoryState();
              }
            },
            icon: Icon(
              Icons.undo_outlined,
              color: _canUndo ? enabledColor : disabledColor,
            )),
        IconButton(
            onPressed: () {
              if (_canRedo) {
                widget.controller.annotationHistoryManager.redo();
                _updateHistoryState();
              }
            },
            icon: Icon(
              Icons.redo_outlined,
              color: _canRedo ? enabledColor : disabledColor,
            )),
      ],
    );
  }
}
