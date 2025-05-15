// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../document/action/cpdf_action.dart';
import '../util/cpdf_rectf.dart';

class CPDFLinkAnnotation extends CPDFAnnotation {
  final CPDFAction? action;

  CPDFLinkAnnotation(
      {required CPDFAnnotationType type,
      required String title,
      required int page,
      required String content,
      required String uuid,
      DateTime? createDate,
      required CPDFRectF rect,
      this.action})
      : super(
            type: type,
            title: title,
            page: page,
            content: content,
            uuid: uuid,
            createDate: createDate,
            rect: rect);

  factory CPDFLinkAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFLinkAnnotation(
        type: common.type,
        title: common.title,
        page: common.page,
        content: common.content,
        uuid: common.uuid,
        createDate: common.createDate,
        rect: common.rect,
        action: json['action'] != null
            ? CPDFAction.fromJson(
                Map<String, dynamic>.from(json['action'] ?? {}))
            : null);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'action': action?.toJson()
    };
  }
}
