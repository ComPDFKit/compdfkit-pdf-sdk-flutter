import 'dart:convert';

///  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.

/// modeConfig: Configuration of parameters that can be adjusted when opening a PDF interface.
/// For example, setting the default display mode when opening, such as entering viewer or annotations mode.
///
/// toolbarConfig: Configuration of top toolbar functionality and menu feature lists.
/// This allows you to customize the buttons and menu options on the top toolbar for various operations.
///
/// readerViewConfig: Configuration related to the PDF view,
/// including functions like highlighting hyperlinks and form field highlighting.
///
/// ```dart
/// ComPDFKit.openDocument(
///   tempDocumentPath,
///   password: '',
///   configuration: CPDFConfiguration());
///
/// ```
class CPDFConfiguration {
  ModeConfig modeConfig;

  ToolbarConfig toolbarConfig;

  ReaderViewConfig readerViewConfig;

  CPDFConfiguration(
      {this.modeConfig = const ModeConfig(initialViewMode: CPreviewMode.viewer),
      this.toolbarConfig = const ToolbarConfig(androidAvailableActions: [
        ToolbarAction.thumbnail,
        ToolbarAction.search,
        ToolbarAction.bota,
        ToolbarAction.menu,
      ], iosLeftBarAvailableActions: [
        ToolbarAction.back,
        ToolbarAction.thumbnail,
      ], iosRightBarAvailableActions: [
        ToolbarAction.search,
        ToolbarAction.bota,
        ToolbarAction.menu,
      ], availableMenus: [
        ToolbarMenuAction.viewSettings,
        ToolbarMenuAction.documentEditor,
        ToolbarMenuAction.security,
        ToolbarMenuAction.watermark,
        ToolbarMenuAction.documentInfo,
        ToolbarMenuAction.save,
        ToolbarMenuAction.share,
        ToolbarMenuAction.openDocument,
      ]),
      this.readerViewConfig = const ReaderViewConfig(
          linkHighlight: true, formFieldHighlight: true)});

  String toJson() => jsonEncode({
        'modeConfig': modeConfig.toJson(),
        'toolbarConfig': toolbarConfig.toJson(),
        'readerViewConfig': readerViewConfig.toJson()
      });
}

enum CPreviewMode {
  viewer,
  annotations,
  contentEditor,
  forms,
  digitalSignatures
}

class ModeConfig {
  final CPreviewMode initialViewMode;

  const ModeConfig({this.initialViewMode = CPreviewMode.viewer});

  Map<String, dynamic> toJson() => {'initialViewMode': initialViewMode.name};
}

enum ToolbarAction { back, thumbnail, search, bota, menu }

enum ToolbarMenuAction {
  viewSettings,
  documentEditor,
  security,
  watermark,
  documentInfo,
  save,
  share,
  openDocument
}

class ToolbarConfig {
  final List<ToolbarAction> androidAvailableActions;

  final List<ToolbarAction> iosLeftBarAvailableActions;

  final List<ToolbarAction> iosRightBarAvailableActions;

  final List<ToolbarMenuAction> availableMenus;

  const ToolbarConfig(
      {this.androidAvailableActions = const [],
      this.iosLeftBarAvailableActions = const [],
      this.iosRightBarAvailableActions = const [],
      this.availableMenus = const []});

  Map<String, dynamic> toJson() => {
        'androidAvailableActions':
            androidAvailableActions.map((e) => e.name).toList(),
        'iosLeftBarAvailableActions':
            iosLeftBarAvailableActions.map((e) => e.name).toList(),
        'iosRightBarAvailableActions':
            iosRightBarAvailableActions.map((e) => e.name).toList(),
        'availableMenus': availableMenus.map((e) => e.name).toList()
      };
}

/// pdf readerView configuration
class ReaderViewConfig {
  // Highlight hyperlink annotations in pdf
  final bool linkHighlight;

  // Highlight hyperlink form field
  final bool formFieldHighlight;

  const ReaderViewConfig(
      {this.linkHighlight = true, this.formFieldHighlight = true});

  Map<String, dynamic> toJson() => {
        'linkHighlight': linkHighlight,
        'formFieldHighlight': formFieldHighlight
      };
}
