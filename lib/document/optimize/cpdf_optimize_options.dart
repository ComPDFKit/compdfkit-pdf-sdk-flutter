// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/optimize/cpdf_color_space_convert_options.dart';
import 'package:compdfkit_flutter/document/optimize/cpdf_compress_algorithm.dart';
import 'package:compdfkit_flutter/document/optimize/cpdf_optimize_flag.dart';
import 'package:compdfkit_flutter/document/optimize/cpdf_optimize_image_options.dart';

/// The full set of options driving a document optimization run.
///
/// Every default value mirrors the corresponding field initializer of the
/// Android `CPDFDocument.CPDFOptimizeOptions` class and the iOS core defaults.
class CPDFOptimizeOptions {
  const CPDFOptimizeOptions({
    this.flags = CPDFOptimizeFlag.defaults,
    this.imageQuality = 40.0,
    this.colorImageOptions = const CPDFOptimizeImageOptions(
      upperPpi: 225,
      targetPpi: 150,
      quality: 40,
      blockSize: 256,
      compressAlgorithm: CPDFCompressAlgorithm.jpeg2000,
    ),
    this.grayscaleImageOptions = const CPDFOptimizeImageOptions(
      upperPpi: 225,
      targetPpi: 150,
      quality: 40,
      blockSize: 256,
      compressAlgorithm: CPDFCompressAlgorithm.jpeg2000,
    ),
    this.monochromeImageOptions = const CPDFOptimizeImageOptions(
      upperPpi: 450,
      targetPpi: 300,
      quality: 40,
      blockSize: 256,
      compressAlgorithm: CPDFCompressAlgorithm.jbig2,
    ),
    this.colorSpaceConvert = const CPDFColorSpaceConvertOptions(),
  });

  /// The optimization steps to run.
  ///
  /// Defaults to [CPDFOptimizeFlag.defaults], which is lossy: read its
  /// documentation before relying on it.
  final Set<CPDFOptimizeFlag> flags;

  /// Overall image quality, from 0 to 100.
  ///
  /// This is a separate knob from the per class
  /// [CPDFOptimizeImageOptions.quality].
  final double imageQuality;

  /// Settings applied to color images.
  final CPDFOptimizeImageOptions colorImageOptions;

  /// Settings applied to grayscale images.
  final CPDFOptimizeImageOptions grayscaleImageOptions;

  /// Settings applied to monochrome images.
  final CPDFOptimizeImageOptions monochromeImageOptions;

  /// Optional ICC driven color space conversion. Disabled by default.
  final CPDFColorSpaceConvertOptions colorSpaceConvert;

  Map<String, dynamic> toJson() => {
        'flags': flags.toMask(),
        'image_quality': imageQuality,
        'color_image_options': colorImageOptions.toJson(),
        'grayscale_image_options': grayscaleImageOptions.toJson(),
        'monochrome_image_options': monochromeImageOptions.toJson(),
        'color_space_convert': colorSpaceConvert.toJson(),
      };

  factory CPDFOptimizeOptions.fromJson(Map<dynamic, dynamic> json) {
    const fallback = CPDFOptimizeOptions();
    final color = json['color_image_options'];
    final grayscale = json['grayscale_image_options'];
    final monochrome = json['monochrome_image_options'];
    final convert = json['color_space_convert'];
    return CPDFOptimizeOptions(
      flags: CPDFOptimizeFlag.fromMask((json['flags'] as num?)?.toInt() ?? 0),
      imageQuality:
          (json['image_quality'] as num?)?.toDouble() ?? fallback.imageQuality,
      colorImageOptions: color is Map
          ? CPDFOptimizeImageOptions.fromJson(color)
          : fallback.colorImageOptions,
      grayscaleImageOptions: grayscale is Map
          ? CPDFOptimizeImageOptions.fromJson(grayscale)
          : fallback.grayscaleImageOptions,
      monochromeImageOptions: monochrome is Map
          ? CPDFOptimizeImageOptions.fromJson(monochrome)
          : fallback.monochromeImageOptions,
      colorSpaceConvert: convert is Map
          ? CPDFColorSpaceConvertOptions.fromJson(convert)
          : fallback.colorSpaceConvert,
    );
  }

  CPDFOptimizeOptions copyWith({
    Set<CPDFOptimizeFlag>? flags,
    double? imageQuality,
    CPDFOptimizeImageOptions? colorImageOptions,
    CPDFOptimizeImageOptions? grayscaleImageOptions,
    CPDFOptimizeImageOptions? monochromeImageOptions,
    CPDFColorSpaceConvertOptions? colorSpaceConvert,
  }) {
    return CPDFOptimizeOptions(
      flags: flags ?? this.flags,
      imageQuality: imageQuality ?? this.imageQuality,
      colorImageOptions: colorImageOptions ?? this.colorImageOptions,
      grayscaleImageOptions:
          grayscaleImageOptions ?? this.grayscaleImageOptions,
      monochromeImageOptions:
          monochromeImageOptions ?? this.monochromeImageOptions,
      colorSpaceConvert: colorSpaceConvert ?? this.colorSpaceConvert,
    );
  }

  @override
  String toString() => 'CPDFOptimizeOptions(flags: ${flags.toMask()}, '
      'imageQuality: $imageQuality)';
}
