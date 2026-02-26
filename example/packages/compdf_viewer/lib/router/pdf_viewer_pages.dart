// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/core/bindings.dart';
import 'package:compdf_viewer/router/pdf_viewer_routes.dart';
import 'package:compdf_viewer/features/bota/bota_page.dart';
import 'package:compdf_viewer/features/bota/bota_page_binding.dart';
import 'package:compdf_viewer/features/bota/thumbnails/thumbnail_page.dart';
import 'package:compdf_viewer/features/bota/thumbnails/thumbnail_binding.dart';
import 'package:compdf_viewer/features/info/pdf_info_binding.dart';
import 'package:compdf_viewer/features/info/pdf_info_page.dart';
import 'package:compdf_viewer/features/search/widgets/pdf_search_page.dart';
import 'package:compdf_viewer/features/viewer/pdf_viewer_page.dart';

/// GetX page configuration for the PDF viewer package.
///
/// Defines all route mappings with their corresponding pages and bindings.
/// Use [PdfViewerPages.routes] when configuring your GetX app.
///
/// Example:
/// ```dart
/// GetMaterialApp(
///   initialRoute: '/home',
///   getPages: [
///     GetPage(name: '/home', page: () => HomePage()),
///     ...PdfViewerPages.routes, // Include PDF viewer routes
///   ],
/// );
/// ```
class PdfViewerPages {
  /// List of all PDF viewer route definitions.
  ///
  /// Each route includes:
  /// - Route path from [PdfViewerRoutes]
  /// - Page widget factory
  /// - Dependency injection binding (where applicable)
  static final routes = [
    // Main PDF viewer page with core controllers
    GetPage(
        name: PdfViewerRoutes.pdfPage,
        page: () => PdfViewerPage.fromRoute(),
        binding: PdfViewerBinding()),

    // BOTA page with annotation, outline, and bookmark controllers
    GetPage(
        name: PdfViewerRoutes.bota,
        page: () => const BotaPage(),
        binding: BotaPageBinding()),

    // Thumbnail page with thumbnail-specific controllers
    GetPage(
        name: PdfViewerRoutes.thumbnail,
        page: () => const ThumbnailPage(),
        binding: ThumbnailBinding()),

    // Document info page with info controllers
    GetPage(
        name: PdfViewerRoutes.documentInfo,
        page: () => const PdfInfoPage(),
        binding: PdfInfoBinding()),

    // Search page (uses existing search controller from PdfViewerBinding)
    GetPage(name: PdfViewerRoutes.pdfSearch, page: () => const PdfSearchPage()),
  ];
}
