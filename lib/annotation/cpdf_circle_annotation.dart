// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'cpdf_square_annotation.dart';

class CPDFCircleAnnotations extends CPDFSquareAnnotation {
    CPDFCircleAnnotations({
        required super.type,
        required super.title,
        required super.page,
        required super.content,
        required super.uuid,
        super.createDate,
        required super.rect,
        required super.borderWidth,
        required super.borderColor,
        required super.borderAlpha,
        required super.fillColor,
        required super.fillAlpha,
        required super.effectType,
    });

    factory CPDFCircleAnnotations.fromJson(Map<String, dynamic> json) {
        final square = CPDFSquareAnnotation.fromJson(json);
        return CPDFCircleAnnotations(
            type: square.type,
            title: square.title,
            page: square.page,
            content: square.content,
            uuid: square.uuid,
            createDate: square.createDate,
            rect: square.rect,
            borderWidth: square.borderWidth,
            borderColor: square.borderColor,
            borderAlpha: square.borderAlpha,
            fillColor: square.fillColor,
            fillAlpha: square.fillAlpha,
            effectType: square.effectType,
        );
    }
}