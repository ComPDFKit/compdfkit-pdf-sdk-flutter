// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/annotations/controller/annotation_controller.dart';
import 'package:compdf_viewer/features/bota/annotations/repository/annotation_repository.dart';
import 'package:compdf_viewer/features/bota/bookmarks/controller/bookmark_controller.dart';
import 'package:compdf_viewer/features/bota/bookmarks/repository/bookmark_repository.dart';
import 'package:compdf_viewer/features/bota/outlines/controller/outline_controller.dart';
import 'package:compdf_viewer/features/bota/outlines/repository/outline_repository.dart';

/// GetX binding for the BOTA (Bookmarks, Outlines, Thumbnails, Annotations) panel.
///
/// This binding class is responsible for lazy-loading all dependencies
/// required by the BOTA panel's three tabs: Annotations, Outline, and Bookmarks.
///
/// **Registered Dependencies:**
/// - [AnnotationRepository] and [AnnotationController] - For annotations tab
/// - [OutlineRepository] and [OutlineController] - For outline tab
/// - [BookmarkRepository] and [BookmarkController] - For bookmarks tab
///
/// **Usage:**
/// ```dart
/// Get.to(
///   () => BotaPage(),
///   binding: BotaPageBinding(),
/// );
/// ```
///
/// All dependencies are registered using `lazyPut` to ensure they are only
/// created when actually needed.
class BotaPageBinding extends Bindings {
  @override
  void dependencies() {
    // Annotation controller initialization
    Get.lazyPut(() => AnnotationRepository());
    Get.lazyPut(() => AnnotationController(Get.find()));
    // Outline controller initialization
    Get.lazyPut(() => OutlineRepository());
    Get.lazyPut(() => OutlineController(Get.find()));
    // Bookmark controller initialization
    Get.lazyPut(() => BookmarkRepository());
    Get.lazyPut(() => BookmarkController(Get.find()));
  }
}
