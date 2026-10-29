// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Image compression algorithm applied while optimizing a document.
///
/// The values map one to one onto the Android
/// `CPDFDocument.CPDFCompressAlgorithm` enum. The wire format is the string in
/// [value] rather than the native ordinal, because the iOS `CPDF_COMP_ALG`
/// enum uses different numeric values for the same algorithms.
enum CPDFCompressAlgorithm {
  /// Keeps the existing encoding of the image.
  none('none'),

  /// Lossless Flate (zlib) encoding.
  flate('flate'),

  /// Lossless run length encoding.
  runLength('run_length'),

  /// Lossy DCT encoding, i.e. baseline JPEG.
  jpeg('jpeg'),

  /// JBIG2 encoding, intended for monochrome images.
  jbig2('jbig2'),

  /// Lossy JPEG 2000 (JPX) encoding.
  jpeg2000('jpeg2000');

  const CPDFCompressAlgorithm(this.value);

  /// The wire value exchanged with the native platforms.
  final String value;

  /// Resolves a native wire value back to an enum entry.
  ///
  /// Unknown values fall back to [CPDFCompressAlgorithm.none] so that a newer
  /// native SDK cannot crash an older Dart layer.
  static CPDFCompressAlgorithm fromValue(String? value) {
    for (final algorithm in CPDFCompressAlgorithm.values) {
      if (algorithm.value == value) {
        return algorithm;
      }
    }
    return CPDFCompressAlgorithm.none;
  }
}
