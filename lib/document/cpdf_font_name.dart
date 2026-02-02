/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:core';

class CPDFFontName {

  final String familyName;

  final List<String> styleNames;

  CPDFFontName({
    required this.familyName,
    required this.styleNames,
  });

  /// Create a [CPDFFontName] from a JSON-like map returned by the platform channel.
  /// Expected keys: `familyName` (String), `psNames` (List<String>), `styleNames` (List<String>)
  factory CPDFFontName.fromJson(Map<String, dynamic> json) {
    return CPDFFontName(
      familyName: json['familyName'] as String? ?? '',
      styleNames: (json['styleNames'] as List?)
              ?.whereType<String>()
              .toList() ?? <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'familyName': familyName,
    'styleNames': styleNames,
  };

}

