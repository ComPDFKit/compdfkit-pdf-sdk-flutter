// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/navigation/reading_settings/theme/theme_selector_button.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/theme/theme_selector_color_picker_dialog.dart';
import 'package:compdf_viewer/features/navigation/side_navigation.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/utils/pdf_global_settings_data.dart';

/// Height of the theme selector.
const double _kThemeSelectorHeight = 48.0;

/// Default predefined themes.
const _defaultThemes = [
  CPDFThemes.light,
  CPDFThemes.reseda,
  CPDFThemes.sepia,
  CPDFThemes.dark,
];

/// PDF reading theme selector with predefined and custom color options.
class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  final PdfViewerController _pdfController = Get.find<PdfViewerController>();
  final Rx<CPDFThemes> _selectedTheme = CPDFThemes.light.obs;

  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  Future<void> _initTheme() async {
    final controller = _pdfController.readerController.value;
    if (controller == null) return;

    final color = await controller.getReadBackgroundColor();
    _selectedTheme.value = CPDFThemes.of(color);
  }

  void _onThemeSelected(CPDFThemes theme) {
    _selectedTheme.value = theme;
    _pdfController.readerController.value?.setReadBackgroundColor(theme);
    PdfGlobalSettingsData.setReadBackgroundColor(theme);
  }

  @override
  Widget build(BuildContext context) {
    final themesWithCustom = [
      ..._defaultThemes,
      // CPDFThemes.custom(Colors.white)
    ];
    return SizedBox(
        height: _kThemeSelectorHeight,
        width: kSideNavigationWidth,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: themesWithCustom.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, index) {
            final theme = themesWithCustom[index];

            return Obx(() {
              final isSelected = theme.type == CPDFThemeType.custom
                  ? _selectedTheme.value.type == CPDFThemeType.custom
                  : _selectedTheme.value.type == theme.type;

              return ThemeSelectorButton(
                theme: theme,
                isSelect: isSelected,
                onTap: theme.type == CPDFThemeType.custom
                    ? (_) => _showColorPicker(context)
                    : _onThemeSelected,
              );
            });
          },
        ));
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ThemeSelectorColorPickerDialog(
        defaultColor: Colors.white,
        onSelect: (customTheme) => _onThemeSelected(customTheme),
      ),
    );
  }
}
