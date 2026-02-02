/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/document/action/cpdf_action.dart';
import 'package:compdfkit_flutter/document/cpdf_destination.dart';

class CPDFOutline {

  final String uuid;

  String? tag;

  String title;

  int level;

  CPDFDestination? destination;

  List<CPDFOutline> childList;

  CPDFAction? action;

  CPDFOutline({
    required this.uuid,
    this.tag = '',
    required this.title,
    required this.level,
    this.destination,
    this.childList = const [],
    this.action
  });

  factory CPDFOutline.fromJson(Map<String, dynamic> json) {
    return CPDFOutline(
      uuid: json['uuid'] ?? '',
      tag: json['tag'] ?? '',
      title: json['title'] ?? '',
      level: json['level'] ?? 0,
      destination: json['destination'] != null
          ? CPDFDestination.fromJson(Map<String, dynamic>.from(json['destination'] ?? {}))
          : null,
      childList: (json['childList'] as List<dynamic>? ?? [])
          .map((e) => CPDFOutline.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      action: json['action'] != null
          ? CPDFAction.fromJson(
          Map<String, dynamic>.from(json['action'] ?? {}))
          : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'tag': tag,
      'title': title,
      'level': level,
      'destination': destination?.toJson(),
      'childList': childList.map((e) => e.toJson()).toList(),
      'action': action?.toJson(),
    };
  }


}