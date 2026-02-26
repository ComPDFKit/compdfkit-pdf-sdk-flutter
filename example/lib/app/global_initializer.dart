// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/widgets.dart';

import '../constants/asset_paths.dart';
import '../utils/file_util.dart';
import '../utils/preferences_service.dart';

/// Global Initializer
///
/// Manages all application-level initialization tasks.
/// Ensures initialization happens only once and provides status tracking.
///
/// Usage:
/// ```dart
/// // In main.dart before runApp
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await GlobalInitializer.instance.initialize();
///   runApp(const MyApp());
/// }
/// ```
class GlobalInitializer {
  GlobalInitializer._();

  /// Singleton instance
  static final GlobalInitializer instance = GlobalInitializer._();

  /// Whether initialization has been completed
  bool _initialized = false;

  /// Whether initialization is currently in progress
  bool _initializing = false;

  /// Whether initialization has been completed
  bool get isInitialized => _initialized;

  /// Whether initialization is currently in progress
  bool get isInitializing => _initializing;

  /// Initialize all required components
  ///
  /// This method is idempotent - calling it multiple times will only
  /// perform initialization once.
  Future<void> initialize() async {
    if (_initialized || _initializing) return;

    _initializing = true;
    try {
      await _initPreferences();
      await _initFontDir();
      await _initLicense();
      _initialized = true;
      debugPrint('GlobalInitializer: All components initialized successfully');
    } catch (e) {
      debugPrint('GlobalInitializer: Initialization failed: $e');
      rethrow;
    } finally {
      _initializing = false;
    }
  }

  /// Initialize user preferences
  Future<void> _initPreferences() async {
    await PreferencesService.init();
    debugPrint('GlobalInitializer: Preferences initialized');
  }

  /// Initialize font directory for PDF rendering
  Future<void> _initFontDir() async {
    final fontDir = await extractAssetFolder('extraFonts/');
    await ComPDFKit.setImportFontDir(fontDir, addSysFont: true);
    debugPrint('GlobalInitializer: Font directory initialized');
  }

  /// Initialize ComPDFKit license
  Future<void> _initLicense() async {
    final File licenseFile = await CPDFFileUtil.extractAsset(
      AppAssets.licenseKeyFlutter,
      shouldOverwrite: false,
    );
    final initResult = await ComPDFKit.initWithPath(licenseFile.path);
    debugPrint('GlobalInitializer: SDK init result: $initResult');
  }

  /// Reset initialization state (useful for testing)
  @visibleForTesting
  void reset() {
    _initialized = false;
    _initializing = false;
  }
}
