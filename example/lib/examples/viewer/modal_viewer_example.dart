// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/file_util.dart';
import '../../utils/preferences_service.dart';

/// Callback type for document selection
typedef DocumentSelectedCallback = void Function(String documentPath);

/// Modal PDF Picker
///
/// A reusable modal bottom sheet for selecting PDF documents.
///
/// This widget provides two options:
/// - Open a default/sample PDF document
/// - Select an external file from the device
///
/// **Parameters:**<br/>
///   [defaultAssetPath] - Asset path for the default PDF (optional).
///   [onDocumentSelected] - Callback when a document is selected.
///   [title] - Custom title for the modal (default: 'Open PDF').
///   [subtitle] - Custom subtitle for the modal.
///   [defaultOptionTitle] - Title for default document option.
///   [defaultOptionSubtitle] - Subtitle for default document option.
///   [externalOptionTitle] - Title for external file option.
///   [externalOptionSubtitle] - Subtitle for external file option.
///
/// Usage:
/// ```dart
/// showPdfPickerModal(
///   context,
///   defaultAssetPath: 'assets/sample.pdf',
///   onDocumentSelected: (path) {
///     // Handle selected document path
///   },
/// );
/// ```
///
/// Since v2.4.3

/// Shows the PDF picker modal bottom sheet
///
/// **Parameters:**<br/>
///   [context] - Build context for showing the modal.
///   [defaultAssetPath] - Asset path for the default PDF document.
///   [onDocumentSelected] - Required callback when a document is selected.
///   [title] - Custom title (default: 'Open PDF').
///   [subtitle] - Custom subtitle.
///   [defaultOptionTitle] - Title for the default option.
///   [defaultOptionSubtitle] - Subtitle for the default option.
///   [externalOptionTitle] - Title for the external file option.
///   [externalOptionSubtitle] - Subtitle for the external file option.
void showPdfPickerModal(
  BuildContext context, {
  String? defaultAssetPath,
  required DocumentSelectedCallback onDocumentSelected,
  String title = 'Open PDF',
  String subtitle = 'Choose how you want to view the PDF',
  String defaultOptionTitle = 'Open Sample PDF',
  String defaultOptionSubtitle = 'View the built-in example',
  String externalOptionTitle = 'Select External File',
  String externalOptionSubtitle = 'Pick a file from your device',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PdfPickerContent(
      defaultAssetPath: defaultAssetPath,
      onDocumentSelected: onDocumentSelected,
      title: title,
      subtitle: subtitle,
      defaultOptionTitle: defaultOptionTitle,
      defaultOptionSubtitle: defaultOptionSubtitle,
      externalOptionTitle: externalOptionTitle,
      externalOptionSubtitle: externalOptionSubtitle,
    ),
  );
}

/// Modal Viewer Example
///
/// Demonstrates opening PDF viewer from a modal bottom sheet with options.
///
/// This example shows:
/// - Creating a modal bottom sheet with [showModalBottomSheet]
/// - Using [ComPDFKit.openDocument] for standalone viewer
/// - Using [ComPDFKit.pickFile] for external file selection
/// - Building custom UI option cards for user selection
///
/// Key classes/APIs used:
/// - [ComPDFKit.openDocument]: Opens PDF in a standalone viewer
/// - [ComPDFKit.pickFile]: System file picker for PDF selection
/// - [CPDFConfiguration]: Viewer configuration options
///
/// Usage:
/// 1. Open the modal sheet via the example entry
/// 2. Choose "Open Sample PDF" for built-in document
/// 3. Or choose "Select External File" to pick from device
///
/// Open Modal example entry (legacy API for backward compatibility)
void openModalViewer(BuildContext context) {
  showPdfPickerModal(
    context,
    defaultAssetPath: AppAssets.pdfDocument,
    onDocumentSelected: (path) {
      ComPDFKit.openDocument(
        path,
        password: '',
        configuration: CPDFConfiguration(
          annotationsConfig: CPDFAnnotationsConfig(
            annotationAuthor: PreferencesService.documentAuthor,
          ),
        ),
      );
    },
  );
}

/// PDF Picker modal content
class _PdfPickerContent extends StatelessWidget {
  final String? defaultAssetPath;
  final DocumentSelectedCallback onDocumentSelected;
  final String title;
  final String subtitle;
  final String defaultOptionTitle;
  final String defaultOptionSubtitle;
  final String externalOptionTitle;
  final String externalOptionSubtitle;

  const _PdfPickerContent({
    this.defaultAssetPath,
    required this.onDocumentSelected,
    required this.title,
    required this.subtitle,
    required this.defaultOptionTitle,
    required this.defaultOptionSubtitle,
    required this.externalOptionTitle,
    required this.externalOptionSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasDefaultAsset = defaultAssetPath != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== Drag indicator bar ====================
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ==================== Title ====================
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            // ==================== Option Cards ====================
            if (hasDefaultAsset) ...[
              _OptionCard(
                icon: Icons.picture_as_pdf,
                title: defaultOptionTitle,
                subtitle: defaultOptionSubtitle,
                colors: colors,
                onTap: () {
                  Navigator.pop(context);
                  _openDefaultDocument();
                },
              ),
              const SizedBox(height: 12),
            ],
            _OptionCard(
              icon: Icons.folder_open,
              title: externalOptionTitle,
              subtitle: externalOptionSubtitle,
              colors: colors,
              onTap: () {
                Navigator.pop(context);
                _openExternalDocument();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _openDefaultDocument() async {
    if (defaultAssetPath == null) return;
    final file = await extractAsset(defaultAssetPath!, shouldOverwrite: false);
    onDocumentSelected(file.path);
  }

  void _openExternalDocument() async {
    final path = await ComPDFKit.pickFile();
    if (path == null) return;
    onDocumentSelected(path);
  }
}

// ==================== Option Cards ====================

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.outline.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: colors.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      );
}
