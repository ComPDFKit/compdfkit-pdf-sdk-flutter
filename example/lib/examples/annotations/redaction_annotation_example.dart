// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_redact_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_text_attribute.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/util/cpdf_rectf.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// Demonstrates creating, reading, updating, and applying redactions.
class RedactionAnnotationExample extends StatelessWidget {
  const RedactionAnnotationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Redaction Annotation',
      assetPath: AppAssets.pdfDocument,
      shouldOverwrite: true,
      builder: (path) => _RedactionAnnotationPage(documentPath: path),
    );
  }
}

class _RedactionAnnotationPage extends ExampleBase {
  const _RedactionAnnotationPage({required super.documentPath});

  @override
  State<_RedactionAnnotationPage> createState() =>
      _RedactionAnnotationPageState();
}

class _RedactionAnnotationPageState
    extends ExampleBaseState<_RedactionAnnotationPage> {
  static const String _create = 'Create Four Redactions';
  static const String _read = 'Read Redaction';
  static const String _update = 'Update Redaction Style';
  static const String _applyOne = 'Apply First Redaction';
  static const String _applyAll = 'Apply All Redactions';

  @override
  String get pageTitle => 'Redaction Annotation';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig:
            const CPDFModeConfig(initialViewMode: CPDFViewMode.annotations),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
      );

  @override
  List<String> get menuActions => const [
        _create,
        _read,
        _update,
        _applyOne,
        _applyAll,
      ];

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    switch (action) {
      case _create:
        _createRedaction(controller);
        break;
      case _read:
        _readRedaction(controller);
        break;
      case _update:
        _updateRedaction(controller);
        break;
      case _applyOne:
        _applyFirstRedaction(controller);
        break;
      case _applyAll:
        _applyAllRedactions(controller);
        break;
    }
  }

  Future<void> _createRedaction(CPDFReaderWidgetController controller) async {
    final success = await controller.document.addAnnotations([
      CPDFRedactAnnotation(
        page: 0,
        title: 'Redaction A',
        rect: const CPDFRectF(left: 72, top: 220, right: 300, bottom: 180),
        overlayText: 'REDACTED A',
        fillColor: Colors.black,
        outlineColor: Colors.red,
        textAttribute: CPDFTextAttribute(
          color: Colors.white,
          familyName: 'Helvetica',
          styleName: 'Regular',
          fontSize: 12,
        ),
        alignment: CPDFAlignment.center,
      ),
      CPDFRedactAnnotation(
        page: 0,
        title: 'Redaction B',
        rect: const CPDFRectF(left: 120, top: 330, right: 360, bottom: 285),
        overlayText: 'REDACTED B',
        fillColor: Colors.blueGrey,
        outlineColor: Colors.blue,
        textAttribute: CPDFTextAttribute(
          color: Colors.yellow,
          familyName: 'Helvetica',
          styleName: 'Bold',
          fontSize: 12,
        ),
        alignment: CPDFAlignment.right,
      ),
      CPDFRedactAnnotation(
        page: 0,
        title: 'Redaction CCC',
        rect: const CPDFRectF(left: 72, top: 440, right: 300, bottom: 395),
        overlayText: 'REDACTED A',
        fillColor: Colors.lightGreen,
        outlineColor: Colors.red,
        textAttribute: CPDFTextAttribute(
          color: Colors.white,
          familyName: 'Helvetica',
          styleName: 'Regular',
          fontSize: 12,
        ),
        alignment: CPDFAlignment.center,
      ),
      CPDFRedactAnnotation(
        page: 0,
        title: 'Redaction DDD',
        rect: const CPDFRectF(left: 120, top: 550, right: 360, bottom: 505),
        overlayText: 'REDACTED B',
        fillColor: Colors.deepPurpleAccent,
        outlineColor: Colors.blue,
        textAttribute: CPDFTextAttribute(
          color: Colors.white,
          familyName: 'Helvetica',
          styleName: 'Bold',
          fontSize: 12,
        ),
        alignment: CPDFAlignment.right,
      ),
    ]);
    _showMessage(
      success ? 'Four redactions created.' : 'Unable to create redactions.',
    );
  }

  Future<void> _readRedaction(CPDFReaderWidgetController controller) async {
    final redact = await _firstRedaction(controller);
    if (redact == null) {
      _showMessage('Create a redaction first.');
      return;
    }
    _showMessage(
      'Overlay: ${redact.overlayText}; alignment: ${redact.alignment.name}',
    );
  }

  Future<void> _updateRedaction(CPDFReaderWidgetController controller) async {
    final redact = await _firstRedaction(controller);
    if (redact == null) {
      _showMessage('Create a redaction first.');
      return;
    }
    redact.overlayText = 'CONFIDENTIAL';
    redact.fillColor = const Color(0xFF263238);
    redact.outlineColor = Colors.orange;
    redact.alignment = CPDFAlignment.right;
    redact.textAttribute = CPDFTextAttribute(
      color: Colors.amber,
      familyName: 'Helvetica',
      styleName: 'Bold',
      fontSize: 14,
    );
    final success = await controller.document.updateAnnotation(redact);
    _showMessage(success ? 'Redaction style updated.' : 'Update failed.');
  }

  Future<void> _applyFirstRedaction(
    CPDFReaderWidgetController controller,
  ) async {
    final redact = await _firstRedaction(controller);
    if (redact == null) {
      _showMessage('Create a redaction first.');
      return;
    }
    if (!await _confirm('Apply the first redaction permanently?')) {
      return;
    }
    try {
      await controller.document.applyRedaction(redact);
      _showMessage('First redaction applied.');
    } catch (error) {
      debugPrint('Failed to apply redaction: $error');
      _showMessage('Failed to apply the first redaction.');
    }
  }

  Future<void> _applyAllRedactions(
    CPDFReaderWidgetController controller,
  ) async {
    if (!await _confirm(
        'Apply every redaction in this document permanently?')) {
      return;
    }
    try {
      await controller.document.applyRedactions();
      _showMessage('All redactions applied.');
    } catch (error) {
      debugPrint('Failed to apply all redactions: $error');
      _showMessage('Failed to apply all redactions.');
    }
  }

  Future<CPDFRedactAnnotation?> _firstRedaction(
    CPDFReaderWidgetController controller,
  ) async {
    final CPDFPage page = controller.document.pageAtIndex(0);
    final annotations = await page.getAnnotations();
    for (final annotation in annotations) {
      if (annotation is CPDFRedactAnnotation) {
        return annotation;
      }
    }
    return null;
  }

  Future<bool> _confirm(String message) async {
    if (!mounted) {
      return false;
    }
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permanent redaction'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Apply'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
