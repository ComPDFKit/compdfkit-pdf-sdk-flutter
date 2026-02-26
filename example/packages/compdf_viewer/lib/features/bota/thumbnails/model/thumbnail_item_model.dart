// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:ui';

/// Data model for a PDF page thumbnail item.
///
/// Represents a single PDF page in the thumbnail view with its index and size.
/// Used for thumbnail rendering, selection tracking, and image cache key
/// generation.
///
/// Key properties:
/// - `pageIndex`: 0-based page index in PDF document
/// - `size`: Page dimensions (width x height) for aspect ratio
/// - `key`: Unique cache key combining index and size
///
/// Usage example:
/// ```dart
/// // Create thumbnail model
/// final model = ThumbnailItemModel(
///   pageIndex: 0,
///   size: Size(595, 842),  // A4 size
/// );
///
/// // Use cache key
/// final cacheKey = model.key;
/// // Returns: 'thumbnail_page_0_595_842'
///
/// // Update size after rotation
/// model.size = Size(842, 595);  // Landscape
/// ```
///
/// Cache key format:
/// - Pattern: `thumbnail_page_{index}_{width}_{height}`
/// - Used by ImageCacheRepository for caching rendered images

class ThumbnailItemModel {
  /// The index of the page in the PDF document.
  final int pageIndex;

  /// The size of the thumbnail image for the page.
  Size size;

  /// Creates a new instance of [ThumbnailItemModel].
  ThumbnailItemModel({
    required this.pageIndex,
    required this.size,
  });

  String get key =>
      'thumbnail_page_${pageIndex}_${size.width.toInt()}_${size.height.toInt()}';
}
