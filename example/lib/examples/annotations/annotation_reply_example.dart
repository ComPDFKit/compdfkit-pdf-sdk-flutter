// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';
import 'annotation_reply_thread_sheet.dart';

/// Annotation Reply Example
///
/// Demonstrates a compact reply thread workflow for annotations.
///
/// Key classes/APIs used:
/// - [CPDFDocument.addAnnotationReply]
/// - [CPDFDocument.getAnnotationReplies]
/// - [CPDFDocument.updateAnnotationReply]
/// - [CPDFDocument.removeAnnotationReply]
/// - [CPDFDocument.removeAllAnnotationReplies]
/// - [CPDFDocument.setAnnotationMarkState]
/// - [CPDFDocument.setAnnotationReviewState]
class AnnotationReplyExample extends StatelessWidget {
  /// Constructor.
  const AnnotationReplyExample({super.key});

  static const String _assetPath = AppAssets.annotTestPdf;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Annotation Replies',
      assetPath: _assetPath,
      builder: (path) => _AnnotationReplyPage(documentPath: path),
    );
  }
}

class _AnnotationReplyPage extends ExampleBase {
  const _AnnotationReplyPage({required super.documentPath});

  @override
  State<_AnnotationReplyPage> createState() => _AnnotationReplyPageState();
}

class _AnnotationReplyPageState extends ExampleBaseState<_AnnotationReplyPage> {
  static const String _repliesAction = 'Replies';

  @override
  String get pageTitle => 'Annotation Replies';

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
  List<String> get menuActions => [_repliesAction];

  @override
  void handleMenuAction(String action, CPDFReaderWidgetController controller) {
    if (action == _repliesAction) {
      _openReplies(controller);
    }
  }

  Future<void> _openReplies(CPDFReaderWidgetController controller) async {
    final pageIndex = await controller.getCurrentPageIndex();
    final page = controller.document.pageAtIndex(pageIndex);
    final annotations = await page.getAnnotations();

    if (!mounted) {
      return;
    }

    if (annotations.isEmpty) {
      await showModalBottomSheet<void>(
        context: context,
        builder: (context) => EmptyAnnotationRepliesSheet(pageIndex: pageIndex),
      );
      return;
    }

    final annotation = annotations.length == 1
        ? annotations.first
        : await _pickAnnotation(controller, pageIndex, annotations);

    if (!mounted || annotation == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.72,
        child: AnnotationReplyThreadSheet(
          controller: controller,
          annotation: annotation,
        ),
      ),
    );
  }

  Future<CPDFAnnotation?> _pickAnnotation(
    CPDFReaderWidgetController controller,
    int pageIndex,
    List<CPDFAnnotation> annotations,
  ) async {
    final replyCounts = <String, int>{};
    for (final annotation in annotations) {
      // Calls CPDFDocument.getAnnotationReplies to show a lightweight reply
      // count before opening the thread for a specific annotation.
      final replies =
          await controller.document.getAnnotationReplies(annotation);
      replyCounts[annotation.uuid] = replies.length;
    }

    if (!mounted) {
      return null;
    }

    return showModalBottomSheet<CPDFAnnotation>(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.56,
        child: AnnotationReplyPickerSheet(
          pageIndex: pageIndex,
          annotations: annotations,
          replyCounts: replyCounts,
        ),
      ),
    );
  }
}
