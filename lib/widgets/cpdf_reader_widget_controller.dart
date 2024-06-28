/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/services.dart';

class CPDFReaderWidgetController {
  late MethodChannel _channel;

  CPDFReaderWidgetController(int id) {
    _channel = MethodChannel('com.compdfkit.flutter.ui.pdfviewer.$id');
    _channel.setMethodCallHandler((call) async {
    });
  }

  /// Save document
  /// Return value: **true** if the save is successful,
  /// **false** if the save fails.
  Future<bool> save() async {
    return await _channel.invokeMethod('save');
  }

}
