/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

enum CPDFContextMenuShowType {
  text,

  // only support Android platform.
  icon;
}
/// Represents a context menu item in the PDF viewer.
///
/// [T] is the enum type of the menu key,
/// such as `CPDFScreenShotMenuKey`, `CPDFViewModeTextSelectKey`, etc.
class CPDFContextMenuItem<T> {

  /// The unique key identifying this menu item.
  ///
  /// If this is a custom menu item, the key **must be** `custom`.
  final T key;

  /// Optional list of sub-menu item titles.
  final List<String>? subItems;

  /// Identifier used to distinguish multiple custom menu items.
  ///
  /// Effective **only when `key = custom`**.
  final String identifier;

  /// The displayed title of the menu item.
  ///
  /// Used when `showType` is set to `text`.
  final String title;

  /// The icon asset path for the menu item.
  /// only support Android platform.
  final String icon;

  /// Determines whether the menu item is displayed as text or icon.
  ///
  /// Defaults to `CPDFContextMenuShowType.text`.
  final CPDFContextMenuShowType showType;

  const CPDFContextMenuItem(
      this.key, {
        this.subItems,
        this.identifier = '',
        this.title = '',
        this.icon = '',
        this.showType = CPDFContextMenuShowType.text,
      });

  /// Creates a menu item with only a key and optional sub-items.
  static CPDFContextMenuItem<T> of<T>(T key, {List<String>? subItems}) {
    return CPDFContextMenuItem<T>(key, subItems: subItems);
  }

  /// Converts the menu item into a JSON-serializable map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'key': key.toString().split('.').last,
    };

    if (subItems != null && subItems!.isNotEmpty) {
      map['subItems'] = subItems;
    }

    map['identifier'] = identifier;
    map['title'] = title;
    map['icon'] = icon;
    map['showType'] = showType.name;
    return map;
  }
}