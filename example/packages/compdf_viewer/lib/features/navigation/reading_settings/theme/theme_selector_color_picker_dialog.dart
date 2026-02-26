// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// Custom color picker dialog for PDF reading theme.
///
/// Displays a color picker dialog allowing users to select a custom background
/// color for PDF reading. Uses flutter_colorpicker for the color selection UI.
/// Selection is applied immediately on pointer up events for real-time preview.
///
/// Key features:
/// - Full spectrum color picker
/// - Real-time selection feedback
/// - Creates custom CPDFThemes with selected color
/// - Immediate callback on color selection
///
/// Usage example:
/// ```dart
/// // In ThemeSelector
/// void _showColorPicker(BuildContext context) {
///   showDialog(
///     context: context,
///     builder: (_) => ThemeSelectorColorPickerDialog(
///       defaultColor: Colors.white,
///       onSelect: (customTheme) {
///         // Apply custom theme to PDF viewer
///         _onThemeSelected(customTheme);
///       },
///     ),
///   );
/// }
/// ```
class ThemeSelectorColorPickerDialog extends StatefulWidget {
  final Color defaultColor;

  final ValueChanged<CPDFThemes>? onSelect;

  const ThemeSelectorColorPickerDialog(
      {super.key, required this.defaultColor, this.onSelect});

  @override
  State<ThemeSelectorColorPickerDialog> createState() =>
      _ThemeSelectorColorPickerDialogState();
}

class _ThemeSelectorColorPickerDialogState
    extends State<ThemeSelectorColorPickerDialog> {
  var _pickedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(PdfLocaleKeys.selectACustomColor.tr),
      content: SingleChildScrollView(
        child: Listener(
          onPointerUp: (_) async {
            CPDFThemes customTheme = CPDFThemes.custom(_pickedColor);
            widget.onSelect?.call(customTheme);
          },
          child: ColorPicker(
            pickerColor: widget.defaultColor,
            onColorChanged: (selectedColor) async {
              _pickedColor = selectedColor;
            },
          ),
        ),
      ),
    );
  }
}
