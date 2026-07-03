// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_options.dart';
import 'package:compdfkit_flutter/thumbnail/cpdf_page_thumbnail_source.dart';
import 'package:flutter/material.dart';

/// Immutable key used by [CPDFPageThumbnailProvider].
class CPDFPageThumbnailKey {
  /// Original source.
  final CPDFPageThumbnailSource source;

  /// Cache scope derived from file timestamp or document cache version.
  final String sourceScope;

  /// Page index.
  final int pageIndex;

  /// Render width in pixels.
  final int width;

  /// Render height in pixels.
  final int height;

  /// Page rotation in degrees.
  final int rotation;

  /// Render options.
  final CPDFPageThumbnailOptions options;

  /// Creates a thumbnail key.
  const CPDFPageThumbnailKey({
    required this.source,
    required this.sourceScope,
    required this.pageIndex,
    required this.width,
    required this.height,
    required this.rotation,
    required this.options,
  });

  /// String used by in-flight maps and disk cache files.
  String get cacheKey {
    return [
      sourceScope,
      pageIndex,
      width,
      height,
      rotation,
      _colorToArgb(options.backgroundColor),
      options.drawAnnot ? 1 : 0,
      options.drawForm ? 1 : 0,
      options.compression.name,
      options.jpegQuality,
    ].join('_');
  }

  /// Hashed directory name used by disk cache.
  String get diskDirectoryName => _hash(sourceScope);

  /// Hashed file name used by disk cache.
  String get diskFileName => _hash(cacheKey);

  @override
  bool operator ==(Object other) {
    return other is CPDFPageThumbnailKey && other.cacheKey == cacheKey;
  }

  @override
  int get hashCode => cacheKey.hashCode;

  String _colorToArgb(Color color) {
    final alpha = (color.a * 255).round() & 0xff;
    final red = (color.r * 255).round() & 0xff;
    final green = (color.g * 255).round() & 0xff;
    final blue = (color.b * 255).round() & 0xff;
    final value = alpha << 24 | red << 16 | green << 8 | blue;
    return value.toRadixString(16).padLeft(8, '0');
  }

  String _hash(String value) {
    const int offsetBasis = 0xcbf29ce484222325;
    const int prime = 0x00000100000001b3;
    const int mask = 0xFFFFFFFFFFFFFFFF;

    int hash = offsetBasis;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
