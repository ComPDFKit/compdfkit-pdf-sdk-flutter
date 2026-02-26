// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// ComPDFViewer - A comprehensive PDF viewing package for Flutter.
///
/// Built on ComPDFKit Flutter SDK with GetX state management.
///
/// ## Features
/// - PDF viewing with multiple display modes (single/double page, continuous scroll)
/// - Annotation tools (note, highlight, ink, shapes, stamps, signatures)
/// - Text search with context snippets
/// - Bookmarks, outlines, and thumbnail navigation
/// - Document information and encryption
/// - Content editor mode
/// - Responsive UI with dark mode support
///
/// ## Quick Start
/// ```dart
/// // 1. Initialize the SDK
/// await PdfViewerGlobal.init('assets/license_key_flutter.xml');
///
/// // 2. Add routes to your app
/// GetMaterialApp(
///   getPages: [
///     ...PdfViewerPages.routes,
///   ],
/// );
///
/// // 3. Navigate to PDF viewer
/// Get.toNamed(
///   PdfViewerRoutes.pdfPage,
///   arguments: {'document': '/path/to/document.pdf'},
/// );
/// ```
///
/// ## Architecture
/// - **Core**: Global settings, configuration, bindings, constants
/// - **Features**: Viewer, annotations, search, BOTA, navigation, security
/// - **Router**: Route definitions and page configuration
/// - **Shared**: Reusable widgets, controllers, utilities
/// - **Localization**: English and Chinese translations
///
/// ## Key Classes
/// - [PdfViewerGlobal]: SDK initialization and logger
/// - [PdfViewerController]: Main PDF viewer controller
/// - [PdfAnnotationToolBarController]: Annotation tool management
/// - [PdfSearchController]: Text search functionality
/// - [PdfViewerRoutes]: Route constants
/// - [PdfViewerPages]: GetX page configuration
library;

// Core
export 'core/global.dart';
export 'core/config.dart';
export 'core/bindings.dart';
export 'core/constants.dart';

// Views
export 'features/viewer/pdf_viewer_page.dart';
export 'features/viewer/widgets/pdf_viewer_content.dart';
export 'features/viewer/controller/pdf_viewer_controller.dart';

// Router
export 'router/pdf_viewer_routes.dart';
export 'router/pdf_viewer_pages.dart';

// Localization
export 'l10n/pdf_viewer_translations.dart';
export 'l10n/pdf_locale_keys.dart';
