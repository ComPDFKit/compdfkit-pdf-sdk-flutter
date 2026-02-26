// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import 'example_item.dart';

/// Category Information Model
///
/// Represents a feature category and all examples it contains
class CategoryInfo {
  /// Category unique identifier
  final String id;

  /// Category name (for display)
  final String name;

  /// Category icon (Material Icons)
  final IconData icon;

  /// Category description (optional)
  final String? description;

  /// All examples in this category
  final List<ExampleItem> examples;

  /// Constructor
  const CategoryInfo({
    required this.id,
    required this.name,
    required this.icon,
    this.description,
    required this.examples,
  });
}
