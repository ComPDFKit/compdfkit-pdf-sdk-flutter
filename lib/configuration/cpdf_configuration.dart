// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';
import 'dart:io';

import 'package:compdfkit_flutter/configuration/config/cpdf_page_editor_config.dart';
import 'package:compdfkit_flutter/configuration/config/cpdf_search_config.dart';
import 'package:compdfkit_flutter/configuration/config/cpdf_ui_style_config.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_config.dart';
import 'package:compdfkit_flutter/toolbar/cpdf_custom_toolbar_item.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

import 'config/cpdf_bota_config.dart';
import 'attributes/cpdf_arrow_attr.dart';
import 'attributes/cpdf_circle_attr.dart';
import 'attributes/cpdf_editor_text_attr.dart';
import 'attributes/cpdf_freetext_attr.dart';
import 'attributes/cpdf_highlight_attr.dart';
import 'attributes/cpdf_ink_attr.dart';
import 'attributes/cpdf_line_attr.dart';
import 'attributes/cpdf_square_attr.dart';
import 'attributes/cpdf_squiggly_attr.dart';
import 'attributes/cpdf_strikeout_attr.dart';
import 'attributes/cpdf_text_attr.dart';
import 'attributes/cpdf_underline_attr.dart';
import 'attributes/form/cpdf_checkbox_attr.dart';
import 'attributes/form/cpdf_combobox_attr.dart';
import 'attributes/form/cpdf_listbox_attr.dart';
import 'attributes/form/cpdf_pushbutton_attr.dart';
import 'attributes/form/cpdf_radiobutton_attr.dart';
import 'attributes/form/cpdf_signature_widget_attr.dart';
import 'attributes/form/cpdf_textfield_attr.dart';
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
///
/// {@category configuration}
class CPDFConfiguration {
  CPDFModeConfig modeConfig;

  CPDFToolbarConfig toolbarConfig;

  CPDFReaderViewConfig readerViewConfig;

  CPDFAnnotationsConfig annotationsConfig;

  CPDFContentEditorConfig contentEditorConfig;

  CPDFFormsConfig formsConfig;

  CPDFGlobalConfig globalConfig;

  CPDFContextMenuConfig contextMenuConfig;

  CPDFConfiguration(
      {this.modeConfig =
          const CPDFModeConfig(initialViewMode: CPDFViewMode.viewer),
      CPDFToolbarConfig? toolbarConfig,
      CPDFReaderViewConfig? readerViewConfig,
      this.annotationsConfig = const CPDFAnnotationsConfig(),
      this.contentEditorConfig = const CPDFContentEditorConfig(),
      this.formsConfig = const CPDFFormsConfig(),
      this.globalConfig = const CPDFGlobalConfig(),
      this.contextMenuConfig = const CPDFContextMenuConfig()})
      : toolbarConfig = toolbarConfig ?? CPDFToolbarConfig(),
        readerViewConfig = readerViewConfig ?? CPDFReaderViewConfig();

  String toJson() => jsonEncode({
        'modeConfig': modeConfig.toJson(),
        'toolbarConfig': toolbarConfig.toJson(),
        'readerViewConfig': readerViewConfig.toJson(),
        'annotationsConfig': annotationsConfig.toJson(),
        'contentEditorConfig': contentEditorConfig.toJson(),
        'formsConfig': formsConfig.toJson(),
        'global': globalConfig.toJson(),
        'contextMenuConfig': contextMenuConfig.toJson()
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

  final CPDFUIVisibilityMode uiVisibilityMode;

  const CPDFModeConfig(
      {this.initialViewMode = CPDFViewMode.viewer,
      this.uiVisibilityMode = CPDFUIVisibilityMode.automatic,
      this.availableViewModes = CPDFViewMode.values});

  Map<String, dynamic> toJson() => {
        'initialViewMode': initialViewMode.name,
        'uiVisibilityMode': uiVisibilityMode.name,
        'availableViewModes': availableViewModes.map((e) => e.name).toList()
      };
}

/// Configuration for top toolbar functionality.
class CPDFToolbarConfig {
  /// Top toolbar actions
  ///
  /// Android Default: []
  ///
  /// iOS Default: `CPDFToolbarAction.back`, `CPDFToolbarAction.thumbnail`
  final List<CPDFToolbarAction> toolbarLeftItems;

  /// Top toolbar right actions
  ///
  /// Android Default: `CPDFToolbarAction.thumbnail`, `CPDFToolbarAction.search`,
  /// `CPDFToolbarAction.bota`, `CPDFToolbarAction.menu`
  ///
  /// iOS Default: `CPDFToolbarAction.search`, `CPDFToolbarAction.bota`,
  /// `CPDFToolbarAction.menu`
  final List<CPDFToolbarAction> toolbarRightItems;

  /// Configure the menu options opened in the top toolbar [CPDFToolbarAction.menu]
  final List<CPDFToolbarAction> availableMenus;

  final List<CPDFCustomToolbarItem> customToolbarLeftItems;

  final List<CPDFCustomToolbarItem> customToolbarRightItems;

  final List<CPDFCustomToolbarItem> customMoreMenuItems;

  final bool mainToolbarVisible;

  final bool annotationToolbarVisible;

  final bool contentEditorToolbarVisible;

  final bool formToolbarVisible;

  final bool signatureToolbarVisible;

  final bool showInkToggleButton;

  // final bool showFormModeToggleButton;

  CPDFToolbarConfig({
    List<CPDFToolbarAction>? toolbarLeftItems,
    List<CPDFToolbarAction>? toolbarRightItems,
    this.customToolbarLeftItems = const [],
    this.customToolbarRightItems = const [],
    this.customMoreMenuItems = const [],
    this.availableMenus = const [
      CPDFToolbarAction.viewSettings,
      CPDFToolbarAction.documentEditor,
      CPDFToolbarAction.security,
      CPDFToolbarAction.watermark,
      CPDFToolbarAction.flattened,
      CPDFToolbarAction.documentInfo,
      CPDFToolbarAction.save,
      CPDFToolbarAction.share,
      CPDFToolbarAction.openDocument,
      CPDFToolbarAction.snip
    ],
    this.mainToolbarVisible = true,
    this.annotationToolbarVisible = true,
    this.showInkToggleButton = true,
    this.contentEditorToolbarVisible = true,
    this.formToolbarVisible = true,
    this.signatureToolbarVisible = true,
    // this.showFormModeToggleButton = true
  })  : toolbarLeftItems = toolbarLeftItems ??
            (Platform.isIOS
                ? const [
                    CPDFToolbarAction.back,
                    CPDFToolbarAction.thumbnail,
                  ]
                : const []),
        toolbarRightItems = toolbarRightItems ??
            (Platform.isIOS
                ? const [
                    CPDFToolbarAction.search,
                    CPDFToolbarAction.bota,
                    CPDFToolbarAction.menu,
                  ]
                : const [
                    CPDFToolbarAction.thumbnail,
                    CPDFToolbarAction.search,
                    CPDFToolbarAction.bota,
                    CPDFToolbarAction.menu,
                  ]);

  Map<String, dynamic> toJson() => {
        'toolbarLeftItems': toolbarLeftItems.map((e) => e.name).toList(),
        'toolbarRightItems': toolbarRightItems.map((e) => e.name).toList(),
        'availableMenus': availableMenus.map((e) => e.name).toList(),
        'customToolbarLeftItems':
            customToolbarLeftItems.map((e) => e.toJson()).toList(),
        'customToolbarRightItems':
            customToolbarRightItems.map((e) => e.toJson()).toList(),
        'customMoreMenuItems':
            customMoreMenuItems.map((e) => e.toJson()).toList(),
        'mainToolbarVisible': mainToolbarVisible,
        'annotationToolbarVisible': annotationToolbarVisible,
        'contentEditorToolbarVisible': contentEditorToolbarVisible,
        'formToolbarVisible': formToolbarVisible,
        'signatureToolbarVisible': signatureToolbarVisible,
        'showInkToggleButton': showInkToggleButton,
        // 'showFormModeToggleButton': showFormModeToggleButton
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

  final List<int> margins;

  final bool enableMinScale;

  /// UI style configuration, such as setting border styles for selected annotations, forms, and content editing text.
  /// Default: CPDFUiStyleConfig()
  final CPDFUiStyleConfig uiStyle;

  /// Whether to display the annotation layer.
  /// Default: true
  final bool annotationsVisible;

  /// In content editing mode, when only text editing is selected, whether to enable creating a text input box by clicking the page area.
  /// Default value: true
  final bool enableCreateEditTextInput;

  /// In content editing mode, when only image editing is selected, whether to enable creating an image picker dialog by clicking the page area.
  /// Default value: true
  final bool enableCreateImagePickerDialog;

  /// Whether to enable double-tap zooming functionality.
  /// Default value: true
  final bool enableDoubleTapZoom;

  CPDFReaderViewConfig({
    this.linkHighlight = true,
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
    this.pageSameWidth = true,
    this.margins = const [0, 0, 0, 0],
    this.enableMinScale = true,
    this.annotationsVisible = true,
    this.enableCreateEditTextInput = true,
    this.enableCreateImagePickerDialog = true,
    this.enableDoubleTapZoom = false,
    CPDFUiStyleConfig? uiStyle,
  }) : uiStyle = uiStyle ?? CPDFUiStyleConfig.create();

  Map<String, dynamic> toJson() => {
        'linkHighlight': linkHighlight,
        'formFieldHighlight': formFieldHighlight,
        'displayMode': displayMode.name,
        'continueMode': continueMode,
        'verticalMode': verticalMode,
        'cropMode': cropMode,
        'themes': themes.type.name,
        'enableSliderBar': enableSliderBar,
        'enablePageIndicator': enablePageIndicator,
        'pageSpacing': pageSpacing,
        'pageScale': pageScale,
        'pageSameWidth': pageSameWidth,
        'margins': margins,
        'enableMinScale': enableMinScale,
        'annotationsVisible': annotationsVisible,
        'enableCreateEditTextInput': enableCreateEditTextInput,
        'enableCreateImagePickerDialog': enableCreateImagePickerDialog,
        'uiStyle': uiStyle.toJson(),
        'enableDoubleTapZoom': enableDoubleTapZoom
      };
}

class CPDFAnnotationsConfig {
  /// In the **V2.1.0** version, a new comment reply function is added,
  /// and the name of the comment author can be set here.
  final String annotationAuthor;

  /// [CPDFViewMode.annotations] mode,
  /// list of annotation functions shown at the bottom of the view.
  final List<CPDFAnnotationType> availableTypes;

  /// [CPDFViewMode.annotations] mode,
  /// annotation tools shown at the bottom of the view.
  final List<CPDFConfigTool> availableTools;

  /// When adding an annotation, the annotation’s default attributes.
  final CPDFAnnotAttribute initAttribute;

  /// In annotation mode, when tapping the bottom toolbar or calling
  /// `controller.setAnnotationMode(CPDFAnnotationType.signature)`, whether to
  /// automatically show the signature picker dialog.
  /// Default: true. If set to false, the signature picker dialog will not be
  /// displayed. You can handle signature selection yourself via the
  /// `CPDFReaderWidget(onAnnotationCreationPreparedCallback: ...)`
  /// callback. For example, show a custom signature picker, then call
  /// `controller.prepareNextSignature(String signPath)` with the chosen signature
  /// path; a subsequent tap will place the custom signature into the PDF.
  final bool autoShowSignPicker;

  /// In annotation mode, when tapping the bottom toolbar or calling
  /// `controller.setAnnotationMode(CPDFAnnotationType.picture)`, whether to
  /// automatically show the picture picker dialog.
  /// Default: true. If set to false, the picture picker dialog will not be
  /// displayed. You can handle picture selection yourself via the
  /// `CPDFReaderWidget(onAnnotationCreationPreparedCallback: ...)`
  /// callback. For example, show a custom image picker, then call
  /// `controller.prepareNextPicture(String imagePath)` with the chosen image
  /// path; a subsequent tap will add the custom image to the PDF.
  final bool autoShowPicPicker;

  /// In annotation mode, when tapping the bottom toolbar or calling
  /// `controller.setAnnotationMode(CPDFAnnotationType.stamp)`, whether to
  /// automatically show the stamp picker dialog.
  /// Default: true. If set to false, the stamp picker dialog will not be
  /// displayed. You can handle stamp selection yourself via the
  /// `CPDFReaderWidget(onAnnotationCreationPreparedCallback: ...)`
  /// callback. For example, show a custom stamp picker, then call
  /// `controller.prepareNextStamp(String stampPath)` with the chosen stamp path;
  /// a subsequent tap will add the custom stamp to the PDF.
  final bool autoShowStampPicker;

  /// In annotation mode, when tapping the bottom toolbar or calling
  /// `controller.setAnnotationMode(CPDFAnnotationType.link)`, whether to
  /// automatically show the link settings dialog after the link area is drawn
  /// on the screen.
  /// Default: true. If set to false, the link settings dialog will not be
  /// displayed. You can handle link configuration yourself via the
  /// `CPDFReaderWidget(onAnnotationCreationPreparedCallback: ...)`
  /// callback. For example, show a custom link dialog, then call
  /// `controller.prepareNextLink(String link)` with the configured link; a
  /// subsequent tap will add the custom link to the PDF.
  final bool autoShowLinkDialog;

  /// Intercept click actions on existing note annotations.
  /// Default is false (not intercepted). Clicking a note annotation will directly pop up the note content editing dialog.
  /// When set to true, the click event is intercepted via [CPDFReaderWidget.onInterceptAnnotationActionCallback].
  /// Developers can handle custom note content editing dialogs through the callback.
  final bool interceptNoteAction;

  /// Intercept click actions on existing link annotations.
  /// Default is false (not intercepted). Clicking a link annotation will directly execute the link jump action.
  /// When set to true, the click event is intercepted via [CPDFReaderWidget.onInterceptAnnotationActionCallback].
  /// Developers can handle custom link jump actions through the callback.
  final bool interceptLinkAction;

  const CPDFAnnotationsConfig(
      {this.availableTypes = CPDFAnnotationType.values,
      this.availableTools = CPDFConfigTool.values,
      this.initAttribute = const CPDFAnnotAttribute(),
      this.annotationAuthor = "",
      this.autoShowSignPicker = true,
      this.autoShowPicPicker = true,
      this.autoShowStampPicker = true,
      this.autoShowLinkDialog = true,
      this.interceptNoteAction = false,
      this.interceptLinkAction = false});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson(),
        'annotationAuthor': annotationAuthor,
        'autoShowSignPicker': autoShowSignPicker,
        'autoShowPicPicker': autoShowPicPicker,
        'autoShowStampPicker': autoShowStampPicker,
        'autoShowLinkDialog': autoShowLinkDialog,
        'interceptNoteAction': interceptNoteAction,
        'interceptLinkAction': interceptLinkAction
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

  factory CPDFAnnotAttribute.fromJson(Map<String, dynamic> json) {
    T parse<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final value = json[key];
      if (value is Map) {
        return fromJson(Map<String, dynamic>.from(value));
      } else {
        throw FormatException('Invalid or missing attribute: $key');
      }
    }

    return CPDFAnnotAttribute(
      noteAttr: parse('noteAttr', CPDFTextAttr.fromJson),
      highlightAttr: parse('highlightAttr', CPDFHighlightAttr.fromJson),
      underlineAttr: parse('underlineAttr', CPDFUnderlineAttr.fromJson),
      squigglyAttr: parse('squigglyAttr', CPDFSquigglyAttr.fromJson),
      strikeoutAttr: parse('strikeoutAttr', CPDFStrikeoutAttr.fromJson),
      inkAttr: parse('inkAttr', CPDFInkAttr.fromJson),
      squareAttr: parse('squareAttr', CPDFSquareAttr.fromJson),
      circleAttr: parse('circleAttr', CPDFCircleAttr.fromJson),
      lineAttr: parse('lineAttr', CPDFLineAttr.fromJson),
      arrowAttr: parse('arrowAttr', CPDFArrowAttr.fromJson),
      freeTextAttr: parse('freetextAttr', CPDFFreetextAttr.fromJson),
    );
  }

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

  final bool showCreateListBoxOptionsDialog;

  final bool showCreateComboBoxOptionsDialog;

  final bool showCreatePushButtonOptionsDialog;

  /// Intercept list box click event.
  /// Default is false (not intercepted), clicking the list box directly shows the list box options dialog.
  /// When set to true, the click event is intercepted via [CPDFReaderWidget.onInterceptWidgetActionCallback].
  /// Developers can handle displaying a custom list box options dialog via the callback.
  /// Note: only support android platform in version 2.6.2
  final bool interceptListBoxAction;

  /// Intercept combo box click event.
  /// Default is false (not intercepted), clicking the combo box directly shows the combo box options dialog.
  /// When set to true, the click event is intercepted via [CPDFReaderWidget.onInterceptWidgetActionCallback].
  /// Developers can handle displaying a custom combo box options dialog via the callback.
  /// Note: only support android platform in version 2.6.2
  final bool interceptComboBoxAction;

  /// Intercept button click event.
  /// Default is false (not intercepted), clicking the button directly triggers the button action.
  /// When set to true, the click event is intercepted via [CPDFReaderWidget.onInterceptWidgetActionCallback].
  /// Developers can handle button click actions via the callback.
  /// Note: only support android platform in version 2.6.2
  final bool interceptPushButtonAction;

  const CPDFFormsConfig(
      {this.availableTypes = CPDFFormType.values,
      this.availableTools = const [CPDFConfigTool.undo, CPDFConfigTool.redo],
      this.initAttribute = const CPDFFormAttribute(),
      this.showCreateListBoxOptionsDialog = true,
      this.showCreateComboBoxOptionsDialog = true,
      this.showCreatePushButtonOptionsDialog = true,
      this.interceptListBoxAction = false,
      this.interceptComboBoxAction = false,
      this.interceptPushButtonAction = false});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson(),
        'showCreateListBoxOptionsDialog': showCreateListBoxOptionsDialog,
        'showCreateComboBoxOptionsDialog': showCreateComboBoxOptionsDialog,
        'showCreatePushButtonOptionsDialog': showCreatePushButtonOptionsDialog,
        'interceptListBoxAction': interceptListBoxAction,
        'interceptComboBoxAction': interceptComboBoxAction,
        'interceptPushButtonAction': interceptPushButtonAction
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

  factory CPDFFormAttribute.fromJson(Map<String, dynamic> json) {
    T parse<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final value = json[key];
      if (value is Map) {
        return fromJson(Map<String, dynamic>.from(value));
      } else {
        throw FormatException('Invalid or missing attribute: $key');
      }
    }

    return CPDFFormAttribute(
      textFieldAttr: parse('textFieldAttr', CPDFTextFieldAttr.fromJson),
      checkBoxAttr: parse('checkBoxAttr', CPDFCheckBoxAttr.fromJson),
      radioButtonAttr: parse('radioButtonAttr', CPDFRadioButtonAttr.fromJson),
      listBoxAttr: parse('listBoxAttr', CPDFListBoxAttr.fromJson),
      comboBoxAttr: parse('comboBoxAttr', CPDFComboBoxAttr.fromJson),
      pushButtonAttr: parse('pushButtonAttr', CPDFPushButtonAttr.fromJson),
      signaturesFieldsAttr:
          parse('signaturesFieldsAttr', CPDFSignatureWidgetAttr.fromJson),
    );
  }

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

  /// Whether to use incremental save. Default is true.
  /// Enabling incremental save can improve save speed and reduce memory usage, but may increase file size.
  /// If you need to generate a smaller file, set this option to false for a full save.
  /// This affects all save operations in CPDFReaderWidget, including manual and auto-save,
  /// such as saving, sharing, and saving on exit.
  /// Only supported on Android platform.
  final bool useSaveIncremental;

  final CPDFWatermarkConfig watermark;

  final bool enableExitSaveTips;

  final CPDFFillSignatureType signatureType;

  final CPDFThumbnailConfig thumbnail;

  final bool enableErrorTips;

  final CPDFBotaConfig bota;

  final CPDFSearchConfig search;

  final CPDFPageEditorConfig pageEditor;

  /// ios pencil annotation menus config
  /// Only supports iOS platform.
  final List<CPDFPencilMenus> pencilMenus;

  const CPDFGlobalConfig(
      {this.themeMode = CPDFThemeMode.system,
      this.fileSaveExtraFontSubset = true,
      this.useSaveIncremental = true,
      this.watermark = const CPDFWatermarkConfig(),
      this.enableExitSaveTips = true,
      this.signatureType = CPDFFillSignatureType.manual,
      this.thumbnail = const CPDFThumbnailConfig(),
      this.enableErrorTips = true,
      this.bota = const CPDFBotaConfig(),
      this.search = const CPDFSearchConfig(),
      this.pageEditor = const CPDFPageEditorConfig(),
      this.pencilMenus = CPDFPencilMenus.values});

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.name,
        'fileSaveExtraFontSubset': fileSaveExtraFontSubset,
        'useSaveIncremental': useSaveIncremental,
        'watermark': watermark.toJson(),
        'enableExitSaveTips': enableExitSaveTips,
        'signatureType': signatureType.name,
        'thumbnail': thumbnail.toJson(),
        'enableErrorTips': enableErrorTips,
        'bota': bota.toJson(),
        'search': search.toJson(),
        'pageEditor': pageEditor.toJson(),
        'pencilMenus': pencilMenus.map((e) => e.name).toList()
      };
}

/// Configuration options for adding a watermark.
///
/// Supports both **text** and **image** watermarks, with full control
/// over appearance, placement, and rendering behavior.
class CPDFWatermarkConfig {
  /// Whether to save the watermarked document as a new file.
  ///
  /// Defaults to `true`.
  final bool saveAsNewFile;

  /// Background color outside the page area (optional).
  final Color? outsideBackgroundColor;

  /// Types of watermarks to apply (text, image, or both).
  ///
  /// Defaults to `[CPDFWatermarkType.text, CPDFWatermarkType.image]`.
  final List<CPDFWatermarkType> types;

  /// The watermark text content.
  ///
  /// Defaults to `"Watermark"`.
  final String text;

  /// The image source for the watermark.
  ///
  /// Can be:
  /// - Android: drawable resource name or file path
  /// - iOS: bundled image name or file path
  ///
  /// Defaults to `""` (no image).
  final String image;

  /// Font size of the watermark text.
  ///
  /// Defaults to `30`.
  final int textSize;

  /// Color of the watermark text.
  ///
  /// Defaults to [Colors.black].
  final Color textColor;

  /// Scale factor for the watermark size.
  ///
  /// Defaults to `1.5`.
  final double scale;

  /// Rotation angle of the watermark (in degrees).
  ///
  /// Negative values rotate counter-clockwise.
  ///
  /// Defaults to `-45`.
  final int rotation;

  /// Opacity of the watermark (0–255).
  ///
  /// Defaults to `255` (fully opaque).
  final int opacity;

  /// Whether to render the watermark **in front** of the content.
  ///
  /// Defaults to `false` (behind the content).
  final bool isFront;

  /// Whether to tile the watermark across the entire page.
  ///
  /// Defaults to `false`.
  final bool isTilePage;

  const CPDFWatermarkConfig(
      {this.saveAsNewFile = true,
      this.outsideBackgroundColor,
      this.types = const [CPDFWatermarkType.text, CPDFWatermarkType.image],
      this.text = "Watermark",
      this.image = "",
      this.textSize = 30,
      this.textColor = Colors.black,
      this.scale = 1.5,
      this.rotation = -45,
      this.opacity = 255,
      this.isFront = false,
      this.isTilePage = false});

  Map<String, dynamic> toJson() => {
        "saveAsNewFile": saveAsNewFile,
        "outsideBackgroundColor": outsideBackgroundColor?.toHex(),
        "types": types.map((e) => e.name).toList(),
        "text": text,
        "image": image,
        "textSize": textSize,
        "textColor": textColor.toHex(),
        "scale": scale,
        "rotation": rotation,
        "opacity": opacity,
        "isFront": isFront,
        "isTilePage": isTilePage
      };
}

class CPDFThumbnailConfig {
  final String? title;

  final Color? backgroundColor;

  final bool editMode;

  const CPDFThumbnailConfig({
    this.title,
    this.backgroundColor,
    this.editMode = true,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "backgroundColor": backgroundColor?.toHex(),
        "editMode": editMode
      };
}
