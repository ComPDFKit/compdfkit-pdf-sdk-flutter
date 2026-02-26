// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdf_viewer/l10n/locale/en_us.dart';
import 'package:compdf_viewer/l10n/locale/zh_cn.dart';

/// Translation map for the PDF viewer package.
///
/// Provides localized strings for English and Chinese.
/// Use with GetX translations to display localized UI text.
///
/// Example:
/// ```dart
/// GetMaterialApp(
///   translations: PdfViewerTranslations(),
///   locale: Locale('en', 'US'),
///   fallbackLocale: Locale('en', 'US'),
/// );
///
/// // Usage in widgets
/// Text(PdfLocaleKeys.save.tr); // Displays "Save" based on locale
/// ```
///
/// Supported locales:
/// - en_US: English (United States)
/// - zh_CN: Chinese (Simplified)
class PdfViewerTranslations {
  /// Returns the complete translation map.
  ///
  /// Keys are locale identifiers ('en_US', 'zh_CN').
  /// Values are maps of translation keys to localized strings.
  static Map<String, Map<String, String>> get keys => {
        'en_US': localeEnUS,
        'zh_CN': localeZhCN,
      };
}
