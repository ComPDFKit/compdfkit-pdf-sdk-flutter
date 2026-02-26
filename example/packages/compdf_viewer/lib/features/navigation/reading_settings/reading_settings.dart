// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/crop_mode_setting.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/display_mode_setting.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/rotate_setting.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/scroll_pages_setting.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/show_page_num_setting.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/theme/theme_selector.dart';
import 'package:compdf_viewer/features/navigation/widgets/side_navigation_title.dart';

/// Reading settings section for the PDF viewer sidebar.
///
/// Aggregates all PDF reading-related configuration options.
class ReadingSettings extends StatelessWidget {
  const ReadingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: SideNavigationTitle(title: PdfLocaleKeys.pageSetting.tr),
        ),
        const ThemeSelector(),
        const SizedBox(height: 8),
        const CropModeSetting(),
        const RotateSetting(),
        const ScrollPagesSetting(),
        const DisplayModeSetting(),
        const ShowPageNumSetting(),
      ],
    );
  }
}
