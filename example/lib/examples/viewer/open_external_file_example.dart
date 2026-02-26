// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/material.dart';

import '../../cpdf_reader_page.dart';
import '../../utils/preferences_service.dart';

/// Open External File Example
///
/// Demonstrates opening PDF files from the device file system.
///
/// This example shows:
/// - Using [ComPDFKit.pickFile] for file selection
/// - Navigating to [CPDFReaderPage] with the selected file
/// - Handling loading states during file selection
/// - Building a custom file picker UI
///
/// Key classes/APIs used:
/// - [ComPDFKit.pickFile]: Opens system file picker for PDF files
/// - [CPDFReaderPage]: Displays the selected PDF document
/// - [CPDFConfiguration]: Viewer configuration options
///
/// Usage:
/// 1. Open the example
/// 2. Tap "Browse Files" button
/// 3. Select a PDF from your device
/// 4. View the selected PDF in the reader
class OpenExternalFileExample extends StatefulWidget {
  /// Constructor
  const OpenExternalFileExample({super.key});

  @override
  State<OpenExternalFileExample> createState() =>
      _OpenExternalFileExampleState();
}

class _OpenExternalFileExampleState extends State<OpenExternalFileExample> {
  bool _isOpening = false;

  Future<void> _pickAndOpenDocument() async {
    setState(() => _isOpening = true);
    final path = await ComPDFKit.pickFile();
    if (!mounted) return;
    setState(() => _isOpening = false);

    if (path == null) return;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CPDFReaderPage(
            title: 'Open External File',
            documentPath: path,
            configuration: CPDFConfiguration(
              annotationsConfig: CPDFAnnotationsConfig(
                annotationAuthor: PreferencesService.documentAuthor,
              ),
              readerViewConfig: CPDFReaderViewConfig(
                linkHighlight: PreferencesService.highlightLink,
                formFieldHighlight: PreferencesService.highlightForm,
              ),
            ),
            onIOSClickBackPressed: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ==================== header ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _BackButton(
                      onTap: () => Navigator.pop(context), colors: colors),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Open External File',
                        style: textStyle.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Select and view PDF files from your device',
                        style: textStyle.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ==================== content ====================
            Expanded(
              child: Container(
                color: colors.surfaceContainerHigh,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IconContainer(colors: colors),
                      const SizedBox(height: 24),
                      Text(
                        'Select PDF File',
                        style: textStyle.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a PDF file from your device to view, annotate, and edit',
                        textAlign: TextAlign.center,
                        style: textStyle.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isOpening ? null : _pickAndOpenDocument,
                          child: Text(
                            _isOpening ? 'Opening PDF...' : 'Browse Files',
                            style: textStyle.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colors;

  const _BackButton({
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: colors.primary,
          ),
        ),
      );
}

class _IconContainer extends StatelessWidget {
  final ColorScheme colors;

  const _IconContainer({required this.colors});

  @override
  Widget build(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.folder_open,
          size: 40,
          color: colors.primary,
        ),
      );
}
