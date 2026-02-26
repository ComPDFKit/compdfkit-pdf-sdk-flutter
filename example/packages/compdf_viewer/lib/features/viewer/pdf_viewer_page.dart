// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:compdf_viewer/features/navigation/side_navigation.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/search/widgets/pdf_search_toolbar.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/features/viewer/widgets/pdf_viewer_content.dart';
import 'package:compdf_viewer/features/viewer/widgets/pdf_viewer_page_menu.dart';
import 'package:compdf_viewer/features/viewer/widgets/content_editor_toggle.dart';
import 'package:compdf_viewer/router/pdf_viewer_routes.dart';

/// Main PDF viewer page with full feature integration.
///
/// A complete PDF reading experience including:
/// - PDF document rendering with [PdfViewerContent]
/// - AppBar with view mode toggle and action menu
/// - Side navigation drawer with file operations and settings
/// - Search toolbar overlay for text search results
/// - Fullscreen mode support
/// - Smart back navigation (exits search → switches mode → saves and closes)
///
/// Uses [PdfViewerBinding] to initialize required controllers.
///
/// Example:
/// ```dart
/// // Navigate with GetX
/// Get.toNamed(
///   PdfViewerRoutes.pdfPage,
///   arguments: {'document': '/path/to/file.pdf'},
/// );
///
/// // Or use directly
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => PdfViewerPage(
///       documentPath: '/path/to/file.pdf',
///     ),
///   ),
/// );
/// ```
class PdfViewerPage extends StatefulWidget {
  final String documentPath;

  const PdfViewerPage({super.key, required this.documentPath});

  /// Factory constructor for GetX route navigation
  ///
  /// Creates a PdfViewerPage by extracting documentPath from [Get.arguments].
  /// Expected arguments format: {'document': String}
  ///
  /// Usage:
  /// ```dart
  /// Get.toNamed(PdfViewerRoutes.pdfPage, arguments: {'document': '/path/to/file.pdf'});
  /// ```
  factory PdfViewerPage.fromRoute({Key? key}) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final documentPath = arguments?['document'] as String? ?? '';
    return PdfViewerPage(key: key, documentPath: documentPath);
  }

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late final PdfViewerController _controller = Get.find<PdfViewerController>();
  late final PdfSearchController _searchController =
      Get.find<PdfSearchController>();

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _delayShowContent();
  }

  /// Delays showing content to avoid jank caused by page transition animation and PDF rendering happening simultaneously
  void _delayShowContent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _showContent = true);
      });
    });
  }

  // ------------------- Event Handlers -------------------

  void _handleBack() async {
    final shouldPop = await _controller.handleBack();
    if (shouldPop) Get.back();
  }

  void _handleThumbnail() async {
    final pageIndex = await Get.toNamed(PdfViewerRoutes.thumbnail);
    if (pageIndex is int) _controller.jumpToPage(pageIndex);
  }

  void _handleBota() =>
      Get.toNamed(PdfViewerRoutes.bota, arguments: 'annotation');

  void _handleSearch() => Get.toNamed(PdfViewerRoutes.pdfSearch);

  // ------------------- UI Building -------------------

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Obx(() {
        final fullScreen = _controller.state.fullScreen.value;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: fullScreen ? null : _buildAppBar(),
          body: _showContent ? _buildBody() : const SizedBox.shrink(),
          endDrawer: SideNavigation(),
          drawerScrimColor: Colors.black12,
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        onPressed: _handleBack,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: const ContentEditorToggle(),
      actions: PdfViewerPageMenu(
        onThumbnail: _handleThumbnail,
        onBota: _handleBota,
        onSearch: _handleSearch,
      ).buildActions(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        PdfViewerContent(
          documentPath: widget.documentPath,
          onTapMainDocArea: _controller.toggleFullScreen,
        ),
        _buildSearchOverlay(),
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return Positioned(
      bottom: 65,
      left: 0,
      right: 0,
      child: Obx(() {
        final hasResults = _searchController.state.searchResults.isNotEmpty;
        return hasResults ? const PdfSearchToolbar() : const SizedBox.shrink();
      }),
    );
  }
}
