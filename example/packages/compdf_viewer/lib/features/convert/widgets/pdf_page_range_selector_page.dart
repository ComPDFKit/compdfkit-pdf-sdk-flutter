// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/utils/pdf_page_util.dart';
import 'package:compdf_viewer/utils/snackbar_util.dart';
import 'package:compdf_viewer/features/convert/model/pdf_page_range_type.dart';

/// Page range selector dialog for PDF operations.
///
/// Provides a radio button interface for selecting which pages to process in
/// PDF operations like conversion to images. Supports predefined ranges (all,
/// odd, even, current) and custom range input with validation.
///
/// Key features:
/// - Radio list for predefined page ranges
/// - Custom range text input (e.g., "1-3,5,8-10")
/// - Real-time validation of custom range syntax
/// - Returns PageRangeResult with type and parsed indices
///
/// Usage example:
/// ```dart
/// PageRangeResult? result = await Get.dialog<PageRangeResult>(
///   PdfPageRangeSelectorPage(
///     totalPage: 20,
///     currentPageIndex: 5,
///   ),
/// );
///
/// if (result != null) {
///   // result.type: PdfPageRangeType
///   // result.pageIndices: [0, 2, 4, ...] (0-based)
/// }
/// ```
///
/// Custom range format:
/// - Single pages: "1,3,5"
/// - Ranges: "1-5,8-10"
/// - Mixed: "1,3-5,7,9-12"
/// - Validation errors shown via SnackbarUtil
///
/// Return value:
/// - PageRangeResult with selected type and parsed page indices
/// - null if cancelled
class PdfPageRangeSelectorPage extends StatefulWidget {
  final int totalPage;
  final int currentPageIndex;

  const PdfPageRangeSelectorPage(
      {super.key, required this.totalPage, required this.currentPageIndex});

  @override
  State<PdfPageRangeSelectorPage> createState() =>
      _PdfPageRangeSelectorPageState();
}

class _PdfPageRangeSelectorPageState extends State<PdfPageRangeSelectorPage> {
  PdfPageRangeType _selected = PdfPageRangeType.all;
  final TextEditingController _customRangeController = TextEditingController();

  @override
  void dispose() {
    _customRangeController.dispose();
    super.dispose();
  }

  Widget _buildRadio({required PdfPageRangeType value, required String title}) {
    return RadioListTile<PdfPageRangeType>(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      dense: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: value,
      groupValue: _selected,
      onChanged: (v) {
        setState(() => _selected = v!);
      },
    );
  }

  void _onConfirm() {
    List<int> pages;
    if (_selected == PdfPageRangeType.custom) {
      try {
        pages = PdfPageUtil.parseCustomPageRange(
            _customRangeController.text, widget.totalPage);
      } catch (e) {
        SnackbarUtil.showTips(PdfLocaleKeys.pageChoosePageRangeInputError.tr);
        return;
      }
    } else {
      pages = PdfPageUtil.parsePageRanges(
          _selected, widget.totalPage, widget.currentPageIndex);
    }
    Get.back(result: PageRangeResult(type: _selected, pageIndices: pages));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        PdfLocaleKeys.pageChooseTitle
            .trParams({'pages': widget.totalPage.toString()}),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadio(
                value: PdfPageRangeType.all,
                title: PdfLocaleKeys.pageChooseAll.tr),
            _buildRadio(
                value: PdfPageRangeType.odd,
                title: PdfLocaleKeys.pageChooseOdd.tr),
            _buildRadio(
                value: PdfPageRangeType.even,
                title: PdfLocaleKeys.pageChooseEven.tr),
            _buildRadio(
                value: PdfPageRangeType.current,
                title: PdfLocaleKeys.pageChooseCurrent.tr),
            _buildRadio(
                value: PdfPageRangeType.custom,
                title: PdfLocaleKeys.pageChoosePageRange.tr),
            TextField(
              controller: _customRangeController,
              enabled: _selected == PdfPageRangeType.custom,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: "1-3,5,8-10",
                border: const UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(PdfLocaleKeys.cancel.tr),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: Text(PdfLocaleKeys.confirm.tr),
        ),
      ],
    );
  }
}
