// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Utility class for managing PDF viewer application directories.
///
/// This class provides platform-aware directory management for storing
/// various PDF processing outputs (images, flattened PDFs, etc.).
///
/// **Directory Structure:**
/// - Base: "PDF Reader Pro"
/// - Images: "PDF Reader Pro/Images" (for PDF to image conversions)
/// - Flattened: "PDF Reader Pro/Flattened" (for flattened PDFs)
///
/// **Platform Behavior:**
/// - Android: Uses Downloads directory as base
/// - iOS/Other: Uses Application Documents directory as base
///
/// **Available Operations:**
/// - [getBaseDirectory] - Get platform-specific base directory
/// - [getImageDirectory] - Get/create directory for PDF-to-image output
/// - [getFlattenedDirectory] - Get/create directory for flattened PDFs
///
/// **Usage:**
/// ```dart
/// final imageDir = await PdfDirUtil.getImageDirectory();
/// final outputPath = '${imageDir.path}/page_1.png';
/// ```
///
/// All directories are created automatically if they don't exist.
class PdfDirUtil {
  // PDF project
  static const String baseFolderName = 'Export';
  // PDF to image folder
  static const String imageFolderName = '$baseFolderName/Images';

  static const String flattenedFolderName = '$baseFolderName/Flattened';

  // Base path for saving various result files
  static Future<Directory?> getBaseDirectory() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await getDownloadsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  // Get PDF to image folder
  static Future<Directory?> getImageDirectory() async {
    final baseDir = await getBaseDirectory();
    if (baseDir == null) {
      return null;
    }
    final imageDir = Directory('${baseDir.path}/$imageFolderName');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }

  static Future<Directory?> getFlattenedDirectory() async {
    final baseDir = await getBaseDirectory();
    if (baseDir == null) {
      return null;
    }
    final imageDir = Directory('${baseDir.path}/$flattenedFolderName');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }
}
