/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Utility methods for working with PDF form widgets.
///
/// This class currently provides helpers for generating unique and readable
/// form field names for different widget types.
///
/// The generated field name is composed of:
/// - The widget type name (capitalized)
/// - An underscore (`_`)
/// - A timestamp using the local time in the format:
///   `yyyyMMdd HH:mm:ss.SSS`
///
/// Example output:
/// `TextField_20260123 14:05:33.127`
///
/// This is useful when creating fields programmatically and you need a stable,
/// human-friendly name that is unlikely to collide.
/// {@category util}
class CPDFWidgetUtil {
  static String createFieldName(CPDFFormType widgetType) {
    final now = DateTime.now();
    final dateStr = '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)} '
        '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}.${now.millisecond.toString().padLeft(3, '0')}';
    final name = widgetType.name;
    final capitalized =
        name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : '';
    return '${capitalized}_$dateStr';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
