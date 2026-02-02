// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:compdfkit_flutter/annotation/cpdf_circle_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_freetext_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_image_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_ink_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_line_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_markup_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_signature_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_sound_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_square_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_stamp_annotation.dart';

import '../configuration/cpdf_options.dart';
import 'cpdf_annotation.dart';
import 'cpdf_note_annotation.dart';

/// Factory function used by [CPDFAnnotationRegistry] to create annotations.
typedef CPDFAnnotationFactory = CPDFAnnotation Function(
  Map<String, dynamic> json);

/// Registry that maps [CPDFAnnotationType] to concrete [CPDFAnnotation]
/// implementations.
///
/// Use [fromJson] to create the right annotation subtype based on the `type`
/// field in the JSON map. If the type is unknown, it falls back to
/// [CPDFAnnotation.fromJson].
///
/// {@category annotations}
class CPDFAnnotationRegistry {
  static final Map<CPDFAnnotationType, CPDFAnnotationFactory> _factories = {
    CPDFAnnotationType.note: (json) => CPDFNoteAnnotation.fromJson(json),
    CPDFAnnotationType.highlight: (json) => CPDFMarkupAnnotation.fromJson(json),
    CPDFAnnotationType.underline: (json) => CPDFMarkupAnnotation.fromJson(json),
    CPDFAnnotationType.squiggly: (json) => CPDFMarkupAnnotation.fromJson(json),
    CPDFAnnotationType.strikeout: (json) => CPDFMarkupAnnotation.fromJson(json),
    CPDFAnnotationType.ink: (json) => CPDFInkAnnotation.fromJson(json),
    CPDFAnnotationType.freetext: (json) => CPDFFreeTextAnnotation.fromJson(json),
    CPDFAnnotationType.square: (json) => CPDFSquareAnnotation.fromJson(json),
    CPDFAnnotationType.circle: (json) => CPDFCircleAnnotation.fromJson(json),
    CPDFAnnotationType.line: (json) => CPDFLineAnnotation.fromJson(json),
    CPDFAnnotationType.arrow: (json) => CPDFLineAnnotation.fromJson(json),
    CPDFAnnotationType.link: (json) => CPDFLinkAnnotation.fromJson(json),
    CPDFAnnotationType.stamp: (json) => CPDFStampAnnotation.fromJson(json),
    CPDFAnnotationType.pictures: (json) => CPDFImageAnnotation.fromJson(json),
    CPDFAnnotationType.signature: (json) => CPDFSignatureAnnotation.fromJson(json),
    CPDFAnnotationType.sound: (json) => CPDFSoundAnnotation.fromJson(json),
  };

  static CPDFAnnotation fromJson(Map<String, dynamic> json) {
    final type = CPDFAnnotationType.fromString(json['type']);
    final factory = _factories[type] ?? CPDFAnnotation.fromJson;
    return factory(json);
  }
}
