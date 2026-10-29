// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Result of extracting images from a PDF document.
class CPDFExtractImageResult {
  /// Whether the native extraction call completed successfully.
  final bool success;

  /// Number of image files found in [directoryPath] after extraction.
  final int count;

  /// Directory where images were written.
  final String directoryPath;

  /// Full paths of image files found in [directoryPath] after extraction.
  final List<String> imagePaths;

  /// Creates an image extraction result.
  const CPDFExtractImageResult({
    required this.success,
    required this.count,
    required this.directoryPath,
    required this.imagePaths,
  });

  /// Creates an image extraction result from native JSON data.
  factory CPDFExtractImageResult.fromJson(Map<String, dynamic> json) {
    final rawPaths = json['image_paths'];
    return CPDFExtractImageResult(
      success: json['success'] == true,
      count: (json['count'] as num?)?.toInt() ?? 0,
      directoryPath: json['directory_path'] as String? ?? '',
      imagePaths: rawPaths is List ? rawPaths.whereType<String>().toList() : [],
    );
  }
}
