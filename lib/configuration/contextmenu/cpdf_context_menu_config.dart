/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_annotation_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_content_editor_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_form_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_view_mode_context_menu.dart';

import 'cpdf_global_context_menu.dart';

class CPDFContextMenuConfig {
  final CPDFGlobalContextMenu global;

  final CPDFViewModeContextMenu viewMode;

  final CPDFAnnotationModeContextMenu annotationMode;

  final CPDFContentEditorModeContextMenu contentEditorMode;

  final CPDFFormModeContextMenu formMode;

  const CPDFContextMenuConfig({
    this.global = const CPDFGlobalContextMenu(),
    this.viewMode = const CPDFViewModeContextMenu(),
    this.annotationMode = const CPDFAnnotationModeContextMenu(),
    this.contentEditorMode = const CPDFContentEditorModeContextMenu(),
    this.formMode = const CPDFFormModeContextMenu(),
  });

  Map<String, dynamic> toJson() {
    return {
      'global': global.toJson(),
      'viewMode': viewMode.toJson(),
      'annotationMode': annotationMode.toJson(),
      'contentEditorMode': contentEditorMode.toJson(),
      'formMode': formMode.toJson(),
    };
  }
}
