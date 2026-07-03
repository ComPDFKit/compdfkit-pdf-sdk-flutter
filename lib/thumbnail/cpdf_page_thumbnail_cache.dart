// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:typed_data';

import 'package:compdfkit_flutter/compdfkit.dart' show ComPDFKit;
import 'cpdf_page_thumbnail_key.dart';

/// Disk cache abstraction for page thumbnails.
abstract class CPDFPageThumbnailDiskCache {
  /// Reads encoded image bytes for [key].
  Future<Uint8List?> read(CPDFPageThumbnailKey key);

  /// Writes encoded image bytes for [key].
  Future<void> write(CPDFPageThumbnailKey key, Uint8List bytes);

  /// Removes one cached thumbnail.
  Future<void> remove(CPDFPageThumbnailKey key);

  /// Clears all cached page thumbnails.
  Future<void> clear();
}

/// File-system backed thumbnail cache.
class CPDFPageThumbnailFileDiskCache implements CPDFPageThumbnailDiskCache {
  /// Directory name under [ComPDFKit.getTemporaryDirectory].
  static const String defaultDirectoryName = 'compdfkit_page_thumbnails';

  final Directory? _cacheDirectory;

  /// Creates a disk cache. When [cacheDirectory] is omitted, a dedicated
  /// subdirectory is created under [ComPDFKit.getTemporaryDirectory].
  const CPDFPageThumbnailFileDiskCache({Directory? cacheDirectory})
      : _cacheDirectory = cacheDirectory;

  @override
  Future<Uint8List?> read(CPDFPageThumbnailKey key) async {
    final file = await _fileForKey(key);
    if (!await file.exists()) {
      return null;
    }
    if (_isExpired(file, key)) {
      await file.delete();
      return null;
    }
    return file.readAsBytes();
  }

  @override
  Future<void> write(CPDFPageThumbnailKey key, Uint8List bytes) async {
    final file = await _fileForKey(key);
    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsBytes(bytes, flush: true);
    if (await file.exists()) {
      await file.delete();
    }
    await tempFile.rename(file.path);
  }

  @override
  Future<void> remove(CPDFPageThumbnailKey key) async {
    final file = await _fileForKey(key);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> clear() async {
    final directory = await _rootDirectory();
    if (!await directory.exists()) {
      return;
    }
    await _deleteChildren(directory);
  }

  Future<File> _fileForKey(CPDFPageThumbnailKey key) async {
    final root = await _rootDirectory();
    if (!await root.exists()) {
      await root.create(recursive: true);
    }
    final documentDirectory =
        Directory(_join(root.path, key.diskDirectoryName));
    if (!await documentDirectory.exists()) {
      await documentDirectory.create(recursive: true);
    }
    return File(_join(documentDirectory.path, key.diskFileName));
  }

  Future<Directory> _rootDirectory() async {
    if (_cacheDirectory != null) {
      return _cacheDirectory!;
    }
    final tempDirectory = await ComPDFKit.getTemporaryDirectory();
    return Directory(_join(tempDirectory.path, defaultDirectoryName));
  }

  bool _isExpired(File file, CPDFPageThumbnailKey key) {
    final ttl = key.options.diskCacheTtl;
    if (ttl == null) {
      return false;
    }
    final modified = file.statSync().modified;
    return DateTime.now().difference(modified) > ttl;
  }

  String _join(String left, String right) {
    if (left.endsWith(Platform.pathSeparator)) {
      return '$left$right';
    }
    return '$left${Platform.pathSeparator}$right';
  }

  Future<void> _deleteChildren(Directory directory) async {
    const attempts = 3;
    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        final children = directory.listSync();
        for (final child in children) {
          await _deleteEntity(child);
        }
        return;
      } on FileSystemException {
        if (attempt == attempts - 1) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
  }

  Future<void> _deleteEntity(FileSystemEntity entity) async {
    const attempts = 3;
    for (var attempt = 0; attempt < attempts; attempt++) {
      if (!await entity.exists()) {
        return;
      }
      try {
        await entity.delete(recursive: true);
        return;
      } on FileSystemException catch (e) {
        if (e.osError?.errorCode == 2 || attempt == attempts - 1) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
  }
}
