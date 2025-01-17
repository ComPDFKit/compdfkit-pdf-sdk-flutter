/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

class CPDFWatermark {
  /// Watermark type, can be either [CPDFWatermarkType.text] or [CPDFWatermarkType.image]
  final CPDFWatermarkType type;

  /// Text content for text-type watermark
  final String textContent;

  /// Image path for image-type watermark
  final String imagePath;

  final Color textColor;

  final int fontSize;

  /// Scaling factor, default is 1.0
  final double scale;

  /// Watermark rotation angle, default is 45°
  final double rotation;

  /// Watermark opacity, default is 1.0, range is 0.0 to 1.0
  final double opacity;

  /// Vertical alignment of the watermark, default is vertical center alignment
  final CPDFWatermarkVerticalAlignment verticalAlignment;

  /// Horizontal alignment of the watermark, default is center alignment
  final CPDFWatermarkHorizontalAlignment horizontalAlignment;

  /// Vertical offset for watermark position
  final double verticalOffset;

  /// Horizontal offset for watermark position
  final double horizontalOffset;

  /// Pages to add the watermark to, e.g., "1,2,3,4,5"
  final List<int> pages;

  /// Position the watermark in front of the content
  final bool isFront;

  /// Enable watermark tiling
  final bool isTilePage;

  /// Set the horizontal spacing for tiled watermarks
  final double horizontalSpacing;

  /// Set the vertical spacing for tiled watermarks
  final double verticalSpacing;

  CPDFWatermark(
      {required this.type,
      required this.pages,
      this.textContent = "",
      this.imagePath = "",
        this.textColor = Colors.black,
        this.fontSize = 24,
      this.scale = 1.0,
      this.rotation = 45,
      this.opacity = 1,
      this.verticalAlignment = CPDFWatermarkVerticalAlignment.center,
      this.horizontalAlignment = CPDFWatermarkHorizontalAlignment.center,
      this.verticalOffset = 0,
      this.horizontalOffset = 0,
      this.isFront = true,
      this.isTilePage = false,
      this.horizontalSpacing = 0,
      this.verticalSpacing = 0});

  /// Text watermark constructor
  ///
  /// This constructor creates a text watermark with customizable properties.
  ///
  /// - [textContent]: The text content of the watermark. (Required)
  /// - [pages]: A list of page indices where the watermark should be applied, e.g., [0, 1, 2, 3] represents pages 1 through 4. (Required)
  /// - [textColor]: The color of the watermark text. Default is `Colors.black`.
  /// - [fontSize]: The font size of the watermark text. Default is `24`.
  /// - [scale]: The scaling factor for the text. Default is `1.0`.
  /// - [rotation]: The rotation angle of the watermark in degrees. Default is `45.0`.
  /// - [opacity]: The transparency of the watermark, where `1.0` is fully opaque and `0.0` is fully transparent. Default is `1.0`.
  /// - [verticalAlignment]: The vertical alignment of the watermark on the page. Default is `CPDFWatermarkVerticalAlignment.center`.
  /// - [horizontalAlignment]: The horizontal alignment of the watermark on the page. Default is `CPDFWatermarkHorizontalAlignment.center`.
  /// - [verticalOffset]: The vertical offset of the watermark relative to the alignment position. Default is `0.0`.
  /// - [horizontalOffset]: The horizontal offset of the watermark relative to the alignment position. Default is `0.0`.
  /// - [isFront]: Whether the watermark should appear in front of the page content. Default is `true`.
  /// - [isTilePage]: Whether the watermark should be tiled across the page. Default is `false`.
  /// - [horizontalSpacing]: The horizontal spacing between tiled watermarks. Default is `0.0`.
  /// - [verticalSpacing]: The vertical spacing between tiled watermarks. Default is `0.0`.
  CPDFWatermark.text(
      {required String textContent,
      required List<int> pages,
        Color textColor = Colors.black,
        int fontSize = 24,
      double scale = 1.0,
      double rotation = 45.0,
      double opacity = 1.0,
      CPDFWatermarkVerticalAlignment verticalAlignment =
          CPDFWatermarkVerticalAlignment.center,
      CPDFWatermarkHorizontalAlignment horizontalAlignment =
          CPDFWatermarkHorizontalAlignment.center,
      double verticalOffset = 0.0,
      double horizontalOffset = 0.0,
      bool isFront = true,
      bool isTilePage = false,
      double horizontalSpacing = 0.0,
      double verticalSpacing = 0.0})
      : this(
            type: CPDFWatermarkType.text,
            textContent: textContent,
            textColor: textColor,
            fontSize: fontSize,
            pages: pages,
            scale: scale,
            rotation: rotation,
            opacity: opacity,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            verticalOffset: verticalOffset,
            horizontalOffset: horizontalOffset,
            isFront: isFront,
            isTilePage: isTilePage,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing);

  /// Image watermark constructor
  ///
  /// This constructor creates an image watermark with customizable properties.
  ///
  /// - [imagePath]: The file path of the image to be used as the watermark. (Required)
  /// - [pages]: A list of page indices where the watermark should be applied, e.g., [0, 1, 2, 3] represents pages 1 through 4. (Required)
  /// - [scale]: The scaling factor for the image. Default is 1.0.
  /// - [rotation]: The rotation angle of the watermark in degrees. Default is 45.0.
  /// - [opacity]: The transparency of the watermark, where 1.0 is fully opaque and 0.0 is fully transparent. Default is 1.0.
  /// - [verticalAlignment]: The vertical alignment of the watermark on the page. Default is `CPDFWatermarkVerticalAlignment.center`.
  /// - [horizontalAlignment]: The horizontal alignment of the watermark on the page. Default is `CPDFWatermarkHorizontalAlignment.center`.
  /// - [verticalOffset]: The vertical offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [horizontalOffset]: The horizontal offset of the watermark relative to the alignment position. Default is 0.0.
  /// - [isFront]: Whether the watermark should appear in front of the page content. Default is `true`.
  /// - [isTilePage]: Whether the watermark should be tiled across the page. Default is `false`.
  /// - [horizontalSpacing]: The horizontal spacing between tiled watermarks. Default is 0.0.
  /// - [verticalSpacing]: The vertical spacing between tiled watermarks. Default is 0.0.
  CPDFWatermark.image({
    required String imagePath,
    required List<int> pages,
    double scale = 1.0,
    double rotation = 45.0,
    double opacity = 1.0,
    CPDFWatermarkVerticalAlignment verticalAlignment =
        CPDFWatermarkVerticalAlignment.center,
    CPDFWatermarkHorizontalAlignment horizontalAlignment =
        CPDFWatermarkHorizontalAlignment.center,
    double verticalOffset = 0.0,
    double horizontalOffset = 0.0,
    bool isFront = true,
    bool isTilePage = false,
    double horizontalSpacing = 0.0,
    double verticalSpacing = 0.0,
  }) : this(
          type: CPDFWatermarkType.image,
          imagePath: imagePath,
          pages: pages,
          scale: scale,
          rotation: rotation,
          opacity: opacity,
          verticalAlignment: verticalAlignment,
          horizontalAlignment: horizontalAlignment,
          verticalOffset: verticalOffset,
          horizontalOffset: horizontalOffset,
          isFront: isFront,
          isTilePage: isTilePage,
          horizontalSpacing: horizontalSpacing,
          verticalSpacing: verticalSpacing,
        );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'text_content': textContent,
    'image_path' : imagePath,
    'text_color' : textColor.toHex(),
    'font_size' : fontSize,
    'scale' : scale,
    'rotation' : rotation,
    'opacity' : opacity,
    'vertical_alignment' : verticalAlignment.name,
    'horizontal_alignment' : horizontalAlignment.name,
    'vertical_offset' : verticalOffset,
    'horizontal_offset' : horizontalOffset,
    'pages' : pages.join(','),
    'is_front' : isFront,
    'is_tile_page' : isTilePage,
    'horizontal_spacing' : horizontalSpacing,
    'vertical_spacing' : verticalSpacing
  };
}

enum CPDFWatermarkVerticalAlignment { top, center, bottom }

enum CPDFWatermarkHorizontalAlignment { left, center, right }
