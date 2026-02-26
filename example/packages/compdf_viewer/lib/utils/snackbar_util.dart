// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// Global snackbar utility for displaying bottom toast messages.
///
/// Provides a simple API for showing temporary bottom snackbar notifications
/// with consistent styling across the app. Uses GetX snackbar system with
/// localized "Tips" title.
///
/// Key features:
/// - Bottom positioned snackbars with standard margins
/// - Localized "Tips" title for all messages
/// - Consistent spacing above bottom navigation
///
/// Usage examples:
/// ```dart
/// // Show success message
/// SnackbarUtil.showTips('File saved successfully');
///
/// // Show error message
/// SnackbarUtil.showTips('Failed to load document');
///
/// // With localized text
/// SnackbarUtil.showTips(PdfLocaleKeys.saveSuccess.tr);
/// ```
///
/// Common use cases:
/// - Operation success/failure feedback
/// - File save confirmations
/// - General info messages
class SnackbarUtil {
  SnackbarUtil._();

  /// Show bottom tip message
  static void showTips(String message) {
    Get.snackbar(PdfLocaleKeys.tips.tr, message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 56, left: 16, right: 16));
  }
}
