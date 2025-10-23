/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/material.dart';

import '../cpdf_controller_example.dart';

class CPDFActionItem {
  final String key;
  final String displayName;
  final String? shortName;
  final String? description;
  final ActionGroup group;
  final IconData? icon;

  const CPDFActionItem({
    required this.key,
    required this.displayName,
    required this.group,
    this.shortName,
    this.description,
    this.icon,
  });

  String get menuDisplayName => shortName ?? displayName;
  String get tooltipText => description ?? displayName;
}