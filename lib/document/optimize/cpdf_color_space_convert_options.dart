// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:typed_data';

/// ICC driven color space conversion between RGB and CMYK.
///
/// The conversion stays disabled unless [iccData] holds a non empty ICC
/// profile. Note that the profile is passed as raw bytes, not as a file path.
class CPDFColorSpaceConvertOptions {
  const CPDFColorSpaceConvertOptions({
    this.iccData,
    this.rgbToCmyk = true,
  });

  /// The raw bytes of the ICC profile driving the conversion.
  ///
  /// Leave it null or empty to keep the color space untouched.
  final Uint8List? iccData;

  /// Converts RGB to CMYK when true, CMYK to RGB when false.
  final bool rgbToCmyk;

  /// Whether the conversion actually runs, mirroring the native
  /// `CPDFColorSpaceConvertOptions.isEnabled()`.
  bool get isEnabled => iccData != null && iccData!.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'icc_data': iccData,
        'rgb_to_cmyk': rgbToCmyk,
      };

  factory CPDFColorSpaceConvertOptions.fromJson(Map<dynamic, dynamic> json) {
    final icc = json['icc_data'];
    return CPDFColorSpaceConvertOptions(
      iccData: icc is Uint8List
          ? icc
          : (icc is List<int> ? Uint8List.fromList(icc) : null),
      rgbToCmyk: json['rgb_to_cmyk'] as bool? ?? true,
    );
  }

  @override
  String toString() => 'CPDFColorSpaceConvertOptions('
      'iccData: ${iccData?.length ?? 0} bytes, rgbToCmyk: $rgbToCmyk)';
}
