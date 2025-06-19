/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

class CPDFContextMenuItem<T> {
  final T key;
  final List<String>? subItems;

  const CPDFContextMenuItem(this.key, {this.subItems});

  static CPDFContextMenuItem<T> of<T>(T key, {List<String>? subItems}) {
    return CPDFContextMenuItem<T>(key, subItems: subItems);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'key': key.toString().split('.').last};

    if (subItems != null && subItems!.isNotEmpty) {
      map['subItems'] = subItems;
    }

    return map;
  }
}
