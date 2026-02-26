// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/compdf_viewer.dart';

/// PDF Viewer Module Example
///
/// A GetX route-based PDF viewer page that receives document path via route arguments.
///
/// This page is designed to be registered in GetX routing system and navigated
/// using `Get.toNamed` with document path passed as argument.
///
/// Key classes/APIs used:
/// - [PdfViewerPage]: Full-featured PDF viewer from pdf_viewer module
/// - [PdfViewerBinding]: GetX bindings for controller initialization (used in route registration)
/// - [PdfViewerController]: Controller for PDF viewer state management
///
/// Route Registration:
/// ```dart
/// GetPage(
///   name: PdfViewerRoutes.pdfPage,
///   page: () => const PdfViewerModuleExample(),
///   binding: PdfViewerBinding(),
/// ),
/// ```
///
/// Navigation Usage:
/// ```dart
/// Get.toNamed(PdfViewerRoutes.pdfPage, arguments: {'document': '/path/to/file.pdf'});
/// ```
class PdfViewerModuleExample extends StatelessWidget {
  /// Constructor
  const PdfViewerModuleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final documentPath = arguments?['document'] as String?;

    if (documentPath == null || documentPath.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF Viewer')),
        body: const Center(
          child: Text('Error: No document path provided'),
        ),
      );
    }

    return PdfViewerPage(documentPath: documentPath);
  }
}
