// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_basic_info_panel.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_create_info_panel.dart';
import 'package:compdf_viewer/features/info/widgets/pdf_permissions_info_panel.dart';

/// Main content container for the PDF information page, composing all info panels.
///
/// This widget organizes the document information display into three vertical sections:
/// 1. [PdfBasicInfoPanel] - File name, size, title, author
/// 2. [PdfCreateInfoPanel] - Version, page count, creator, producer, dates
/// 3. [PdfPermissionsInfoPanel] - Encryption, copy/print permissions
///
/// The content is wrapped in a [SingleChildScrollView] to handle overflow on smaller screens.
/// Visual spacing between sections provides clear separation.
/// All data is fetched and managed by [PdfInfoController] which is accessed by the child panels.
///
/// Example usage:
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: Text('File Info')),
///   body: PdfInfoContent(), // Shows all three info panels
/// )
/// ```
class PdfInfoContent extends StatelessWidget {
  const PdfInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            _buildSection(context, child: const PdfBasicInfoPanel()),
            const SizedBox(height: 12),
            _buildSection(context, child: const PdfCreateInfoPanel()),
            const SizedBox(height: 12),
            _buildSection(context, child: const PdfPermissionsInfoPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
