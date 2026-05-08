// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Editor Selection Events Example
///
/// Demonstrates how to track content editor selection state and react to the
/// currently selected [CPDFEditArea].
///
/// This example shows:
/// - Listening for editor selection and deselection events
/// - Tracking the currently selected edit area in widget state
/// - Opening the edit area properties panel for the current selection
/// - Removing the selected edit area from the document
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.addEventListener]: Registers selection listeners
/// - [CPDFEvent.editorSelectionSelected]: Fired when an edit area is selected
/// - [CPDFEvent.editorSelectionDeselected]: Fired when the current selection clears
/// - [CPDFReaderWidgetController.showEditAreaPropertiesView]: Opens the style panel
/// - [CPDFDocument.removeEditArea]: Removes the selected edit area
///
/// Usage:
/// 1. Enter content editor mode and select editable content in the document
/// 2. Use the menu to inspect the selected area or remove it from the page
/// 3. Clear the selection to confirm the state resets automatically
class EditorSelectionEventsExample extends StatelessWidget {
  /// Constructor
  const EditorSelectionEventsExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Editor Selection Events',
      assetPath: _assetPath,
      builder: (path) => _EditorSelectionEventsPage(documentPath: path),
    );
  }
}

class _EditorSelectionEventsPage extends ExampleBase {
  const _EditorSelectionEventsPage({required super.documentPath});

  @override
  State<_EditorSelectionEventsPage> createState() =>
      _EditorSelectionEventsPageState();
}

class _EditorSelectionEventsPageState
    extends ExampleBaseState<_EditorSelectionEventsPage> {
  static const List<String> _menuItems = [
    'Show Edit Area Properties',
    'Remove Edit Area',
  ];

  CPDFEditArea? _selectedArea;

  late final void Function(dynamic) _onEditorSelected;
  late final void Function(dynamic) _onEditorDeselected;

  @override
  String get pageTitle => 'Editor Selection Events';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  List<String> get menuActions => _menuItems;

  @override
  void dispose() {
    final currentController = controller;
    currentController
        ?.removeAllEventListeners(CPDFEvent.editorSelectionSelected);
    currentController?.removeAllEventListeners(
      CPDFEvent.editorSelectionDeselected,
    );
    super.dispose();
  }

  @override
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);

    _onEditorSelected = (event) {
      if (event is! CPDFEditArea || !mounted) {
        return;
      }
      setState(() {
        _selectedArea = event;
      });
      _showStatus('Selected edit area: ${event.type.name}');
    };

    _onEditorDeselected = (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedArea = null;
      });
      _showStatus('Editor selection cleared');
    };

    controller.addEventListener(
        CPDFEvent.editorSelectionSelected, _onEditorSelected);
    controller.addEventListener(
      CPDFEvent.editorSelectionDeselected,
      _onEditorDeselected,
    );
  }

  @override
  void handleMenuAction(
    String action,
    CPDFReaderWidgetController controller,
  ) async {
    final selectedArea = _selectedArea;
    if (selectedArea == null) {
      _showStatus('Select editable content in content editor mode first');
      return;
    }

    switch (action) {
      case 'Show Edit Area Properties':
        await controller.showEditAreaPropertiesView(selectedArea);
        _showStatus('Opened style panel for the selected area');
        break;
      case 'Remove Edit Area':
        await controller.document.removeEditArea(selectedArea);
        if (!mounted) {
          return;
        }
        setState(() {
          _selectedArea = null;
        });
        _showStatus('Removed the selected edit area');
        break;
    }
  }

  void _showStatus(String message) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
