// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== System UI Overlay Styles ====================

/// Light theme system UI overlay style
const SystemUiOverlayStyle lightSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: _lightSurface,
  systemNavigationBarIconBrightness: Brightness.dark,
);

/// Dark theme system UI overlay style
const SystemUiOverlayStyle darkSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: _darkSurface,
  systemNavigationBarIconBrightness: Brightness.light,
);

/// Get system UI overlay style based on brightness
SystemUiOverlayStyle getSystemUiOverlayStyle(Brightness brightness) {
  return brightness == Brightness.dark
      ? darkSystemUiOverlayStyle
      : lightSystemUiOverlayStyle;
}

// ==================== Color Constants ====================

const _lightPrimary = Color(0xFF1460F3);
const _lightSecondary = Color(0xFF7C3AED);
const _lightTertiary = Color(0xFF16A34A);
const _lightBackground = Color(0xFFFFFFFF);
const _lightSurface = Color(0xFFFFFFFF);
const _lightSurfaceAlt = Color(0xFFF5F7FA);
const _lightSurfaceVariant = Color(0xFFF3F4F6);
const _lightOutline = Color(0xFFD1D5DB);
const _lightOutlineVariant = Color(0xFFE5E7EB);
const _lightTextPrimary = Color(0xFF1A1A1A);
const _lightTextSecondary = Color(0xFF6B7280);

const _darkPrimary = Color(0xFF3B82F6);
const _darkSecondary = Color(0xFFA78BFA);
const _darkTertiary = Color(0xFF22C55E);
const _darkBackground = Color(0xFF0B111A);
const _darkSurface = Color(0xFF111827);
const _darkSurfaceAlt = Color(0xFF1A2230);
const _darkSurfaceVariant = Color(0xFF2A3342);
const _darkOutline = Color(0xFF334155);
const _darkOutlineVariant = Color(0xFF2A3342);
const _darkTextPrimary = Color(0xFFF3F4F6);
const _darkTextSecondary = Color(0xFFA0A9B6);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: _lightBackground,
  fontFamily: 'Inter',
  colorScheme: const ColorScheme.light(
    primary: _lightPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEBF2FF),
    onPrimaryContainer: _lightPrimary,
    secondary: _lightSecondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFEDE9FE),
    onSecondaryContainer: _lightSecondary,
    tertiary: _lightTertiary,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEAF9F5),
    onTertiaryContainer: _lightTertiary,
    error: Color(0xFFDC2626),
    onError: Colors.white,
    surface: _lightSurface,
    onSurface: _lightTextPrimary,
    surfaceContainerHigh: _lightSurfaceAlt,
    surfaceContainerHighest: _lightSurfaceVariant,
    onSurfaceVariant: _lightTextSecondary,
    outline: _lightOutline,
    outlineVariant: _lightOutlineVariant,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  ).apply(
    displayColor: _lightTextPrimary,
    bodyColor: _lightTextPrimary,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 2.0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _lightTextPrimary,
    ),
    backgroundColor: _lightSurface,
    foregroundColor: _lightTextPrimary,
    systemOverlayStyle: lightSystemUiOverlayStyle,
  ),
  cardTheme: const CardThemeData(
    color: _lightSurface,
    elevation: 2,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: _lightOutlineVariant,
    thickness: 1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightPrimary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _lightPrimary,
    foregroundColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return _lightPrimary;
      }
      return _lightOutline;
    }),
    trackColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return const Color(0xFFEBF2FF);
      }
      return _lightOutlineVariant;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return const Color(0xFFEBF2FF);
      }
      return _lightOutlineVariant;
    }),
  ),
  iconTheme: const IconThemeData(color: _lightTextPrimary),
  canvasColor: _lightSurfaceAlt,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _darkBackground,
  fontFamily: 'Inter',
  colorScheme: const ColorScheme.dark(
    primary: _darkPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1C2A4A),
    onPrimaryContainer: _darkPrimary,
    secondary: _darkSecondary,
    onSecondary: Color(0xFF0B111A),
    secondaryContainer: Color(0xFF221A3A),
    onSecondaryContainer: _darkSecondary,
    tertiary: _darkTertiary,
    onTertiary: Color(0xFF0B111A),
    tertiaryContainer: Color(0xFF0F2B22),
    onTertiaryContainer: _darkTertiary,
    error: Color(0xFFF87171),
    onError: Color(0xFF0B111A),
    surface: _darkSurface,
    onSurface: _darkTextPrimary,
    surfaceContainerHigh: _darkSurfaceAlt,
    surfaceContainerHighest: _darkSurfaceVariant,
    onSurfaceVariant: _darkTextSecondary,
    outline: _darkOutline,
    outlineVariant: _darkOutlineVariant,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  ).apply(
    displayColor: _darkTextPrimary,
    bodyColor: _darkTextPrimary,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 2.0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    backgroundColor: _darkSurface,
    foregroundColor: _darkTextPrimary,
    systemOverlayStyle: darkSystemUiOverlayStyle,
  ),
  cardTheme: const CardThemeData(
    color: _darkSurface,
    elevation: 2,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: _darkOutlineVariant,
    thickness: 1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkPrimary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _darkPrimary,
    foregroundColor: Colors.white,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return _darkPrimary;
      }
      return _darkOutline;
    }),
    trackColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return const Color(0xFF1C2A4A);
      }
      return _darkOutlineVariant;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((status) {
      if (status.contains(WidgetState.selected)) {
        return const Color(0xFF1C2A4A);
      }
      return _darkOutlineVariant;
    }),
  ),
  iconTheme: const IconThemeData(color: _darkTextPrimary),
  canvasColor: _darkSurfaceAlt,
);
