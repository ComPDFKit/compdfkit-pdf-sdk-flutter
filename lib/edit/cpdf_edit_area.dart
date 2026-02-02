/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

enum CPDFEditAreaType { text, image, path, none }

/// Represents an editable area in a PDF document.
/// Contains the type of the area, a unique identifier (UUID), and the page number.
class CPDFEditArea {

  final CPDFEditAreaType type;

  final String uuid;

  final int page;

  const CPDFEditArea({required this.type, required this.uuid, required this.page});

  factory CPDFEditArea.fromJson(Map<String, dynamic> json) {
    return CPDFEditArea(
      type: CPDFEditAreaType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => CPDFEditAreaType.none),
      uuid: json['uuid'] ?? '',
      page: json['page'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'uuid': uuid,
        'page': page,
      };


}
