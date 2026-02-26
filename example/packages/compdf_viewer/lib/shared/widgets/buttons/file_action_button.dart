// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:compdf_viewer/core/constants.dart';

/// A circular button widget for file-related actions with ripple effect.
///
/// This widget provides a white circular button with shadow, containing
/// an icon image from the package assets. It includes Material Design
/// ripple effect on tap.
///
/// **Visual Style:**
/// - 48x48px circular container
/// - White background
/// - Subtle shadow (black12, 2px blur)
/// - Circular ripple effect on tap
/// - 8px padding around icon
///
/// **Usage:**
/// ```dart
/// FileActionButton(
///   imagePath: PdfViewerAssets.icShare,
///   onTap: () => shareFile(),
/// )
/// ```
class FileActionButton extends StatelessWidget {
  final String imagePath;

  final VoidCallback? onTap;

  const FileActionButton({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 0),
        ],
      ),
      child: Material(
        color: Colors
            .white, // Ensure the background is white to facilitate ripple effect
        shape: const CircleBorder(), // Ensure ripple effect is circular
        child: InkWell(
          onTap: onTap,
          customBorder:
              const CircleBorder(), // Also set ripple effect circular boundary
          child: Padding(
            padding:
                const EdgeInsets.all(8.0), // Optional: control image padding
            child: Image(
                image: AssetImage(imagePath,
                    package: PdfViewerAssets.packageName)),
          ),
        ),
      ),
    );
  }
}
