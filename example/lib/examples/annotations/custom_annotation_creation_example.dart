// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter_example/widgets/dialogs/link_config_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../features/annotations/signature_list_page.dart';
import '../../features/annotations/stamp_list_page.dart';
import '../../utils/file_util.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import '../../constants/asset_paths.dart';

/// Custom Annotation Creation Example
///
/// Demonstrates intercepting annotation creation for custom UI workflows.
///
/// This example shows:
/// - Disabling auto-show dialogs via [CPDFAnnotationsConfig]
/// - Intercepting [onAnnotationCreationPrepared] callback
/// - Custom signature picker using [SignatureListPage]
/// - Custom stamp picker using [StampListPage]
/// - Custom image picker using [FilePicker]
/// - Custom link configuration with [LinkConfigDialog]
///
/// Key classes/APIs used:
/// - [CPDFAnnotationsConfig.autoShowSignPicker]: Disable built-in signature picker
/// - [CPDFAnnotationsConfig.autoShowStampPicker]: Disable built-in stamp picker
/// - [CPDFReaderWidgetController.addSignAnnot]: Add signature annotation
/// - [CPDFReaderWidgetController.addStampAnnot]: Add stamp annotation
/// - [CPDFLinkAnnotation]: Link annotation configuration
///
/// Usage:
/// 1. Open the example
/// 2. Select signature/stamp/image/link tool from toolbar
/// 3. Custom picker dialogs will appear instead of default ones
class CustomAnnotationCreationExample extends StatelessWidget {
  /// Constructor
  const CustomAnnotationCreationExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Custom Annotation',
      assetPath: _assetPath,
      builder: (path) => _CustomAnnotationCreationPage(documentPath: path),
    );
  }
}

class _CustomAnnotationCreationPage extends ExampleBase {
  const _CustomAnnotationCreationPage({required super.documentPath});

  @override
  State<_CustomAnnotationCreationPage> createState() =>
      _CustomAnnotationCreationPageState();
}

class _CustomAnnotationCreationPageState
    extends ExampleBaseState<_CustomAnnotationCreationPage> {
  @override
  String get pageTitle => 'Custom Annotation';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        modeConfig: const CPDFModeConfig(
          initialViewMode: CPDFViewMode.annotations,
          availableViewModes: [CPDFViewMode.viewer, CPDFViewMode.annotations],
        ),
        toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: true),
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
          autoShowSignPicker: false,
          autoShowLinkDialog: false,
          autoShowPicPicker: false,
          autoShowStampPicker: false,
          availableTypes: [
            CPDFAnnotationType.signature,
            CPDFAnnotationType.stamp,
            CPDFAnnotationType.pictures,
            CPDFAnnotationType.link,
          ],
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  void onAnnotationCreationPrepared(
    CPDFAnnotationType type,
    CPDFAnnotation? annotation,
  ) {
    super.onAnnotationCreationPrepared(type, annotation);
    switch (type) {
      case CPDFAnnotationType.signature:
        _showSignListPage();
        break;
      case CPDFAnnotationType.pictures:
        _showPicturePicker();
        break;
      case CPDFAnnotationType.stamp:
        _setNextStamp();
        break;
      case CPDFAnnotationType.link:
        _showLinkDialog(annotation);
        break;
      default:
        break;
    }
  }

  Future<void> _showSignListPage() async {
    final String? signPath = await showDialog<String?>(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Signature List'),
        content: SignatureListPage(),
      ),
    );
    if (signPath != null) {
      await controller?.prepareNextSignature(signPath);
    }
  }

  Future<void> _showPicturePicker() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        await controller?.prepareNextImage(filePath);
      }
    }
  }

  Future<void> _setNextStamp() async {
    final data = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const StampListPage()),
    );
    if (data == null) {
      return;
    }

    final CPDFStampType type = data['type'];
    if (type == CPDFStampType.standard) {
      final CPDFStandardStamp stamp = data['standardStamp'];
      await controller?.prepareNextStamp(standardStamp: stamp);
    } else if (type == CPDFStampType.image) {
      final String imagePath = data['imagePath'];
      await controller?.prepareNextStamp(imagePath: imagePath);
    }
  }

  Future<void> _showLinkDialog(CPDFAnnotation? annotation) async {
    if (annotation is! CPDFLinkAnnotation) return;

    final action = await showDialog(
      context: context,
      builder: (context) => LinkConfigDialog(),
    );

    if (action != null && mounted) {
      annotation.action = action;
      printJsonString(jsonEncode(annotation.toJson()));
      await controller?.document.updateAnnotation(annotation);
    }
  }
}
