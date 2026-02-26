// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.
// example/lib/main.dart

import 'dart:ui';

import 'package:compdfkit_flutter_example/app/global_initializer.dart';
import 'package:compdfkit_flutter_example/app/home_page.dart';
import 'package:compdfkit_flutter_example/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/compdf_viewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalInitializer.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _getLightTheme() => lightTheme;
  ThemeData _getDarkTheme() => darkTheme;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ComPDFKit SDK for Flutter',
      theme: _getLightTheme(),
      darkTheme: _getDarkTheme(),
      themeMode: ThemeMode.system,
      // Localization
      translations: _AppTranslations(),
      locale: _getDeviceLocale(),
      fallbackLocale: const Locale('en', 'US'),
      // Routes
      getPages: PdfViewerPages.routes,
      home: const HomePage(),
    );
  }

  /// Get device locale, defaults to en_US if not supported
  Locale _getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    // Check if device locale is supported
    if (deviceLocale.languageCode == 'zh') {
      return const Locale('zh', 'CN');
    }
    return const Locale('en', 'US');
  }
}

/// App translations combining pdf_viewer translations
class _AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => PdfViewerTranslations.keys;
}
