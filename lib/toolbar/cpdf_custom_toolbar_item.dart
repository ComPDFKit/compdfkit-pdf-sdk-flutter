/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Model for defining a custom toolbar item.
///
/// This model is typically used together with viewer configuration to describe
/// toolbar buttons shown in the UI.
///
/// There are two common use-cases:
/// - Create a built-in action item via [CPDFCustomToolbarItem.action].
/// - Create a custom item via [CPDFCustomToolbarItem.custom] and handle it with
///   the corresponding callback.
///
/// {@category toolbar}
class CPDFCustomToolbarItem {
  /// Unique identifier for a custom toolbar item.
  ///
  /// This value is mainly used when [action] is [CPDFToolbarAction.custom].
  /// For built-in actions, this is usually an empty string.
  final String identifier;

  /// Display title for this toolbar item.
  final String title;

  /// Icon representation for this toolbar item.
  ///
  /// The exact format depends on the native implementation (e.g. asset name,
  /// resource identifier, or other agreed-upon representation).
  final String icon;

  /// The action associated with this toolbar item.
  final CPDFToolbarAction action;

  /// Creates a toolbar item with explicit fields.
  ///
  /// Prefer [CPDFCustomToolbarItem.action] for built-in actions and
  /// [CPDFCustomToolbarItem.custom] for custom items.
  const CPDFCustomToolbarItem({
    required this.identifier,
    required this.title,
    required this.icon,
    required this.action,
  });

  /// Creates a built-in toolbar item.
  ///
  /// Built-in actions typically do not require an [identifier].
  const CPDFCustomToolbarItem.action({
    required this.action,
    this.title = '',
    this.icon = '',
  }) : identifier = '';

  /// Creates a custom toolbar item.
  ///
  /// Use [identifier] to distinguish which custom item was tapped.
  const CPDFCustomToolbarItem.custom({
    required this.identifier,
    this.title = '',
    required this.icon,
  }) : action = CPDFToolbarAction.custom;

  /// Whether this item is a custom action.
  bool get isCustom => action == CPDFToolbarAction.custom;

  /// Creates an instance from a JSON map.
  ///
  /// Unknown action strings will fall back to [CPDFToolbarAction.custom].
  factory CPDFCustomToolbarItem.fromJson(Map<String, dynamic> json) {
    final actionName = json['action'] as String?;
    final action = CPDFToolbarAction.values.firstWhere(
      (e) => e.name == actionName,
      orElse: () => CPDFToolbarAction.custom,
    );
    return CPDFCustomToolbarItem(
      identifier: json['identifier'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      action: action,
    );
  }

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'title': title,
        'icon': icon,
        'action': action.name,
      };

  /// Creates a copy with selective overrides.
  CPDFCustomToolbarItem copyWith({
    String? identifier,
    String? title,
    String? icon,
    CPDFToolbarAction? action,
  }) {
    return CPDFCustomToolbarItem(
      identifier: identifier ?? this.identifier,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      action: action ?? this.action,
    );
  }
}
