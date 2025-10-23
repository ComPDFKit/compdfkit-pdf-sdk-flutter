/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

// config/cpdf_configuration_manager.dart
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

class CPDFConfigurationManager {

  static CPDFConfiguration get defaultConfig => CPDFConfiguration();

  static CPDFConfiguration get annotationConfig => CPDFConfiguration(
    modeConfig: const CPDFModeConfig(
      initialViewMode: CPDFViewMode.annotations,
      uiVisibilityMode: CPDFUIVisibilityMode.never,
    ),
    toolbarConfig: const CPDFToolbarConfig(mainToolbarVisible: false),
  );

  static CPDFConfiguration get controllerExampleConfig => CPDFConfiguration();

  static CPDFConfiguration buildConfig({
    CPDFViewMode? initialViewMode,
    CPDFUIVisibilityMode? uiVisibilityMode,
    bool mainToolbarVisible = true,
    CPDFWatermarkConfig? watermark,
  }) {
    return CPDFConfiguration(
      modeConfig: CPDFModeConfig(
        initialViewMode: initialViewMode ?? CPDFViewMode.viewer,
        uiVisibilityMode: uiVisibilityMode ?? CPDFUIVisibilityMode.automatic,
      ),
      toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: mainToolbarVisible),
      globalConfig: CPDFGlobalConfig(watermark: watermark ?? const CPDFWatermarkConfig())
    );
  }
}
