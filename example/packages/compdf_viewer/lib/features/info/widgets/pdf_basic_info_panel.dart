// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/info/controller/pdf_info_controller.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_info_head.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_info_item.dart';

/// Panel displaying basic PDF document information.
///
/// This panel shows fundamental file and document metadata:
/// - **File Name**: Name of the PDF file
/// - **File Size**: Size in megabytes (MB)
/// - **Title**: Document title metadata
/// - **Author**: Document author metadata
///
/// Data is reactively fetched from [PdfInfoController] using GetX state management.
/// The panel includes a section header and uses [PdfInfoItem] for each field.
///
/// Example usage:
/// ```dart
/// // Used in PdfInfoContent to show basic info section
/// SingleChildScrollView(
///   child: Column(
///     children: [
///       PdfBasicInfoPanel(),     // File basics
///       PdfCreateInfoPanel(),    // Creation metadata
///       PdfPermissionsInfoPanel(), // Security settings
///     ],
///   ),
/// )
/// ```
class PdfBasicInfoPanel extends GetView<PdfInfoController> {
  const PdfBasicInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CPDFInfo info = controller.state.pdfInfo.value;
      return Column(
        children: [
          PdfInfoHead(
              title: PdfLocaleKeys.abstract.tr,
              icon: Icons.description_outlined),
          PdfInfoItem(
            title: PdfLocaleKeys.fileName.tr,
            content: controller.state.fileName.value,
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.fileSize.tr,
            content: '${controller.state.fileSizeInMB.toStringAsFixed(2)} MB',
          ),
          PdfInfoItem(title: PdfLocaleKeys.title.tr, content: info.title),
          PdfInfoItem(title: PdfLocaleKeys.author.tr, content: info.author),
        ],
      );
    });
  }
}
