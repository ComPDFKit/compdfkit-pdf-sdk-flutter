// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// The outcome of a document optimization run.
class CPDFOptimizeResult {
  const CPDFOptimizeResult({
    required this.ok,
    required this.cancelled,
    required this.pagesProcessed,
    required this.stepsUs,
    required this.saveUs,
  });

  /// Whether the run completed successfully.
  final bool ok;

  /// Whether the run stopped because `CPDFDocument.cancelOptimize` was called.
  ///
  /// A cancelled run reports `ok == false`; it is a user action, not a failure.
  final bool cancelled;

  /// How many pages the run processed.
  final int pagesProcessed;

  /// Time spent on the optimization steps, in microseconds.
  final int stepsUs;

  /// Time spent serializing the optimized document, in microseconds.
  final int saveUs;

  factory CPDFOptimizeResult.fromJson(Map<dynamic, dynamic> json) {
    return CPDFOptimizeResult(
      ok: json['ok'] as bool? ?? false,
      cancelled: json['cancelled'] as bool? ?? false,
      pagesProcessed: (json['pages_processed'] as num?)?.toInt() ?? 0,
      stepsUs: (json['steps_us'] as num?)?.toInt() ?? 0,
      saveUs: (json['save_us'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() => 'CPDFOptimizeResult(ok: $ok, cancelled: $cancelled, '
      'pagesProcessed: $pagesProcessed, stepsUs: $stepsUs, saveUs: $saveUs)';
}
