// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';

/// A floating toolbar widget for navigating through PDF search results.
///
/// This widget displays a compact, rounded toolbar with navigation controls
/// that appears over the PDF viewer when search results are active.
///
/// **Controls:**
/// - **Previous button:** Navigate to previous search match (rotated arrow)
/// - **Next button:** Navigate to next search match
/// - **Finish button:** Clear search and hide toolbar
///
/// **Visual Style:**
/// - Primary color background with rounded corners
/// - Floating appearance with shadow
/// - White icons and text
/// - Centered alignment over the PDF viewer
///
/// **Usage:**
/// ```dart
/// PdfSearchToolbar() // Automatically connects to PdfSearchController
/// ```
class PdfSearchToolbar extends GetView<PdfSearchController> {
  const PdfSearchToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: controller.previousSelection,
              icon: Transform.rotate(
                angle: math.pi,
                child: const Icon(Icons.navigate_next, color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: controller.nextSelection,
              icon: const Icon(Icons.navigate_next, color: Colors.white),
            ),
            TextButton(
              onPressed: controller.clearSearch,
              child: Text(
                PdfLocaleKeys.finish.tr,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
