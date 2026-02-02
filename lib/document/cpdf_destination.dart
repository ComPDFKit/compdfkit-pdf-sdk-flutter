// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

class CPDFDestination {
  final int pageIndex;

  final double zoom;

  final double positionX;

  final double positionY;

  const CPDFDestination({
    required this.pageIndex,
    this.zoom = 0.0,
    this.positionX = 0.0,
    this.positionY = 0.0,
  });

  factory CPDFDestination.fromJson(Map<String, dynamic> json) {
    return CPDFDestination(
      pageIndex: json['pageIndex'],
      zoom: (json['zoom'] as num?)?.toDouble() ?? 0,
      positionX: (json['positionX'] as num?)?.toDouble() ?? 0,
      positionY: (json['positionY'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageIndex': pageIndex,
      'zoom': zoom,
      'positionX': positionX,
      'positionY': positionY,
    };
  }
}
