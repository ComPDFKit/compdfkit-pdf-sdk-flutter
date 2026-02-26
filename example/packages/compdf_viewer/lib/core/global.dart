// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:logger/logger.dart';

/// Global configuration and utilities for the PDF viewer package.
///
/// Provides centralized access to:
/// - Logger instance for debugging and error tracking
/// - ComPDFKit SDK initialization
///
/// Example:
/// ```dart
/// // Initialize the SDK with license
/// await PdfViewerGlobal.init('path/to/license.xml');
///
/// // Use logger for debugging
/// PdfViewerGlobal.logger.i('PDF loaded successfully');
/// PdfViewerGlobal.logger.e('Failed to load PDF: $error');
/// ```
class PdfViewerGlobal {
  /// Global logger instance for the PDF viewer package.
  ///
  /// Uses [PrettyPrinter] for formatted console output.
  static var logger = Logger(
    printer: PrettyPrinter(),
  );

  /// Initializes ComPDFKit SDK with the provided license file.
  ///
  /// Must be called before using any PDF functionality.
  ///
  /// [licenseFilePath] - Absolute path to the ComPDFKit license file.
  ///
  /// Example:
  /// ```dart
  /// await PdfViewerGlobal.init('assets/license_key_flutter.xml');
  /// ```
  static Future<void> init(String licenseFilePath) async {
    ComPDFKit.initWithPath(licenseFilePath);
  }
}
