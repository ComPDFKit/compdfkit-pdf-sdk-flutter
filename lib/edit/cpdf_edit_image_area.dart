/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


import 'dart:typed_data';

import 'package:compdfkit_flutter/edit/cpdf_edit_area.dart';

class CPDFEditImageArea extends CPDFEditArea {

  final double alpha;

  final Uint8List? image;

  CPDFEditImageArea({required super.uuid, required super.page, this.alpha = 255, this.image})
      : super(type: CPDFEditAreaType.image);

  factory CPDFEditImageArea.fromJson(Map<String, dynamic> json) {
    return CPDFEditImageArea(
      uuid: json['uuid'] ?? '',
      page: json['page'] ?? 0,
      alpha: (json['alpha'] as num?)?.toDouble() ?? 255.0,
      image: json['image'] is List
          ? Uint8List.fromList(List<int>.from(json['image']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'uuid': uuid,
        'page': page,
        'alpha': alpha,
        'image': image
      };

}