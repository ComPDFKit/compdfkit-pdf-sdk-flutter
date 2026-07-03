// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

/// Controls how PDF page thumbnails are rendered and cached.
class CPDFPageThumbnailOptions {
  /// Target thumbnail width in pixels.
  final int? width;

  /// Target thumbnail height in pixels.
  final int? height;

  /// Scale used when [width] and [height] are not specified.
  final double scale;

  /// Background color used by the native page renderer.
  final Color backgroundColor;

  /// Whether annotations are included in the thumbnail.
  final bool drawAnnot;

  /// Whether form widgets are included in the thumbnail.
  final bool drawForm;

  /// Encoded image format.
  final CPDFPageCompression compression;

  /// JPEG quality. PNG ignores this value.
  final int jpegQuality;

  /// Cache behavior.
  final CPDFPageThumbnailCachePolicy cachePolicy;

  /// Optional disk cache time to live.
  final Duration? diskCacheTtl;

  /// Whether a missing dimension is calculated from the page aspect ratio.
  final bool preserveAspectRatio;

  /// Maximum number of pixels allowed for one rendered thumbnail.
  final int maxPixelCount;

  /// Creates thumbnail options.
  const CPDFPageThumbnailOptions({
    this.width,
    this.height,
    this.scale = 1.0,
    this.backgroundColor = Colors.white,
    this.drawAnnot = true,
    this.drawForm = true,
    this.compression = CPDFPageCompression.png,
    this.jpegQuality = 85,
    this.cachePolicy = CPDFPageThumbnailCachePolicy.memoryAndDisk,
    this.diskCacheTtl,
    this.preserveAspectRatio = true,
    this.maxPixelCount = 4096 * 4096,
  });

  /// Validates option values before rendering.
  void validate() {
    if (width != null && width! <= 0) {
      throw ArgumentError.value(width, 'width', 'Must be greater than 0.');
    }
    if (height != null && height! <= 0) {
      throw ArgumentError.value(height, 'height', 'Must be greater than 0.');
    }
    if (scale <= 0 || scale.isNaN || scale.isInfinite) {
      throw ArgumentError.value(scale, 'scale', 'Must be greater than 0.');
    }
    if (jpegQuality < 1 || jpegQuality > 100) {
      throw ArgumentError.value(
          jpegQuality, 'jpegQuality', 'Must be between 1 and 100.');
    }
    if (maxPixelCount <= 0) {
      throw ArgumentError.value(
          maxPixelCount, 'maxPixelCount', 'Must be greater than 0.');
    }
  }

  /// Resolves the target render size for a page.
  CPDFPageThumbnailSize resolveSize(Size pageSize) {
    validate();
    if (pageSize.width <= 0 || pageSize.height <= 0) {
      throw ArgumentError.value(
          pageSize, 'pageSize', 'Must be greater than 0.');
    }

    int resolvedWidth;
    int resolvedHeight;
    if (width != null && height != null) {
      resolvedWidth = width!;
      resolvedHeight = height!;
    } else if (width != null) {
      resolvedWidth = width!;
      resolvedHeight = preserveAspectRatio
          ? (width! * pageSize.height / pageSize.width).round()
          : (pageSize.height * scale).round();
    } else if (height != null) {
      resolvedHeight = height!;
      resolvedWidth = preserveAspectRatio
          ? (height! * pageSize.width / pageSize.height).round()
          : (pageSize.width * scale).round();
    } else {
      resolvedWidth = (pageSize.width * scale).round();
      resolvedHeight = (pageSize.height * scale).round();
    }

    resolvedWidth = resolvedWidth.clamp(1, maxPixelCount);
    resolvedHeight = resolvedHeight.clamp(1, maxPixelCount);
    final pixelCount = resolvedWidth * resolvedHeight;
    if (pixelCount > maxPixelCount) {
      throw ArgumentError.value(
        pixelCount,
        'pixelCount',
        'Must be less than or equal to maxPixelCount.',
      );
    }
    return CPDFPageThumbnailSize(resolvedWidth, resolvedHeight);
  }
}

/// Cache behavior for page thumbnails.
enum CPDFPageThumbnailCachePolicy {
  /// Use Flutter image cache only.
  memoryOnly,

  /// Use Flutter image cache and SDK disk cache.
  memoryAndDisk,

  /// Use SDK disk cache without SDK in-memory encoded bytes cache.
  diskOnly,

  /// Skip SDK disk cache reads and writes.
  noCache;

  /// Whether the SDK disk cache can be read.
  bool get readsDisk => this == memoryAndDisk || this == diskOnly;

  /// Whether the SDK disk cache can be written.
  bool get writesDisk => this == memoryAndDisk || this == diskOnly;

  /// Whether the in-memory encoded bytes cache can be read.
  bool get readsMemory => this == memoryOnly || this == memoryAndDisk;

  /// Whether the in-memory encoded bytes cache can be written.
  bool get writesMemory => this == memoryOnly || this == memoryAndDisk;
}

/// Resolved thumbnail dimensions in pixels.
class CPDFPageThumbnailSize {
  /// Width in pixels.
  final int width;

  /// Height in pixels.
  final int height;

  /// Creates a resolved size.
  const CPDFPageThumbnailSize(this.width, this.height);

  @override
  bool operator ==(Object other) {
    return other is CPDFPageThumbnailSize &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);
}
