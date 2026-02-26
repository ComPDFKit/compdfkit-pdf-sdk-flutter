// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Page insertion type enumeration.
///
/// Defines available page types that can be inserted into a PDF document.
/// Includes blank pages and pages with predefined templates (lines, music, grid).
///
/// Types:
/// - `blankPage`: Empty white page
/// - `pdfPage`: Import pages from another PDF file
/// - `horizontalLine`: Page with horizontal line template
/// - `musicalNotation`: Page with musical staff notation template
/// - `square`: Page with square grid template
enum InsertPageType {
  blankPage, // Insert blank page
  pdfPage, // Insert PDF page
  horizontalLine, // Insert horizontal line
  musicalNotation, // Insert musical notation
  square, // Insert square grid
}
