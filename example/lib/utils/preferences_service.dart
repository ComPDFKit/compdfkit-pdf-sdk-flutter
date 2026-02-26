// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// A service class for managing user preferences using SharedPreferences.
///
/// This class provides a centralized way to store and retrieve user settings
/// that persist across app sessions.
class PreferencesService {
  PreferencesService._();

  static SharedPreferences? _prefs;

  // ==================== Keys ====================

  static const String _keyDocumentAuthor = 'document_author';
  static const String _keyHighlightLink = 'highlight_link';
  static const String _keyHighlightForm = 'highlight_form';

  // ==================== Initialization ====================

  /// Initializes the SharedPreferences instance.
  ///
  /// This should be called before accessing any preferences.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Document Author ====================

  /// Gets the saved document author name.
  ///
  /// Returns the default author from [AppConstants.documentAuthor] if not set.
  static String get documentAuthor {
    return _prefs?.getString(_keyDocumentAuthor) ?? AppConstants.documentAuthor;
  }

  /// Sets the document author name.
  static Future<bool> setDocumentAuthor(String author) async {
    await init();
    return _prefs!.setString(_keyDocumentAuthor, author);
  }

  // ==================== Highlight Link ====================

  /// Gets the highlight link setting.
  ///
  /// Returns false if not set.
  static bool get highlightLink {
    return _prefs?.getBool(_keyHighlightLink) ?? false;
  }

  /// Sets the highlight link setting.
  static Future<bool> setHighlightLink(bool value) async {
    await init();
    return _prefs!.setBool(_keyHighlightLink, value);
  }

  // ==================== Highlight Form ====================

  /// Gets the highlight form setting.
  ///
  /// Returns false if not set.
  static bool get highlightForm {
    return _prefs?.getBool(_keyHighlightForm) ?? false;
  }

  /// Sets the highlight form setting.
  static Future<bool> setHighlightForm(bool value) async {
    await init();
    return _prefs!.setBool(_keyHighlightForm, value);
  }
}
