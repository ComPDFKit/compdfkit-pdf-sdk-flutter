// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Controls how interactive annotation and form creation ends.
///
/// The configuration applies to objects created from the reader annotation or
/// form tools, including tools selected through the reader controller. It does
/// not affect programmatic document creation APIs.
///
/// Since v3.2.0
class CPDFCreationConfig {
  /// Creates a creation policy.
  ///
  /// Since v3.2.0
  const CPDFCreationConfig({
    this.continuousCreation = true,
    this.autoSelectCreatedAnnotation = true,
  });

  /// Whether the selected creation tool remains active after an object is
  /// created.
  ///
  /// Since v3.2.0
  final bool continuousCreation;

  /// Whether the newly created annotation or form field is selected.
  ///
  /// Since v3.2.0
  final bool autoSelectCreatedAnnotation;

  /// Serializes this policy for the native reader configuration codec.
  Map<String, dynamic> toJson() => {
        'continuousCreation': continuousCreation,
        'autoSelectCreatedAnnotation': autoSelectCreatedAnnotation,
      };
}
