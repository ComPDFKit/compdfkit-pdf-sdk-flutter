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

/// Panel displaying PDF creation and production metadata.
///
/// This panel shows document creation information and technical details:
/// - **Version**: PDF specification version (e.g., "PDF 1.7")
/// - **Page Count**: Total number of pages in the document
/// - **Creator**: Application that created the original document
/// - **Producer**: PDF software that generated the PDF file
/// - **Creation Date**: When the document was first created (local timezone)
/// - **Modification Date**: Last modification timestamp (local timezone)
///
/// Data is reactively fetched from [PdfInfoController] using GetX state management.
/// Dates are converted to local timezone for display. The panel includes a section
/// header and uses [PdfInfoItem] for each field.
///
/// Example usage:
/// ```dart
/// // Used in PdfInfoContent to show creation metadata section
/// Column(
///   children: [
///     PdfBasicInfoPanel(),
///     PdfCreateInfoPanel(),    // Shows version, dates, etc.
///     PdfPermissionsInfoPanel(),
///   ],
/// )
/// ```
class PdfCreateInfoPanel extends GetView<PdfInfoController> {
  const PdfCreateInfoPanel({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CPDFInfo info = controller.state.pdfInfo.value;
      return Column(
        children: [
          PdfInfoHead(
              title: PdfLocaleKeys.createInfo.tr, icon: Icons.info_outline),
          PdfInfoItem(
            title: PdfLocaleKeys.version.tr,
            content: controller.state.documentVersion.value,
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.pageCount.tr,
            content: '${controller.state.pageCount.value}',
          ),
          PdfInfoItem(title: PdfLocaleKeys.creator.tr, content: info.creator),
          PdfInfoItem(title: PdfLocaleKeys.producer.tr, content: info.producer),
          PdfInfoItem(
            title: PdfLocaleKeys.creationDate.tr,
            content: _formatDate(info.creationDate),
          ),
          PdfInfoItem(
            title: PdfLocaleKeys.modificationDate.tr,
            content: _formatDate(info.modificationDate),
          ),
        ],
      );
    });
  }
}
