// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/cpdf_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';
import 'package:compdf_viewer/features/bota/bookmarks/controller/bookmark_controller.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/shared/widgets/dialogs/input_alert_dialog.dart';

/// A list item widget representing a single PDF bookmark.
///
/// This widget displays bookmark information with a modern card-like design
/// and provides tap-to-navigate and menu actions (edit/delete).
///
/// **Displayed Information:**
/// - Bookmark icon (leading)
/// - Bookmark title (main text)
/// - Formatted date (subtitle)
/// - Page number badge (trailing)
/// - Action menu (more options)
///
/// **User Interactions:**
/// - **Tap:** Navigate to the bookmarked page and close BOTA panel
/// - **Menu → Edit:** Show dialog to rename the bookmark
/// - **Menu → Delete:** Remove the bookmark from the document
///
/// **Usage:**
/// ```dart
/// BookmarkItem(bookmark: myBookmark)
/// ```
///
/// Requires [BookmarkController] and [PdfViewerController] to be registered
/// in the GetX dependency injection system.
class BookmarkItem extends StatelessWidget {
  final CPDFBookmark bookmark;

  const BookmarkItem({super.key, required this.bookmark});

  // Tap the item to jump to the bookmark position page
  void _handleTap() async {
    final pdfController = Get.find<PdfViewerController>();
    int pageIndex = bookmark.pageIndex;
    if (pageIndex >= 0) {
      await pdfController.readerController.value?.setDisplayPageIndex(
        pageIndex: pageIndex,
      );
    }
    Get.back();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            // Bookmark icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.bookmark_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            // Title and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    bookmark.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  if (bookmark.date != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(bookmark.date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Page badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Text(
                '${bookmark.pageIndex + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            // Menu button
            _buildMenu(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, ColorScheme colorScheme) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      splashRadius: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        switch (value) {
          case 'delete':
            // Delete bookmark logic
            Get.find<BookmarkController>().removeBookmark(bookmark);
            break;
          case 'edit':
            // Edit bookmark logic
            String? text = await showDialog<String?>(
              context: context,
              builder: (context) {
                return InputAlertDialog(
                  title: PdfLocaleKeys.pleaseInputBookmarkName.tr,
                  text: bookmark.title,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  hintText: PdfLocaleKeys.inputBookmarkTextFieldHint.tr,
                );
              },
            );
            if (text != null) {
              bookmark.title = text;
              Get.find<BookmarkController>().editBookmark(bookmark);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: 12),
              Text(PdfLocaleKeys.edit.tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded,
                  size: 18, color: colorScheme.error),
              const SizedBox(width: 12),
              Text(PdfLocaleKeys.delete.tr,
                  style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
