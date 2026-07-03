// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../shared/api_example_base.dart';

/// Demonstrates using PDF page thumbnails directly as an ImageProvider.
class PageThumbnailProviderExample extends ApiExampleBase {
  const PageThumbnailProviderExample({super.key});

  @override
  String get assetPath => AppAssets.pdfDocument;

  @override
  String get title => 'Page Thumbnail Provider';

  @override
  bool get shouldOverwriteAsset => false;

  @override
  State<PageThumbnailProviderExample> createState() =>
      _PageThumbnailProviderExampleState();
}

class _PageThumbnailProviderExampleState
    extends ApiExampleBaseState<PageThumbnailProviderExample> {
  int _pageIndex = 0;
  int _pageCount = 0;
  int _cacheVersion = 0;
  int _imageRefreshVersion = 0;
  bool _isDocumentReady = false;
  bool _useFlutterImageCache = true;
  bool _simulateRenderFailure = false;
  final CPDFPageThumbnailService _failingThumbnailService =
      CPDFPageThumbnailService(
    renderer: const _FailingPageThumbnailRenderer(),
    diskCache: const _NoopPageThumbnailDiskCache(),
  );

  @override
  void onDocumentReady() {
    setState(() {
      _isDocumentReady = true;
    });
    _loadPageCount();
  }

  @override
  List<Widget> buildExampleContent(BuildContext context) {
    if (!_isDocumentReady) {
      return const [
        SizedBox(
          height: 260,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final provider = CPDFPageThumbnailProvider.document(
      document: document,
      pageIndex: _pageIndex,
      cacheVersion: _cacheVersion,
      service: _simulateRenderFailure ? _failingThumbnailService : null,
      useFlutterImageCache:
          _simulateRenderFailure ? false : _useFlutterImageCache,
      options: const CPDFPageThumbnailOptions(
        drawAnnot: false,
        width: 800,
        compression: CPDFPageCompression.jpeg,
        cachePolicy: CPDFPageThumbnailCachePolicy.memoryAndDisk,
        backgroundColor: Colors.white,
      ),
    );

    return [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: _pageCount <= 0 ? null : _previousPage,
              child: const Text('Previous'),
            ),
            TextButton(
              onPressed: _pageCount <= 0 ? null : _nextPage,
              child: const Text('Next'),
            ),
            TextButton(
              onPressed: _clearThumbnailCache,
              child: const Text('Clear Cache'),
            ),
            FilterChip(
              selected: _useFlutterImageCache,
              label: const Text('Use Flutter Cache'),
              onSelected: _simulateRenderFailure
                  ? null
                  : (selected) {
                      setState(() {
                        _useFlutterImageCache = selected;
                        _imageRefreshVersion++;
                      });
                      applyLog(
                        selected
                            ? 'Flutter image cache enabled.'
                            : 'Flutter image cache disabled.',
                      );
                    },
            ),
            FilterChip(
              selected: _simulateRenderFailure,
              label: const Text('Simulate Error'),
              onSelected: (selected) {
                setState(() {
                  _simulateRenderFailure = selected;
                  _imageRefreshVersion++;
                });
                applyLog(
                  selected
                      ? 'Simulated thumbnail render failure enabled.'
                      : 'Simulated thumbnail render failure disabled.',
                );
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
            'Page ${_pageIndex + 1} / ${_pageCount == 0 ? '-' : _pageCount}'),
      ),
      SizedBox(
        height: 260,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image(
                key: ValueKey(
                  'page-thumbnail-$_pageIndex-$_cacheVersion-$_imageRefreshVersion-$_simulateRenderFailure',
                ),
                image: provider,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: 180,
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.broken_image_outlined),
                          const SizedBox(height: 8),
                          Text(
                            'Thumbnail failed',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> _loadPageCount() async {
    final count = await document.getPageCount();
    if (!mounted) {
      return;
    }
    setState(() {
      _pageCount = count;
    });
    applyLog('Page count: $count');
  }

  void _previousPage() {
    if (_pageCount == 0) {
      return;
    }
    setState(() {
      _pageIndex = (_pageIndex - 1 + _pageCount) % _pageCount;
    });
  }

  void _nextPage() {
    if (_pageCount == 0) {
      return;
    }
    setState(() {
      _pageIndex = (_pageIndex + 1) % _pageCount;
    });
  }

  void _clearThumbnailCache() {
    setState(() {
      _cacheVersion++;
      _imageRefreshVersion++;
    });
    CPDFPageThumbnailService.shared.clearCache();
    applyLog('Thumbnail cache cleared.');
  }
}

class _FailingPageThumbnailRenderer implements CPDFPageThumbnailRenderer {
  const _FailingPageThumbnailRenderer();

  @override
  Future<CPDFPageThumbnailPageMetrics> getPageMetrics(
    CPDFPageThumbnailSource source,
    int pageIndex,
  ) async {
    return const CPDFPageThumbnailPageMetrics(
      size: Size(595, 842),
      rotation: 0,
    );
  }

  @override
  Future<Uint8List> render(CPDFPageThumbnailKey key) async {
    throw const CPDFPageThumbnailRenderException(
      'Simulated thumbnail render failure.',
    );
  }
}

class _NoopPageThumbnailDiskCache implements CPDFPageThumbnailDiskCache {
  const _NoopPageThumbnailDiskCache();

  @override
  Future<void> clear() async {}

  @override
  Future<void> remove(CPDFPageThumbnailKey key) async {}

  @override
  Future<Uint8List?> read(CPDFPageThumbnailKey key) async => null;

  @override
  Future<void> write(CPDFPageThumbnailKey key, Uint8List bytes) async {}
}
