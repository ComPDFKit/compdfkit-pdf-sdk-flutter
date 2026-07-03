// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Base exception for PDF page thumbnail loading.
class CPDFPageThumbnailException implements Exception {
  /// Error message.
  final String message;

  /// Creates a thumbnail exception.
  const CPDFPageThumbnailException(this.message);

  @override
  String toString() => 'CPDFPageThumbnailException: $message';
}

/// Thrown when the PDF file cannot be opened.
class CPDFPageThumbnailDocumentException extends CPDFPageThumbnailException {
  /// Creates a document exception.
  const CPDFPageThumbnailDocumentException(super.message);
}

/// Thrown when a password is required or incorrect.
class CPDFPageThumbnailPasswordException extends CPDFPageThumbnailException {
  /// Creates a password exception.
  const CPDFPageThumbnailPasswordException(super.message);
}

/// Thrown when the requested page cannot be rendered.
class CPDFPageThumbnailRenderException extends CPDFPageThumbnailException {
  /// Creates a render exception.
  const CPDFPageThumbnailRenderException(super.message);
}
