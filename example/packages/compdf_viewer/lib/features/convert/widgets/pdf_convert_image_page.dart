// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:compdf_viewer/features/convert/controller/pdf_convert_image_controller.dart';
import 'package:compdf_viewer/features/convert/widgets/pdf_page_range_selector_page.dart';
import 'package:compdf_viewer/features/convert/model/pdf_page_range_type.dart';

/// PDF to JPG conversion dialog page.
///
/// Displays a dialog for selecting which pages to convert to images. Shows
/// the current page range selection and provides access to the full range
/// selector page. Returns the selected page indices when confirmed.
///
/// Key features:
/// - Page range selector with dropdown-style trigger
/// - Shows current selection label
/// - Opens PdfPageRangeSelectorPage on tap
/// - Returns selected page indices on confirm
///
/// Usage example:
/// ```dart
/// // In FileMenuActions
/// List<int>? pages = await Get.dialog(PdfConvertImagePage());
/// if (pages != null) {
///   // Convert selected pages to images
///   await PdfPageUtil.pdfToImage(controller, pages);
/// }
/// ```
///
/// Return value:
/// - List of 0-based page indices to convert
/// - null if cancelled
///
/// State management:
/// - Creates temporary PdfConvertImageController
/// - Initializes with current PDF page count
/// - Cleans up controller on dispose
class PdfConvertImagePage extends StatefulWidget {
  const PdfConvertImagePage({super.key});

  @override
  State<PdfConvertImagePage> createState() => _PdfConvertImagePageState();
}

class _PdfConvertImagePageState extends State<PdfConvertImagePage> {
  late final PdfConvertImageController _controller;
  late final PdfViewerController _pdfController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PdfConvertImageController());
    _pdfController = Get.find<PdfViewerController>();
    _controller.initPages(_pdfController.state.pageCount.value);
  }

  @override
  void dispose() {
    Get.delete<PdfConvertImageController>();
    super.dispose();
  }

  void _handlePageRange() async {
    final pageCount = _pdfController.state.pageCount.value;
    final currentPageIndex = _pdfController.state.currentPage.value;
    PageRangeResult? result = await Get.dialog<PageRangeResult>(
      PdfPageRangeSelectorPage(
          totalPage: pageCount, currentPageIndex: currentPageIndex),
    );
    if (result != null) {
      _controller.applyPageRangeResult(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(PdfLocaleKeys.pdfToJpg.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 38,
                child: Text(PdfLocaleKeys.pageRange.tr),
              ),
              Expanded(
                child: Obx(() {
                  return GestureDetector(
                    onTap: _handlePageRange,
                    child: SizedBox(
                      height: 38,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _controller.getPageRangeTitle(
                                  _controller.state.pageRangeType.value,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down_outlined),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Divider(
                              height: 1.0,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(PdfLocaleKeys.cancel.tr),
        ),
        TextButton(
          onPressed: () => Get.back(result: _controller.state.pages.toList()),
          child: Text(PdfLocaleKeys.confirm.tr),
        ),
      ],
    );
  }
}
