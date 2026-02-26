// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:flutter/material.dart';

import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// A hierarchical list item widget representing a single PDF outline entry.
///
/// This widget recursively renders the outline tree structure with proper
/// indentation, expand/collapse functionality, and tap-to-navigate behavior.
///
/// **Displayed Information:**
/// - Outline title (bold for parent items, normal for leaf items)
/// - Page number (trailing, if destination exists)
/// - URI link (subtitle, if action is CPDFUriAction)
/// - Expand/collapse icon (leading, for items with children)
///
/// **User Interactions:**
/// - **Tap:** Navigate to the destination page or open URI link
/// - **Tap expand icon:** Toggle child outline visibility
///
/// **Layout Features:**
/// - Indentation based on outline level (20px per level)
/// - Smooth expand/collapse animation
/// - Recursive rendering of child outlines
/// - Visual hierarchy with indent guides
///
/// **Usage:**
/// ```dart
/// OutlineItem(outline: outlineNode)
/// ```
class OutlineItem extends StatefulWidget {
  final CPDFOutline outline;

  const OutlineItem({super.key, required this.outline});

  @override
  State<OutlineItem> createState() => _OutlineItemState();
}

class _OutlineItemState extends State<OutlineItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  final PdfViewerController pdfController = Get.find<PdfViewerController>();

  void _handleTap() async {
    final outline = widget.outline;
    final pageIndex = outline.destination?.pageIndex ?? -1;

    if (outline.action is CPDFUriAction) {
      final uri = (outline.action as CPDFUriAction).uri;
      if (uri.isNotEmpty) {
        launchUrl(Uri.parse(uri));
        return;
      }
    }

    if (pageIndex >= 0) {
      await pdfController.readerController.value?.setDisplayPageIndex(
        pageIndex: pageIndex,
      );
    }
    Get.back();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final outline = widget.outline;
    final hasChildren = outline.childList.isNotEmpty;
    final level = outline.level;
    final indentPadding = (level - 1) * 20.0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main item row
        InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: EdgeInsets.only(left: 12 + indentPadding, right: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                // Expand/collapse button
                _buildExpandButton(hasChildren, colorScheme),
                const SizedBox(width: 8),
                // Title and subtitle
                Expanded(
                    child: _buildTitleSection(outline, hasChildren, theme)),
                // Page number badge
                if (outline.destination?.pageIndex != null &&
                    outline.destination!.pageIndex >= 0)
                  _buildPageBadge(outline.destination!.pageIndex, colorScheme),
              ],
            ),
          ),
        ),
        // Children (no animation)
        if (_isExpanded && hasChildren) _buildChildren(outline.childList),
      ],
    );
  }

  Widget _buildExpandButton(bool hasChildren, ColorScheme colorScheme) {
    if (!hasChildren) {
      return SizedBox(
        width: 28,
        height: 28,
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleExpand,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _isExpanded
              ? colorScheme.primaryContainer.withOpacity(0.5)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: AnimatedRotation(
          turns: _isExpanded ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: _isExpanded
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(
      CPDFOutline outline, bool hasChildren, ThemeData theme) {
    final isUri = outline.action is CPDFUriAction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          outline.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: hasChildren ? FontWeight.w600 : FontWeight.w400,
            height: 1.3,
          ),
        ),
        if (isUri) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link_rounded,
                size: 12,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  (outline.action as CPDFUriAction).uri,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPageBadge(int pageIndex, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
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
        '${pageIndex + 1}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildChildren(List<CPDFOutline> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children.map((child) => OutlineItem(outline: child)).toList(),
    );
  }
}
