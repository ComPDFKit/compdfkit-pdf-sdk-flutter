// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:core';
import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:compdfkit_flutter/document/cpdf_document_permission_info.dart';
import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:compdfkit_flutter/document/cpdf_watermark.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';
import 'package:compdfkit_flutter/page/cpdf_page.dart';
import 'package:compdfkit_flutter/page/cpdf_text_searcher.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../annotation/cpdf_annotation.dart';
import '../annotation/form/cpdf_widget.dart';
import '../compdfkit.dart';
import '../configuration/attributes/cpdf_editor_text_attr.dart';
import '../edit/cpdf_image_data.dart';
import '../util/cpdf_uuid_util.dart';
import 'cpdf_info.dart';

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
///
/// {@category document}
class CPDFDocument {
  late final MethodChannel _channel;

  bool _isValid = false;

  bool get isValid => _isValid;

  CPDFTextSearcher? _textSearcher;

  // static Future<CPDFDocument> _createDocument() async {
  //   var id = CpdfUuidUtil.generateShortUniqueId();
  //   bool success = await ComPDFKit.createDocument(id);
  //   if (!success) {
  //     throw Exception('Failed to create document instance');
  //   }
  //   return CPDFDocument._(id);
  // }

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
  /// - [saveIncremental] Whether to perform an incremental save. Default is true.Only supported on Android Platform.
  /// - [fontSubSet] Whether to embed the font subset when saving the PDF. This will affect how text appears in other PDF software. This is a time-consuming operation.
  ///
  ///
  /// example:
  /// ```dart
  /// bool result = await _controller.save(saveIncremental: true, fontSubSet: true);
  /// ```
  /// Return value: **true** if the save is successful,
  /// **false** if the save fails.
  Future<bool> save(
      {bool saveIncremental = true, bool fontSubSet = true}) async {
    return await _channel.invokeMethod('save',
        {'save_incremental': saveIncremental, 'font_sub_set': fontSubSet});
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
    if (Platform.isIOS) {
      return;
    }
    await _channel.invokeMethod('close');
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

  /// Inserts a new PDF page at the specified index using an image from a file path.
  ///
  /// The image located at [imagePath] will be used to create a new page,
  /// which will be inserted at [pageIndex] in the current PDF document.
  ///
  /// [pageSize] specifies the size of the new page. Defaults to A4 size.
  ///
  /// example:
  /// ```dart
  /// bool result = await controller.document.insertPageWithImagePath(
  ///   pageIndex: 0,
  ///   imagePath: '/path/to/image.png',
  ///   pageSize: CPDFPageSize.a4,
  ///  );
  /// ```
  /// Returns `true` if the page is successfully inserted, otherwise `false`.
  /// Throws a [PlatformException] if the native platform reports an error.
  Future<bool> insertPageWithImagePath({
    required int pageIndex,
    required String imagePath,
    CPDFPageSize pageSize = CPDFPageSize.a4,
  }) async {
    return await _channel.invokeMethod('insert_page_with_image_path', {
      'page_index': pageIndex,
      'image_path': imagePath,
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
  Future<String> getDocumentPath() async {
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

  /// Gets the outline data of the current document.
  ///
  /// example:
  /// ```dart
  /// CPDFOutline outline = await document.getOutlineRoot();
  /// ```
  Future<CPDFOutline?> getOutlineRoot() async {
    final result = await _channel.invokeMethod('get_outline_root');
    if (result is Map) {
      final outlineMap = Map<String, dynamic>.from(result);
      return CPDFOutline.fromJson(outlineMap);
    } else {
      return null;
    }
  }

  /// Creates a new outline root for the current document.
  /// example:
  /// ```dart
  /// CPDFOutline? outline = await document.newOutlineRoot();
  /// ```
  Future<CPDFOutline?> newOutlineRoot() async {
    final result = await _channel.invokeMethod('new_outline_root');
    if (result is Map) {
      final outlineMap = Map<String, dynamic>.from(result);
      return CPDFOutline.fromJson(outlineMap);
    } else {
      return null;
    }
  }

  /// Adds an outline to the current document.
  /// Parameters:
  /// - [parentUuid] The UUID of the parent outline under which the new outline will be added.
  /// - [insertIndex] The index at which to insert the new outline under the parent. Default is -1 (append to the end).
  /// - [title] The title of the new outline.
  /// - [pageIndex] The index of the page that the outline will point to.
  /// example:
  /// ```dart
  /// bool result = await document.addOutline(
  ///   parentUuid: parentOutline.uuid,
  ///   insertIndex: 0,
  ///   title: 'New Outline',
  ///   pageIndex: 0
  /// );
  /// ```
  Future<bool> addOutline(
      {required String parentUuid,
      int insertIndex = -1,
      required String title,
      required int pageIndex}) async {
    return await _channel.invokeMethod('add_outline', {
      'parent_uuid': parentUuid,
      'insert_index': insertIndex,
      'title': title,
      'page_index': pageIndex
    });
  }

  /// Removes an outline from the current document by its UUID.
  /// Parameters:
  /// - [uuid] The UUID of the outline to be removed.
  /// example:
  /// ```dart
  /// bool result = await document.removeOutline(outline.uuid);
  /// ```
  Future<bool> removeOutline(String uuid) async {
    return await _channel.invokeMethod('remove_outline', uuid);
  }

  /// Updates an existing outline in the current document.
  /// Parameters:
  /// - [uuid] The UUID of the outline to be updated.
  /// - [title] The new title for the outline.
  /// - [pageIndex] The new page index that the outline will point to.
  /// example:
  /// ```dart
  /// bool result = await document.updateOutline(
  ///   uuid: outline.uuid,
  ///   title: 'Updated Title',
  ///   pageIndex: 1
  /// );
  /// ```
  Future<bool> updateOutline({
    required String uuid,
    required title,
    required pageIndex,
  }) async {
    return await _channel.invokeMethod('update_outline', {
      'uuid': uuid,
      'title': title,
      'page_index': pageIndex,
    });
  }

  /// Moves the specified outline to a new parent outline at the given insert position.
  ///
  /// This method repositions an existing outline within the document's outline tree.
  /// It changes the parent of the outline and inserts it at the specified index
  /// under the new parent.
  ///
  /// Parameters:
  /// - `outline`: The outline node to be moved.
  /// - `newParent`: The target parent outline under which the node will be placed.
  /// - `insertIndex`: The position at which to insert the outline under `newParent`.
  ///   Use `-1` to append the outline to the end.
  ///
  /// Example:
  /// ```dart
  /// bool result = await document.moveOutline(
  ///  outline: outlineToMove,
  ///  newParent: targetParentOutline,
  ///  insertIndex: 0,
  ///  );
  /// ```
  ///
  /// Returns:
  /// - `true` if the operation succeeds; otherwise, `false`.
  Future<bool> moveOutline({
    required CPDFOutline outline,
    required CPDFOutline newParent,
    int insertIndex = -1,
  }) async {
    return await _channel.invokeMethod('move_to_outline', {
      'new_parent_uuid': newParent.uuid,
      'uuid': outline.uuid,
      'insert_index': insertIndex,
    });
  }

  /// Gets the bookmarks of the current document.
  /// example:
  /// ```dart
  /// List<CPDFBookmark> bookmarks = await document.getBookmarks();
  /// ```
  Future<List<CPDFBookmark>> getBookmarks() async {
    final bookmarks = await _channel.invokeMethod('get_bookmarks');
    if (bookmarks is! List) return [];
    return bookmarks
        .whereType<Map>()
        .map((item) {
          try {
            final map = Map<String, dynamic>.from(item);
            return CPDFBookmark.fromJson(map);
          } catch (e, stack) {
            debugPrint('CPDFBookmark parse error: $e\n$stack');
            return null;
          }
        })
        .whereType<CPDFBookmark>()
        .toList();
  }

  /// remove a bookmark by its page index.
  ///
  /// Parameters:
  /// - [pageIndex] The index of the page for which the bookmark should be removed.
  /// example:
  /// ```dart
  /// bool result = await document.removeBookmark(0);
  /// ```
  Future<bool> removeBookmark(int pageIndex) async {
    return await _channel.invokeMethod('remove_bookmark', pageIndex);
  }

  /// Checks if a bookmark exists for the specified page index.
  ///
  /// Parameters:
  /// - [pageIndex] The index of the page to check for a bookmark.
  /// example:
  /// ```dart
  /// bool hasBookmark = await document.hasBookmark(0);
  /// ```
  Future<bool> hasBookmark(int pageIndex) async {
    return await _channel.invokeMethod('has_bookmark', pageIndex);
  }

  /// Adds a bookmark with the specified title and page index.
  /// Parameters:
  /// - [title] The title of the bookmark.
  /// - [pageIndex] The index of the page to which the bookmark should point.
  /// example:
  /// ```dart
  /// bool result = await document.addBookmark(title: 'My Bookmark', pageIndex: 0);
  /// ```
  Future<bool> addBookmark({
    required String title,
    required int pageIndex,
  }) async {
    return await _channel.invokeMethod('add_bookmark', {
      'title': title,
      'page_index': pageIndex,
    });
  }

  /// Updates an existing bookmark with the specified title and page index.
  /// Parameters:
  /// - [bookmark] The bookmark object containing the updated title and page index.
  /// example:
  /// ```dart
  /// List<CPDFBookmark> bookmarks = await document.getBookmarks();
  /// if (bookmarks.isNotEmpty) {
  ///   CPDFBookmark bookmark = bookmarks.first;
  ///   bookmark.setTitle('Updated Title');
  ///   bool result = await document.updateBookmark(bookmark);
  /// }
  /// ```
  Future<bool> updateBookmark(CPDFBookmark bookmark) async {
    return await _channel.invokeMethod('update_bookmark', bookmark.toJson());
  }

  /// Removes pages at the specified indexes from the document.
  /// This method allows you to delete multiple pages from the PDF document
  /// by providing a list of page indexes.
  /// Parameters:
  /// - [pageIndexes] A list of integers representing the indexes of the pages to be removed.
  /// example:
  /// ```dart
  /// List<int> pagesToRemove = [0, 1, 2]; // Pages to remove
  /// bool result = await document.removePages(pagesToRemove);
  /// ```
  Future<bool> removePages(List<int> pageIndexes) async {
    if (pageIndexes.isEmpty) return false;
    return await _channel.invokeMethod('remove_pages', pageIndexes);
  }

  /// Moves a page from one index to another within the document.
  /// Parameters:
  /// - [fromIndex] The index of the page to move.
  /// - [toIndex] The index to which the page should be moved.
  /// example:
  /// ```dart
  /// bool result = await document.movePage(fromIndex: 0, toIndex: 1);
  /// ```
  Future<bool> movePage({
    required int fromIndex,
    required int toIndex,
  }) async {
    return await _channel.invokeMethod('move_page', {
      'from_index': fromIndex,
      'to_index': toIndex,
    });
  }

  /// Gets the document information, such as title, author, subject, keywords, creation date, modification date, and producer.
  /// This method retrieves metadata about the PDF document.
  /// example:
  /// ```dart
  /// CPDFInfo info = await document.getInfo();
  /// ```
  Future<CPDFInfo> getInfo() async {
    final result = await _channel.invokeMethod('get_document_info');
    if (result is Map) {
      final infoMap = Map<String, dynamic>.from(result);
      return CPDFInfo.fromJson(infoMap);
    } else {
      return CPDFInfo.empty();
    }
  }

  /// Gets major version string of document.
  /// example:
  /// ```dart
  /// int majorVersion = await document.getMajorVersion();
  /// ```
  Future<int> getMajorVersion() async {
    return await _channel.invokeMethod('get_major_version');
  }

  /// Gets minor version string of document.
  /// example:
  /// ```dart
  /// int minorVersion = await document.getMinorVersion();
  /// ```
  Future<int> getMinorVersion() async {
    return await _channel.invokeMethod('get_minor_version');
  }

  /// Gets permission information of document,
  /// including whether printing, copying, and modifying are allowed.
  /// example:
  /// ```dart
  /// CPDFDocumentPermissionInfo permissionsInfo = await document.getPermissionsInfo();
  /// ```
  Future<CPDFDocumentPermissionInfo> getPermissionsInfo() async {
    final result = await _channel.invokeMethod('get_permissions_info');
    if (result is Map) {
      final infoMap = Map<String, dynamic>.from(result);
      return CPDFDocumentPermissionInfo.fromJson(infoMap);
    } else {
      return CPDFDocumentPermissionInfo.empty();
    }
  }

  Future<bool> isLocked() async {
    return await _channel.invokeMethod('is_locked');
  }

  /// Gets the text searcher for the document.
  /// This method returns an instance of [CPDFTextSearcher] that can be used to perform text searches
  /// within the PDF document.
  /// example:
  /// ```dart
  /// final searcher = document.getTextSearcher();
  /// ```
  CPDFTextSearcher getTextSearcher() {
    return _textSearcher ??= CPDFTextSearcher(
      int.parse(_channel.name.split('_').last),
    );
  }

  /// Renders a specific page of the document as an image.
  /// Parameters:
  /// - [pageIndex] The index of the page to render.
  /// - [width] The width of the rendered image in pixels.
  /// - [height] The height of the rendered image in pixels.
  /// - [backgroundColor] The background color to use when rendering the page. Default is white.  only Android Platform
  /// - [drawAnnot] Whether to draw annotations on the rendered page. Default is true. only Android Platform
  /// - [drawForm] Whether to draw form fields on the rendered page. Default is true. only Android Platform
  /// - [compression] The compression format for the rendered image. Default is PNG. only Android Platform
  /// example:
  /// ```dart
  /// var pageIndex = 0; // The index of the page to render
  /// Size size = await document.getPageSize(pageIndex);
  /// Uint8List imageData = await document.renderPage(pageIndex: pageIndex, width: size.width, height: size.height);
  /// ```
  Future<Uint8List> renderPage(
      {required int pageIndex,
      required int width,
      required int height,
      Color backgroundColor = Colors.white,
      bool drawAnnot = true,
      bool drawForm = true,
      CPDFPageCompression compression = CPDFPageCompression.png}) async {
    final result = await _channel.invokeMethod('render_page', {
      'page_index': pageIndex,
      'width': width,
      'height': height,
      'background_color': backgroundColor.toHex(),
      'draw_annot': drawAnnot,
      'draw_form': drawForm,
      'compression': compression.name,
    });
    if (result is Uint8List) {
      return result;
    } else if (result is Map && result.containsKey('error')) {
      throw Exception('renderPage failed: ${result['error']}');
    } else {
      throw Exception('renderPage failed: unexpected result type ${result.runtimeType}');
    }
  }

  /// Gets the size of the specified page in the document.
  /// This method retrieves the dimensions of a page at the given index.
  /// Parameters:
  /// - [pageIndex] The index of the page for which the size is requested.
  /// example:
  /// ```dart
  /// Size pageSize = await document.getPageSize(0);
  /// ```
  Future<Size> getPageSize(int pageIndex) async {
    final result = await _channel.invokeMethod<Map>('get_page_size', {
      'page_index': pageIndex,
    });

    if (result == null || result['width'] == null || result['height'] == null) {
      throw Exception('Invalid page size result');
    }

    return Size(
      (result['width'] as num).toDouble(),
      (result['height'] as num).toDouble(),
    );
  }

  /// Updates an annotation on the document.
  ///
  /// **example:**
  /// ```dart
  /// CPDFPage page = controller.document.pageAtIndex(pageIndex);
  /// List<CPDFAnnotation> annotations = await page.getAnnotations();
  /// bool result = await document.updateAnnotation(annotations[0]);
  /// ```
  Future<bool> updateAnnotation(CPDFAnnotation annotation) async {
    return await _channel.invokeMethod('update_annotation', {
      'page_index': annotation.page,
      'uuid': annotation.uuid,
      'data': annotation.toJson(),
    });
  }

  /// Updates a widget on the document.
  ///
  /// **example:**
  /// ```dart
  /// CPDFPage page = document.pageAtIndex(pageIndex);
  /// List<CPDFWidget> widgets = await page.getWidgets();
  /// CPDFTextWidget widget = widgets[0] as CPDFTextWidget;
  /// widget.title = 'TextFields---ComPDFKit';
  /// widget.fillColor = Colors.green;
  /// widget.borderColor = Colors.red;
  /// widget.borderWidth = 10;
  /// widget.text = 'Updated Text';
  /// widget.fontColor = Colors.blue;
  /// widget.fontSize = 20.0;
  /// widget.alignment = CPDFAlignment.center;
  /// widget.isMultiline = true;
  /// widget.familyName = 'Dancing Script';
  /// widget.styleName = 'Regular';
  ///
  /// bool result = await document.updateWidget(widget);
  /// ```
  Future<bool> updateWidget(CPDFWidget widget) async {
    return await _channel.invokeMethod('update_widget', {
      'page_index': widget.page,
      'uuid': widget.uuid,
      'data': widget.toJson(),
    });
  }

  /// Removes an edit area from the document.
  ///
  /// **example:**
  /// ```dart
  /// controller.addEventListener(CPDFEvent.editorSelectionSelected, (event){
  ///   if(event is CPDFEditTextArea || event is CPDFEditImageArea || event is CPDFEditPathArea){
  ///     document.removeEditArea(event);
  ///   }
  /// });
  ///
  /// document.removeEditArea(editArea);
  /// ```
  Future<bool> removeEditArea(CPDFEditArea editArea) async {
    return await _channel.invokeMethod('remove_edit_area', {
      'page_index': editArea.page,
      'uuid': editArea.uuid,
      'type': editArea.type.name,
    });
  }

  /// Adds annotations to the document.
  ///
  /// **example:**
  /// ```dart
  /// List<CPDFAnnotation> annotations = [
  ///     CPDFNoteAnnotation(
  ///           page: 1,
  ///           title: 'ComPDFKit-Flutter',
  ///           content: 'This is Note Annotation',
  ///           uuid: 'note-annotation-1',
  ///           rect: const CPDFRectF(left: 260, top: 700, right: 300, bottom: 740),
  ///           color: Colors.green,
  ///           alpha: 128)];
  /// await document.addAnnotations(annotations);
  /// ```
  Future<bool> addAnnotations(List<CPDFAnnotation> annotations) async {
    List<Map<String, dynamic>> annotationsData =
        annotations.map((e) => e.toJson()).toList();
    return await _channel
        .invokeMethod('add_annotations', {'annotations': annotationsData});
  }

  /// Adds widgets to the document.
  ///
  /// **example:**
  /// ```dart
  /// List<CPDFWidget> widgets = [CPDFTextWidget(
  ///     title: CPDFWidgetUtil.createFieldName(CPDFFormType.textField),
  ///     page: 0,
  ///     rect: const CPDFRectF(left: 40, top: 799, right: 320, bottom: 701),
  ///     borderColor: Colors.lightGreen,
  ///     fillColor: Colors.white,
  ///     borderWidth: 2,
  ///     text: 'This text field is created using the Flutter API.',
  ///     familyName: 'Times',
  ///     styleName: 'Bold')];
  ///
  /// bool result = await document.addWidgets(widgets);
  /// ```
  Future<bool> addWidgets(List<CPDFWidget> widgets) async {
    List<Map<String, dynamic>> widgetsData =
        widgets.map((e) => e.toJson()).toList();
    return await _channel.invokeMethod('add_widgets', {'widgets': widgetsData});
  }

  /// Inserts a new text area on the specified page.
  ///
  /// This method creates a new text box within the page's coordinate system
  /// and writes the given text content into it. The coordinate origin (0, 0)
  /// is located at the bottom-left corner of the page.
  ///
  /// ---
  /// **Parameters:**
  ///
  /// - [pageIndex]: The index of the target page where the text will be inserted,
  ///                starting from 0.
  /// - [content]: The text content to be inserted.
  /// - [offset]: The position of the text area’s bottom-left corner in PDF
  ///             page coordinates (unit: point).
  /// - [maxWidth]: The maximum width of the text area. Text will automatically
  ///               wrap when exceeding this width.
  ///               If `null`, the width is not constrained.
  /// - [attr]: Text attributes, such as font size, color, alignment, etc.
  ///           Defaults to the standard `CPDFEditorTextAttr` configuration.
  ///
  /// ---
  /// **Returns:**
  /// - `true` if the text area is successfully created.
  /// - `false` if the operation fails.
  ///
  /// ---
  /// **Platform Requirements:**
  /// - This method is only supported on Android.
  ///   Calling it on other platforms will throw an `UnsupportedError`.
  ///
  /// ---
  /// **Example:**
  /// ```dart
  /// bool result = await document.createNewTextArea(
  ///       pageIndex: 0,
  ///       content: 'ComPDFKit insert text This is Test create text Area ...',
  ///       offset: const Offset(50, 800),
  ///       maxWidth: 300,
  ///       attr: const CPDFEditorTextAttr(
  ///         fontSize: 18,
  ///         fontColor: Colors.red,
  ///         alignment: CPDFAlignment.left,
  ///       ),
  /// );
  /// ```
  Future<bool> createNewTextArea({
    required int pageIndex,
    required String content,
    required Offset offset,
    double? maxWidth,
    CPDFEditorTextAttr attr = const CPDFEditorTextAttr(),
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError(
          'createNewTextArea() is only supported on Android platform.');
    }
    return await _channel.invokeMethod(
      'create_new_text_area',
      {
        'page_index': pageIndex,
        'content': content,
        'x': offset.dx,
        'y': offset.dy,
        'max_width': maxWidth,
        'attr': attr.toJson(),
      },
    );
  }

  /// Inserts a new image area on the specified page.
  ///
  /// This method creates a new image box within the page's coordinate system.
  /// The coordinate origin (0, 0) is located at the bottom-left corner of the page.
  ///
  /// ---
  /// **Parameters:**
  ///
  /// - [pageIndex]: The index of the target page where the image will be inserted,
  ///                starting from 0.
  /// - [imageData]: The image data to be inserted. Supports multiple formats:
  ///   - File path: `CPDFImageData.fromPath('/path/to/image.png')`
  ///   - Base64: `CPDFImageData.fromBase64('iVBORw0KGgo...')`
  ///   - Asset: `CPDFImageData.fromAsset('assets/images/logo.png')`
  ///   - Uri (Android): `CPDFImageData.fromUri('content://...')`
  /// - [offset]: The position of the image area's bottom-left corner in PDF
  ///             page coordinates (unit: point).
  /// - [width]: The width of the image area. Height is calculated automatically
  ///            based on aspect ratio. If `null`, uses original image width.
  ///
  /// ---
  /// **Returns:**
  /// - `true` if the image area is successfully created.
  /// - `false` if the operation fails.
  ///
  /// ---
  /// **Example:**
  /// ```dart
  /// // From file path
  /// bool result1 = await document.createNewImageArea(
  ///   pageIndex: 0,
  ///   imageData: CPDFImageData.fromPath('/path/to/image.png'),
  ///   offset: const Offset(50, 700),
  ///   width: 200,
  /// );
  ///
  /// // From base64
  /// bool result2 = await document.createNewImageArea(
  ///   pageIndex: 1,
  ///   imageData: CPDFImageData.fromBase64('iVBORw0KGgoAAAANSUhEUgAAAAUA...'),
  ///   offset: const Offset(100, 600),
  ///   width: 150,
  /// );
  ///
  /// // From asset
  /// bool result3 = await document.createNewImageArea(
  ///   pageIndex: 2,
  ///   imageData: CPDFImageData.fromAsset('logo.png'),
  ///   offset: const Offset(200, 500),
  ///   width: null, // Use original width
  /// );
  /// ```
  Future<bool> createNewImageArea({
    required int pageIndex,
    required CPDFImageData imageData,
    required Offset offset,
    double width = 200,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError(
          'createNewTextArea() is only supported on Android platform.');
    }
    try {
      return await _channel.invokeMethod('create_new_image_area', {
        'page_index': pageIndex,
        'image_data': imageData.toJson(),
        'x': offset.dx,
        'y': offset.dy,
        'width': width,
      });
    } on PlatformException catch (e) {
      debugPrint('Error creating image area: ${e.message}');
      return false;
    }
  }
}
