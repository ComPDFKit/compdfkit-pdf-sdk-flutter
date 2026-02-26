// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../cpdf_reader_page.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/loading_error_scaffold.dart';

/// Basic PDF Viewer Example
///
/// Demonstrates the simplest way to open and display a PDF document.
///
/// This example shows:
/// - Loading a PDF from app assets using [extractAsset]
/// - Displaying PDF with [CPDFReaderPage] widget
/// - Basic [CPDFConfiguration] setup with annotation author
/// - Handling back navigation on iOS
///
/// Key classes/APIs used:
/// - [CPDFReaderPage]: High-level PDF viewer widget
/// - [CPDFConfiguration]: Configuration options for the viewer
/// - [CPDFAnnotationsConfig]: Annotation-specific settings
///
/// Usage:
/// 1. Open the example to view the sample PDF document
/// 2. Use pinch-to-zoom and swipe gestures to navigate
/// 3. Access annotation tools from the toolbar
class BasicViewerExample extends StatelessWidget {
  /// Constructor
  const BasicViewerExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: extractAsset(_assetPath, shouldOverwrite: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingErrorScaffold(title: 'Basic Viewer');
        }
        if (!snapshot.hasData) {
          return LoadingErrorScaffold(
            title: 'Basic Viewer',
            errorText:
                'Failed to load example document${snapshot.error == null ? '' : ': ${snapshot.error}'}',
          );
        }
        return CPDFReaderPage(
          title: 'Basic Viewer',
          documentPath: snapshot.data!.path,
          configuration: CPDFConfiguration(
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
