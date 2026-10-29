// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// PDF standard conformance level of a document.
///
/// Since v3.2.0 the supported set is no longer limited to PDF/A: it also
/// covers the PDF/X, PDF/E, PDF/UA and PDF/VT families. The values map one to
/// one onto the Android `CPDFDocument.PDFDocumentType` enum and onto the iOS
/// `CPDFStandardMode` (format, typenum, partType) triple.
///
/// Every value can be read on both platforms. As a conversion target, iOS
/// rejects [pdfE2] and [pdf] with `UNSUPPORTED_PDF_STANDARD`.
enum CPDFPdfStandardType {
  /// A plain PDF that does not declare any standard conformance.
  pdf('pdf'),

  pdfA1a('pdf_a_1a'),
  pdfA1b('pdf_a_1b'),
  pdfA2a('pdf_a_2a'),
  pdfA2u('pdf_a_2u'),
  pdfA2b('pdf_a_2b'),
  pdfA3a('pdf_a_3a'),
  pdfA3u('pdf_a_3u'),
  pdfA3b('pdf_a_3b'),

  pdfX1a('pdf_x_1a'),
  pdfX3('pdf_x_3'),
  pdfX4('pdf_x_4'),

  pdfE1('pdf_e_1'),

  /// PDF/E-2. iOS cannot convert to it: the conversion fails with
  /// `UNSUPPORTED_PDF_STANDARD`.
  pdfE2('pdf_e_2'),

  pdfUA1('pdf_ua_1'),

  pdfVT1('pdf_vt_1'),
  pdfVT2('pdf_vt_2');

  const CPDFPdfStandardType(this.value);

  /// The wire value exchanged with the native platforms.
  final String value;

  /// Resolves a native wire value back to an enum entry.
  ///
  /// Unknown values fall back to [CPDFPdfStandardType.pdf] so that a newer
  /// native SDK cannot crash an older Dart layer.
  static CPDFPdfStandardType fromValue(String? value) {
    for (final type in CPDFPdfStandardType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return CPDFPdfStandardType.pdf;
  }
}

/// Error raised by the PDF standard detection and conversion APIs.
///
/// The [code] values are stable across platforms:
///
/// * `INVALID_OUTPUT_PATH` - the output path is empty, not writable, its
///   parent directory is missing, or it points at the current document.
/// * `DOCUMENT_INVALID` - the document has been released or is invalid.
/// * `ENCRYPTED_DOCUMENT_NOT_CONVERTIBLE` - the document carries a password.
/// * `UNSUPPORTED_PDF_STANDARD` - the platform cannot convert to the requested
///   type. Raised on iOS for [CPDFPdfStandardType.pdfE2] and
///   [CPDFPdfStandardType.pdf].
/// * `PDF_STANDARD_CONVERT_FAILED` - the native conversion failed. On iOS the
///   message carries the native failure reason.
/// * `PDF_STANDARD_SAVE_FAILED` - the conversion succeeded but writing the
///   output file failed.
/// * `PDF_STANDARD_RESTORE_FAILED` - the output file was written, but the
///   opened document could not be reloaded from its original source and still
///   holds the converted content. Do not save it: doing so would overwrite the
///   source file. Close and reopen the document instead. Android only: iOS
///   converts a copy and never touches the opened document.
class CPDFPdfStandardException implements Exception {
  const CPDFPdfStandardException(this.code, this.message);

  final String code;

  final String message;

  @override
  String toString() => 'CPDFPdfStandardException($code): $message';
}
