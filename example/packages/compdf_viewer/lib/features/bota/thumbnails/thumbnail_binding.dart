// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/repository/thumbnail_repository.dart';

import 'package:compdf_viewer/features/bota/thumbnails/controller/thumbnail_controller.dart';

/// GetX binding for thumbnail page dependencies.
///
/// Lazily injects ThumbnailRepository and ThumbnailController when navigating
/// to the thumbnail page. Ensures proper dependency setup and cleanup.
///
/// Usage example:
/// ```dart
/// // In routing configuration
/// GetPage(
///   name: PdfViewerRoutes.thumbnails,
///   page: () => ThumbnailPage(),
///   binding: ThumbnailBinding(),
/// )
///
/// // Or explicit navigation
/// Get.toNamed(
///   PdfViewerRoutes.thumbnails,
///   binding: ThumbnailBinding(),
/// );
/// ```
class ThumbnailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThumbnailRepository>(() => ThumbnailRepository());
    Get.lazyPut<ThumbnailController>(() => ThumbnailController(Get.find()));
  }
}
