// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../../widgets/snack_bar_helper.dart';
import '../shared/example_document_loader.dart';

/// Flatten Annotations Example
///
/// Demonstrates how to flatten all annotations into page content,
/// save the flattened result as a new file, and reopen that file.
///
/// This example shows:
/// - Saving the current ink annotation before flattening
/// - Using [CPDFDocument.flattenAllPages] to generate a new PDF file
/// - Showing a success dialog with the output file path
/// - Reopening the flattened document with [CPDFDocument.open]
class FlattenAnnotationsExample extends StatelessWidget {
  /// Constructor.
  const FlattenAnnotationsExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Flatten Annotations',
      assetPath: _assetPath,
      builder: (path) => _FlattenAnnotationsPage(documentPath: path),
    );
  }
}

class _FlattenAnnotationsPage extends ExampleBase {
  const _FlattenAnnotationsPage({required super.documentPath});

  @override
  State<_FlattenAnnotationsPage> createState() =>
      _FlattenAnnotationsPageState();
}

class _FlattenAnnotationsPageState
    extends ExampleBaseState<_FlattenAnnotationsPage> {
  static const List<String> _menuActions = ['Flatten Annotations'];

  @override
  String get pageTitle => 'Flatten Annotations';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig:
            const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
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
      case 'Flatten Annotations':
        _flattenAnnotations(controller);
        break;
    }
  }

  Future<void> _flattenAnnotations(
    CPDFReaderWidgetController controller,
  ) async {
    await controller.saveCurrentInk();

    final savePath = await _buildFlattenedSavePath(controller);
    final result = await controller.document.flattenAllPages(savePath, true);

    if (!mounted) {
      return;
    }

    if (!result) {
      SnackBarHelper.error(
        context,
        message: 'Failed to flatten annotations',
      );
      return;
    }

    await _showFlattenSuccessDialog(controller, savePath);
  }

  Future<String> _buildFlattenedSavePath(
    CPDFReaderWidgetController controller,
  ) async {
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    final fileName = await controller.document.getFileName();
    final dotIndex = fileName.lastIndexOf('.');
    final hasExtension = dotIndex > 0;
    final fileNameWithoutExtension =
        hasExtension ? fileName.substring(0, dotIndex) : fileName;
    final extension = hasExtension ? fileName.substring(dotIndex) : '.pdf';

    var counter = 0;
    while (true) {
      final suffix = counter == 0 ? '_flattened' : '_flattened($counter)';
      final candidatePath =
          '${tempDir.path}/$fileNameWithoutExtension$suffix$extension';
      final candidateFile = File(candidatePath);
      if (!await candidateFile.exists()) {
        return candidatePath;
      }
      counter++;
    }
  }

  Future<void> _showFlattenSuccessDialog(
    CPDFReaderWidgetController controller,
    String flattenedPath,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Flatten completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The flattened document has been saved successfully.'),
              const SizedBox(height: 12),
              SelectableText(flattenedPath),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async{
                await controller.reloadPages2();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Confirm'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final openResult =
                    await controller.document.open(flattenedPath);
                if (!mounted) {
                  return;
                }
                if (openResult == CPDFDocumentError.success) {
                  SnackBarHelper.success(
                    context,
                    message: 'Opened flattened document',
                  );
                } else {
                  SnackBarHelper.error(
                    context,
                    message:
                        'Failed to open flattened document: ${openResult.name}',
                  );
                }
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }
}
