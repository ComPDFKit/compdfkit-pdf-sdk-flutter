// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui' as ui;

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_key.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_service.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Image provider that renders one PDF page as a thumbnail.
class CPDFPageThumbnailProvider extends ImageProvider<CPDFPageThumbnailKey> {
  /// Thumbnail source.
  final CPDFPageThumbnailSource source;

  /// Page index to render.
  final int pageIndex;

  /// Render options.
  final CPDFPageThumbnailOptions options;

  /// Service used to load thumbnails.
  final CPDFPageThumbnailService? service;

  /// Whether Flutter's decoded image cache is used before SDK caches.
  final bool useFlutterImageCache;

  /// Creates a thumbnail provider.
  const CPDFPageThumbnailProvider({
    required this.source,
    required this.pageIndex,
    this.options = const CPDFPageThumbnailOptions(),
    this.service,
    this.useFlutterImageCache = true,
  });

  /// Creates a thumbnail provider from an existing document.
  CPDFPageThumbnailProvider.document({
    required CPDFDocument document,
    required int pageIndex,
    CPDFPageThumbnailOptions options = const CPDFPageThumbnailOptions(),
    Object? cacheVersion,
    CPDFPageThumbnailService? service,
    bool useFlutterImageCache = true,
  }) : this(
          source: CPDFPageThumbnailSource.document(
            document,
            cacheVersion: cacheVersion,
          ),
          pageIndex: pageIndex,
          options: options,
          service: service,
          useFlutterImageCache: useFlutterImageCache,
        );

  /// Creates a thumbnail provider from a file path.
  CPDFPageThumbnailProvider.file({
    required String filePath,
    required int pageIndex,
    String password = '',
    CPDFPageThumbnailOptions options = const CPDFPageThumbnailOptions(),
    CPDFPageThumbnailService? service,
    bool useFlutterImageCache = true,
  }) : this(
          source: CPDFPageThumbnailSource.file(filePath, password: password),
          pageIndex: pageIndex,
          options: options,
          service: service,
          useFlutterImageCache: useFlutterImageCache,
        );

  @override
  Future<CPDFPageThumbnailKey> obtainKey(ImageConfiguration configuration) {
    return _service.resolveKey(
      source: source,
      pageIndex: pageIndex,
      options: options,
    );
  }

  @override
  ImageStreamCompleter loadImage(
    CPDFPageThumbnailKey key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: 'CPDFPageThumbnail(${key.cacheKey})',
    );
  }

  @override
  void resolveStreamForKey(
    ImageConfiguration configuration,
    ImageStream stream,
    CPDFPageThumbnailKey key,
    ImageErrorListener handleError,
  ) {
    if (!useFlutterImageCache) {
      _logCacheDisabled(key);
      if (stream.completer != null) {
        return;
      }
      stream.setCompleter(
        loadImage(
          key,
          PaintingBinding.instance.instantiateImageCodecWithSize,
        ),
      );
      return;
    }
    if (kDebugMode) {
      final status = PaintingBinding.instance.imageCache.statusForKey(key);
      if (status.keepAlive || status.live) {
        _logCacheHit(key, 'flutterCache');
      } else if (status.pending) {
        _logCacheHit(key, 'flutterCachePending');
      }
    }
    super.resolveStreamForKey(configuration, stream, key, handleError);
  }

  Future<ui.Codec> _loadAsync(
    CPDFPageThumbnailKey key,
    ImageDecoderCallback decode,
  ) async {
    final bytes = await _service.load(key);
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  /// Evicts this thumbnail from Flutter image cache and SDK disk cache.
  Future<bool> evictThumbnail({
    ImageCache? cache,
    ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    final key = await obtainKey(configuration);
    await _service.evict(key);
    return evict(cache: cache, configuration: configuration);
  }

  CPDFPageThumbnailService get _service =>
      service ?? CPDFPageThumbnailService.shared;

  void _logCacheHit(CPDFPageThumbnailKey key, String source) {
    debugPrint(
      '[CPDFPageThumbnail] P${key.pageIndex + 1} <- $source '
      'index=${key.pageIndex} size=${key.width}x${key.height} '
      'format=${key.options.compression.name} '
      'pdf=${key.source.describeSync()}',
    );
  }

  void _logCacheDisabled(CPDFPageThumbnailKey key) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(
      '[CPDFPageThumbnail] P${key.pageIndex + 1} skip flutterCache '
      'index=${key.pageIndex} size=${key.width}x${key.height} '
      'format=${key.options.compression.name} '
      'pdf=${key.source.describeSync()}',
    );
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CPDFPageThumbnailProvider')}'
        '(pageIndex: $pageIndex, width: ${options.width}, height: ${options.height})';
  }
}
