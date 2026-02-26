// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:compdf_viewer/core/constants.dart';

/// A reusable empty state widget for BOTA panel tabs.
///
/// This widget displays a centered image and message when a BOTA tab
/// (Bookmarks, Outlines, Thumbnails, Annotations) has no content to show.
///
/// **Displayed Elements:**
/// - Image asset (centered, top)
/// - Text message (centered, below image)
///
/// **Usage:**
/// ```dart
/// BotaPageEmptyPage(
///   imagePath: PdfViewerAssets.icNoBookmarks,
///   message: 'No bookmarks available',
/// )
/// ```
///
/// The image is loaded from the compdf_viewer package using [PdfViewerAssets.packageName].
class BotaPageEmptyPage extends StatelessWidget {
  final String imagePath;
  final String message;

  const BotaPageEmptyPage({
    super.key,
    required this.imagePath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, package: PdfViewerAssets.packageName),
          Text(message),
        ],
      ),
    );
  }
}
