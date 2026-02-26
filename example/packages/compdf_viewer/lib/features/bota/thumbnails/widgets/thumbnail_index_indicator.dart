// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Page number indicator badge for thumbnail items.
///
/// Displays 1-based page number in a rounded badge below the thumbnail image.
/// Changes color to primary when page is current/selected, gray otherwise.
///
/// Key features:
/// - Compact badge design (22px height)
/// - Dynamic color: primary (selected) or gray
/// - IntrinsicWidth for variable number width
/// - White text on colored background
///
/// Usage example:
/// ```dart
/// // In ThumbnailItem
/// Positioned(
///   bottom: 0,
///   left: 0,
///   right: 0,
///   child: ThumbnailIndexIndicator(
///     pageIndex: 5,  // 0-based
///     isSelected: true,  // Shows as page 6 in primary color
///   ),
/// )
/// ```
class ThumbnailIndexIndicator extends StatelessWidget {
  final bool isSelected;
  final int pageIndex;
  const ThumbnailIndexIndicator(
      {super.key, required this.isSelected, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          '${pageIndex + 1}',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
