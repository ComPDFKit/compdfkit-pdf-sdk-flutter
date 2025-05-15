// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<File> extractAsset(BuildContext context, String assetPath,
    {bool shouldOverwrite = false, String prefix = ''}) async {
  final bytes = await DefaultAssetBundle.of(context).load(assetPath);
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

Future<String> extractAssetFolder(BuildContext context, String folder) async {
  final tempDir = await ComPDFKit.getTemporaryDirectory();
  final assetPaths = await getAssetPaths(folder);
  for (var path in assetPaths) {
    if (context.mounted) {
      await extractAsset(context, path);
    }
  }
  String dir = '${tempDir.path}/$folder';
  debugPrint('ComPDFKit-fontDir: $dir');
  return dir;
}

Future<List<String>> getAssetPaths(String folderPath) async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);
  final assetPaths =
      manifestMap.keys.where((key) => key.startsWith(folderPath)).toList();
  return assetPaths;
}

void printJsonString(String jsonStr) {
  try {
    final dynamic jsonData = json.decode(jsonStr);
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyJson = encoder.convert(jsonData);
    _printLongText(prettyJson);
  } catch (e) {
    if (kDebugMode) {
      print('Invalid JSON: $e');
    }
  }
}

void _printLongText(String text, {int chunkSize = 800}) {
  final pattern = RegExp('.{1,$chunkSize}', dotAll: true);
  for (final match in pattern.allMatches(text)) {
    if (kDebugMode) {
      print(match.group(0));
    }
  }
}