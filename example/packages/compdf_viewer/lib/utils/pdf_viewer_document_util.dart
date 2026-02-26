// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// Utility class for PDF document operations such as sharing and file conversion.
///
/// This class provides static helper methods for common document-related tasks.
///
/// **Available Operations:**
/// - [share] - Share PDF file via platform share dialog
/// - [filePathToUint8List] - Convert file path to byte array
///
/// **Usage:**
/// ```dart
/// // Share PDF document
/// PdfViewerDocumentUtil.share('/path/to/document.pdf');
///
/// // Read file as bytes
/// final bytes = await PdfViewerDocumentUtil.filePathToUint8List(filePath);
/// ```
class PdfViewerDocumentUtil {
  static void share(String? path) {
    try {
      if (path != null) {
        final files = <XFile>[];
        files.add(XFile(path, mimeType: 'application/pdf'));
        SharePlus.instance.share(ShareParams(files: files));
      }
    } catch (e) {
      // Print error log
      Get.log('share error: $e');
    }
  }

  static Future<Uint8List> filePathToUint8List(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes(); // Returns Uint8List
  }
}
