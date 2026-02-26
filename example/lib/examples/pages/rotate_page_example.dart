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

/// Rotate Page Example
///
/// Demonstrates how to rotate individual pages within a PDF document.
///
/// This example shows:
/// - Getting the current rotation angle of a page
/// - Rotating a page by 90-degree increments
/// - Refreshing the document view after rotation changes
///
/// Key classes/APIs used:
/// - [CPDFDocument.pageAtIndex]: Gets a reference to a specific page
/// - [CPDFPage.getRotation]: Retrieves the current rotation angle (0, 90, 180, 270)
/// - [CPDFPage.setRotation]: Sets the rotation angle for a page
/// - [CPDFReaderWidgetController.reloadPages]: Refreshes the reader view after modifications
///
/// Usage:
/// 1. Open a PDF document in the reader
/// 2. Select "Rotate First Page" from the menu
/// 3. The first page will rotate 90 degrees clockwise
/// 4. Repeat to continue rotating through 180, 270, and back to 0 degrees
class RotatePageExample extends StatelessWidget {
  /// Constructor
  const RotatePageExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Rotate Page',
      assetPath: _assetPath,
      builder: (path) => _RotatePagePage(documentPath: path),
    );
  }
}

class _RotatePagePage extends ExampleBase {
  const _RotatePagePage({required super.documentPath});

  @override
  State<_RotatePagePage> createState() => _RotatePagePageState();
}

class _RotatePagePageState extends ExampleBaseState<_RotatePagePage> {
  static const List<String> _menuActions = ['Rotate First Page'];

  @override
  String get pageTitle => 'Rotate Page';

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
    if (action == 'Rotate First Page') {
      _handleRotate(controller);
    }
  }

  Future<void> _handleRotate(CPDFReaderWidgetController controller) async {
    const pageIndex = 0;
    final page = controller.document.pageAtIndex(pageIndex);
    final currentRotation = await page.getRotation();
    final newAngle = currentRotation + 90;
    final result = await page.setRotation(newAngle);
    debugPrint('Rotate page result: $result');
    if (result) {
      controller.reloadPages();
    }
  }
}
