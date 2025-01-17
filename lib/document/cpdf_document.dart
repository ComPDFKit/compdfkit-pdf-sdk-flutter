// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  Future<bool> open(String filePath, String password) async {
    return  await _channel.invokeMethod(
        'open_document', {'filePath': filePath, 'password': password});
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

  /// Save document
  ///
  /// example:
  /// ```dart
  /// bool result = await _controller.save();
  /// ```
  /// Return value: **true** if the save is successful,
  /// **false** if the save fails.
  Future<bool> save() async {
    return await _channel.invokeMethod('save');
  }

  /// Saves the document to the specified directory.
  ///
  /// Example usage:
  /// ```dart
  /// await controller.document.saveAs('data/your_package_name/files/xxx.pdf')
  /// ```
  /// - [savePath] Specifies the path where the document should be saved.
  /// On Android, both file paths and URIs are supported. For example:
  ///   - File path: `/data/user/0/com.compdfkit.flutter.example/cache/temp/PDF_Document.pdf`
  ///   - URI: `content://media/external/file/1000045118`
  /// - [removeSecurity] Whether to remove the document's password.
  /// - [fontSubSet] Whether to embed the font subset when saving the PDF.
  /// This will affect how text appears in other PDF software. This is a time-consuming operation.
  Future<bool> saveAs(String savePath, {
    bool removeSecurity = false,
    bool fontSubSet = true
  }) async {
    try {
      return await _channel.invokeMethod('save_as', {
        'save_path' : savePath,
        'remove_security' : removeSecurity,
        'font_sub_set' : fontSubSet
      });
    } on PlatformException catch (e) {
      debugPrint(e.details);
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Invokes the system's print service to print the current document.
  ///
  /// example:
  /// ```dart
  /// await document.printDocument();
  /// ```
  Future<void> printDocument() async {
    await _channel.invokeMethod('print');
  }

  /// Remove the user password and owner permission password
  /// set in the document, and perform an incremental save.
  ///
  /// example:
  /// ```dart
  /// bool result = await document.removePassword();
  /// ```
  Future<bool> removePassword() async{
    try{
      return await _channel.invokeMethod('remove_password');
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  /// This method sets the document password, including the user password for access restrictions
  /// and the owner password for granting permissions.
  ///
  /// - To enable permissions like printing or copying, the owner password must be set; otherwise,
  ///   the settings will not take effect.
  ///
  /// example:
  /// ```dart
  /// bool result = controller.document.setPassword(
  ///   userPassword : '1234',
  ///   ownerPassword : '4321',
  ///   allowsPrinting : false,
  ///   allowsCopying : false,
  ///   encryptAlgo = CPDFDocumentEncryptAlgo.rc4
  /// );
  /// ```
  Future<bool> setPassword({
    String? userPassword,
    String? ownerPassword,
    bool allowsPrinting = true,
    bool allowsCopying = true,
    CPDFDocumentEncryptAlgo encryptAlgo = CPDFDocumentEncryptAlgo.rc4
  }) async {
    try{
      return await _channel.invokeMethod('set_password', {
        'user_password' : userPassword,
        'owner_password' : ownerPassword,
        'allows_printing' : allowsPrinting,
        'allows_copying' : allowsCopying,
        'encrypt_algo' : encryptAlgo.name
      });
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  /// Get the encryption algorithm of the current document
  ///
  /// example:
  /// ```dart
  /// CPDFDocumentEncryptAlgo encryptAlgo = await controller.document.getEncryptAlgo();
  /// ```
  Future<CPDFDocumentEncryptAlgo> getEncryptAlgo() async {
    String encryptAlgoStr = await _channel.invokeMethod('get_encrypt_algorithm');
    return CPDFDocumentEncryptAlgo.values.where((e) => e.name == encryptAlgoStr).first;
  }

  /// Create document watermarks, including text watermarks and image watermarks
  ///
  /// - Add Text Watermark Example:
  /// ```dart
  /// await controller.document.createWatermark(CPDFWatermark.text(
  ///             textContent: 'Flutter',
  ///             scale: 1.0,
  ///             fontSize: 50,
  ///             textColor: Colors.deepOrange,
  ///             pages: [0, 1, 2, 3,8,9]));
  /// ```
  ///
  /// - Add Image Watermark Example:
  /// ```dart
  /// File imageFile = await extractAsset(context, 'images/logo.png');
  /// await controller.document.createWatermark(CPDFWatermark.image(
  ///           imagePath: imageFile.path,
  ///           pages: [0, 1, 2, 3],
  ///           horizontalSpacing: 50,
  ///           verticalSpacing: 50,
  ///           horizontalAlignment: CPDFWatermarkHorizontalAlignment.center,
  ///           verticalAlignment: CPDFWatermarkVerticalAlignment.center,
  ///         ));
  /// ```
  Future<bool> createWatermark(CPDFWatermark watermark) async {
    return await _channel.invokeMethod('create_watermark', watermark.toJson());
  }

  /// remove all watermark
  ///
  /// example:
  /// ```dart
  /// await controller.document.removeAllWatermarks();
  /// ```
  Future<void> removeAllWatermarks() async{
    return await _channel.invokeMethod('remove_all_watermarks');
  }
}
