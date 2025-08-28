/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */


/// Search options for PDF text search.
enum CPDFSearchOptions {
  /// Case-insensitive search.
  caseInsensitive(0),

  /// Case sensitive search.
  caseSensitive(1),

  /// Matches a whole word
  matchWholeWord(2);

  /// Native value used by the platform code.
  final int nativeValue;

  const CPDFSearchOptions(this.nativeValue);
}