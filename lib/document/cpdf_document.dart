// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.



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
  // late MethodChannel _channel;
  //
  // bool _isValid = false;
  //
  // CPDFDocument.withController(int viewId)
  //     : _channel = MethodChannel('com.compdfkit.flutter.document_$viewId'),
  //       _isValid = true;

}
