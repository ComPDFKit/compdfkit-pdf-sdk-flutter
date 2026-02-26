// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// A navigation option item with icon, title, optional trailing widget and children.
///
/// Used in the side navigation drawer to display menu options with expandable children.
class SideNavigationOption extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget? trailing;
  final List<Widget>? children;
  final GestureTapCallback? onTap;

  const SideNavigationOption({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.children,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: onTap,
            leading: icon,
            title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            trailing: trailing,
          ),
        ),
        if (children != null) ...children!,
      ],
    );
  }
}
