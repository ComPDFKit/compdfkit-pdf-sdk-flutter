// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/document/cpdf_header_footer.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import 'dialogs/header_footer_details_dialog.dart';

/// Demonstrates the visible header and footer CRUD workflow in a PDF reader.
class HeaderFooterExample extends StatelessWidget {
  /// Creates the header and footer example.
  const HeaderFooterExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Header & Footer',
      assetPath: _assetPath,
      builder: (path) => _HeaderFooterPage(documentPath: path),
    );
  }
}

class _HeaderFooterPage extends ExampleBase {
  const _HeaderFooterPage({required super.documentPath});

  @override
  State<_HeaderFooterPage> createState() => _HeaderFooterPageState();
}

class _HeaderFooterPageState extends ExampleBaseState<_HeaderFooterPage> {
  static const List<String> _menuActions = [
    'Add Header & Footer',
    'Read Header & Footer',
    'Update Header & Footer',
    'Clear Header & Footer',
  ];

  @override
  String get pageTitle => 'Header & Footer';

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
  void handleMenuAction(
    String action,
    CPDFReaderWidgetController controller,
  ) {
    switch (action) {
      case 'Add Header & Footer':
        _applyHeaderFooter(controller);
        break;
      case 'Read Header & Footer':
        _readHeaderFooter(controller);
        break;
      case 'Update Header & Footer':
        _updateHeaderFooter(controller);
        break;
      case 'Clear Header & Footer':
        _clearHeaderFooter(controller);
        break;
    }
  }

  Future<void> _applyHeaderFooter(
    CPDFReaderWidgetController controller,
  ) async {
    final pages = await _allPages(controller);
    final success = await controller.document.updateHeaderFooter(
      CPDFHeaderFooter(
        pages: pages,
        margin: const EdgeInsets.all(36),
        slots: const <CPDFHeaderFooterSlot>[
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.headerLeft,
            text: 'ComPDF',
            fontSize: 10,
          ),
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.headerRight,
            text: 'Confidential',
            fontSize: 10,
            textColor: Colors.red,
          ),
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.footerCenter,
            text: 'Page <<1>>',
            fontSize: 10,
          ),
        ],
      ),
    );
    _showMessage(
        success ? 'Header/footer added' : 'Failed to add header/footer');
  }

  Future<void> _readHeaderFooter(
    CPDFReaderWidgetController controller,
  ) async {
    final value = await controller.document.getHeaderFooter();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => HeaderFooterDetailsDialog(value: value),
    );
  }

  Future<void> _updateHeaderFooter(
    CPDFReaderWidgetController controller,
  ) async {
    final pages = await _allPages(controller);
    final success = await controller.document.updateHeaderFooter(
      CPDFHeaderFooter(
        pages: pages,
        margin: const EdgeInsets.fromLTRB(48, 36, 48, 36),
        slots: const <CPDFHeaderFooterSlot>[
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.headerLeft,
            text: 'ComPDF 3.2.0',
            fontSize: 11,
          ),
          CPDFHeaderFooterSlot(
            position: CPDFHeaderFooterPosition.footerCenter,
            text: 'Updated page <<1>>',
            fontSize: 11,
          ),
        ],
      ),
    );
    _showMessage(
        success ? 'Header/footer updated' : 'Failed to update header/footer');
  }

  Future<void> _clearHeaderFooter(
    CPDFReaderWidgetController controller,
  ) async {
    final success = await controller.document.clearHeaderFooter();
    _showMessage(
        success ? 'Header/footer cleared' : 'Failed to clear header/footer');
  }

  Future<List<int>> _allPages(CPDFReaderWidgetController controller) async {
    final count = await controller.document.getPageCount();
    return List<int>.generate(count, (index) => index);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
