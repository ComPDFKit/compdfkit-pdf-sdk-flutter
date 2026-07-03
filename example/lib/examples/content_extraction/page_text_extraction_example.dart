// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/page/cpdf_text_line.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../widgets/snack_bar_helper.dart';
import '../shared/example_document_loader.dart';

/// Page Text Extraction Example
///
/// Demonstrates page-level text extraction APIs from a [CPDFReaderWidget].
class PageTextExtractionExample extends StatelessWidget {
  const PageTextExtractionExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Page Text Extraction',
      assetPath: _assetPath,
      builder: (path) => _PageTextExtractionPage(documentPath: path),
    );
  }
}

class _PageTextExtractionPage extends ExampleBase {
  const _PageTextExtractionPage({required super.documentPath});

  @override
  State<_PageTextExtractionPage> createState() =>
      _PageTextExtractionPageState();
}

class _PageTextExtractionPageState
    extends ExampleBaseState<_PageTextExtractionPage> {
  static const List<String> _menuActions = [
    'Extract Current Page Text',
    'Extract First Text Line',
    'Extract Text From Rect',
  ];

  @override
  String get pageTitle => 'Page Text Extraction';

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
    switch (action) {
      case 'Extract Current Page Text':
        _extractCurrentPageText(controller);
        break;
      case 'Extract First Text Line':
        _extractFirstTextLine(controller);
        break;
      case 'Extract Text From Rect':
        _extractTextFromRect(controller);
        break;
    }
  }

  Future<void> _extractCurrentPageText(
    CPDFReaderWidgetController controller,
  ) async {
    try {
      final pageIndex = await controller.getCurrentPageIndex();
      final CPDFPage page = controller.document.pageAtIndex(pageIndex);
      final text = await page.getAllText();

      if (!mounted) {
        return;
      }

      await _showTextDialog(
        title: 'Page ${pageIndex + 1} Text',
        text: _contentOrEmptyMessage(text),
      );
    } catch (e) {
      _showError('Extract current page text failed: $e');
    }
  }

  Future<void> _extractFirstTextLine(
    CPDFReaderWidgetController controller,
  ) async {
    try {
      final pageIndex = await controller.getCurrentPageIndex();
      final CPDFPage page = controller.document.pageAtIndex(pageIndex);
      final line = await _findFirstTextLine(page);

      if (!mounted) {
        return;
      }

      if (line == null) {
        SnackBarHelper.warning(
          context,
          message: 'No text line found on the current page.',
        );
        return;
      }

      final text = await page.getTextByLine(line);
      await controller.setDisplayPageIndex(
        pageIndex: line.pageIndex,
        rectList: [line.rect],
      );

      if (!mounted) {
        return;
      }

      await _showTextDialog(
        title: 'Page ${line.pageIndex + 1}, Line ${line.lineIndex + 1}',
        text: [
          'Line index: ${line.lineIndex}',
          'Range: ${line.location}, ${line.length}',
          'Rect: ${_formatRect(line)}',
          '',
          _contentOrEmptyMessage(text),
        ].join('\n'),
      );
    } catch (e) {
      _showError('Extract first text line failed: $e');
    }
  }

  Future<void> _extractTextFromRect(
    CPDFReaderWidgetController controller,
  ) async {
    try {
      final pageIndex = await controller.getCurrentPageIndex();
      final CPDFPage page = controller.document.pageAtIndex(pageIndex);
      final line = await _findFirstTextLine(page);

      if (!mounted) {
        return;
      }

      if (line == null) {
        SnackBarHelper.warning(
          context,
          message: 'No text line found on the current page.',
        );
        return;
      }

      final text = await page.getTextInRect(line.rect);
      await controller.setDisplayPageIndex(
        pageIndex: line.pageIndex,
        rectList: [line.rect],
      );

      if (!mounted) {
        return;
      }

      await _showTextDialog(
        title: 'Rect Text - Page ${line.pageIndex + 1}',
        text: [
          'Rect: ${_formatRect(line)}',
          'Text length: ${text.length}',
          '',
          _contentOrEmptyMessage(text),
        ].join('\n'),
      );
    } catch (e) {
      _showError('Extract text from rect failed: $e');
    }
  }

  Future<CPDFTextLine?> _findFirstTextLine(CPDFPage page) async {
    final lines = await page.getTextLines();
    for (final line in lines) {
      final text = await page.getTextByLine(line);
      if (text.trim().isNotEmpty) {
        return line;
      }
    }
    return null;
  }

  Future<void> _showTextDialog({
    required String title,
    required String text,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.of(dialogContext).size.height;
        final dialogHeight =
            (screenHeight * 0.42).clamp(220.0, 360.0).toDouble();

        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: dialogHeight,
            child: SingleChildScrollView(
              child: SelectableText(text),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _contentOrEmptyMessage(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? 'No text content found.' : text;
  }

  String _formatRect(CPDFTextLine line) {
    final rect = line.rect;
    return 'left ${_round(rect.left)}, top ${_round(rect.top)}, '
        'right ${_round(rect.right)}, bottom ${_round(rect.bottom)}';
  }

  double _round(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    SnackBarHelper.error(context, message: message);
  }
}
