// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

import 'package:flutter/material.dart';

/// In-memory cache repository for PDF thumbnail images.
///
/// Provides fast access to rendered page images using a key-value map. Supports
/// full cache clearing, single key removal, and fuzzy key matching for bulk
/// operations.
///
/// Key features:
/// - Simple key-value caching of Uint8List images
/// - Check cache existence before rendering
/// - Clear entire cache or single entries
/// - Fuzzy key matching for clearing related images
///
/// Usage example:
/// ```dart
/// final cache = ImageCacheRepository();
///
/// // Cache an image
/// cache.cacheImage('page_0_200_280', imageBytes);
///
/// // Check if cached
/// if (cache.hasCache('page_0_200_280')) {
///   final image = cache.getImage('page_0_200_280');
/// }
///
/// // Remove single image
/// cache.removeImage('page_0_200_280');
///
/// // Clear by prefix (all sizes of page 0)
/// cache.clearCacheByKey('page_0');
///
/// // Clear all
/// cache.clearCache();
/// ```
///
/// Fuzzy key clearing:
/// - `clearCacheByKey('page_5')` removes all entries starting with 'page_5'
/// - Useful for clearing all cached sizes of a page after rotation/modification
class ImageCacheRepository {
  final Map<String, Uint8List> _imageCache = {};

  /// Get cached images
  Uint8List? getImage(String key) {
    return _imageCache[key];
  }

  /// Cache image
  void cacheImage(String key, Uint8List image) {
    _imageCache[key] = image;
  }

  /// Clear cache
  void clearCache() {
    _imageCache.clear();
  }

  void removeImage(String key) {
    _imageCache.remove(key);
  }

  bool hasCache(String key) {
    return _imageCache.containsKey(key) && _imageCache[key] != null;
  }

  /// Clear cache by fuzzy matching key, if the passed key matches the start of any cache key, it will be cleared
  void clearCacheByKey(String key) {
    _imageCache.removeWhere((k, v) {
      bool success = k.startsWith(key);
      if (success) {
        debugPrint('Fuzzy match clear cache: $key, success');
      }
      return success;
    });
  }
}
