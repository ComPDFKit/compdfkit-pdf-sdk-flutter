// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/widgets.dart';

import 'example_route_type.dart';

/// Example Visual Configuration
///
/// Defines custom icon and color styling for an example
class ExampleVisual {
  /// Icon to display (optional, uses category icon if not specified)
  final IconData? icon;

  /// Background color for icon container (optional)
  final Color? backgroundColor;

  /// Icon color (optional)
  final Color? iconColor;

  /// Constructor
  const ExampleVisual({
    this.icon,
    this.backgroundColor,
    this.iconColor,
  });
}

/// Example Item Model
///
/// Represents the metadata and behavior of a single example
class ExampleItem {
  /// Example title (displayed in list)
  final String title;

  /// Example description (optional, shown below title)
  final String? description;

  /// Route type: pageBuilder or modalCallback
  final ExampleRouteType routeType;

  /// Page builder (used when routeType == pageBuilder)
  ///
  /// Returns the Widget to navigate to
  final WidgetBuilder? pageBuilder;

  /// Modal callback (used when routeType == modalCallback)
  ///
  /// Accepts BuildContext parameter to support operations requiring context like showModalBottomSheet
  final void Function(BuildContext context)? modalCallback;

  /// Platform restrictions (optional)
  ///
  /// If specified, this example is only shown on listed platforms
  final List<TargetPlatform>? supportedPlatforms;

  /// Visual configuration (optional)
  ///
  /// Custom icon and colors for this example. If not provided, uses category icon with automatic coloring
  final ExampleVisual? visual;

  /// Constructor
  const ExampleItem({
    required this.title,
    this.description,
    required this.routeType,
    this.pageBuilder,
    this.modalCallback,
    this.supportedPlatforms,
    this.visual,
  }) : assert(
          (routeType == ExampleRouteType.pageBuilder && pageBuilder != null) ||
              (routeType == ExampleRouteType.modalCallback &&
                  modalCallback != null),
          'pageBuilder is required when routeType is pageBuilder, '
          'modalCallback is required when routeType is modalCallback',
        );
}
