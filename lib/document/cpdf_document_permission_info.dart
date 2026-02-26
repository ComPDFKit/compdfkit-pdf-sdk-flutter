/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

class CPDFDocumentPermissionInfo {
  /// Printing the document
  final bool allowsPrinting;

  final bool allowsHighQualityPrinting;

  /// Extract content (text, images, etc.)
  final bool allowsCopying;

  /// Modify the document contents except for page management (document attributes)
  final bool allowsDocumentChanges;

  /// Page management: insert, delete, and rotate pages
  final bool allowsDocumentAssembly;

  /// Create or modify annotations, including form field entries
  final bool allowsCommenting;

  /// Modify form field entries, even if allowsCommenting is false
  final bool allowsFormFieldEntry;

  const CPDFDocumentPermissionInfo({
    required this.allowsPrinting,
    required this.allowsHighQualityPrinting,
    required this.allowsCopying,
    required this.allowsDocumentChanges,
    required this.allowsDocumentAssembly,
    required this.allowsCommenting,
    required this.allowsFormFieldEntry,
  });

  CPDFDocumentPermissionInfo.empty()
      : allowsPrinting = false,
        allowsHighQualityPrinting = false,
        allowsCopying = false,
        allowsDocumentChanges = false,
        allowsDocumentAssembly = false,
        allowsCommenting = false,
        allowsFormFieldEntry = false;

  factory CPDFDocumentPermissionInfo.fromJson(Map<String, dynamic> json) {
    return CPDFDocumentPermissionInfo(
      allowsPrinting: json['allowsPrinting'] ?? false,
      allowsHighQualityPrinting: json['allowsHighQualityPrinting'] ?? false,
      allowsCopying: json['allowsCopying'] ?? false,
      allowsDocumentChanges: json['allowsDocumentChanges'] ?? false,
      allowsDocumentAssembly: json['allowsDocumentAssembly'] ?? false,
      allowsCommenting: json['allowsCommenting'] ?? false,
      allowsFormFieldEntry: json['allowsFormFieldEntry'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowsPrinting': allowsPrinting,
      'allowsHighQualityPrinting': allowsHighQualityPrinting,
      'allowsCopying': allowsCopying,
      'allowsDocumentChanges': allowsDocumentChanges,
      'allowsDocumentAssembly': allowsDocumentAssembly,
      'allowsCommenting': allowsCommenting,
      'allowsFormFieldEntry': allowsFormFieldEntry,
    };
  }
}
