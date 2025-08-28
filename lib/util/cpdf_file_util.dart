/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:flutter/services.dart';

import '../compdfkit.dart';



class CPDFFileUtil {

  static Future<File> extractAsset(String assetPath,
      {bool shouldOverwrite = false, String prefix = ''}) async {
    final bytes = await rootBundle.load(assetPath);
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
}