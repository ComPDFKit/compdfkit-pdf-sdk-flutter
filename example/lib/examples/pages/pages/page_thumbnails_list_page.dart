// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../../widgets/app_toolbar.dart';

/// Page thumbnails list page
///
/// Displays a grid of thumbnail images for all pages in the PDF document.
class PageThumbnailsListPage extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const PageThumbnailsListPage({
    super.key,
    required this.controller,
  });

  @override
  State<PageThumbnailsListPage> createState() => _PageThumbnailsListPageState();
}

class _PageThumbnailsListPageState extends State<PageThumbnailsListPage> {
  int _pageCount = 0;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPageCount();
    _loadCurrentPageIndex();
  }

  Future<void> _loadPageCount() async {
    final count = await widget.controller.document.getPageCount();
    if (!mounted) return;
    setState(() {
      _pageCount = count;
    });
  }

  Future<void> _loadCurrentPageIndex() async {
    final pageIndex = await widget.controller.getCurrentPageIndex();
    if (!mounted) return;
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Page Thumbnails',
            subtitle: '$_pageCount pages',
            onBack: () => Navigator.pop(context),
          ),
        ),
      ),
      body: _pageCount == 0
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: _pageCount,
              itemBuilder: (context, index) {
                final isCurrentPage = index == _currentPageIndex;

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: isCurrentPage ? 8 : 4,
                  shadowColor: isCurrentPage
                      ? colorScheme.primary.withAlpha(102)
                      : Colors.black.withAlpha(77),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isCurrentPage
                        ? BorderSide(
                            color: colorScheme.primary,
                            width: 2.5,
                          )
                        : BorderSide.none,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildThumbnailContent(index, colorScheme),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentPage
                              ? colorScheme.primary.withAlpha(26)
                              : colorScheme.surfaceContainerHighest,
                          border: Border(
                            top: BorderSide(
                              color: isCurrentPage
                                  ? colorScheme.primary.withAlpha(77)
                                  : colorScheme.outlineVariant.withAlpha(51),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Page ${index + 1}',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: isCurrentPage
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: isCurrentPage
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildThumbnailContent(int index, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _navigateToPage(index),
      child: Container(
        color: colorScheme.surfaceContainerHighest,
        child: CPDFPageThumbnail.document(
          document: widget.controller.document,
          pageIndex: index,
          options: const CPDFPageThumbnailOptions(
            width: 300,
            compression: CPDFPageCompression.jpeg,
          ),
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error rendering thumbnail for page $index: $error');
            return Icon(
              Icons.broken_image_outlined,
              size: 32,
              color: colorScheme.outline,
            );
          },
        ),
      ),
    );
  }

  Future<void> _navigateToPage(int pageIndex) async {
    await widget.controller.setDisplayPageIndex(pageIndex: pageIndex);
    await _loadCurrentPageIndex();
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
