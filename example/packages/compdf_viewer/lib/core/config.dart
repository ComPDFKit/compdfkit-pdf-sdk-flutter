// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/attributes/cpdf_highlight_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/cpdf_square_attr.dart';
import 'package:compdfkit_flutter/configuration/attributes/cpdf_text_attr.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/utils/pdf_global_settings_data.dart';

/// Builds PDF reader configuration with persistent user preferences.
///
/// Retrieves previously saved settings from local storage including:
/// - Crop mode (enabled/disabled)
/// - Background color theme (light/dark/sepia/reseda)
/// - Scroll direction (vertical/horizontal)
/// - Continuous scrolling mode
/// - Display mode (single page/double page/book mode)
///
/// Also configures:
/// - Annotation toolbar visibility
/// - Reader view margins and spacing
/// - Default annotation styles (note, highlight, square)
///
/// Returns a fully configured [CPDFConfiguration] instance.
///
/// Example:
/// ```dart
/// final config = await getCpdfConfig();
/// CPDFReaderWidget(
///   document: documentPath,
///   configuration: config,
/// );
/// ```
Future<CPDFConfiguration> getCpdfConfig() async {
  // Load any necessary configurations or settings here
  bool isCropMode = await PdfGlobalSettingsData.getIsCropMode();
  CPDFThemes theme = await PdfGlobalSettingsData.getReadBackgroundColor();
  bool isVerticalMode = await PdfGlobalSettingsData.getBoolean(
      PdfGlobalSettingsData.isVerticalMode,
      defaultValue: true);
  bool isContinueMode = await PdfGlobalSettingsData.getBoolean(
      PdfGlobalSettingsData.isContinueMode,
      defaultValue: true);

  String savedModeName = await PdfGlobalSettingsData.getValue(
    PdfGlobalSettingsData.displayMode,
    defaultValue: CPDFDisplayMode.singlePage.name,
  );

  CPDFDisplayMode displayMode = CPDFDisplayMode.values.firstWhere(
    (mode) => mode.name == savedModeName,
    orElse: () => CPDFDisplayMode.singlePage,
  );

  return CPDFConfiguration(
      modeConfig: CPDFModeConfig(
        uiVisibilityMode: CPDFUIVisibilityMode.automatic,
        initialViewMode: CPDFViewMode.annotations,
      ),
      toolbarConfig: CPDFToolbarConfig(
          annotationToolbarVisible: true, mainToolbarVisible: false),
      readerViewConfig: CPDFReaderViewConfig(
          enableSliderBar: true,
          enablePageIndicator: false,
          cropMode: isCropMode,
          themes: theme,
          margins: [10, 10, 10, 10],
          pageSpacing: 10,
          verticalMode: isVerticalMode,
          continueMode: isContinueMode,
          displayMode: displayMode),
      annotationsConfig: CPDFAnnotationsConfig(
          initAttribute: CPDFAnnotAttribute(
              noteAttr: CPDFTextAttr(color: Colors.amber, alpha: 255),
              highlightAttr:
                  CPDFHighlightAttr(color: Colors.deepOrange, alpha: 255),
              squareAttr: CPDFSquareAttr(
                  fillColor: Colors.blueAccent,
                  borderColor: Colors.greenAccent))));
}
