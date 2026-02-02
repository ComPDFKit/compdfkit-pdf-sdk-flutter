/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

/// Utility class for formatting dates and times.
/// {@category util}
class CPDFDate {
  /// Formats an integer to a two-digit string.
  ///
  /// For example, `3` becomes `03` and `12` remains `12`.
  static String _two(int v) => v < 10 ? '0$v' : v.toString();

  /// Formats the current date/time into a string.
  ///
  /// - When [dateSwitch] is `true`, includes the date part in `yyyy/MM/dd`.
  /// - When [timeSwitch] is `true`, includes the time part in `HH:mm:ss`.
  /// - When both are `true`, they are separated by a single space.
  /// - When both are `false`, returns an empty string.
  ///
  /// Returns the formatted string based on the selected parts.
  static String formatDateTime({
    required bool timeSwitch,
    required bool dateSwitch,
  }) {
    if (!timeSwitch && !dateSwitch) return '';
    final now = DateTime.now();
    final buffer = StringBuffer();

    if (dateSwitch) {
      buffer
        ..write(now.year)
        ..write('/')
        ..write(_two(now.month))
        ..write('/')
        ..write(_two(now.day));
    }
    if (timeSwitch) {
      if (dateSwitch) buffer.write(' ');
      buffer
        ..write(_two(now.hour))
        ..write(':')
        ..write(_two(now.minute))
        ..write(':')
        ..write(_two(now.second));
    }
    return buffer.toString();
  }

  /// Returns a formatted timestamp string for text stamp usage.
  ///
  /// This is a convenience wrapper around [formatDateTime].
  ///
  /// - [dateSwitch] controls whether the date part is included.
  /// - [timeSwitch] controls whether the time part is included.
  static String getTextStampDate({
    required bool timeSwitch,
    required bool dateSwitch,
  }) {
    return formatDateTime(timeSwitch: timeSwitch, dateSwitch: dateSwitch);
  }
}
