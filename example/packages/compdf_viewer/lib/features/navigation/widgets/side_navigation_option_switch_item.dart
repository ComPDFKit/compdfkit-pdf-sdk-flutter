// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/navigation/widgets/side_navigation_option.dart';

/// A navigation option with a switch toggle.
///
/// Wraps [SideNavigationOption] with a reactive switch for boolean settings.
class SideNavigationOptionSwitchItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final RxBool isChecked;
  final ValueChanged<bool> onChanged;

  const SideNavigationOptionSwitchItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SideNavigationOption(
      icon: icon,
      title: title,
      trailing: Transform.scale(
        scale: 0.8,
        child: Obx(() => Switch(
              value: isChecked.value,
              onChanged: onChanged,
            )),
      ),
    );
  }
}
