// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupMockMethodChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.compdfkit.flutter.plugin'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        // ==================== SDK initialization ====================
        case 'init_sdk':
        case 'init_sdk_with_path':
        case 'init_sdk_keys':
          return true;

        // ==================== Font directory settings ====================
        case 'set_import_font_directory':
        case 'update_import_font_directory':
          return true;

        // ==================== Version information ====================
        case 'sdk_version_code':
          return '2.6.0';
        case 'sdk_build_tag':
          return 'mock-build';

        // ==================== Document operations ====================
        case 'open_document':
          return {'success': true};
        case 'get_temporary_directory':
          return '/tmp/mock';
        case 'pick_file':
          return null;

        // ====================  ====================
        // Add more mock methods as needed
        default:
          return null;
      }
    },
  );
}

/// Clear mock
void teardownMockMethodChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.compdfkit.flutter.plugin'),
    null,
  );
}
