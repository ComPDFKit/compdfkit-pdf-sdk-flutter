// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/document/cpdf_document.dart';

/// Describes where a thumbnail should be rendered from.
class CPDFPageThumbnailSource {
  final CPDFDocument? _document;
  final String? _filePath;

  /// Password used when [filePath] is opened.
  final String password;

  /// Optional version for invalidating thumbnails from an already open document.
  final Object? cacheVersion;

  const CPDFPageThumbnailSource._({
    CPDFDocument? document,
    String? filePath,
    this.password = '',
    this.cacheVersion,
  })  : _document = document,
        _filePath = filePath;

  /// Uses an existing [CPDFDocument]. The document is not closed by the provider.
  const CPDFPageThumbnailSource.document(
    CPDFDocument document, {
    Object? cacheVersion,
  }) : this._(document: document, cacheVersion: cacheVersion);

  /// Opens [filePath] for rendering and closes it after each render.
  const CPDFPageThumbnailSource.file(
    String filePath, {
    String password = '',
  }) : this._(filePath: filePath, password: password);

  /// Existing document source, when available.
  CPDFDocument? get document => _document;

  /// File path source, when available.
  String? get filePath => _filePath;

  /// Whether this source wraps an existing document.
  bool get isDocument => _document != null;

  /// Whether this source opens a file path.
  bool get isFile => _filePath != null;

  /// Returns a short description without touching the file system.
  String describeSync() {
    if (_filePath != null) {
      return 'file(${_fileName(_filePath!)})';
    }
    return 'document(${identityHashCode(_document)})';
  }

  /// Returns a short description for debug logs.
  Future<String> describe() async {
    if (_filePath != null) {
      return _describeFile(_filePath!);
    }
    final documentPath = await _getDocumentPath();
    if (documentPath != null && documentPath.isNotEmpty) {
      return _describeFile(documentPath);
    }
    return 'document(${identityHashCode(_document)}, cacheVersion=${cacheVersion ?? 0})';
  }

  /// Returns a stable scope for cache key generation.
  Future<String> resolveScope() async {
    if (_filePath != null) {
      return _fileScope(_filePath!, password: password);
    }
    final documentPath = await _getDocumentPath();
    if (documentPath != null && documentPath.isNotEmpty) {
      return _documentPathScope(documentPath);
    }
    return [
      'document',
      identityHashCode(_document),
      cacheVersion ?? 0,
    ].join('_');
  }

  Future<String?> _getDocumentPath() async {
    final document = _document;
    if (document == null) {
      return null;
    }
    try {
      return (await document.getDocumentPath()).trim();
    } catch (_) {
      return null;
    }
  }

  Future<String> _fileScope(
    String path, {
    String password = '',
    Object? version,
  }) async {
    final normalizedPath = path.trim();
    final stat = await File(normalizedPath).stat();
    if (stat.type != FileSystemEntityType.file) {
      throw FileSystemException('Document path is not a file.', normalizedPath);
    }
    final parts = [
      'file',
      _hash(normalizedPath.toLowerCase()),
      stat.modified.millisecondsSinceEpoch,
      _hash(password),
    ];
    if (version != null) {
      parts.add(version);
    }
    return parts.join('_');
  }

  Future<String> _documentPathScope(String path) async {
    try {
      return await _fileScope(path, version: cacheVersion);
    } catch (_) {
      return [
        'document_path',
        _hash(path.trim().toLowerCase()),
        cacheVersion ?? 0,
      ].join('_');
    }
  }

  Future<String> _describeFile(String path) async {
    final normalizedPath = path.trim();
    try {
      final stat = await File(normalizedPath).stat();
      return 'file(${_fileName(normalizedPath)}, modified=${stat.modified.millisecondsSinceEpoch})';
    } catch (_) {
      return 'file(${_fileName(normalizedPath)})';
    }
  }

  static String _hash(String value) {
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

  static String _fileName(String path) {
    final segments = path.split(Platform.pathSeparator);
    if (segments.isEmpty) {
      return path;
    }
    return segments.last;
  }
}
