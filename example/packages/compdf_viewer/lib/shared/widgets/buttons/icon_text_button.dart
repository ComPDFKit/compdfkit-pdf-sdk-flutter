// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:compdf_viewer/core/constants.dart';

/// A reusable button widget with an icon above text label.
///
/// This widget displays a vertical layout with an icon on top and
/// a text label below, commonly used for toolbar or menu items.
///
/// **Layout:**
/// - Icon (top) - Asset image from package
/// - 4px spacing
/// - Text label (bottom) - Default 12px font size
///
/// **Customization:**
/// - Custom icon size (default: 24px)
/// - Custom text style
/// - Tap handler callback
///
/// **Usage:**
/// ```dart
/// IconTextButton(
///   icon: PdfViewerAssets.icSave,
///   label: 'Save',
///   onTap: () => saveDocument(),
///   iconSize: 32,
///   textStyle: TextStyle(fontSize: 14),
/// )
/// ```
class IconTextButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final TextStyle? textStyle;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 24,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(
            AssetImage(icon, package: PdfViewerAssets.packageName),
          ),
          const SizedBox(height: 4),
          Text(label, style: textStyle ?? const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
