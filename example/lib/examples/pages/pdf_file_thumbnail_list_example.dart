// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../widgets/app_toolbar.dart';

/// Demonstrates loading thumbnails for a list of PDF files.
class PdfFileThumbnailListExample extends StatelessWidget {
  /// Constructor.
  const PdfFileThumbnailListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PdfFileThumbnailListPage();
  }
}

class _PdfFileThumbnailListPage extends StatefulWidget {
  const _PdfFileThumbnailListPage();

  @override
  State<_PdfFileThumbnailListPage> createState() =>
      _PdfFileThumbnailListPageState();
}

class _PdfFileThumbnailListPageState extends State<_PdfFileThumbnailListPage> {
  static final List<_PdfFileItem> _items = [
    for (int index = 0; index < AppAssets.thumbnailFileListPdfs.length; index++)
      _PdfFileItem(
        title: 'PDF Document - Page ${index + 1}.pdf',
        metadata: '1 page',
        assetPath: AppAssets.thumbnailFileListPdfs[index],
      ),
    const _PdfFileItem(
      title: 'Password_compdfkit_Security_Sample_File.pdf',
      metadata: 'Password protected',
      assetPath: AppAssets.passwordProtectedPdf,
      expectedFailure: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppToolbar(
              title: 'PDF File Thumbnails',
              subtitle: 'Load thumbnails for a list of PDF files',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: _PdfFileList(items: _items),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfFileList extends StatelessWidget {
  final List<_PdfFileItem> items;

  const _PdfFileList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 108,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) => _PdfFileListTile(
        item: items[index],
        index: index,
      ),
    );
  }
}

class _PdfFileListTile extends StatelessWidget {
  static const CPDFPageThumbnailOptions _thumbnailOptions =
      CPDFPageThumbnailOptions(
    width: 320,
    compression: CPDFPageCompression.jpeg,
    cachePolicy: CPDFPageThumbnailCachePolicy.memoryAndDisk,
    backgroundColor: Colors.white,
  );

  final _PdfFileItem item;
  final int index;

  const _PdfFileListTile({
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: index == 0 ? const Radius.circular(8) : Radius.zero,
          bottom: Radius.zero,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PdfThumbnailPreview(
              item: item,
              options: _thumbnailOptions,
              delay: Duration(milliseconds: index * 70),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        item.expectedFailure
                            ? Icons.lock_outline
                            : Icons.picture_as_pdf_outlined,
                        size: 15,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item.metadata,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfThumbnailPreview extends StatefulWidget {
  final _PdfFileItem item;
  final CPDFPageThumbnailOptions options;
  final Duration delay;

  const _PdfThumbnailPreview({
    required this.item,
    required this.options,
    required this.delay,
  });

  @override
  State<_PdfThumbnailPreview> createState() => _PdfThumbnailPreviewState();
}

class _PdfThumbnailPreviewState extends State<_PdfThumbnailPreview> {
  late final Future<File> _fileFuture = Future<void>.delayed(widget.delay)
      .then((_) => extractAsset(widget.item.assetPath));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 76,
      height: 102,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _buildThumbnailContent(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildThumbnailContent(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: FutureBuilder<File>(
        future: _fileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _ThumbnailPlaceholder(colorScheme: colorScheme);
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const _ThumbnailUnavailable();
          }
          return _buildPdfFileThumbnail(
            filePath: snapshot.data!.path,
            colorScheme: colorScheme,
          );
        },
      ),
    );
  }

  /// Renders the first page thumbnail from a PDF file path.
  Widget _buildPdfFileThumbnail({
    required String filePath,
    required ColorScheme colorScheme,
  }) {
    return CPDFPageThumbnail.file(
      filePath: filePath,
      pageIndex: 0,
      options: widget.options,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => _ThumbnailPlaceholder(
        colorScheme: colorScheme,
      ),
      errorBuilder: (context, error, stackTrace) {
        debugPrint(
          'Failed to load thumbnail for ${widget.item.assetPath}: $error',
        );
        return const _ThumbnailUnavailable();
      },
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ThumbnailPlaceholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface.withAlpha(160),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant.withAlpha(170),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbnailUnavailable extends StatelessWidget {
  const _ThumbnailUnavailable();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(
      child: ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
                const SizedBox(height: 6),
                Text(
                  'No preview',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfFileItem {
  final String title;
  final String metadata;
  final String assetPath;
  final bool expectedFailure;

  const _PdfFileItem({
    required this.title,
    required this.metadata,
    required this.assetPath,
    this.expectedFailure = false,
  });
}
