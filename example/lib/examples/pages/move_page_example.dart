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

/// Move Page Example
///
/// Demonstrates how to reorder pages within a PDF document by moving them to new positions.
///
/// This example shows:
/// - Moving a page from one position to another
/// - Validating page indices before performing move operations
/// - Refreshing the document view after reordering pages
///
/// Key classes/APIs used:
/// - [CPDFDocument.movePage]: Moves a page from one index to another
/// - [CPDFDocument.getPageCount]: Gets the total number of pages for validation
/// - [CPDFReaderWidgetController.reloadPages2]: Refreshes the reader view after modifications
///
/// Usage:
/// 1. Open a PDF document with multiple pages
/// 2. Select a move option from the menu:
///    - "Move First Page to Second" to swap page order
///    - "Move Second Page to First" to reverse the swap
/// 3. The document view will refresh to reflect the new page order
class MovePageExample extends StatelessWidget {
  /// Constructor
  const MovePageExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Move Page',
      assetPath: _assetPath,
      builder: (path) => _MovePagePage(documentPath: path),
    );
  }
}

class _MovePagePage extends ExampleBase {
  const _MovePagePage({required super.documentPath});

  @override
  State<_MovePagePage> createState() => _MovePagePageState();
}

class _MovePagePageState extends ExampleBaseState<_MovePagePage> {
  static const List<String> _menuActions = [
    'Move First Page to Second',
    'Move Second Page to First',
  ];

  @override
  String get pageTitle => 'Move Page';

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
    if (action == 'Move First Page to Second') {
      _handleMovePage(controller, 0, 1);
    } else if (action == 'Move Second Page to First') {
      _handleMovePage(controller, 1, 0);
    }
  }

  Future<void> _handleMovePage(
    CPDFReaderWidgetController controller,
    int fromIndex,
    int toIndex,
  ) async {
    final pageCount = await controller.document.getPageCount();

    // Validate indices
    if (fromIndex < 0 || fromIndex >= pageCount) {
      debugPrint('Invalid from index: $fromIndex');
      return;
    }
    if (toIndex < 0 || toIndex >= pageCount) {
      debugPrint('Invalid to index: $toIndex');
      return;
    }
    if (fromIndex == toIndex) {
      debugPrint('Source and destination are the same');
      return;
    }

    final moveResult = await controller.document.movePage(
      fromIndex: fromIndex,
      toIndex: toIndex,
    );
    debugPrint('ComPDFKit:movePage():$moveResult');

    if (moveResult) {
      controller.reloadPages2();
      debugPrint('Moved page ${fromIndex + 1} to position ${toIndex + 1}');
    } else {
      debugPrint('Failed to move page');
    }
  }
}
