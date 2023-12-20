///  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/cpdf_configuration.dart';
import 'package:flutter/services.dart';

class ComPDFKit {
  static const MethodChannel _methodChannel =
      MethodChannel('com.compdfkit.flutter.plugin');

  static const initSDK = 'init_sdk';
  static const sdkVersionCode = 'sdk_version_code';
  static const sdkBuildTag = "sdk_build_tag";

  /// Please enter your ComPDFKit license to initialize the ComPDFKit SDK.<br/>
  /// A new license verification is enabled in ComPDFKit SDK V1.11.0.
  /// If you want to update the ComPDFKit SDK to V1.11.0 and do not have a new license,
  /// please contact the [ComPDFKit team.](https://www.compdf.com/support)"
  ///
  /// **samples:**
  /// ```dart
  /// ComPDFKit.init('your compdfkit license')
  /// ```
  static void init(String key) async {
    _methodChannel.invokeMethod(initSDK, {'key': key});
  }

  /// Get the version code of the ComPDFKit SDK.
  static Future<String> getVersionCode() async {
    String versionCode =
        await _methodChannel.invokeMethod(ComPDFKit.sdkVersionCode);
    return versionCode;
  }

  /// Get the version information of ComPDFKit SDK.
  static Future<String> getSDKBuildTag() async {
    String buildTag = await _methodChannel.invokeMethod(ComPDFKit.sdkBuildTag);
    return buildTag;
  }

  /// Enter the local PDF file path, document password (if required),
  /// and configuration parameters, and display the PDF document in a new window.
  ///
  /// **for Samples:**
  /// ```dart
  /// ComPDFKit.openDocument(
  ///     'xxx/compdfkit.pdf',
  ///     password : '',
  ///     configuration:CPDFConfiguration())
  /// ```
  static void openDocument(String document,
      {String? password, CPDFConfiguration? configuration}) async {
    await _methodChannel.invokeMethod('openDocument', <String, dynamic>{
      'document': document,
      'password': password,
      'configuration': configuration?.toJson()
    });
  }

  /// Retrieve the path of your operating system's temporary directory.
  /// Support [Android] and [iOS] only for now.
  static Future<Directory> getTemporaryDirectory() async {
    final String? path =
        await _methodChannel.invokeMethod('getTemporaryDirectory');
    if (path == null) {
      throw Exception('Unable to get temporary directory');
    }
    return Directory(path);
  }
}
