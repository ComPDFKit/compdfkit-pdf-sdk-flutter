// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// Simple dialog for choosing between inserting a blank page or importing from a PDF file.
///
/// This dialog presents two options:
/// - **Blank Page**: Creates a new page using one of the built-in templates
///   (blank, horizontal lines, musical notation, or square grid)
/// - **PDF Page**: Opens a file picker to import pages from an existing PDF
///
/// Returns:
/// - `'blank_page'` if user selects Blank Page
/// - `'pdf_page'` if user selects PDF Page
/// - `null` if dialog is dismissed
///
/// Example usage:
/// ```dart
/// final result = await Get.dialog<String>(InsertPageTypePickerDialog());
///
/// if (result == 'blank_page') {
///   // Show InsertPagesDialog for template selection
///   final pageData = await Get.dialog<InsertPageData>(InsertPagesDialog());
/// } else if (result == 'pdf_page') {
///   // Open file picker to import PDF pages
///   final file = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
/// }
/// ```
class InsertPageTypePickerDialog extends StatelessWidget {
  const InsertPageTypePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          _buildTile(PdfLocaleKeys.blankPage.tr, () {
            Get.back(result: 'blank_page');
          }),
          _buildTile(PdfLocaleKeys.pdfPage.tr, () {
            Get.back(result: 'pdf_page');
          }),
        ],
      ),
    );
  }

  Widget _buildTile(String title, VoidCallback onTap) {
    return ListTile(title: Text(title), onTap: onTap);
  }
}
