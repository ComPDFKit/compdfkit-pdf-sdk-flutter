// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

class CPDFBookmark {
  String title;
  final int pageIndex;
  final DateTime? date;
  final String uuid;

  CPDFBookmark(
      {required this.title,
      required this.pageIndex,
      this.date,
      this.uuid = ''});

  factory CPDFBookmark.fromJson(Map<String, dynamic> json) {
    return CPDFBookmark(
      title: json['title'] ?? '',
      pageIndex: json['pageIndex'] ?? 0,
      date: json['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date'])
          : null,
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'pageIndex': pageIndex,
      'date': date?.toString(),
      'uuid': uuid,
    };
  }
}
