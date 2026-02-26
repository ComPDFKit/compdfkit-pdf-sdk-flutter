// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// A section title widget for the side navigation drawer.
///
/// Displays a faded title text to separate different sections.
class SideNavigationTitle extends StatelessWidget {
  final String title;

  const SideNavigationTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleSmall;
    final fadedColor = baseStyle?.color?.withAlpha(180);
    return Text(title, style: baseStyle?.copyWith(color: fadedColor));
  }
}
