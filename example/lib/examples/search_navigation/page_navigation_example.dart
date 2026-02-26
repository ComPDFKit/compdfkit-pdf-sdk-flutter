// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:flutter/material.dart';

import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

import '../../constants/asset_paths.dart';

/// Page Navigation Example
///
/// Demonstrates programmatic page navigation within a PDF document using
/// the reader widget controller.
///
/// This example shows:
/// - Jumping to the first page of the document
/// - Navigating to the previous page
/// - Navigating to the next page
/// - Jumping to the last page of the document
/// - Using animated transitions between pages
///
/// Key classes/APIs used:
/// - [CPDFReaderWidgetController.setDisplayPageIndex]: Navigates to a specific page
/// - [CPDFReaderWidgetController.getCurrentPageIndex]: Gets the current page index
/// - [CPDFDocument.getPageCount]: Gets the total number of pages
///
/// Usage:
/// 1. Open the PDF document with the reader widget
/// 2. Use the bottom navigation bar buttons to navigate between pages
/// 3. The navigation respects document boundaries (won't go past first/last page)
class PageNavigationExample extends StatelessWidget {
  /// Constructor
  const PageNavigationExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Page Navigation',
      assetPath: _assetPath,
      builder: (path) => _PageNavigationPage(documentPath: path),
    );
  }
}

class _PageNavigationPage extends ExampleBase {
  const _PageNavigationPage({required super.documentPath});

  @override
  State<_PageNavigationPage> createState() => _PageNavigationPageState();
}

class _PageNavigationPageState extends ExampleBaseState<_PageNavigationPage> {
  @override
  String get pageTitle => 'Page Navigation';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: buildContent()),
        _buildNavigationBar(),
      ],
    );
  }

  Widget _buildNavigationBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildNavButton(
                  icon: Icons.first_page_rounded,
                  label: 'First',
                  onTap: _jumpFirstPage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.chevron_left_rounded,
                  label: 'Previous',
                  onTap: _jumpPreviousPage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.chevron_right_rounded,
                  label: 'Next',
                  onTap: _jumpNextPage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.last_page_rounded,
                  label: 'Last',
                  onTap: _jumpLastPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Future<void> Function() onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: controller != null ? () => onTap() : null,
        borderRadius: BorderRadius.circular(12),
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        highlightColor: colorScheme.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: colorScheme.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _jumpFirstPage() async {
    await controller?.setDisplayPageIndex(pageIndex: 0, animated: true);
  }

  Future<void> _jumpPreviousPage() async {
    if (controller == null) return;
    final currentIndex = await controller!.getCurrentPageIndex();
    final targetIndex = currentIndex > 0 ? currentIndex - 1 : 0;
    await controller!.setDisplayPageIndex(
      pageIndex: targetIndex,
      animated: true,
    );
  }

  Future<void> _jumpNextPage() async {
    if (controller == null) return;
    final pageCount = await controller!.document.getPageCount();
    final currentIndex = await controller!.getCurrentPageIndex();
    final lastIndex = pageCount > 0 ? pageCount - 1 : 0;
    final targetIndex = currentIndex < lastIndex ? currentIndex + 1 : lastIndex;
    await controller!.setDisplayPageIndex(
      pageIndex: targetIndex,
      animated: true,
    );
  }

  Future<void> _jumpLastPage() async {
    if (controller == null) return;
    final pageCount = await controller!.document.getPageCount();
    final lastIndex = pageCount > 0 ? pageCount - 1 : 0;
    await controller!.setDisplayPageIndex(pageIndex: lastIndex, animated: true);
  }
}
