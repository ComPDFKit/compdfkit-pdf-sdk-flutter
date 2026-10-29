// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/optimize/cpdf_compress_algorithm.dart';

/// Downsampling and compression settings for one class of images.
///
/// A separate instance is used for color, grayscale and monochrome images.
/// These settings only take effect when `CPDFOptimizeFlag.compressImages` is
/// part of `CPDFOptimizeOptions.flags`.
class CPDFOptimizeImageOptions {
  const CPDFOptimizeImageOptions({
    required this.upperPpi,
    required this.targetPpi,
    required this.quality,
    required this.blockSize,
    this.compressAlgorithm = CPDFCompressAlgorithm.none,
  });

  /// Images above this resolution are downsampled. Must be positive.
  final int upperPpi;

  /// The resolution images are downsampled to. Must be positive.
  final int targetPpi;

  /// Compression quality, from 0 to 100. Lower means smaller and lossier.
  final int quality;

  /// Block size used by the encoder. Must be positive.
  final int blockSize;

  /// The algorithm used to re-encode the images.
  final CPDFCompressAlgorithm compressAlgorithm;

  Map<String, dynamic> toJson() => {
        'upper_ppi': upperPpi,
        'target_ppi': targetPpi,
        'quality': quality,
        'block_size': blockSize,
        'compress_algorithm': compressAlgorithm.value,
      };

  factory CPDFOptimizeImageOptions.fromJson(Map<dynamic, dynamic> json) {
    return CPDFOptimizeImageOptions(
      upperPpi: (json['upper_ppi'] as num?)?.toInt() ?? 0,
      targetPpi: (json['target_ppi'] as num?)?.toInt() ?? 0,
      quality: (json['quality'] as num?)?.toInt() ?? 0,
      blockSize: (json['block_size'] as num?)?.toInt() ?? 0,
      compressAlgorithm:
          CPDFCompressAlgorithm.fromValue(json['compress_algorithm'] as String?),
    );
  }

  CPDFOptimizeImageOptions copyWith({
    int? upperPpi,
    int? targetPpi,
    int? quality,
    int? blockSize,
    CPDFCompressAlgorithm? compressAlgorithm,
  }) {
    return CPDFOptimizeImageOptions(
      upperPpi: upperPpi ?? this.upperPpi,
      targetPpi: targetPpi ?? this.targetPpi,
      quality: quality ?? this.quality,
      blockSize: blockSize ?? this.blockSize,
      compressAlgorithm: compressAlgorithm ?? this.compressAlgorithm,
    );
  }

  @override
  String toString() => 'CPDFOptimizeImageOptions(upperPpi: $upperPpi, '
      'targetPpi: $targetPpi, quality: $quality, blockSize: $blockSize, '
      'compressAlgorithm: ${compressAlgorithm.value})';
}
