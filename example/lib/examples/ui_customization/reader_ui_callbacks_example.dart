// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Reader UI Callbacks Example
///
/// Demonstrates widget-level reader callbacks exposed by [ExampleBaseState].
/// These hooks are constructor callbacks on the reader widget, not controller
/// event subscriptions.
///
/// This example shows:
/// - Handling the search back button callback
/// - Handling annotation style dialog dismissal callbacks
/// - Handling form style dialog dismissal callbacks
/// - Handling content editor style dialog dismissal callbacks
///
/// Key classes/APIs used:
/// - [ExampleBaseState.onSearchBackButtonTapped]: Search UI back action callback
/// - [ExampleBaseState.onAnnotationStyleDialogDismissed]: Annotation dialog callback
/// - [ExampleBaseState.onFormStyleDialogDismissed]: Form dialog callback
/// - [ExampleBaseState.onContentEditorStyleDialogDismissed]: Editor dialog callback
///
/// Usage:
/// 1. Open search, annotation style, form style, or editor style panels
/// 2. Close the panel or tap the search back button
/// 3. Check the floating status message for the callback that fired
class ReaderUiCallbacksExample extends StatelessWidget {
  /// Constructor
  const ReaderUiCallbacksExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Reader UI Callbacks',
      assetPath: _assetPath,
      builder: (path) => _ReaderUiCallbacksPage(documentPath: path),
    );
  }
}

class _ReaderUiCallbacksPage extends ExampleBase {
  const _ReaderUiCallbacksPage({required super.documentPath});

  @override
  State<_ReaderUiCallbacksPage> createState() => _ReaderUiCallbacksPageState();
}

class _ReaderUiCallbacksPageState
    extends ExampleBaseState<_ReaderUiCallbacksPage> {
  @override
  String get pageTitle => 'Reader UI Callbacks';

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
  void onSearchBackButtonTapped() {
    _showStatus('Callback fired: search back button tapped');
  }

  @override
  void onAnnotationStyleDialogDismissed(CPDFAnnotationType type) {
    _showStatus(
        'Callback fired: annotation style dialog dismissed (${type.name})');
  }

  @override
  void onFormStyleDialogDismissed(CPDFFormType type) {
    _showStatus('Callback fired: form style dialog dismissed (${type.name})');
  }

  @override
  void onContentEditorStyleDialogDismissed(CPDFEditAreaType type) {
    _showStatus(
        'Callback fired: content editor style dialog dismissed (${type.name})');
  }

  @override
  void onAddWatermarkDialogDismissed() {
    _showStatus('Callback fired: add watermark dialog dismissed');
    super.onAddWatermarkDialogDismissed();
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
