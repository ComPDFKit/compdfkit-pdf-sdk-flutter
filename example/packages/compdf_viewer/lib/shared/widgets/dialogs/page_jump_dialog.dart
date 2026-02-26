// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';

/// Dialog for jumping to a specific page in the PDF document.
///
/// Features:
/// - Validates input is within page range (1 to page count)
/// - Shows hint with valid range
/// - Clamps input to valid range
/// - Converts 1-based user input to 0-based page index
///
/// Example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => const PageJumpDialog(),
/// );
///
/// // User enters page number → validates → jumps to page → closes dialog
/// ```
class PageJumpDialog extends StatefulWidget {
  const PageJumpDialog({super.key});

  @override
  State<PageJumpDialog> createState() => _PageJumpDialogState();
}

class _PageJumpDialogState extends State<PageJumpDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdfController = Get.find<PdfViewerController>();
    final pageCount = pdfController.state.pageCount.value;

    return AlertDialog(
      title: Text(PdfLocaleKeys.pageJump.tr),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: '1 - $pageCount'),
          validator: (value) {
            final page = int.tryParse(value ?? '');
            if (page == null || page < 1 || page > pageCount) {
              return PdfLocaleKeys.enterPageHint
                  .trParams({'pages': '$pageCount'});
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(PdfLocaleKeys.cancel.tr),
        ),
        TextButton(
          onPressed: _jumpToPage,
          child: Text(PdfLocaleKeys.jump.tr),
        ),
      ],
    );
  }

  void _jumpToPage() {
    final pdfController = Get.find<PdfViewerController>();
    final pageCount = pdfController.state.pageCount.value;
    if (_formKey.currentState!.validate()) {
      final page = int.tryParse(_controller.text.trim()) ?? 1;
      final targetPage = page.clamp(1, pageCount);
      pdfController.jumpToPage(targetPage - 1); // Note: page index is 0-based
      Get.back(); // Close dialog
    }
  }
}
