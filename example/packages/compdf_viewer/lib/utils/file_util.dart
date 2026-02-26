// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'package:compdf_viewer/core/constants.dart';
import 'package:path/path.dart' as p;
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:flutter/services.dart';

/// File utility class for asset extraction and file path operations.
///
/// Provides helper methods for:
/// - Extracting package assets to temporary directory
/// - Building unique file paths to avoid overwriting
/// - Handling file name conflicts with sequential numbering
///
/// Example:
/// ```dart
/// // Extract PDF from assets
/// final file = await FileUtil.extractAsset('assets/sample.pdf');
///
/// // Create unique file path
/// final uniquePath = await FileUtil.buildUniqueFilePath(
///   '/path/to/dir',
///   'document.pdf', // If exists, becomes document(1).pdf
/// );
/// ```
class FileUtil {
  /// Extracts an asset file from the package to the temporary directory.
  ///
  /// [assetPath] - Relative path within the package (e.g., 'assets/sample.pdf')
  /// [shouldOverwrite] - Whether to overwrite existing file (default: false)
  /// [prefix] - Optional prefix to add to the filename
  ///
  /// Returns a [File] object pointing to the extracted file.
  static Future<File> extractAsset(String assetPath,
      {bool shouldOverwrite = false, String prefix = ''}) async {
    final bytes = await rootBundle
        .load('packages/${PdfViewerAssets.packageName}/$assetPath');

    final list = bytes.buffer.asUint8List();

    final tempDir = await ComPDFKit.getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$prefix$assetPath';
    final file = File(tempDocumentPath);

    if (shouldOverwrite || !file.existsSync()) {
      await file.create(recursive: true);
      file.writeAsBytesSync(list);
    }
    return file;
  }

  /// Builds a unique file path by adding sequential numbers if file exists.
  ///
  /// [baseDirPath] - Directory where file will be created
  /// [fileName] - Desired file name (e.g., 'document.pdf')
  ///
  /// Returns a unique file path. If 'document.pdf' exists, returns 'document(1).pdf',
  /// 'document(2).pdf', etc.
  ///
  /// Example:
  /// ```dart
  /// final path = await FileUtil.buildUniqueFilePath(
  ///   '/storage/emulated/0/Download',
  ///   'invoice.pdf',
  /// );
  /// // Returns: /storage/emulated/0/Download/invoice.pdf
  /// // Or: /storage/emulated/0/Download/invoice(1).pdf if exists
  /// ```
  static Future<String> buildUniqueFilePath(
      String baseDirPath, String fileName) async {
    // Split file name and extension
    final fileNameNoExt = p.basenameWithoutExtension(fileName);
    final ext = p.extension(fileName);

    // Initial path
    String targetFilePath = p.join(baseDirPath, "$fileNameNoExt$ext");
    int counter = 1;

    // If file exists, add sequence number
    while (await File(targetFilePath).exists()) {
      targetFilePath = p.join(baseDirPath, "$fileNameNoExt($counter)$ext");
      counter++;
    }

    return targetFilePath;
  }
}
