// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Snackbar type for different message categories.
enum SnackBarType {
  /// Success message with emerald green accent
  success,

  /// Error message with coral red accent
  error,

  /// Warning message with amber accent
  warning,

  /// Informational message with blue accent
  info,
}

/// A themed Snackbar utility for displaying consistent messages
/// throughout the ComPDFKit example application.
///
/// Features a modern design with:
/// - Rounded icon badge with subtle background
/// - Smooth backdrop blur effect
/// - Elegant shadow and border styling
///
/// Usage:
/// ```dart
/// SnackBarHelper.show(context, message: 'Document saved');
/// SnackBarHelper.success(context, message: 'Export completed');
/// SnackBarHelper.error(context, message: 'Failed to load document');
/// ```
class SnackBarHelper {
  SnackBarHelper._();

  static const Duration _defaultDuration = Duration(seconds: 3);
  static const double _borderRadius = 12.0;
  static const double _iconBadgeSize = 32.0;

  /// Shows a themed Snackbar with the specified [message].
  ///
  /// [type] determines the color scheme (default: [SnackBarType.info]).
  /// [action] optional action button configuration.
  /// [duration] how long the Snackbar is displayed.
  /// [showCloseIcon] whether to show a dismiss button.
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    SnackBarAction? action,
    Duration duration = _defaultDuration,
    bool showCloseIcon = false,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      _buildSnackBar(
        context,
        message: message,
        type: type,
        action: action,
        duration: duration,
        showCloseIcon: showCloseIcon,
      ),
    );
  }

  /// Shows a success Snackbar (emerald green accent).
  static void success(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = _defaultDuration,
    bool showCloseIcon = false,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      action: action,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows an error Snackbar (coral red accent).
  static void error(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = _defaultDuration,
    bool showCloseIcon = false,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      action: action,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows a warning Snackbar (amber accent).
  static void warning(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = _defaultDuration,
    bool showCloseIcon = false,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      action: action,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Shows an info Snackbar (blue accent).
  static void info(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = _defaultDuration,
    bool showCloseIcon = false,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      action: action,
      duration: duration,
      showCloseIcon: showCloseIcon,
    );
  }

  static SnackBar _buildSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    SnackBarAction? action,
    required Duration duration,
    required bool showCloseIcon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = _getColors(isDark, type);

    return SnackBar(
      elevation: 6,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            // Icon badge with gradient background and layered shadow
            Container(
              width: _iconBadgeSize,
              height: _iconBadgeSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.accentColor,
                    colors.accentColor.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  // Primary glow shadow
                  BoxShadow(
                    color: colors.accentColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  // Subtle ambient shadow
                  BoxShadow(
                    color: colors.accentColor.withValues(alpha: 0.2),
                    blurRadius: 6,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getIcon(type),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            // Message text
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textColor,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            // Close button (optional)
            if (showCloseIcon)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colors.textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: colors.backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        side: BorderSide(
          color: colors.borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      action: action != null
          ? SnackBarAction(
              label: action.label,
              textColor: colors.accentColor,
              onPressed: action.onPressed,
            )
          : null,
    );
  }

  static IconData _getIcon(SnackBarType type) {
    return switch (type) {
      SnackBarType.success => Icons.check_rounded,
      SnackBarType.error => Icons.close_rounded,
      SnackBarType.warning => Icons.priority_high_rounded,
      SnackBarType.info => Icons.lightbulb_outline_rounded,
    };
  }

  static _SnackBarColors _getColors(bool isDark, SnackBarType type) {
    // ==================== Light Theme Colors ====================
    const lightSuccess = Color(0xFF1460F3); // ComPDFKit Primary Blue
    const lightError = Color(0xFFEF4444); // Red 500
    const lightWarning = Color(0xFFF59E0B); // Amber 500
    const lightInfo = Color(0xFF3B82F6); // Blue 500

    // ==================== Dark Theme Colors ====================
    const darkSuccess = Color(0xFF60A5FA); // Blue 400
    const darkError = Color(0xFFF87171); // Red 400
    const darkWarning = Color(0xFFFBBF24); // Amber 400
    const darkInfo = Color(0xFF60A5FA); // Blue 400

    return switch (type) {
      SnackBarType.success => _SnackBarColors(
          backgroundColor: isDark
              ? const Color(0xFF1A2536) // Dark blue bg
              : const Color(0xFFEBF4FF), // Light blue bg
          textColor: isDark
              ? const Color(0xFFE2E8F0) // Slate 200
              : const Color(0xFF1E293B), // Slate 800
          accentColor: isDark ? darkSuccess : lightSuccess,
          borderColor: isDark
              ? const Color(0xFF2D4A6E) // Dark blue border
              : const Color(0xFFBFDBFE), // Light blue border
        ),
      SnackBarType.error => _SnackBarColors(
          backgroundColor: isDark
              ? const Color(0xFF2D1F1F) // Dark red bg
              : const Color(0xFFFEF2F2), // Light red bg
          textColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          accentColor: isDark ? darkError : lightError,
          borderColor: isDark
              ? const Color(0xFF4A2D2D) // Dark red border
              : const Color(0xFFFECACA), // Light red border
        ),
      SnackBarType.warning => _SnackBarColors(
          backgroundColor: isDark
              ? const Color(0xFF2D2816) // Dark amber bg
              : const Color(0xFFFFFBEB), // Light amber bg
          textColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          accentColor: isDark ? darkWarning : lightWarning,
          borderColor: isDark
              ? const Color(0xFF4A4020) // Dark amber border
              : const Color(0xFFFEF3C7), // Light amber border
        ),
      SnackBarType.info => _SnackBarColors(
          backgroundColor: isDark
              ? const Color(0xFF1E2A3B) // Dark blue bg
              : const Color(0xFFEFF6FF), // Light blue bg
          textColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          accentColor: isDark ? darkInfo : lightInfo,
          borderColor: isDark
              ? const Color(0xFF2D3E56) // Dark blue border
              : const Color(0xFFDBEAFE), // Light blue border
        ),
    };
  }
}

class _SnackBarColors {
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final Color borderColor;

  const _SnackBarColors({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.borderColor,
  });
}
