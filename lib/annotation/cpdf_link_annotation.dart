// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

import '../document/action/cpdf_action.dart';

/// Link annotation model.
///
/// Link annotations are used to create clickable areas that can navigate to a
/// different page, open a URL, or perform other actions.
///
/// Key properties:
/// - [action]: Optional [CPDFAction] triggered when the link is activated.
///
/// Serialization:
/// - Use [CPDFLinkAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFLinkAnnotation extends CPDFAnnotation {
  CPDFAction? action;

  CPDFLinkAnnotation({
    required super.title,
    required super.page,
    required super.content,
    super.uuid = '',
    super.createDate,
    required super.rect,
    this.action,
  }) : super(type: CPDFAnnotationType.link);

  factory CPDFLinkAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFLinkAnnotation(
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
    return {...super.toJson(), 'action': action?.toJson()};
  }
}
