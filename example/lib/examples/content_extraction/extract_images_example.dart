// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Demonstrates extracting embedded images from the current reader document.
class ExtractImagesExample extends StatelessWidget {
  const ExtractImagesExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Extract Images',
      assetPath: _assetPath,
      builder: (path) => _ExtractImagesPage(documentPath: path),
    );
  }
}

class _ExtractImagesPage extends ExampleBase {
  const _ExtractImagesPage({required super.documentPath});

  @override
  State<_ExtractImagesPage> createState() => _ExtractImagesPageState();
}

class _ExtractImagesPageState extends ExampleBaseState<_ExtractImagesPage> {
  bool _isExtracting = false;
  List<String> _imagePaths = [];

  @override
  String get pageTitle => 'Extract Images';

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
  List<String> get menuActions => [
        _isExtracting ? 'Extracting Images...' : 'Extract Images',
        if (_imagePaths.isNotEmpty) 'View Extracted Images',
        if (_imagePaths.isNotEmpty) 'Clear Preview',
      ];

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case 'Extract Images':
        _extractImages(controller);
        break;
      case 'View Extracted Images':
        _showImagePreviewDialog();
        break;
      case 'Clear Preview':
        _clearPreview();
        break;
    }
  }

  Future<void> _extractImages(CPDFReaderWidgetController controller) async {
    if (_isExtracting) {
      return;
    }

    setState(() {
      _isExtracting = true;
      _imagePaths = [];
    });

    try {
      final tempDir = await ComPDFKit.getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputDir = Directory(
        '${tempDir.path}${Platform.pathSeparator}extracted_images_$timestamp',
      );
      if (await outputDir.exists()) {
        await outputDir.delete(recursive: true);
      }
      await outputDir.create(recursive: true);

      final result = await controller.document.extractImages(
        directoryPath: outputDir.path,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _imagePaths = result.imagePaths;
        _isExtracting = false;
      });

      if (!result.success) {
        await _showImageResultDialog(
          message: 'Extract images failed.',
        );
        return;
      }

      await _showImageResultDialog(
        message: result.imagePaths.isEmpty
            ? 'No embedded images were extracted.'
            : null,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isExtracting = false;
      });
      await _showImageResultDialog(message: 'Extract images failed: $e');
    }
  }

  Future<void> _showImagePreviewDialog() {
    return _showImageResultDialog();
  }

  Future<void> _showImageResultDialog({String? message}) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.of(dialogContext).size.height;
        final dialogHeight =
            (screenHeight * 0.58).clamp(280.0, 520.0).toDouble();

        return AlertDialog(
          title: const Text('Extracted Images'),
          content: SizedBox(
            width: double.maxFinite,
            height: dialogHeight,
            child: message != null
                ? Center(child: Text(message, textAlign: TextAlign.center))
                : GridView.builder(
                    itemCount: _imagePaths.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 148,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final path = _imagePaths[index];
                      return InkWell(
                        onTap: () => _showSingleImageDialog(path),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.file(
                              File(path),
                              fit: BoxFit.contain,
                              cacheWidth: 320,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
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

  Future<void> _showSingleImageDialog(String path) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.of(dialogContext).size.height;
        final imageHeight =
            (screenHeight * 0.68).clamp(320.0, 680.0).toDouble();

        return AlertDialog(
          contentPadding: const EdgeInsets.all(12),
          content: SizedBox(
            width: double.maxFinite,
            height: imageHeight,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.file(
                File(path),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image_outlined),
                  );
                },
              ),
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

  void _clearPreview() {
    setState(() {
      _imagePaths = [];
    });
  }
}
