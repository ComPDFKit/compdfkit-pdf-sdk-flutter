// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/services.dart';

/// A class to handle PDF documents without using [CPDFReaderWidget]
///
/// example:
/// ```dart
/// var document = CPDFDocument();
/// document.open('pdf file path', 'password');
///
/// /// get pdf document info.
/// var info = await document.getInfo();
///
/// /// get pdf document file name.
/// var fileName = await document.getFileName();
/// ```
class CPDFDocument {
  late final MethodChannel _channel;

  bool _isValid = false;

  get isValid => _isValid;

  CPDFDocument.withController(int viewId)
      : _channel = MethodChannel('com.compdfkit.flutter.document_$viewId'),
        _isValid = true;

  Future<CPDFDocumentError> open(String filePath, String password) async {
    var errorCode = await _channel.invokeMethod(
        'open_document', {'filePath': filePath, 'password': password});
    var error = CPDFDocumentError.values[errorCode];
    _isValid = error == CPDFDocumentError.success;
    return error;
  }

  /// Gets the file name of the PDF document.
  ///
  /// example:
  /// ```dart
  /// var fileName = await document.getFileName();
  /// ```
  Future<String> getFileName() async {
    return await _channel.invokeMethod('get_file_name');
  }

  /// Checks if the PDF document is encrypted.
  ///
  /// example:
  /// ```dart
  /// var isEncrypted = await document.isEncrypted();
  /// ```
  Future<bool> isEncrypted() async {
    return await _channel.invokeMethod('is_encrypted');
  }

  /// Checks if the PDF document is an image document.
  /// This is a time-consuming operation that depends on the document size.
  ///
  /// example:
  /// ```dart
  /// var isImageDoc = await document.isImageDoc();
  /// ```
  Future<bool> isImageDoc() async {
    return await _channel.invokeMethod('is_image_doc');
  }

  /// Gets the current document's permissions. There are three types of permissions:
  /// No restrictions: [CPDFDocumentPermissions.none]
  /// If the document has an open password and an owner password,
  /// using the open password will grant [CPDFDocumentPermissions.user] permissions,
  /// and using the owner password will grant [CPDFDocumentPermissions.owner] permissions.
  ///
  /// example:
  /// ```dart
  /// var permissions = await document.getPermissions();
  /// ```
  Future<CPDFDocumentPermissions> getPermissions() async {
    int permissionId = await _channel.invokeMethod('get_permissions');
    return CPDFDocumentPermissions.values[permissionId];
  }

  /// Check if owner permissions are unlocked
  ///
  /// example:
  /// ```dart
  /// var isUnlocked = await document.checkOwnerUnlocked();
  /// ```
  Future<bool> checkOwnerUnlocked() async {
    return await _channel.invokeMethod('check_owner_unlocked');
  }

  /// Whether the owner password is correct.
  ///
  /// example:
  /// ```dart
  /// var isCorrect = await document.checkOwnerPassword('password');
  /// ```
  Future<bool> checkOwnerPassword(String password) async {
    return await _channel.invokeMethod('check_owner_password',
        {'password': password});
  }

  /// Check the document for modifications
  ///
  /// example:
  /// ```dart
  /// bool hasChange = await document.hasChange();
  /// ```
  Future<bool> hasChange() async {
    return await _channel.invokeMethod('has_change');
  }


  /// Imports annotations from the specified XFDF file into the current PDF document.
  ///
  /// **Parameters:**<br/>
  ///   xfdfFile - Path of the XFDF file to be imported.
  ///
  /// **example:**
  /// ```dart
  /// bool result = await document.importAnnotations(xxx.xfdf);
  /// ```
  ///
  /// **Returns:**
  ///   true if the import is successful; otherwise, false.
  Future<bool> importAnnotations(String xfdfFile) async {
    return await _channel.invokeMethod('import_annotations', xfdfFile);
  }

  /// Exports annotations from the current PDF document to an XFDF file.
  ///
  /// **example:**
  /// ```dart
  /// String xfdfPath = await document.exportAnnotations();
  /// ```
  ///
  /// Returns:
  ///   The path of the XFDF file if export is successful; an empty string if the export fails.
  Future<String> exportAnnotations() async {
    return await _channel.invokeMethod('export_annotations');
  }


  /// Delete all comments in the current document
  ///
  /// example:
  /// ```dart
  /// bool result = await document.removeAllAnnotations();
  /// ```
  Future<bool> removeAllAnnotations() async {
    return await _channel.invokeMethod('remove_all_annotations');
  }

  /// Get the total number of pages in the current document
  ///
  /// example:
  /// ```dart
  /// int pageCount = await document.getPageCount();
  /// ```
  Future<int> getPageCount()  async {
    return await _channel.invokeMethod('get_page_count');
  }

  // Future<void> getInfo() async {}

}
