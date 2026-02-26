// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import 'package:compdf_viewer/features/navigation/file_operations/file_actions.dart';
import 'package:compdf_viewer/features/navigation/reading_settings/reading_settings.dart';

/// Width of the side navigation drawer.
const double kSideNavigationWidth = 280.0;

/// Side navigation drawer for PDF viewer.
///
/// Provides access to file operations and reading settings.
class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSideNavigationWidth,
      height: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [FileActions(), ReadingSettings()],
        ),
      ),
    );
  }
}
