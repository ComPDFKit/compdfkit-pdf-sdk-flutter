// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Mark state for an annotation review workflow.
///
/// {@category annotations}
enum CPDFAnnotationMarkState {
  marked,
  unmarked;

  static CPDFAnnotationMarkState fromString(String? value) {
    return CPDFAnnotationMarkState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => CPDFAnnotationMarkState.unmarked,
    );
  }
}

/// Review state for an annotation review workflow.
///
/// {@category annotations}
enum CPDFAnnotationReviewState {
  accepted,
  rejected,
  cancelled,
  completed,
  none,
  error;

  static CPDFAnnotationReviewState fromString(String? value) {
    return CPDFAnnotationReviewState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => CPDFAnnotationReviewState.none,
    );
  }
}
