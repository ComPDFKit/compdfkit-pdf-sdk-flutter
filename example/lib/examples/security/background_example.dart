// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/document/cpdf_background.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import 'dialogs/background_details_dialog.dart';

/// Demonstrates visible document background CRUD in a PDF reader.
class BackgroundExample extends StatelessWidget {
  const BackgroundExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Document Background',
      assetPath: AppAssets.pdfDocument,
      builder: (path) => _BackgroundPage(documentPath: path),
    );
  }
}

class _BackgroundPage extends ExampleBase {
  const _BackgroundPage({required super.documentPath});

  @override
  State<_BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends ExampleBaseState<_BackgroundPage> {
  static const List<String> _menuActions = [
    'Add Color Background',
    'Add Image Background',
    'Read Background',
    'Update Background',
    'Clear Background',
  ];

  @override
  String get pageTitle => 'Document Background';

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
      case 'Add Color Background':
        _addColorBackground(controller);
        break;
      case 'Add Image Background':
        _addImageBackground(controller);
        break;
      case 'Read Background':
        _readBackground(controller);
        break;
      case 'Update Background':
        _updateBackground(controller);
        break;
      case 'Clear Background':
        _clearBackground(controller);
        break;
    }
  }

  Future<void> _addColorBackground(
    CPDFReaderWidgetController controller,
  ) async {
    final success = await controller.document.updateBackground(
      CPDFBackground.color(
        pages: await _allPages(controller),
        color: Colors.amber,
        opacity: 0.35,
      ),
    );
    _showMessage(
      success ? 'Color background added' : 'Failed to add color background',
    );
  }

  Future<void> _addImageBackground(
    CPDFReaderWidgetController controller,
  ) async {
    final image = await extractAsset(AppAssets.logo);
    final success = await controller.document.updateBackground(
      CPDFBackground.image(
        pages: await _allPages(controller),
        imagePath: image.path,
        opacity: 0.25,
        scale: 0.5,
      ),
    );
    _showMessage(
      success ? 'Image background added' : 'Failed to add image background',
    );
  }

  Future<void> _readBackground(
    CPDFReaderWidgetController controller,
  ) async {
    final value = await controller.document.getBackground();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => BackgroundDetailsDialog(value: value),
    );
  }

  Future<void> _updateBackground(
    CPDFReaderWidgetController controller,
  ) async {
    final current = await controller.document.getBackground();
    if (current == null) {
      _showMessage('No background to update');
      return;
    }

    final CPDFBackground updated;
    if (current.type == CPDFBackgroundType.color) {
      updated = CPDFBackground.color(
        pages: current.pages,
        color: Colors.lightBlue,
        opacity: 0.55,
        scale: current.scale,
        rotation: 15,
        horizontalAlignment: current.horizontalAlignment,
        verticalAlignment: current.verticalAlignment,
        horizontalOffset: current.horizontalOffset,
        verticalOffset: current.verticalOffset,
        allowView: current.allowView,
        allowPrint: current.allowPrint,
      );
    } else {
      final image = await extractAsset(AppAssets.logo);
      updated = CPDFBackground.image(
        pages: current.pages,
        imagePath: image.path,
        opacity: 0.45,
        scale: current.scale,
        rotation: 15,
        horizontalAlignment: current.horizontalAlignment,
        verticalAlignment: current.verticalAlignment,
        horizontalOffset: current.horizontalOffset,
        verticalOffset: current.verticalOffset,
        allowView: current.allowView,
        allowPrint: current.allowPrint,
      );
    }

    final success = await controller.document.updateBackground(updated);
    _showMessage(
        success ? 'Background updated' : 'Failed to update background');
  }

  Future<void> _clearBackground(
    CPDFReaderWidgetController controller,
  ) async {
    final success = await controller.document.clearBackground();
    _showMessage(success ? 'Background cleared' : 'Failed to clear background');
  }

  Future<List<int>> _allPages(
    CPDFReaderWidgetController controller,
  ) async {
    final count = await controller.document.getPageCount();
    return List<int>.generate(count, (index) => index);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
