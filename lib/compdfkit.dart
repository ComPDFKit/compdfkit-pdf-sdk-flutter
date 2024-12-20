// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/services.dart';


/// ComPDFKit plugin to load PDF and image documents on both platform iOS and Android.
class ComPDFKit {
  static const MethodChannel _methodChannel = MethodChannel('com.compdfkit.flutter.plugin');

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
    _methodChannel.invokeMethod('init_sdk', {'key': key});
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
    _methodChannel.invokeMethod('init_sdk_keys', {'androidOnlineLicense': androidOnlineLicense, 'iosOnlineLicense': iosOnlineLicense});
  }

  /// Get the version code of the ComPDFKit SDK.
  static Future<String> getVersionCode() async {
    String versionCode =
        await _methodChannel.invokeMethod('sdk_version_code');
    return versionCode;
  }

  /// Get the version information of ComPDFKit SDK.
  static Future<String> getSDKBuildTag() async {
    String buildTag = await _methodChannel.invokeMethod('sdk_build_tag');
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
    await _methodChannel.invokeMethod('open_document', <String, dynamic>{
      'document': document,
      'password': password,
      'configuration': configuration?.toJson()
    });
  }

  /// Retrieve the path of your operating system's temporary directory.
  /// Support [Android] and [iOS] only for now.
  static Future<Directory> getTemporaryDirectory() async {
    final String? path =
        await _methodChannel.invokeMethod('get_temporary_directory');
    if (path == null) {
      throw Exception('Unable to get temporary directory');
    }
    return Directory(path);
  }

  /// Delete annotated electronic signature file list data
  /// **for Samples:**
  /// ```dart
  /// ComPDFKit.removeSignFileList()
  /// ```
  static Future<bool> removeSignFileList() async {
    return await _methodChannel.invokeMethod('remove_sign_file_list');
  }

  static Future<String?> pickFile() async {
    final String? filePath = await _methodChannel.invokeMethod('pick_file');
    return filePath;
  }
}
