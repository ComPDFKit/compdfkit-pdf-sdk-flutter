// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Event Listeners Example
///
/// Demonstrates how to register, handle, and remove PDF event callbacks to respond
/// to user interactions and document changes in real-time.
///
/// This example shows:
/// - Listening for annotation creation events
/// - Listening for form field creation events
/// - Tracking content editor selection/deselection events
/// - Responding to events with UI updates and actions
/// - Accessing event data for further processing
/// - **Removing specific event listeners**
/// - **Removing all event listeners for a specific event type**
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.addEventListener]: Registers event listeners
/// - [CPDFReaderWidgetController.removeEventListener]: Removes a specific listener
/// - [CPDFReaderWidgetController.removeAllEventListeners]: Removes all listeners
/// - [CPDFEvent.annotationsCreated]: Fired when annotations are created
/// - [CPDFEvent.formFieldsCreated]: Fired when form fields are created
/// - [CPDFEvent.editorSelectionSelected]: Fired when editor content is selected
/// - [CPDFEvent.editorSelectionDeselected]: Fired when editor selection is cleared
/// - [CPDFEditArea]: Represents selected content in the editor
///
/// Usage:
/// 1. Override [onControllerCreated] to access the controller
/// 2. Call [controller.addEventListener] with the desired [CPDFEvent] type
/// 3. Provide a callback function to handle the event data
/// 4. Use [setState] to update UI based on events (e.g., track selected areas)
/// 5. Use event data to perform actions (e.g., show properties, remove areas)
/// 6. Use [controller.removeEventListener] to remove a specific callback
/// 7. Use [controller.removeAllEventListeners] to remove all listeners
class EventListenersExample extends StatelessWidget {
  /// Constructor
  const EventListenersExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Event Listeners',
      assetPath: _assetPath,
      builder: (path) => _EventListenersPage(documentPath: path),
    );
  }
}

class _EventListenersPage extends ExampleBase {
  const _EventListenersPage({required super.documentPath});

  @override
  State<_EventListenersPage> createState() => _EventListenersPageState();
}

class _EventListenersPageState extends ExampleBaseState<_EventListenersPage> {
  CPDFEditArea? _selectArea;

  // Track listener registration status
  bool _annotationListenerAdded = true;
  bool _formFieldListenerAdded = true;

  // Store callback references for removal
  late final void Function(dynamic) _onAnnotationCreated;
  late final void Function(dynamic) _onFormFieldCreated;
  late final void Function(dynamic) _onEditorSelected;
  late final void Function(dynamic) _onEditorDeselected;

  @override
  List<String>? get menuActions => [
        'Show Edit Area Properties',
        'Remove Edit Area',
        _annotationListenerAdded
            ? 'Remove Annotation Listener'
            : 'Add Annotation Listener',
        _formFieldListenerAdded
            ? 'Remove FormField Listener'
            : 'Add FormField Listener',
        'Remove All Listeners',
      ];

  @override
  String get pageTitle => 'Event Listeners';

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
  void onControllerCreated(CPDFReaderWidgetController controller) {
    super.onControllerCreated(controller);

    // Define named callbacks for later removal
    _onAnnotationCreated = (event) {
      debugPrint('Annotation created: ${event.runtimeType}');
      printJsonString(jsonEncode(event));
    };

    _onFormFieldCreated = (event) {
      debugPrint('Form field created: ${event.runtimeType}');
      printJsonString(jsonEncode(event));
    };

    _onEditorSelected = (event) {
      setState(() {
        _selectArea = event;
      });
    };

    _onEditorDeselected = (event) {
      setState(() {
        _selectArea = null;
      });
    };

    // Register all listeners
    controller.addEventListener(
        CPDFEvent.annotationsCreated, _onAnnotationCreated);
    controller.addEventListener(
        CPDFEvent.formFieldsCreated, _onFormFieldCreated);
    controller.addEventListener(
        CPDFEvent.editorSelectionSelected, _onEditorSelected);
    controller.addEventListener(
        CPDFEvent.editorSelectionDeselected, _onEditorDeselected);
  }

  @override
  void handleMenuAction(
    String action,
    CPDFReaderWidgetController controller,
  ) async {
    switch (action) {
      case 'Show Edit Area Properties':
        if (_selectArea != null) {
          await controller.showEditAreaPropertiesView(_selectArea!);
        }
        break;
      case 'Remove Edit Area':
        if (_selectArea != null) {
          await controller.document.removeEditArea(_selectArea!);
        }
        break;
      case 'Remove Annotation Listener':
        // Remove specific annotation listener using callback reference
        final removed = controller.removeEventListener(
            CPDFEvent.annotationsCreated, _onAnnotationCreated);
        debugPrint('Annotation listener removed: $removed');
        setState(() {
          _annotationListenerAdded = false;
        });
        break;
      case 'Add Annotation Listener':
        // Re-add the annotation listener
        controller.addEventListener(
            CPDFEvent.annotationsCreated, _onAnnotationCreated);
        debugPrint('Annotation listener added');
        setState(() {
          _annotationListenerAdded = true;
        });
        break;
      case 'Remove FormField Listener':
        // Remove specific form field listener
        final removed = controller.removeEventListener(
            CPDFEvent.formFieldsCreated, _onFormFieldCreated);
        debugPrint('FormField listener removed: $removed');
        setState(() {
          _formFieldListenerAdded = false;
        });
        break;
      case 'Add FormField Listener':
        // Re-add the form field listener
        controller.addEventListener(
            CPDFEvent.formFieldsCreated, _onFormFieldCreated);
        debugPrint('FormField listener added');
        setState(() {
          _formFieldListenerAdded = true;
        });
        break;
      case 'Remove All Listeners':
        // Remove all listeners for all events
        controller.removeAllEventListeners();
        debugPrint('All listeners removed');
        setState(() {
          _annotationListenerAdded = false;
          _formFieldListenerAdded = false;
          _selectArea = null;
        });
        break;
    }
  }
}
