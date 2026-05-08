// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Event Listeners Example
///
/// Demonstrates how to register, handle, and remove controller event listeners
/// for annotation and form creation events.
///
/// This example shows:
/// - Listening for annotation creation events
/// - Listening for form field creation events
/// - Accessing event data for further processing
/// - Removing a specific event listener by callback reference
/// - Removing all registered listeners from the controller
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.addEventListener]: Registers event listeners
/// - [CPDFReaderWidgetController.removeEventListener]: Removes a specific listener
/// - [CPDFReaderWidgetController.removeAllEventListeners]: Removes all listeners
/// - [CPDFEvent.annotationsCreated]: Fired when annotations are created
/// - [CPDFEvent.formFieldsCreated]: Fired when form fields are created
///
/// Usage:
/// 1. Open the example and create an annotation or form field in the reader
/// 2. Check the debug output for the serialized event payload
/// 3. Use the menu to remove or restore listeners one by one
/// 4. Use "Remove All Listeners" to stop every registered event callback
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
  // Track listener registration status
  bool _annotationListenerAdded = true;
  bool _formFieldListenerAdded = true;

  // Store callback references for removal
  late final void Function(dynamic) _onAnnotationCreated;
  late final void Function(dynamic) _onFormFieldCreated;

  @override
  List<String>? get menuActions => [
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
  void dispose() {
    final currentController = controller;
    currentController?.removeAllEventListeners(CPDFEvent.annotationsCreated);
    currentController?.removeAllEventListeners(CPDFEvent.formFieldsCreated);
    super.dispose();
  }

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

    controller.addEventListener(
        CPDFEvent.annotationsCreated, _onAnnotationCreated);
    controller.addEventListener(
        CPDFEvent.formFieldsCreated, _onFormFieldCreated);
  }

  @override
  void handleMenuAction(
    String action,
    CPDFReaderWidgetController controller,
  ) async {
    switch (action) {
      case 'Remove Annotation Listener':
        final removed = controller.removeEventListener(
            CPDFEvent.annotationsCreated, _onAnnotationCreated);
        debugPrint('Annotation listener removed: $removed');
        _showStatus('Annotation creation listener removed');
        setState(() {
          _annotationListenerAdded = false;
        });
        break;
      case 'Add Annotation Listener':
        controller.addEventListener(
            CPDFEvent.annotationsCreated, _onAnnotationCreated);
        debugPrint('Annotation listener added');
        _showStatus('Annotation creation listener added');
        setState(() {
          _annotationListenerAdded = true;
        });
        break;
      case 'Remove FormField Listener':
        final removed = controller.removeEventListener(
            CPDFEvent.formFieldsCreated, _onFormFieldCreated);
        debugPrint('FormField listener removed: $removed');
        _showStatus('Form creation listener removed');
        setState(() {
          _formFieldListenerAdded = false;
        });
        break;
      case 'Add FormField Listener':
        controller.addEventListener(
            CPDFEvent.formFieldsCreated, _onFormFieldCreated);
        debugPrint('FormField listener added');
        _showStatus('Form creation listener added');
        setState(() {
          _formFieldListenerAdded = true;
        });
        break;
      case 'Remove All Listeners':
        controller.removeAllEventListeners();
        debugPrint('All listeners removed');
        _showStatus('All creation listeners removed');
        setState(() {
          _annotationListenerAdded = false;
          _formFieldListenerAdded = false;
        });
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
