// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Error raised by the document optimization APIs.
///
/// The [code] values are stable across platforms:
///
/// * `DOCUMENT_INVALID` - the document has been released or is invalid.
/// * `INVALID_OUTPUT_PATH` - the output path is empty, not writable, its
///   parent directory is missing, or it points at the current document.
/// * `INVALID_OPTIMIZE_OPTIONS` - the options payload is incomplete or holds
///   out of range values.
/// * `OPTIMIZE_ALREADY_RUNNING` - another optimization run is already in
///   flight on this document. iOS allows a single run across all documents.
/// * `OPTIMIZE_FAILED` - the native run reported a failure.
/// * `OPTIMIZE_RESTORE_FAILED` - the opened document could not be reloaded
///   from its original source and still holds the optimized content. Do not
///   save it: doing so would overwrite the source file. Close and reopen the
///   document instead.
class CPDFOptimizeException implements Exception {
  const CPDFOptimizeException(this.code, this.message);

  final String code;

  final String message;

  @override
  String toString() => 'CPDFOptimizeException($code): $message';
}
