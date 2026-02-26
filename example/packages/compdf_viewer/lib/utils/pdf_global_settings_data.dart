// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:compdf_viewer/compdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent storage for PDF viewer global settings.
///
/// Uses SharedPreferences to store user preferences including:
/// - Crop mode enabled/disabled
/// - Background color theme (light/dark/sepia/reseda)
/// - Scroll direction (vertical/horizontal)
/// - Continuous scrolling mode
/// - Display mode (single page/double page/book mode)
/// - Page number indicator visibility
/// - Fullscreen default setting
/// - Sidebar expansion states
///
/// All settings persist across app sessions.
///
/// Example:
/// ```dart
/// // Save crop mode setting
/// await PdfGlobalSettingsData.setIsCropMode(true);
///
/// // Load crop mode setting
/// final isCropMode = await PdfGlobalSettingsData.getIsCropMode();
///
/// // Save theme
/// await PdfGlobalSettingsData.setReadBackgroundColor(CPDFThemes.sepia);
///
/// // Load theme
/// final theme = await PdfGlobalSettingsData.getReadBackgroundColor();
/// ```
class PdfGlobalSettingsData {
  static const String _isExpandRotateSetting = 'is_expand_rotate_setting';
  static const String _isExpandScrollPagesSetting =
      'is_expand_scroll_pages_setting';
  static const String _isExpandDisplayModeSetting =
      'is_expand_display_mode_setting';
  static const String _isShowPageNum = 'is_show_page_num';
  static const String _isDefaultFullScreen = 'is_default_full_screen';
  static const String _isCropMode = 'is_crop_mode';
  static const String _readBackgroundColor = 'read_background_color';
  static const String isVerticalMode = 'is_vertical_mode';
  static const String isContinueMode = 'is_continue_mode';
  static const String displayMode = 'cpdf_display_mode';

  static Future<bool> setValue(String key, dynamic value) async {
    // Save any value
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is String) {
      return prefs.setString(key, value);
    } else if (value is List<String>) {
      return prefs.setStringList(key, value);
    }
    return false;
  }

  static Future<bool> getBoolean(String key,
      {bool defaultValue = false}) async {
    // Get any value
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    // Get any value
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? defaultValue;
  }

  static Future<bool> setIsExpandRotateSetting(bool value) async {
    // Save expand state
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isExpandRotateSetting, value);
  }

  static Future<bool> getIsExpandRotateSetting() async {
    // Get expand state
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isExpandRotateSetting) ?? false;
  }

  static Future<bool> setIsExpandScrollPagesSetting(bool value) async {
    // Save expand state
    PdfViewerGlobal.logger.i('Set expand scroll direction setting: $value');
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isExpandScrollPagesSetting, value);
  }

  static Future<bool> getIsExpandScrollPagesSetting() async {
    // Get expand state
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isExpandScrollPagesSetting) ?? false;
  }

  static Future<bool> setIsExpandDisplayModeSetting(bool value) async {
    // Save expand state
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isExpandDisplayModeSetting, value);
  }

  static Future<bool> getIsExpandDisplayModeSetting() async {
    // Get expand state
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isExpandDisplayModeSetting) ?? false;
  }

  static Future<bool> setIsShowPageNum(bool value) async {
    // Save whether to show page number indicator
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isShowPageNum, value);
  }

  static Future<bool> getIsShowPageNum() async {
    // Get whether to show page number indicator
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isShowPageNum) ?? true;
  }

  static Future<bool> setIsDefaultFullScreen(bool value) async {
    // Save whether to default fullscreen
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isDefaultFullScreen, value);
  }

  static Future<bool> getIsDefaultFullScreen() async {
    // Get whether to default fullscreen
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDefaultFullScreen) ?? false;
  }

  static Future<bool> setIsCropMode(bool value) async {
    // Save whether crop mode
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isCropMode, value);
  }

  static Future<bool> getIsCropMode() async {
    // Get whether crop mode
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isCropMode) ?? false;
  }

  static Future<bool> setReadBackgroundColor(CPDFThemes theme) async {
    // Save reading background color
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_readBackgroundColor, theme.color);
  }

  static Future<CPDFThemes> getReadBackgroundColor() async {
    // Get reading background color
    final prefs = await SharedPreferences.getInstance();
    var readBackgroundColor = prefs.getString(_readBackgroundColor) ??
        '#FFFFFFFF'; // Default white background
    return CPDFThemes.of(HexColor.fromHex(readBackgroundColor));
  }
}
