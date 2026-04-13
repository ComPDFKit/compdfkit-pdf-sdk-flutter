/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

/// Represents different types of image data for inserting into PDF
class CPDFImageData {
  final CPDFImageType type;

  final String data;

  const CPDFImageData._({
    required this.type,
    required this.data,
  });

  /// Create from file path
  /// example: '/data/user/0/com.example.app/cache/image.png'
  factory CPDFImageData.fromPath(String filePath) {
    return CPDFImageData._(
      type: CPDFImageType.filePath,
      data: filePath,
    );
  }

  /// Create from base64 encoded string
  /// example: 'iVBORw0KGgoAAAANSUhEUgAAAAUA...'
  factory CPDFImageData.fromBase64(String base64String) {
    return CPDFImageData._(
      type: CPDFImageType.base64,
      data: base64String,
    );
  }

  /// Create from a data URI string.
  /// example: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...'
  factory CPDFImageData.fromDataUri(String dataUri) {
    return CPDFImageData._(
      type: CPDFImageType.base64,
      data: dataUri,
    );
  }

  /// Create from asset path
  /// example: 'logo.png'
  factory CPDFImageData.fromAsset(String assetPath) {
    return CPDFImageData._(
      type: CPDFImageType.asset,
      data: assetPath,
    );
  }

  /// Create from Uri (Android only)
  /// example: 'content://media/external/images/media/1000'
  factory CPDFImageData.fromUri(String uri) {
    return CPDFImageData._(
      type: CPDFImageType.uri,
      data: uri,
    );
  }

  factory CPDFImageData.fromJson(Map<String, dynamic> json) {
    return CPDFImageData._(
      type: CPDFImageType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => CPDFImageType.base64,
      ),
      data: json['data']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'data': data,
    };
  }
}

enum CPDFImageType {
  filePath,
  base64,
  asset,
  uri,
}
