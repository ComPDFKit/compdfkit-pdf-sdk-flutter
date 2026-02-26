// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Delete Page Example
///
/// Demonstrates how to remove pages from a PDF document programmatically.
///
/// This example shows:
/// - Deleting specific pages by their index
/// - Handling the result of page removal operations
/// - Refreshing the document view after page deletion
///
/// Key classes/APIs used:
/// - [CPDFDocument.removePages]: Removes pages at specified indices from the document
/// - [CPDFReaderWidgetController.reloadPages2]: Refreshes the reader view after modifications
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Select "Delete First Page" from the menu
/// 3. The first page will be removed and the view will refresh
class DeletePageExample extends StatelessWidget {
  /// Constructor
  const DeletePageExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Delete Page',
      assetPath: _assetPath,
      builder: (path) => _DeletePagePage(documentPath: path),
    );
  }
}

class _DeletePagePage extends ExampleBase {
  const _DeletePagePage({required super.documentPath});

  @override
  State<_DeletePagePage> createState() => _DeletePagePageState();
}

class _DeletePagePageState extends ExampleBaseState<_DeletePagePage> {
  static const List<String> _menuActions = ['Delete First Page'];

  @override
  String get pageTitle => 'Delete Page';

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
  List<String> get menuActions => _menuActions;

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == 'Delete First Page') {
      _removePages(controller);
    }
  }

  Future<void> _removePages(CPDFReaderWidgetController controller) async {
    const removePages = [0];
    final result = await controller.document.removePages(removePages);
    debugPrint('Remove pages result: $result');
    if (result) {
      controller.reloadPages2();
    }
  }
}
