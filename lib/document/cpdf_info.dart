/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

class CPDFInfo {
  final String title;
  final String author;
  final String subject;
  final String keywords;
  final String creator;
  final String producer;
  final DateTime? creationDate;
  final DateTime? modificationDate;

  CPDFInfo({
    required this.title,
    required this.author,
    required this.subject,
    required this.keywords,
    required this.creator,
    required this.producer,
    this.creationDate,
    this.modificationDate,
  });

  CPDFInfo.empty()
      : title = '',
        author = '',
        subject = '',
        keywords = '',
        creator = '',
        producer = '',
        creationDate = null,
        modificationDate = null;

  factory CPDFInfo.fromJson(Map<String, dynamic> json) {
    return CPDFInfo(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      subject: json['subject'] ?? '',
      keywords: json['keywords'] ?? '',
      creator: json['creator'] ?? '',
      producer: json['producer'] ?? '',
      creationDate: json['creationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['creationDate'])
          : null,
      modificationDate: json['modificationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['modificationDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'subject': subject,
        'keywords': keywords,
        'creator': creator,
        'producer': producer,
        'creationDate': creationDate?.toIso8601String(),
        'modificationDate': modificationDate?.toIso8601String()
      };
}
