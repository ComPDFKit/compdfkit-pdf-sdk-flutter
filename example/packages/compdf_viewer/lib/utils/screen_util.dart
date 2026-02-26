// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

/// Screen rotation management utilities for the PDF viewer.
///
/// Provides persistent screen rotation settings with three modes: follow system,
/// auto-rotate, and lock rotation. Settings are saved to SharedPreferences and
/// applied via SystemChrome preferred orientations.
///
/// Rotation modes:
/// - Follow System: Allows all orientations, respects device auto-rotate setting
/// - Auto Rotate: Always allows rotation (same as follow system in implementation)
/// - Lock Rotation: Locks to current orientation (portrait or landscape)
///
/// Key features:
/// - Persists rotation mode and last orientation to SharedPreferences
/// - Applies settings system-wide via SystemChrome
/// - Supports portrait and landscape locking
/// - Can restore saved settings on app restart
///
/// Usage examples:
/// ```dart
/// // Set rotation mode
/// await ScreenUtil.setRotationMode(
///   ScreenRotationMode.lockRotation,
///   orientation: MediaQuery.of(context).orientation,
/// );
///
/// // Get current mode
/// final mode = await ScreenUtil.getRotationMode();
///
/// // Apply saved settings
/// ScreenUtil.applyRotationMode();
///
/// // Lock to specific orientation
/// ScreenUtil.lockPortrait();
/// ScreenUtil.lockLandscape();
/// ```
///
/// Integration with RotateSetting widget:
/// - RotateSetting reads mode via getRotationMode()
/// - User selections update via setRotationMode()
/// - applyRotationMode() applies changes immediately
enum ScreenRotationMode {
  followSystem,
  autoRotate,
  lockRotation;

  static ScreenRotationMode fromName(String name) {
    return ScreenRotationMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ScreenRotationMode.followSystem,
    );
  }
}

class ScreenUtil {
  static const String _key = 'screen_rotation_mode';
  static const String _orientation = 'screen_orientation';

  /// Save screen rotation setting
  static Future<void> setRotationMode(ScreenRotationMode mode,
      {Orientation? orientation}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
    if (orientation != null) {
      await prefs.setString(_orientation, orientation.name);
    }
  }

  /// Get current screen rotation setting
  static Future<ScreenRotationMode> getRotationMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return ScreenRotationMode.fromName(saved ?? 'followSystem');
  }

  /// Get recorded screen orientation
  static Future<Orientation> getRecordedOrientation() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_orientation);
    return Orientation.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => Orientation.portrait,
    );
  }

  // Follow system rotation (allow all orientations)
  static void followSystemRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Auto rotate (same as follow system)
  static void enableAutoRotation() {
    followSystemRotation();
  }

  static void lockScreenRotation(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      // Currently in portrait
      lockPortrait();
    } else {
      // Currently in landscape
      lockLandscape();
    }
  }

  // Lock portrait
  static void lockPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  // Lock landscape
  static void lockLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void applyRotationMode() async {
    final mode = await getRotationMode();
    switch (mode) {
      case ScreenRotationMode.followSystem:
        followSystemRotation();
        break;
      case ScreenRotationMode.autoRotate:
        enableAutoRotation();
        break;
      case ScreenRotationMode.lockRotation:
        final recordOrientation = await getRecordedOrientation();
        if (recordOrientation == Orientation.portrait) {
          lockPortrait();
        } else {
          lockLandscape();
        }
        break;
    }
  }
}
