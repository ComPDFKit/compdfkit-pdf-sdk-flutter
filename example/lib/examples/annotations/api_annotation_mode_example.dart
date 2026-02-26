/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:flutter/material.dart';

import '../../features/annotations/tools/annotation_toolbar.dart';
import '../../utils/preferences_service.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// API Annotation Mode Example
///
/// Demonstrates building a custom annotation toolbar using controller APIs.
///
/// This example shows:
/// - Hiding the built-in annotation toolbar via [CPDFToolbarConfig]
/// - Creating a custom [AnnotationToolbar] widget
/// - Using [CPDFReaderWidgetController.setAnnotationMode] to switch modes
/// - Handling annotation mode changes and tool selection
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController]: Controller for reader widget
/// - [CPDFToolbarConfig]: Toolbar visibility configuration
/// - [AnnotationToolbar]: Custom toolbar widget (in features/annotations/)
/// - [CPDFViewMode.annotations]: Annotation editing mode
///
/// Usage:
/// 1. Open the example
/// 2. Use the custom bottom toolbar to select annotation tools
/// 3. Tap on the PDF to add annotations
class ApiAnnotationModeExample extends StatelessWidget {
  const ApiAnnotationModeExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'API Annotation Mode',
      assetPath: _assetPath,
      builder: (path) => _ApiAnnotationModePage(documentPath: path),
    );
  }
}

class _ApiAnnotationModePage extends StatefulWidget {
  final String documentPath;

  const _ApiAnnotationModePage({required this.documentPath});

  @override
  State<_ApiAnnotationModePage> createState() => _ApiAnnotationModePageState();
}

class _ApiAnnotationModePageState extends State<_ApiAnnotationModePage> {
  final CPDFConfiguration _configuration = CPDFConfiguration(
    annotationsConfig: CPDFAnnotationsConfig(
      annotationAuthor: PreferencesService.documentAuthor,
    ),
    modeConfig: const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
    toolbarConfig: CPDFToolbarConfig(annotationToolbarVisible: false),
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
            title: 'API Annotation Mode',
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
                  ? const SizedBox(height: 72)
                  : AnnotationToolbar(controller: _controller!),
            ),
          ),
        ],
      ),
    );
  }
}
