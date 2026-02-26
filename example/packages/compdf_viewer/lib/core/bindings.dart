// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/viewer/controller/pdf_viewer_controller.dart';
import 'package:compdf_viewer/shared/controllers/pdf_global_settings_controller.dart';
import 'package:compdf_viewer/features/search/controller/pdf_search_controller.dart';
import 'package:compdf_viewer/features/annotation/controller/pdf_annotation_tool_bar_controller.dart';
import 'package:compdf_viewer/features/navigation/controller/side_navigation_controller.dart';
import 'package:compdf_viewer/features/navigation/repository/side_navigation_repository.dart';

/// GetX binding for PDF viewer core dependencies.
///
/// Initializes and registers all required controllers for the PDF viewer page.
/// This binding is automatically invoked when navigating to the PDF viewer route.
///
/// Registered controllers:
/// - [PdfViewerController]: Manages PDF document loading, navigation, and view modes
/// - [PdfGlobalSettingsController]: Handles global UI settings and preferences
/// - [PdfSearchController]: Manages PDF text search functionality
/// - [PdfAnnotationToolBarController]: Controls annotation tool selection and history
///
/// Example:
/// ```dart
/// GetPage(
///   name: '/pdf_viewer',
///   page: () => PdfViewerPage(),
///   binding: PdfViewerBinding(),
/// )
/// ```
class PdfViewerBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize controller
    Get.put(PdfViewerController());
    Get.put(PdfGlobalSettingsController());
    Get.put(PdfSearchController());
    Get.put(PdfAnnotationToolBarController());
    Get.put(SideNavigationRepository());
    Get.put(SideNavigationController(Get.find()));
  }
}
