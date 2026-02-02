/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';

/// Sound annotation model.
///
/// A sound/media annotation that extends [CPDFAnnotation].
///
/// Key properties:
/// - [soundPath]: Path or identifier for the associated audio resource.
///
/// Serialization:
/// - Use [CPDFSoundAnnotation.fromJson] to create an instance from a JSON map.
/// - Use [toJson] to convert this instance to a JSON map.
///
/// {@category annotations}
class CPDFSoundAnnotation extends CPDFAnnotation {

  final String? soundPath;

  CPDFSoundAnnotation(
      {super.title,
      super.content,
      super.createDate,
      required super.page,
      super.uuid = '',
      required super.rect,
      this.soundPath})
      : super(type: CPDFAnnotationType.sound);

  factory CPDFSoundAnnotation.fromJson(Map<String, dynamic> json) {
    final common = CPDFAnnotation.fromJson(json);
    return CPDFSoundAnnotation(
      title: common.title,
      content: common.content,
      createDate: common.createDate,
      page: common.page,
      uuid: common.uuid,
      rect: common.rect,
      soundPath: json['soundPath'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'soundPath': soundPath};
  }

}
