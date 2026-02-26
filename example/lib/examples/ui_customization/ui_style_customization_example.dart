// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/config/cpdf_ui_style_config.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

/// UI Style Customization Example
///
/// Demonstrates how to customize the visual appearance of the PDF reader
/// including colors, icons, and border styles for various UI elements.
///
/// This example shows:
/// - Customizing the bookmark indicator icon
/// - Setting custom text selection highlight color
/// - Replacing default selection cursor icons (left/right handles)
/// - Customizing annotation rotation handle icon
/// - Configuring default border styles (color, width, dash pattern)
/// - Configuring focus border styles for selected elements
/// - Customizing crop image mode border appearance
///
/// Key classes/APIs used:
/// - [CPDFUiStyleConfig]: Root configuration for UI styling
/// - [CPDFUiStyleIcons]: Custom icons for selection and rotation handles
/// - [CPDFUiBorderStyle]: Border appearance (color, width, dash pattern, node color)
/// - [CPDFReaderViewConfig.uiStyle]: Applies style configuration to the reader
///
/// Usage:
/// 1. Create [CPDFUiStyleConfig] using the [CPDFUiStyleConfig.create] factory
/// 2. Specify custom icon names matching your asset files
/// 3. Define [CPDFUiBorderStyle] for default, focus, and crop states
/// 4. Pass the config to [CPDFReaderViewConfig.uiStyle]
/// 5. Include the reader config in your [CPDFConfiguration]
class UiStyleCustomizationExample extends StatelessWidget {
  /// Constructor
  const UiStyleCustomizationExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'UI Style Customization',
      assetPath: _assetPath,
      builder: (path) => _UiStyleCustomizationPage(documentPath: path),
    );
  }
}

class _UiStyleCustomizationPage extends ExampleBase {
  const _UiStyleCustomizationPage({required super.documentPath});

  @override
  State<_UiStyleCustomizationPage> createState() =>
      _UiStyleCustomizationPageState();
}

class _UiStyleCustomizationPageState
    extends ExampleBaseState<_UiStyleCustomizationPage> {
  @override
  String get pageTitle => 'UI Style Customization';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
          uiStyle: CPDFUiStyleConfig.create(
            bookmarkIcon: 'ic_test_bookmark',
            selectTextColor: Colors.deepOrange.withAlpha(100),
            icons: const CPDFUiStyleIcons(
              selectTextIcon: 'ic_test_cursor',
              selectTextLeftIcon: 'ic_test_cursor_left',
              selectTextRightIcon: 'ic_test_cursor_right',
              rotationAnnotationIcon: 'ic_test_rotate',
            ),
            defaultBorderStyle: const CPDFUiBorderStyle(
              borderColor: Colors.amberAccent,
              borderWidth: 2,
              borderDashPattern: [20, 8],
            ),
            focusBorderStyle: const CPDFUiBorderStyle(
              nodeColor: Colors.pink,
              borderColor: Colors.pink,
              borderWidth: 2,
              borderDashPattern: [20, 8],
            ),
            cropImageStyle: const CPDFUiBorderStyle(
              borderColor: Colors.pink,
              borderWidth: 2,
              borderDashPattern: [20, 8],
            ),
          ),
        ),
      );
}
