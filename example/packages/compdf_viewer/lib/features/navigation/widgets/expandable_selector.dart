// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Height of each expandable selector item.
const double _kExpandableSelectorHeight = 48.0;

/// A generic selectable list item that shows a checkmark when active.
///
/// Used within expandable settings sections to display mode options.
class ExpandableSelector<T> extends StatelessWidget {
  final String title;
  final T mode;
  final Rx<T> currentMode;
  final ValueChanged<T> onModeChanged;

  const ExpandableSelector({
    super.key,
    required this.title,
    required this.mode,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kExpandableSelectorHeight,
      child: ListTile(
        leading: const SizedBox(width: 20),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Obx(
          () => Icon(
            Icons.check,
            color: currentMode.value == mode
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        onTap: () => onModeChanged(mode),
      ),
    );
  }
}
