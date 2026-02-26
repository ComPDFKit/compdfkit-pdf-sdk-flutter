// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:get/get.dart';
import 'package:compdf_viewer/features/bota/thumbnails/page_editor/insert_page_state.dart';

/// GetX controller for insert page dialog feature.
///
/// Simple controller that manages InsertPageState for page insertion dialogs.
/// Resets state to defaults on initialization.
///
/// Usage example:
/// ```dart
/// // In InsertPagesDialog
/// final controller = Get.put(PageEditorController());
///
/// // Access state
/// final type = controller.state.insertPageType.value;
/// final pageData = controller.state.getInsertPageData();
/// ```

class PageEditorController extends GetxController {
  InsertPageState state = InsertPageState();

  @override
  void onInit() {
    super.onInit();
    state.reset();
  }
}
