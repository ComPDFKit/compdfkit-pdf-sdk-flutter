// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:get/get.dart';

/// Repository for accessing and managing PDF annotation data.
///
/// This repository provides a data access layer for annotation operations,
/// interfacing with the ComPDFKit SDK to fetch and delete annotations
/// across all pages of the current document.
///
/// **Provided Operations:**
/// - [fetchAnnotations] - Retrieve all annotations from all pages
/// - [removeAnnotations] - Batch delete a list of annotations
///
/// **Usage:**
/// ```dart
/// final repository = AnnotationRepository();
/// final allAnnotations = await repository.fetchAnnotations();
/// await repository.removeAnnotations([annotation1, annotation2]);
/// ```
///
/// All operations depend on an active [PdfViewerController] and its
/// associated document instance.
class AnnotationRepository {
  final PdfViewerController pdfController = Get.find<PdfViewerController>();

  Future<List<CPDFAnnotation>> fetchAnnotations() async {
    final controller = pdfController.readerController.value;
    if (controller == null) return [];

    final List<CPDFAnnotation> annotationList = [];
    final pageCount = await controller.document.getPageCount();
    for (int i = 0; i < pageCount; i++) {
      final page = controller.document.pageAtIndex(i);
      final annotations = await page.getAnnotations();
      annotationList.addAll(annotations);
    }
    return annotationList;
  }

  /// Batch delete annotations
  Future<void> removeAnnotations(List<CPDFAnnotation> annotations) async {
    final controller = pdfController.readerController.value;
    if (controller == null) return;
    for (final ann in annotations) {
      await controller.document.removeAnnotation(ann);
    }
  }
}
