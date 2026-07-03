// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:ui';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_cache.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_exceptions.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_key.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_source.dart';
import 'package:flutter/foundation.dart';

/// Page metrics used to resolve thumbnail cache identity.
class CPDFPageThumbnailPageMetrics {
  /// Creates page metrics.
  const CPDFPageThumbnailPageMetrics({
    required this.size,
    required this.rotation,
  });

  /// Page size.
  final Size size;

  /// Page rotation in degrees.
  final int rotation;
}

/// Renders encoded thumbnail bytes.
abstract class CPDFPageThumbnailRenderer {
  /// Returns the page metrics for [source].
  Future<CPDFPageThumbnailPageMetrics> getPageMetrics(
    CPDFPageThumbnailSource source,
    int pageIndex,
  );

  /// Renders [key] to encoded image bytes.
  Future<Uint8List> render(CPDFPageThumbnailKey key);
}

/// Default renderer backed by [CPDFDocument].
class CPDFDocumentPageThumbnailRenderer implements CPDFPageThumbnailRenderer {
  /// Creates a document renderer.
  const CPDFDocumentPageThumbnailRenderer();

  @override
  Future<CPDFPageThumbnailPageMetrics> getPageMetrics(
      CPDFPageThumbnailSource source, int pageIndex) async {
    return _withDocument(source, (document) async {
      final pageSize = await document.getPageSize(pageIndex);
      final rotation = await document.pageAtIndex(pageIndex).getRotation();
      return CPDFPageThumbnailPageMetrics(
        size: pageSize,
        rotation: rotation,
      );
    });
  }

  @override
  Future<Uint8List> render(CPDFPageThumbnailKey key) {
    return _withDocument(key.source, (document) {
      return document.renderPage(
        pageIndex: key.pageIndex,
        width: key.width,
        height: key.height,
        backgroundColor: key.options.backgroundColor,
        drawAnnot: key.options.drawAnnot,
        drawForm: key.options.drawForm,
        compression: key.options.compression,
      );
    });
  }

  Future<T> _withDocument<T>(
    CPDFPageThumbnailSource source,
    Future<T> Function(CPDFDocument document) action,
  ) async {
    final existingDocument = source.document;
    if (existingDocument != null) {
      return action(existingDocument);
    }

    final filePath = source.filePath;
    if (filePath == null || filePath.isEmpty) {
      throw const CPDFPageThumbnailDocumentException('File path is empty.');
    }
    if (!await File(filePath).exists()) {
      throw CPDFPageThumbnailDocumentException('File not found: $filePath');
    }

    final document = await CPDFDocument.createInstance();
    try {
      final error = await document.open(filePath, password: source.password);
      if (error == CPDFDocumentError.errorPassword) {
        throw const CPDFPageThumbnailPasswordException(
          'Password is required or incorrect for this document.',
        );
      }
      if (error != CPDFDocumentError.success) {
        throw CPDFPageThumbnailDocumentException(
          'Unable to open document: $error',
        );
      }
      return await action(document);
    } finally {
      await document.close();
    }
  }
}

/// Coordinates thumbnail key resolution, cache lookup, and rendering.
class CPDFPageThumbnailService {
  final CPDFPageThumbnailRenderer _renderer;
  final CPDFPageThumbnailDiskCache _diskCache;
  final Map<String, Future<Uint8List>> _inFlightRequests =
      <String, Future<Uint8List>>{};
  final Map<String, Uint8List> _memoryCache = <String, Uint8List>{};

  /// Creates a thumbnail service.
  CPDFPageThumbnailService({
    CPDFPageThumbnailRenderer renderer =
        const CPDFDocumentPageThumbnailRenderer(),
    CPDFPageThumbnailDiskCache diskCache =
        const CPDFPageThumbnailFileDiskCache(),
  })  : _renderer = renderer,
        _diskCache = diskCache;

  static final CPDFPageThumbnailService _shared = CPDFPageThumbnailService();

  /// Shared default service.
  static CPDFPageThumbnailService get shared => _shared;

  /// Resolves an immutable provider key.
  Future<CPDFPageThumbnailKey> resolveKey({
    required CPDFPageThumbnailSource source,
    required int pageIndex,
    required CPDFPageThumbnailOptions options,
  }) async {
    if (pageIndex < 0) {
      throw ArgumentError.value(
          pageIndex, 'pageIndex', 'Must not be negative.');
    }
    options.validate();
    final pageMetrics = await _renderer.getPageMetrics(source, pageIndex);
    final thumbnailSize = options.resolveSize(pageMetrics.size);
    final key = CPDFPageThumbnailKey(
      source: source,
      sourceScope: await source.resolveScope(),
      pageIndex: pageIndex,
      width: thumbnailSize.width,
      height: thumbnailSize.height,
      rotation: _normalizeRotation(pageMetrics.rotation),
      options: options,
    );
    return key;
  }

  /// Loads encoded thumbnail bytes for [key].
  Future<Uint8List> load(CPDFPageThumbnailKey key) async {
    if (key.options.cachePolicy.readsMemory) {
      final cachedBytes = _memoryCache[key.cacheKey];
      if (cachedBytes != null) {
        _logHit(key, source: 'memory');
        return cachedBytes;
      }
    }

    final inFlight = _inFlightRequests[key.cacheKey];
    if (inFlight != null) {
      _logHit(key, source: 'inFlight');
      return inFlight;
    }

    final task = _loadOrRender(key);
    _inFlightRequests[key.cacheKey] = task;
    try {
      final bytes = await task;
      if (key.options.cachePolicy.writesMemory) {
        _memoryCache[key.cacheKey] = bytes;
      }
      return bytes;
    } finally {
      _inFlightRequests.remove(key.cacheKey);
    }
  }

  /// Removes the SDK disk cache entry for [key].
  Future<void> evict(CPDFPageThumbnailKey key) {
    _memoryCache.remove(key.cacheKey);
    _log('P${key.pageIndex + 1} evict ${_summary(key)}');
    return _diskCache.remove(key);
  }

  /// Clears all SDK disk cache entries.
  Future<void> clearCache() {
    _memoryCache.clear();
    _log('clear thumbnail cache');
    return _diskCache.clear();
  }

  Future<Uint8List> _loadOrRender(CPDFPageThumbnailKey key) async {
    if (key.options.cachePolicy.readsDisk) {
      final cachedBytes = await _diskCache.read(key);
      if (cachedBytes != null) {
        _logHit(key, source: 'disk');
        return cachedBytes;
      }
    }

    final stopwatch = Stopwatch();
    try {
      _logRenderStart(key);
      stopwatch.start();
      final bytes = await _renderer.render(key);
      stopwatch.stop();
      if (key.options.cachePolicy.writesDisk) {
        await _diskCache.write(key, bytes);
      }
      _logRenderDone(key, stopwatch.elapsed);
      return bytes;
    } on CPDFPageThumbnailException {
      stopwatch.stop();
      _logRenderFailed(key, duration: stopwatch.elapsed);
      rethrow;
    } catch (e) {
      stopwatch.stop();
      _logRenderFailed(key, duration: stopwatch.elapsed, error: e);
      throw CPDFPageThumbnailRenderException('Unable to render thumbnail: $e');
    }
  }

  void _logHit(
    CPDFPageThumbnailKey key, {
    required String source,
  }) {
    _log('P${key.pageIndex + 1} <- $source ${_summary(key)}');
  }

  void _logRenderStart(CPDFPageThumbnailKey key) {
    _log('P${key.pageIndex + 1} render start ${_summary(key)}');
  }

  void _logRenderDone(CPDFPageThumbnailKey key, Duration duration) {
    _log(
      'P${key.pageIndex + 1} <- render ${_summary(key)} '
      'duration=${duration.inMilliseconds}ms',
    );
  }

  void _logRenderFailed(
    CPDFPageThumbnailKey key, {
    required Duration duration,
    Object? error,
  }) {
    final suffix = error == null ? '' : ' error=$error';
    _log(
      'P${key.pageIndex + 1} render failed ${_summary(key)} '
      'duration=${duration.inMilliseconds}ms$suffix',
    );
  }

  String _summary(CPDFPageThumbnailKey key) {
    return 'index=${key.pageIndex} rotation=${key.rotation} '
        'size=${key.width}x${key.height} '
        'format=${key.options.compression.name} '
        'pdf=${key.source.describeSync()}';
  }

  int _normalizeRotation(int rotation) {
    return rotation % 360;
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[CPDFPageThumbnail] $message');
    }
  }
}
