// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';
import 'package:compdf_viewer/core/constants.dart';

/// Theme selector circular button for PDF reading themes.
///
/// Displays a circular button with the theme's background color and a border
/// that highlights when selected. Custom theme button shows a color picker
/// icon overlay. Features smooth animation transitions for selection state.
///
/// Key features:
/// - Circular color preview with theme background
/// - Animated border highlighting for selected state
/// - Special icon overlay for custom color picker theme
/// - Configurable size (default 38px)
///
/// Usage example:
/// ```dart
/// // In ThemeSelector
/// ListView.separated(
///   scrollDirection: Axis.horizontal,
///   children: themes.map((theme) {
///     return ThemeSelectorButton(
///       theme: theme,
///       isSelect: selectedTheme == theme,
///       onTap: _onThemeSelected,
///     );
///   }).toList(),
/// )
/// ```
class ThemeSelectorButton extends StatelessWidget {
  final bool isSelect;
  final CPDFThemes theme;
  final ValueChanged<CPDFThemes>? onTap;
  final double size;

  const ThemeSelectorButton({
    super.key,
    required this.theme,
    required this.isSelect,
    this.onTap,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(theme),
      borderRadius: BorderRadius.circular(32),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: size,
        curve: Curves.fastEaseInToSlowEaseOut,
        height: size,
        decoration: BoxDecoration(
          color: HexColor.fromHex(theme.color),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelect
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: theme.type == CPDFThemeType.custom
            ? Image(
                image: AssetImage(
                  PdfViewerAssets.icColorPicker,
                  package: PdfViewerAssets.packageName,
                ),
                width: size,
                height: size,
                fit: BoxFit.contain,
              )
            : null,
      ),
    );
  }
}
