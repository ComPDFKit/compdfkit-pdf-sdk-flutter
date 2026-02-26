// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../cpdf_reader_page.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/loading_error_scaffold.dart';

/// Dark Theme Viewer Example
///
/// Demonstrates configuring the PDF viewer with a dark theme (Android only).
///
/// This example shows:
/// - Setting [CPDFThemeMode.dark] via [CPDFGlobalConfig]
/// - Configuring theme mode at initialization
/// - Platform-specific theme behavior (Android only)
///
/// Key classes/APIs used:
/// - [CPDFGlobalConfig]: Global configuration including theme mode
/// - [CPDFThemeMode]: Theme options (light, dark, system)
/// - [CPDFConfiguration]: Main configuration container
///
/// Note: Theme mode configuration is currently Android-only.
/// On iOS, use system appearance settings.
///
/// Usage:
/// 1. Open the example on an Android device
/// 2. Observe the dark theme applied to the viewer
class DarkThemeExample extends StatelessWidget {
  /// Constructor
  const DarkThemeExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: extractAsset(_assetPath, shouldOverwrite: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingErrorScaffold(title: 'Dark Theme');
        }
        if (!snapshot.hasData) {
          return LoadingErrorScaffold(
            title: 'Dark Theme',
            errorText:
                'Failed to load example document${snapshot.error == null ? '' : ': ${snapshot.error}'}',
          );
        }
        return CPDFReaderPage(
          title: 'Dark Theme',
          documentPath: snapshot.data!.path,
          configuration: CPDFConfiguration(
            globalConfig: const CPDFGlobalConfig(themeMode: CPDFThemeMode.dark),
            annotationsConfig: CPDFAnnotationsConfig(
              annotationAuthor: PreferencesService.documentAuthor,
            ),
            readerViewConfig: CPDFReaderViewConfig(
              linkHighlight: PreferencesService.highlightLink,
              formFieldHighlight: PreferencesService.highlightForm,
            ),
          ),
          onIOSClickBackPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
