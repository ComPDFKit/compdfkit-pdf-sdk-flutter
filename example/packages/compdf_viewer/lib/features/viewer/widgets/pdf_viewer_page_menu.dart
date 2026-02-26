// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import 'package:compdf_viewer/core/constants.dart';

/// A widget providing action buttons for the PDF viewer app bar.
///
/// This widget renders a horizontal row of icon buttons for primary
/// PDF viewer actions: thumbnails, BOTA panel, search, and side menu.
///
/// **Actions:**
/// - **Thumbnail:** Opens page thumbnail grid view
/// - **BOTA:** Opens Bookmarks/Outlines/Thumbnails/Annotations panel
/// - **Search:** Opens text search interface
/// - **Side Menu:** Opens end drawer (right-side menu) with settings
///
/// **Default Behavior:**
/// - Side menu button automatically opens end drawer if no callback provided
///
/// **Usage:**
/// ```dart
/// PdfViewerPageMenu(
///   onThumbnail: () => showThumbnails(),
///   onBota: () => openBotaPanel(),
///   onSearch: () => openSearch(),
///   onSideMenu: () => customMenuHandler(),
/// )
/// ```
class PdfViewerPageMenu extends StatelessWidget {
  final VoidCallback? onThumbnail;

  final VoidCallback? onBota;

  final VoidCallback? onSearch;

  final VoidCallback? onSideMenu;

  const PdfViewerPageMenu({
    super.key,
    this.onThumbnail,
    this.onBota,
    this.onSearch,
    this.onSideMenu,
  });

  List<Widget> buildActions() {
    return [
      IconButton(
        onPressed: onThumbnail,
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icPageEdit,
              package: PdfViewerAssets.packageName),
        ),
      ),
      IconButton(
        onPressed: onBota,
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icBota,
              package: PdfViewerAssets.packageName),
        ),
      ),
      IconButton(
        onPressed: onSearch,
        icon: ImageIcon(
          AssetImage(PdfViewerAssets.icSearch,
              package: PdfViewerAssets.packageName),
        ),
      ),
      Builder(
        builder: (context) {
          return IconButton(
            onPressed: onSideMenu ?? () => Scaffold.of(context).openEndDrawer(),
            icon: ImageIcon(
              AssetImage(PdfViewerAssets.icSideMenu,
                  package: PdfViewerAssets.packageName),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buildActions(),
    );
  }
}
