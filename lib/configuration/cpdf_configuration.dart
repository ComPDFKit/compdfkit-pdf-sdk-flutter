// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'dart:convert';

import 'package:compdfkit_flutter/configuration/attributes/cpdf_annot_attr.dart';

import 'cpdf_options.dart';

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
  CPDFModeConfig modeConfig;

  CPDFToolbarConfig toolbarConfig;

  CPDFReaderViewConfig readerViewConfig;

  CPDFAnnotationsConfig annotationsConfig;

  CPDFContentEditorConfig contentEditorConfig;

  CPDFFormsConfig formsConfig;

  CPDFGlobalConfig globalConfig;

  CPDFConfiguration(
      {this.modeConfig =
          const CPDFModeConfig(initialViewMode: CPDFViewMode.viewer),
      this.toolbarConfig = const CPDFToolbarConfig(),
      this.readerViewConfig = const CPDFReaderViewConfig(),
      this.annotationsConfig = const CPDFAnnotationsConfig(),
      this.contentEditorConfig = const CPDFContentEditorConfig(),
      this.formsConfig = const CPDFFormsConfig(),
      this.globalConfig = const CPDFGlobalConfig()});

  String toJson() => jsonEncode({
        'modeConfig': modeConfig.toJson(),
        'toolbarConfig': toolbarConfig.toJson(),
        'readerViewConfig': readerViewConfig.toJson(),
        'annotationsConfig': annotationsConfig.toJson(),
        'contentEditorConfig': contentEditorConfig.toJson(),
        'formsConfig': formsConfig.toJson(),
        'global': globalConfig.toJson()
      });
}

// Set the default display mode and list of supported modes when rendering PDF documents.
// The default display mode is the **viewer** mode.
// In this mode, you can preview the document and fill in the form,
// but you cannot edit comments and other content.
class CPDFModeConfig {
  /// Default mode to display when opening the PDF View, default is [CPDFViewMode.viewer]
  final CPDFViewMode initialViewMode;

  /// Configure supported modes
  final List<CPDFViewMode> availableViewModes;

  /// Setting this to true will hide the top and bottom toolbars,
  /// displaying only the central PDF document view.
  /// Conversely, setting this to false will display all toolbars.
  final bool readerOnly;

  const CPDFModeConfig(
      {this.initialViewMode = CPDFViewMode.viewer,
      this.readerOnly = false,
      this.availableViewModes = CPDFViewMode.values});

  Map<String, dynamic> toJson() => {
        'initialViewMode': initialViewMode.name,
        'readerOnly': readerOnly,
        'availableViewModes': availableViewModes.map((e) => e.name).toList()
      };
}

/// Configuration for top toolbar functionality.
class CPDFToolbarConfig {
  /// Top toolbar actions for Android platform
  ///
  /// Default: thumbnail, search, bota, menu.
  ///
  /// [CPDFToolbarAction.BACK] button will be shown only on the far left
  final List<CPDFToolbarAction> androidAvailableActions;

  /// Left toolbar actions for iOS platform
  ///
  /// Default: back, thumbnail
  final List<CPDFToolbarAction> iosLeftBarAvailableActions;

  /// Right toolbar actions for iOS platform
  ///
  /// Default: search, bota, menu
  final List<CPDFToolbarAction> iosRightBarAvailableActions;

  /// Configure the menu options opened in the top toolbar [CPDFToolbarAction.menu]
  final List<CPDFToolbarMenuAction> availableMenus;

  const CPDFToolbarConfig(
      {this.androidAvailableActions = const [
        CPDFToolbarAction.thumbnail,
        CPDFToolbarAction.search,
        CPDFToolbarAction.bota,
        CPDFToolbarAction.menu,
      ],
      this.iosLeftBarAvailableActions = const [
        CPDFToolbarAction.back,
        CPDFToolbarAction.thumbnail,
      ],
      this.iosRightBarAvailableActions = const [
        CPDFToolbarAction.search,
        CPDFToolbarAction.bota,
        CPDFToolbarAction.menu
      ],
      this.availableMenus = const [
        CPDFToolbarMenuAction.viewSettings,
        CPDFToolbarMenuAction.documentEditor,
        CPDFToolbarMenuAction.security,
        CPDFToolbarMenuAction.watermark,
        CPDFToolbarMenuAction.flattened,
        CPDFToolbarMenuAction.documentInfo,
        CPDFToolbarMenuAction.save,
        CPDFToolbarMenuAction.share,
        CPDFToolbarMenuAction.openDocument,
        CPDFToolbarMenuAction.snip
      ]});

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
class CPDFReaderViewConfig {
  // Highlight hyperlink annotations in pdf
  final bool linkHighlight;

  // Highlight hyperlink form field
  final bool formFieldHighlight;

  /// Display mode of the PDF document, single page, double page, or book mode.
  /// Default: [CPDFDisplayMode.singlePage]
  final CPDFDisplayMode displayMode;

  /// Whether PDF page flipping is continuous scrolling.
  final bool continueMode;

  /// Whether scrolling is in vertical direction.
  ///
  /// `true`: Vertical scrolling.<br/>
  /// `false`: Horizontal scrolling. <br/>
  /// Default: true
  final bool verticalMode;

  /// Cropping mode.
  ///
  /// Whether to crop blank areas of PDF pages.<br/>
  /// Default: false
  final bool cropMode;

  /// Theme color.
  ///
  /// Default: [CPDFThemes.light]
  final CPDFThemes themes;

  /// Whether to display the sidebar quick scroll bar.
  final bool enableSliderBar;

  /// Whether to display the bottom page indicator.
  final bool enablePageIndicator;

  /// Spacing between each page of the PDF, default 10px.
  final int pageSpacing;

  /// Page scale value, default 1.0.
  final double pageScale;

  /// only android platform
  final bool pageSameWidth;

  const CPDFReaderViewConfig(
      {this.linkHighlight = true,
      this.formFieldHighlight = true,
      this.displayMode = CPDFDisplayMode.singlePage,
      this.continueMode = true,
      this.verticalMode = true,
      this.cropMode = false,
      this.themes = CPDFThemes.light,
      this.enableSliderBar = true,
      this.enablePageIndicator = true,
      this.pageSpacing = 10,
      this.pageScale = 1.0,
      this.pageSameWidth = true});

  Map<String, dynamic> toJson() => {
        'linkHighlight': linkHighlight,
        'formFieldHighlight': formFieldHighlight,
        'displayMode': displayMode.name,
        'continueMode': continueMode,
        'verticalMode': verticalMode,
        'cropMode': cropMode,
        'themes': themes.name,
        'enableSliderBar': enableSliderBar,
        'enablePageIndicator': enablePageIndicator,
        'pageSpacing': pageSpacing,
        'pageScale': pageScale,
        'pageSameWidth': pageSameWidth
      };
}

class CPDFAnnotationsConfig {
  /// In the **V2.1.0** version, a new comment reply function is added,
  /// and the name of the comment author can be set here.
  final String annotationAuthor;

  /// [CPDFViewMode.annotations] mode,
  /// list of annotation functions shown at the bottom of the view.
  final List<CPDFAnnotationType> availableTypes;

  /// [CPDFViewMode.ANNOTATIONS] mode,
  /// annotation tools shown at the bottom of the view.
  final List<CPDFConfigTool> availableTools;

  /// When adding an annotation, the annotation’s default attributes.
  final CPDFAnnotAttribute initAttribute;

  const CPDFAnnotationsConfig(
      {this.availableTypes = CPDFAnnotationType.values,
      this.availableTools = CPDFConfigTool.values,
      this.initAttribute = const CPDFAnnotAttribute(),
      this.annotationAuthor = ""});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson(),
        'annotationAuthor': annotationAuthor
      };
}

class CPDFAnnotAttribute {
  /// Note annotation attribute configuration.
  final CPDFTextAttr noteAttr;

  final CPDFHighlightAttr highlightAttr;

  final CPDFUnderlineAttr underlineAttr;

  final CPDFSquigglyAttr squigglyAttr;

  final CPDFStrikeoutAttr strikeoutAttr;

  final CPDFInkAttr inkAttr;

  final CPDFSquareAttr squareAttr;

  final CPDFCircleAttr circleAttr;

  final CPDFLineAttr lineAttr;

  final CPDFArrowAttr arrowAttr;

  final CPDFFreetextAttr freeTextAttr;

  const CPDFAnnotAttribute({
    this.noteAttr = const CPDFTextAttr(),
    this.highlightAttr = const CPDFHighlightAttr(),
    this.underlineAttr = const CPDFUnderlineAttr(),
    this.squigglyAttr = const CPDFSquigglyAttr(),
    this.strikeoutAttr = const CPDFStrikeoutAttr(),
    this.inkAttr = const CPDFInkAttr(),
    this.squareAttr = const CPDFSquareAttr(),
    this.circleAttr = const CPDFCircleAttr(),
    this.lineAttr = const CPDFLineAttr(),
    this.arrowAttr = const CPDFArrowAttr(),
    this.freeTextAttr = const CPDFFreetextAttr(),
  });

  Map<String, dynamic> toJson() => {
        'note': noteAttr.toJson(),
        'highlight': highlightAttr.toJson(),
        'underline': underlineAttr.toJson(),
        'squiggly': squigglyAttr.toJson(),
        'strikeout': strikeoutAttr.toJson(),
        'ink': inkAttr.toJson(),
        'square': squareAttr.toJson(),
        'circle': circleAttr.toJson(),
        'line': lineAttr.toJson(),
        'arrow': arrowAttr.toJson(),
        'freeText': freeTextAttr.toJson()
      };
}


class CPDFContentEditorConfig {
  /// Content editing mode, the editing mode displayed at the bottom of the view
  /// Default order: editorText, editorImage
  final List<CPDFContentEditorType> availableTypes;

  /// Available tools, including: Setting, Undo, Redo.
  final List<CPDFConfigTool> availableTools;

  final CPDFContentEditorAttribute initAttribute;

  const CPDFContentEditorConfig(
      {this.availableTypes = CPDFContentEditorType.values,
      this.availableTools = CPDFConfigTool.values,
      this.initAttribute = const CPDFContentEditorAttribute()});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson()
      };
}

class CPDFContentEditorAttribute {

  final CPDFEditorTextAttr text;

  const CPDFContentEditorAttribute({this.text = const CPDFEditorTextAttr()});

  Map<String, dynamic> toJson() => {'text': text.toJson()};
}



class CPDFFormsConfig {
  /// In [CPDFViewMode.forms] mode, the list of form types at the bottom of the view.
  final List<CPDFFormType> availableTypes;

  /// Only supports [CPDFConfigTool.undo] and [CPDFConfigTool.redo].
  final List<CPDFConfigTool> availableTools;

  /// Form default attribute configuration
  final CPDFFormAttribute initAttribute;

  const CPDFFormsConfig(
      {this.availableTypes = CPDFFormType.values,
      this.availableTools = const [CPDFConfigTool.undo, CPDFConfigTool.redo],
      this.initAttribute = const CPDFFormAttribute()});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson()
      };
}

class CPDFFormAttribute {

  final CPDFTextFieldAttr textFieldAttr;

  final CPDFCheckBoxAttr checkBoxAttr;

  final CPDFRadioButtonAttr radioButtonAttr;

  final CPDFListBoxAttr listBoxAttr;

  final CPDFComboBoxAttr comboBoxAttr;

  final CPDFPushButtonAttr pushButtonAttr;

  final CPDFSignatureWidgetAttr signaturesFieldsAttr;

  const CPDFFormAttribute({
    this.textFieldAttr = const CPDFTextFieldAttr(),
    this.checkBoxAttr = const CPDFCheckBoxAttr(),
    this.radioButtonAttr = const CPDFRadioButtonAttr(),
    this.listBoxAttr = const CPDFListBoxAttr(),
    this.comboBoxAttr = const CPDFComboBoxAttr(),
    this.pushButtonAttr = const CPDFPushButtonAttr(),
    this.signaturesFieldsAttr = const CPDFSignatureWidgetAttr(),
  });

  Map<String, dynamic> toJson() => {
        'textField': textFieldAttr.toJson(),
        'checkBox': checkBoxAttr.toJson(),
        'radioButton': radioButtonAttr.toJson(),
        'listBox': listBoxAttr.toJson(),
        'comboBox': comboBoxAttr.toJson(),
        'pushButton': pushButtonAttr.toJson(),
        'signaturesFields': signaturesFieldsAttr.toJson()
      };
}

class CPDFGlobalConfig {
  /// Only supports Android platform in version 2.0.2
  //  Set the view theme mode except the PDF area, the default value is [CPDFThemeMode.system]
  final CPDFThemeMode themeMode;

  /// In version V2.1.0, you can set whether to save a subset of fonts when the document is saved.
  /// The default value is true. Saving font subsets may increase file size.
  final bool fileSaveExtraFontSubset;

  const CPDFGlobalConfig(
      {this.themeMode = CPDFThemeMode.system,
      this.fileSaveExtraFontSubset = true});

  Map<String, dynamic> toJson() => {
        "themeMode": themeMode.name,
        "fileSaveExtraFontSubset": fileSaveExtraFontSubset
      };
}
