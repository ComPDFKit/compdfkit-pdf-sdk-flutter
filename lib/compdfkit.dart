///  Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
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
  static const initSdkKeys = 'init_sdk_keys';
  static const sdkVersionCode = 'sdk_version_code';
  static const sdkBuildTag = "sdk_build_tag";

  /// Please enter your ComPDFKit license to initialize the ComPDFKit SDK.<br/>
  /// This method is used for offline license authentication.
  /// In version **1.13.0**, we have introduced a brand-new online authentication licensing scheme.
  /// By default, the ComPDFKit SDK performs online authentication.
  /// If you are unsure about the type of your license, please contact the [ComPDFKit team.](https://www.compdf.com/support).
  ///
  /// **samples:**<br/>
  /// ```dart
  /// ComPDFKit.init('your compdfkit license')
  /// ```
  static void init(String key) async {
    _methodChannel.invokeMethod(initSDK, {'key': key});
  }

  /// Please enter your ComPDFKit license to initialize the ComPDFKit SDK.<br/>
  /// This method is used for online license authentication
  /// In version **1.13.0**, we have introduced a brand-new online authentication licensing scheme.
  /// By default, the ComPDFKit SDK performs online authentication.
  /// If you obtained your ComPDFKit License before the release of version 1.13.0, please use [ComPDFKit.init] <br/>
  /// If you are unsure about the type of your license, please contact the [ComPDFKit team.](https://www.compdf.com/support).
  ///
  /// **samples:**<br/>
  /// **online auth**
  /// ```dart
  /// ComPDFKit.initialize(androidOnlineLicense : 'your android platform compdfkit license', iosOnlineLicense: 'your ios platform compdfkit license')
  /// ```
  static void initialize({required String androidOnlineLicense,required String iosOnlineLicense}) {
    _methodChannel.invokeMethod(initSdkKeys, {'androidOnlineLicense': androidOnlineLicense, 'iosOnlineLicense': iosOnlineLicense});
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
