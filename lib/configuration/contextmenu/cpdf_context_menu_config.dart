/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:ui';

import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_annotation_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_content_editor_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_form_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_view_mode_context_menu.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';

import 'cpdf_global_context_menu.dart';

class CPDFContextMenuConfig {

  // set context menu background color, only for android platform.
  final Color? backgroundColor;

  final double fontSize;

  final List<double> padding;

  final double iconSize;

  final CPDFGlobalContextMenu global;

  final CPDFViewModeContextMenu viewMode;

  final CPDFAnnotationModeContextMenu annotationMode;

  final CPDFContentEditorModeContextMenu contentEditorMode;

  final CPDFFormModeContextMenu formMode;

  const CPDFContextMenuConfig({
    this.backgroundColor,
    this.fontSize = 14.0,
    this.padding = const [0,0,0,0],
    this.iconSize = 36,
    this.global = const CPDFGlobalContextMenu(),
    this.viewMode = const CPDFViewModeContextMenu(),
    this.annotationMode = const CPDFAnnotationModeContextMenu(),
    this.contentEditorMode = const CPDFContentEditorModeContextMenu(),
    this.formMode = const CPDFFormModeContextMenu(),
  });

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor?.toHex(),
      'fontSize': fontSize,
      'iconSize': iconSize,
      'padding': padding,
      'global': global.toJson(),
      'viewMode': viewMode.toJson(),
      'annotationMode': annotationMode.toJson(),
      'contentEditorMode': contentEditorMode.toJson(),
      'formMode': formMode.toJson(),
    };
  }
}
