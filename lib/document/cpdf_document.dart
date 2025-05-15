// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../annotation/cpdf_annotation.dart';
import '../annotation/form/cpdf_widget.dart';
import '../compdfkit.dart';
import '../util/cpdf_uuid_util.dart';

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

  static Future<CPDFDocument> createInstance() async {
    var id = CpdfUuidUtil.generateShortUniqueId();
    bool success = await ComPDFKit.createDocumentInstance(id);
    if (!success) {
      throw Exception('Failed to create document instance');
    }
    return CPDFDocument._(id);
  }

  CPDFDocument._(String id) {
    _channel = MethodChannel('com.compdfkit.flutter.document_$id');
  }

  CPDFDocument.withController(int viewId)
      : _channel = MethodChannel('com.compdfkit.flutter.document_$viewId'),
        _isValid = true;

  Future<CPDFDocumentError> open(String filePath,
      {String password = ''}) async {
    try {
      var error = await _channel.invokeMethod(
          'open_document', {'filePath': filePath, 'password': password});
      var type = CPDFDocumentError.values.where((e) => e.name == error).first;
      if (type == CPDFDocumentError.success) {
        _isValid = true;
      }
      return type;
    } on PlatformException {
      return CPDFDocumentError.unknown;
    }
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
    return await _channel
        .invokeMethod('check_owner_password', {'password': password});
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
  Future<int> getPageCount() async {
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
  Future<bool> saveAs(String savePath,
      {bool removeSecurity = false, bool fontSubSet = true}) async {
    try {
      return await _channel.invokeMethod('save_as', {
        'save_path': savePath,
        'remove_security': removeSecurity,
        'font_sub_set': fontSubSet
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
  Future<bool> removePassword() async {
    try {
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
  Future<bool> setPassword(
      {String? userPassword,
      String? ownerPassword,
      bool allowsPrinting = true,
      bool allowsCopying = true,
      CPDFDocumentEncryptAlgo encryptAlgo =
          CPDFDocumentEncryptAlgo.rc4}) async {
    try {
      return await _channel.invokeMethod('set_password', {
        'user_password': userPassword,
        'owner_password': ownerPassword,
        'allows_printing': allowsPrinting,
        'allows_copying': allowsCopying,
        'encrypt_algo': encryptAlgo.name
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
    String encryptAlgoStr =
        await _channel.invokeMethod('get_encrypt_algorithm');
    return CPDFDocumentEncryptAlgo.values
        .where((e) => e.name == encryptAlgoStr)
        .first;
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
  Future<void> removeAllWatermarks() async {
    return await _channel.invokeMethod('remove_all_watermarks');
  }

  Future<void> close() async {
    if (!_isValid) return;
    await _channel.invokeMethod('close');
    debugPrint('ComPDFKit:CPDFDocument.close');
    _isValid = false;
  }

  /// Imports the form data from the specified XFDF file into the current PDF document.<br>
  /// [xfdfFile] The path or URI of the XFDF file to import.
  ///
  /// example:
  /// ```dart
  /// bool importResult = await controller.document.importWidgets('data/your_package_name/files/xxx.xfdf');
  /// // or use Uri on the Android Platform.
  /// const xfdfFile = 'content://media/external/file/1000045118';
  /// const importResult = await controller.document.importWidgets(xfdfFile);
  /// ```
  ///
  Future<bool> importWidgets(String xfdfFile) async {
    return await _channel.invokeMethod('import_widgets', xfdfFile);
  }

  /// exports the form data from the current PDF document to an XFDF file.
  ///
  /// example:
  /// ```dart
  /// const exportPath = await controller.document.exportWidgets();
  /// ```
  Future<String> exportWidgets() async {
    return await _channel.invokeMethod('export_widgets');
  }

  /// Flatten all pages of the current document.
  ///
  /// [savePath] is the path to save the flattened document. On Android, you can pass a Uri.
  ///
  /// [fontSubset] determines whether to include the font subset when saving.
  ///
  /// Example:
  /// ```dart
  /// final savePath = 'file:///storage/emulated/0/Download/flatten.pdf';
  /// // or use a Uri on Android:
  /// final savePath = await ComPDFKit.createUri('flatten_test.pdf', 'compdfkit', 'application/pdf');
  /// final fontSubset = true;
  /// final result = await controller.document.flattenAllPages(savePath, fontSubset);
  /// ```
  ///
  /// Returns `true` if the flattened document is saved successfully, otherwise `false`.
  Future<bool> flattenAllPages(String savePath, bool fontSubset) async {
    return await _channel.invokeMethod('flatten_all_pages',
        {'save_path': savePath, 'font_subset': fontSubset});
  }

  /// Imports another PDF document and inserts it at a specified position in the current document.
  ///
  /// This method imports an external PDF document into the current document,
  /// allowing you to choose which pages to import and where to insert the document.
  ///
  /// Example:
  /// ```dart
  /// final filePath = '/data/user/0/com.compdfkit.flutter.example/cache/temp/PDF_Document.pdf';
  /// final pages = [0]; // The pages to import from the document
  /// final insertPosition = 0; // Insert at the beginning of the document
  /// final password = ''; // Password if the document is encrypted
  /// final result = await controller.document.importDocument(
  ///   filePath: filePath,
  ///   pages: pages,
  ///   insertPosition: insertPosition,
  ///   password: password,
  /// );
  /// ```
  ///
  /// [filePath] The path of the PDF document to import. Must be a valid, accessible path on the device.
  ///
  /// [pages] The pages to import from the document. If empty or not provided, the entire document will be imported.
  ///
  /// [insertPosition] The position at which to insert the imported document in the current document.
  /// If not specified, it defaults to -1 (append to the end).
  ///
  /// [password] The password for the document if it is encrypted. Use an empty string if not encrypted.
  ///
  /// Returns `true` if the document was successfully imported, `false` otherwise.
  ///
  /// Throws an error if the native method call fails.
  Future<bool> importDocument(
      {required String filePath,
      List<int> pages = const [],
      int insertPosition = -1,
      String? password}) async {
    return await _channel.invokeMethod('import_document', {
      'file_path': filePath,
      'pages': pages,
      'insert_position': insertPosition,
      'password': password
    });
  }

  /// Inserts a blank page at the specified index in the document.
  ///
  /// This method allows adding a blank page of a specified size at a specific index within the PDF document.
  /// It is useful for document editing scenarios where page insertion is needed.
  ///
  /// Parameters:
  /// - pageIndex: The index position where the blank page will be inserted. Must be a valid index within the document.
  /// - pageSize: The size of the blank page to insert. Defaults to A4 size if not specified.
  ///   Custom page sizes can be used by creating an instance of CPDFPageSize with custom dimensions.
  ///
  /// Returns:
  /// - A boolean value indicating the success or failure of the blank page insertion.
  ///   True if the insertion was successful, false otherwise.
  ///
  /// example:
  /// ```dart
  /// CPDFPageSize pageSize = CPDFPageSize.a4;
  /// // custom page size
  /// // CPDFPageSize.custom(500, 800);
  /// bool insertResult = await controller.document.insertBlankPage(pageIndex: 0, pageSize = pageSize);
  /// ```
  Future<bool> insertBlankPage(
      {required int pageIndex, CPDFPageSize pageSize = CPDFPageSize.a4}) async {
    return await _channel.invokeMethod('insert_blank_page', {
      'page_index': pageIndex,
      'page_width': pageSize.width,
      'page_height': pageSize.height
    });
  }


  /// Splits the specified pages from the current document and saves them as a new document.
  ///
  /// This function extracts the given pages from the current PDF document and saves them as a
  /// new document at the provided save path.
  ///
  /// Parameters:
  /// - [savePath] The path where the new document will be saved.
  /// - [pages] The list of page indices to be extracted from the current document.
  ///
  /// example:
  /// ```dart
  /// var savePath = '/data/user/0/com.compdfkit.flutter.example/cache/temp/PDF_Document.pdf';
  /// // on Android, you can use ComPDFKit.createUri() to create a Uri
  /// var savePath = ComPDFKit.createUri('split_document.pdf');
  /// bool splitResult = await controller.document.splitDocumentPages(savePath, [0, 1, 2]);
  /// ```
  Future<bool> splitDocumentPages(String savePath, List<int> pages) async {
    return await _channel.invokeMethod(
        'split_document_pages', {'save_path': savePath, 'pages': pages});
  }

  /// Get the path of the current document.
  ///
  /// example:
  /// ```dart
  /// var path = await controller.document.getDocumentPath();
  /// ```
  Future<String> getDocumentPath() async{
    return await _channel.invokeMethod('get_document_path');
  }

  /// Get the page object at the specified index.
  /// [pageIndex] The index of the page to retrieve.
  ///
  /// example
  /// ```dart
  /// CPDFPage page = controller.document.pageAtIndex(0);
  /// ```
  CPDFPage pageAtIndex(int pageIndex) {
    return CPDFPage(_channel, pageIndex);
  }

  /// Removes an annotation from the current page.
  ///
  /// example:
  /// ```dart
  /// bool result = document.removeAnnotation(annotation);
  /// ```
  Future<bool> removeAnnotation(CPDFAnnotation annotation) async {
    return await _channel.invokeMethod('remove_annotation', {
      'page_index': annotation.page,
      'uuid': annotation.uuid,
    });
  }

  /// Removes a widget from the current page.
  ///
  /// example:
  /// ```dart
  /// bool result = document.removeWidget(widget);
  /// ```
  Future<bool> removeWidget(CPDFWidget widget) async {
    return await _channel.invokeMethod('remove_widget', {
      'page_index': widget.page,
      'uuid': widget.uuid,
    });
  }


}
