// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../features/forms/tools/form_toolbar.dart';
import '../../utils/preferences_service.dart';
import '../shared/example_document_loader.dart';

/// API Form Creation Mode Example
///
/// Demonstrates how to build a custom form creation toolbar that programmatically
/// enters form creation mode using the ComPDFKit Flutter API.
///
/// This example shows:
/// - Hiding the default form toolbar via [CPDFToolbarConfig]
/// - Building a custom [FormToolbar] widget for form field creation
/// - Entering form creation mode programmatically via controller API
/// - Switching between different form field types (text, checkbox, etc.)
///
/// Key classes/APIs used:
/// - [CPDFToolbarConfig.formToolbarVisible]: Hides the built-in form toolbar
/// - [CPDFReaderWidgetController]: Controls the reader widget state
/// - [FormToolbar]: Custom toolbar widget for selecting form field types
///
/// Usage:
/// 1. Open the example to see the custom form toolbar at the bottom
/// 2. Tap a form field type button to enter creation mode
/// 3. Tap on the PDF page to place the form field
/// 4. The document is auto-saved when navigating back
class ApiFormCreationModeExample extends StatelessWidget {
  const ApiFormCreationModeExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'API Form Creation Mode',
      assetPath: _assetPath,
      builder: (path) => _ApiFormCreationModePage(documentPath: path),
    );
  }
}

class _ApiFormCreationModePage extends StatefulWidget {
  final String documentPath;

  const _ApiFormCreationModePage({required this.documentPath});

  @override
  State<_ApiFormCreationModePage> createState() =>
      _ApiFormCreationModePageState();
}

class _ApiFormCreationModePageState extends State<_ApiFormCreationModePage> {
  final CPDFConfiguration _configuration = CPDFConfiguration(
    modeConfig: const CPDFModeConfig(
      initialViewMode: CPDFViewMode.forms,
      availableViewModes: [CPDFViewMode.viewer, CPDFViewMode.forms],
    ),
    toolbarConfig: CPDFToolbarConfig(formToolbarVisible: false),
    annotationsConfig: CPDFAnnotationsConfig(
      annotationAuthor: PreferencesService.documentAuthor,
    ),
    readerViewConfig: CPDFReaderViewConfig(
      linkHighlight: PreferencesService.highlightLink,
      formFieldHighlight: PreferencesService.highlightForm, 
    ),
  );

  CPDFReaderWidgetController? _controller;

  void _handleControllerCreated(CPDFReaderWidgetController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'API Form Creation Mode',
            onBack: () async {
              final controller = _controller;
              if (controller != null) {
                final saveResult = await controller.document.save();
                debugPrint('ComPDFKit: saveResult: $saveResult');
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CPDFReaderWidget(
              document: widget.documentPath,
              configuration: _configuration,
              pageIndex: 0,
              onCreated: _handleControllerCreated,
            ),
          ),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: _controller == null
                  ? const SizedBox(height: 56)
                  : FormToolbar(controller: _controller!),
            ),
          ),
        ],
      ),
    );
  }
}
