import 'dart:convert';

import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:flutter/material.dart';

import 'cpdf_options.dart';

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

  CPDFAnnotationsConfig annotationsConfig;

  CPDFContentEditorConfig contentEditorConfig;

  CPDFFormsConfig formsConfig;

  CPDFConfiguration(
      {this.modeConfig = const ModeConfig(initialViewMode: CPreviewMode.viewer),
      this.toolbarConfig = const ToolbarConfig(),
      this.readerViewConfig = const ReaderViewConfig(),
      this.annotationsConfig = const CPDFAnnotationsConfig(),
      this.contentEditorConfig = const CPDFContentEditorConfig(),
      this.formsConfig = const CPDFFormsConfig()});

  String toJson() => jsonEncode({
        'modeConfig': modeConfig.toJson(),
        'toolbarConfig': toolbarConfig.toJson(),
        'readerViewConfig': readerViewConfig.toJson(),
        'annotationsConfig': annotationsConfig.toJson(),
        'contentEditorConfig': contentEditorConfig.toJson(),
        'formsConfig': formsConfig.toJson()
      });
}

class ModeConfig {
  final CPreviewMode initialViewMode;

  final List<CPreviewMode> availableViewModes;

  const ModeConfig(
      {this.initialViewMode = CPreviewMode.viewer,
      this.availableViewModes = CPreviewMode.values});

  Map<String, dynamic> toJson() => {
        'initialViewMode': initialViewMode.name,
        'availableViewModes': availableViewModes.map((e) => e.name).toList()
      };
}

class ToolbarConfig {
  final List<ToolbarAction> androidAvailableActions;

  final List<ToolbarAction> iosLeftBarAvailableActions;

  final List<ToolbarAction> iosRightBarAvailableActions;

  final List<ToolbarMenuAction> availableMenus;

  const ToolbarConfig(
      {this.androidAvailableActions = const [
        ToolbarAction.thumbnail,
        ToolbarAction.search,
        ToolbarAction.bota,
        ToolbarAction.menu,
      ],
      this.iosLeftBarAvailableActions = const [
        ToolbarAction.back,
        ToolbarAction.thumbnail,
      ],
      this.iosRightBarAvailableActions = const [
        ToolbarAction.search,
        ToolbarAction.bota,
        ToolbarAction.menu
      ],
      this.availableMenus = const [
        ToolbarMenuAction.viewSettings,
        ToolbarMenuAction.documentEditor,
        ToolbarMenuAction.security,
        ToolbarMenuAction.watermark,
        ToolbarMenuAction.flattened,
        ToolbarMenuAction.documentInfo,
        ToolbarMenuAction.save,
        ToolbarMenuAction.share,
        ToolbarMenuAction.openDocument,
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
class ReaderViewConfig {
  // Highlight hyperlink annotations in pdf
  final bool linkHighlight;

  // Highlight hyperlink form field
  final bool formFieldHighlight;

  final CPDFDisplayMode displayMode;

  final bool continueMode;

  final bool verticalMode;

  final bool cropMode;

  final CPDFThemes themes;

  final bool enableSliderBar;

  final bool enablePageIndicator;

  final int pageSpacing;

  final double pageScale;

  const ReaderViewConfig(
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
      this.pageScale = 1.0});

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
        'pageScale': pageScale
      };
}

class CPDFAnnotationsConfig {
  final List<CPDFAnnotationType> availableTypes;

  final List<CPDFConfigTool> availableTools;

  final CPDFAnnotationAttribute initAttribute;

  const CPDFAnnotationsConfig(
      {this.availableTypes = CPDFAnnotationType.values,
      this.availableTools = CPDFConfigTool.values,
      this.initAttribute = const CPDFAnnotationAttribute()});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson()
      };
}

class CPDFAnnotationAttribute {
  final CPDFAnnotAttr note;

  final CPDFAnnotAttr highlight;

  final CPDFAnnotAttr underline;

  final CPDFAnnotAttr squiggly;

  final CPDFAnnotAttr strikeout;

  final CPDFAnnotAttr ink;

  final CPDFAnnotAttr square;

  final CPDFAnnotAttr circle;

  final CPDFAnnotAttr line;

  final CPDFAnnotAttr arrow;

  final CPDFAnnotAttr freeText;

  const CPDFAnnotationAttribute({
    this.note = const CPDFAnnotAttr.note(),
    this.highlight = const CPDFAnnotAttr.highlight(),
    this.underline = const CPDFAnnotAttr.underline(),
    this.squiggly = const CPDFAnnotAttr.squiggly(),
    this.strikeout = const CPDFAnnotAttr.strikeout(),
    this.ink = const CPDFAnnotAttr.ink(),
    this.square = const CPDFAnnotAttr.square(),
    this.circle = const CPDFAnnotAttr.circle(),
    this.line = const CPDFAnnotAttr.line(),
    this.arrow = const CPDFAnnotAttr.arrow(),
    this.freeText = const CPDFAnnotAttr.freeText(),
  });

  Map<String, dynamic> toJson() => {
        'note': note.toJson(),
        'highlight': highlight.toJson(),
        'underline': underline.toJson(),
        'squiggly': squiggly.toJson(),
        'strikeout': strikeout.toJson(),
        'ink': ink.toJson(),
        'square': square.toJson(),
        'circle': circle.toJson(),
        'line': line.toJson(),
        'arrow': arrow.toJson(),
        'freeText': freeText.toJson()
      };
}

class CPDFAnnotAttr {
  final CPDFAnnotationType? annotationType;

  final Color? color;

  final int? alpha;

  final int? borderWidth;

  final Color? fillColor;

  final Color? borderColor;

  final int? borderAlpha;

  final int? colorAlpha;

  final CPDFBorderStyle? borderStyle;

  final CPDFLineType? startLineType;

  final CPDFLineType? tailLineType;

  final Color? fontColor;

  final int? fontColorAlpha;

  final int? fontSize;

  final bool? isBold;

  final bool? isItalic;

  final CPDFAlignment? alignment;

  final CPDFTypeface? typeface;

  const CPDFAnnotAttr(
      {required this.annotationType,
      this.color,
      this.alpha,
      this.borderWidth,
      this.fillColor,
      this.borderColor,
      this.borderAlpha,
      this.colorAlpha,
      this.borderStyle,
      this.startLineType,
      this.tailLineType,
      this.fontColor,
      this.fontColorAlpha,
      this.fontSize,
      this.isBold,
      this.isItalic,
      this.alignment,
      this.typeface});

  const CPDFAnnotAttr.note(
      {Color color = const Color(0xFF1460F3), int alpha = 255})
      : this(
            annotationType: CPDFAnnotationType.note,
            color: color,
            alpha: alpha);

  const CPDFAnnotAttr.highlight(
      {Color color = const Color(0xFF1460F3), int alpha = 77})
      : this(
            annotationType: CPDFAnnotationType.highlight,
            color: color,
            alpha: alpha);

  const CPDFAnnotAttr.underline(
      {Color color = const Color(0xFF1460F3), int alpha = 77})
      : this(
            annotationType: CPDFAnnotationType.underline,
            color: color,
            alpha: alpha);

  const CPDFAnnotAttr.squiggly(
      {Color color = const Color(0xFF1460F3), int alpha = 77})
      : this(
            annotationType: CPDFAnnotationType.squiggly,
            color: color,
            alpha: alpha);

  const CPDFAnnotAttr.strikeout(
      {Color color = const Color(0xFF1460F3), int alpha = 77})
      : this(
            annotationType: CPDFAnnotationType.highlight,
            color: color,
            alpha: alpha);

  const CPDFAnnotAttr.ink(
      {Color color = const Color(0xFF1460F3),
      int alpha = 100,
      int borderWidth = 10})
      : this(
            annotationType: CPDFAnnotationType.ink,
            color: color,
            alpha: alpha,
            borderWidth: borderWidth);

  const CPDFAnnotAttr.square({
    Color fillColor = const Color(0xFF1460F3),
    Color borderColor = Colors.black,
    int colorAlpha = 128,
    int borderWidth = 2,
    CPDFBorderStyle borderStyle = const CPDFBorderStyle.solid(),
  }) : this(
            annotationType: CPDFAnnotationType.square,
            fillColor: fillColor,
            borderColor: borderColor,
            colorAlpha: colorAlpha,
            borderWidth: borderWidth,
            borderStyle: borderStyle);

  const CPDFAnnotAttr.circle({
    Color fillColor = const Color(0xFF1460F3),
    Color borderColor = Colors.black,
    int colorAlpha = 128,
    int borderWidth = 2,
    CPDFBorderStyle borderStyle = const CPDFBorderStyle.solid(),
  }) : this(
            annotationType: CPDFAnnotationType.circle,
            fillColor: fillColor,
            borderColor: borderColor,
            colorAlpha: colorAlpha,
            borderWidth: borderWidth,
            borderStyle: borderStyle);

  const CPDFAnnotAttr.line({
    Color borderColor = const Color(0xFF1460F3),
    int borderAlpha = 100,
    int borderWidth = 5,
    CPDFBorderStyle borderStyle = const CPDFBorderStyle.solid(),
  }) : this(
            annotationType: CPDFAnnotationType.line,
            borderColor: borderColor,
            borderAlpha: borderAlpha,
            borderWidth: borderWidth,
            borderStyle: borderStyle,
            startLineType: CPDFLineType.none,
            tailLineType: CPDFLineType.none);

  const CPDFAnnotAttr.arrow(
      {Color borderColor = const Color(0xFF1460F3),
      int borderAlpha = 100,
      int borderWidth = 5,
      CPDFBorderStyle borderStyle = const CPDFBorderStyle.solid(),
      CPDFLineType startLineType = CPDFLineType.none,
      CPDFLineType tailLineType = CPDFLineType.openArrow})
      : this(
            annotationType: CPDFAnnotationType.arrow,
            borderColor: borderColor,
            borderAlpha: borderAlpha,
            borderWidth: borderWidth,
            borderStyle: borderStyle,
            startLineType: startLineType,
            tailLineType: tailLineType);

  const CPDFAnnotAttr.freeText(
      {Color fontColor = Colors.black,
      int fontColorAlpha = 255,
      int fontSize = 30,
      bool isBold = false,
      bool isItalic = false,
      CPDFAlignment alignment = CPDFAlignment.left,
      CPDFTypeface typeface = CPDFTypeface.helvetica})
      : this(
            annotationType: CPDFAnnotationType.freetext,
            fontColor: fontColor,
            fontColorAlpha: fontColorAlpha,
            fontSize: fontSize,
            isBold: isBold,
            isItalic: isItalic,
            alignment: alignment,
            typeface: typeface);

  Map<String, dynamic> toJson() {
    switch (annotationType) {
      case CPDFAnnotationType.note:
      case CPDFAnnotationType.highlight:
      case CPDFAnnotationType.underline:
      case CPDFAnnotationType.squiggly:
      case CPDFAnnotationType.strikeout:
        return {'color': color?.toHex(), 'alpha': alpha};
      case CPDFAnnotationType.ink:
        return {
          'color': color?.toHex(),
          'alpha': alpha,
          'borderWidth': borderWidth
        };
      case CPDFAnnotationType.square:
      case CPDFAnnotationType.circle:
        return {
          'fillColor': fillColor?.toHex(),
          'borderColor': borderColor?.toHex(),
          'colorAlpha': colorAlpha,
          'borderWidth': borderWidth,
          'borderStyle': borderStyle?.toJson(),
        };
      case CPDFAnnotationType.line:
      case CPDFAnnotationType.arrow:
        return {
          'borderColor': borderColor?.toHex(),
          'borderAlpha': borderAlpha,
          'borderWidth': borderWidth,
          'borderStyle': borderStyle?.toJson(),
          'startLineType': startLineType?.name,
          'tailLineType': tailLineType?.name
        };
      case CPDFAnnotationType.freetext:
        return {
          'fontColor': fontColor?.toHex(),
          'fontColorAlpha': fontColorAlpha,
          'fontSize': fontSize,
          'isBold': isBold,
          'isItalic': isItalic,
          'alignment': alignment?.name,
          'typeface': typeface?.getFontName(),
        };
      default:
        return {};
    }
  }
}

class CPDFBorderStyle {
  final CPDFAnnotBorderStyle style;

  final double dashGap;

  const CPDFBorderStyle(
      {this.style = CPDFAnnotBorderStyle.solid, this.dashGap = 8.0});

  const CPDFBorderStyle.solid()
      : style = CPDFAnnotBorderStyle.solid,
        dashGap = 0;

  const CPDFBorderStyle.dashed({this.dashGap = 9.0})
      : style = CPDFAnnotBorderStyle.dashed;

  Map<String, dynamic> toJson() => {'style': style.name, 'dashGap': dashGap};
}

class CPDFContentEditorConfig {

  final List<CPDFContentEditorType> availableTypes;

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
  final CPDFContentEditorAttr text;

  const CPDFContentEditorAttribute({this.text = const CPDFContentEditorAttr()});

  Map<String, dynamic> toJson() => {'text': text.toJson()};
}

class CPDFContentEditorAttr {

  final Color fontColor;

  final int fontColorAlpha;

  final int fontSize;

  final bool isBold;

  final bool isItalic;

  final CPDFTypeface typeface;

  final CPDFAlignment alignment;

  const CPDFContentEditorAttr(
      {this.fontColor = Colors.black,
      this.fontColorAlpha = 255,
      this.fontSize = 30,
      this.isBold = false,
      this.isItalic = false,
      this.typeface = CPDFTypeface.helvetica,
      this.alignment = CPDFAlignment.left});

  Map<String, dynamic> toJson() => {
        'fontColor': fontColor.toHex(),
        'fontColorAlpha': fontColorAlpha,
        'fontSize': fontSize,
        'isBold': isBold,
        'isItalic': isItalic,
        'typeface': typeface.getFontName(),
        'alignment': alignment.name
      };
}

class CPDFFormsConfig {

  final List<CPDFFormType> availableTypes;

  final List<CPDFFormConfigTool> availableTools;

  final CPDFFormAttribute initAttribute;

  const CPDFFormsConfig(
      {this.availableTypes = CPDFFormType.values,
      this.availableTools = CPDFFormConfigTool.values,
      this.initAttribute = const CPDFFormAttribute()});

  Map<String, dynamic> toJson() => {
        'availableTypes': availableTypes.map((e) => e.name).toList(),
        'availableTools': availableTools.map((e) => e.name).toList(),
        'initAttribute': initAttribute.toJson()
      };
}

class CPDFFormAttribute {

  final CPDFFormAttr textField;

  final CPDFFormAttr checkBox;

  final CPDFFormAttr radioButton;

  final CPDFFormAttr listBox;

  final CPDFFormAttr comboBox;

  final CPDFFormAttr pushButton;

  final CPDFFormAttr signaturesFields;

  const CPDFFormAttribute({
    this.textField = const CPDFFormAttr.textField(),
    this.checkBox = const CPDFFormAttr.checkBox(),
    this.radioButton = const CPDFFormAttr.radioButton(),
    this.listBox = const CPDFFormAttr.listBox(),
    this.comboBox = const CPDFFormAttr.comboBox(),
    this.pushButton = const CPDFFormAttr.pushButton(),
    this.signaturesFields = const CPDFFormAttr.signaturesFields(),
  });

  Map<String, dynamic> toJson() => {
        'textField': textField.toJson(),
        'checkBox': checkBox.toJson(),
        'radioButton': radioButton.toJson(),
        'listBox': listBox.toJson(),
        'comboBox': comboBox.toJson(),
        'pushButton': pushButton.toJson(),
        'signaturesFields': signaturesFields.toJson()
      };
}

class CPDFFormAttr {
  final CPDFFormType formType;

  final Color fillColor;

  final Color borderColor;

  final int borderWidth;

  final Color fontColor;

  final int fontSize;

  final bool isBold;

  final bool isItalic;

  final CPDFAlignment alignment;

  final bool multiline;

  final CPDFTypeface typeface;

  final Color checkedColor;

  final bool isChecked;

  final CPDFCheckStyle checkedStyle;

  final String title;

  const CPDFFormAttr(
      {required this.formType,
      this.fillColor = const Color(0xFFDDE9FF),
      this.borderColor = const Color(0xFF1460F3),
      this.borderWidth = 2,
      this.fontColor = Colors.black,
      this.fontSize = 20,
      this.isBold = false,
      this.isItalic = false,
      this.alignment = CPDFAlignment.left,
      this.multiline = true,
      this.typeface = CPDFTypeface.helvetica,
      this.checkedColor = const Color(0xFF43474D),
      this.isChecked = false,
      this.checkedStyle = CPDFCheckStyle.check,
      this.title = 'Button'});

  const CPDFFormAttr.textField(
      {Color fillColor = const Color(0xFFDDE9FF),
      Color borderColor = const Color(0xFF1460F3),
      int borderWidth = 2,
      Color fontColor = Colors.black,
      int fontSize = 20,
      bool isBold = false,
      bool isItalic = false,
      CPDFAlignment alignment = CPDFAlignment.left,
      bool multiline = true,
      CPDFTypeface typeface = CPDFTypeface.helvetica})
      : this(
            formType: CPDFFormType.textField,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            fontColor: fontColor,
            fontSize: fontSize,
            isBold: isBold,
            isItalic: isItalic,
            alignment: alignment,
            multiline: multiline,
            typeface: typeface);

  const CPDFFormAttr.checkBox(
      {Color fillColor = const Color(0xFFDDE9FF),
      Color borderColor = const Color(0xFF1460F3),
      int borderWidth = 2,
      Color checkedColor = const Color(0xFF43474D),
      bool isChecked = false,
      CPDFCheckStyle checkStyle = CPDFCheckStyle.check})
      : this(
            formType: CPDFFormType.checkBox,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            checkedColor: checkedColor,
            isChecked: isChecked,
            checkedStyle: checkStyle);

  const CPDFFormAttr.radioButton(
      {Color fillColor = const Color(0xFFDDE9FF),
      Color borderColor = const Color(0xFF1460F3),
      int borderWidth = 2,
      Color checkedColor = const Color(0xFF43474D),
      bool isChecked = false,
      CPDFCheckStyle checkStyle = CPDFCheckStyle.check})
      : this(
            formType: CPDFFormType.radioButton,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            checkedColor: checkedColor,
            isChecked: isChecked,
            checkedStyle: checkStyle);

  const CPDFFormAttr.listBox({
    Color fillColor = const Color(0xFFDDE9FF),
    Color borderColor = const Color(0xFF1460F3),
    int borderWidth = 2,
    Color fontColor = Colors.black,
    int fontSize = 20,
    CPDFTypeface typeface = CPDFTypeface.helvetica,
    bool isBold = false,
    bool isItalic = false,
  }) : this(
            formType: CPDFFormType.listBox,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            fontColor: fontColor,
            fontSize: fontSize,
            typeface: typeface,
            isBold: isBold,
            isItalic: isItalic);

  const CPDFFormAttr.comboBox({
    Color fillColor = const Color(0xFFDDE9FF),
    Color borderColor = const Color(0xFF1460F3),
    int borderWidth = 2,
    Color fontColor = Colors.black,
    int fontSize = 20,
    CPDFTypeface typeface = CPDFTypeface.helvetica,
    bool isBold = false,
    bool isItalic = false,
  }) : this(
            formType: CPDFFormType.comboBox,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            fontColor: fontColor,
            fontSize: fontSize,
            typeface: typeface,
            isBold: isBold,
            isItalic: isItalic);

  const CPDFFormAttr.pushButton({
    String title = 'Button',
    Color fillColor = const Color(0xFFDDE9FF),
    Color borderColor = const Color(0xFF1460F3),
    int borderWidth = 2,
    Color fontColor = Colors.black,
    int fontSize = 20,
    CPDFTypeface typeface = CPDFTypeface.helvetica,
    bool isBold = false,
    bool isItalic = false,
  }) : this(
            formType: CPDFFormType.pushButton,
            title: title,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            fontColor: fontColor,
            fontSize: fontSize,
            typeface: typeface,
            isBold: isBold,
            isItalic: isItalic);

  const CPDFFormAttr.signaturesFields(
      {Color fillColor = const Color(0xFFDDE9FF),
      Color borderColor = const Color(0xFF1460F3),
      int borderWidth = 2})
      : this(
            formType: CPDFFormType.signaturesFields,
            fillColor: fillColor,
            borderColor: borderColor,
            borderWidth: borderWidth);

  Map<String, dynamic> toJson() {
    switch (formType) {
      case CPDFFormType.textField:
        return {
          'fillColor': fillColor.toHex(),
          'borderColor': borderColor.toHex(),
          'borderWidth': borderWidth,
          'fontColor': fontColor.toHex(),
          'fontSize': fontSize,
          'isBold': isBold,
          'isItalic': isItalic,
          'alignment': alignment.name,
          'multiline': multiline,
          'typeface': typeface.getFontName()
        };
      case CPDFFormType.checkBox:
      case CPDFFormType.radioButton:
        return {
          'fillColor': fillColor.toHex(),
          'borderColor': borderColor.toHex(),
          'borderWidth': borderWidth,
          'checkedColor': checkedColor.toHex(),
          'isChecked': false,
          'checkedStyle': checkedStyle.name
        };
      case CPDFFormType.listBox:
      case CPDFFormType.comboBox:
        return {
          'fillColor': fillColor.toHex(),
          'borderColor': borderColor.toHex(),
          'borderWidth': borderWidth,
          'fontColor': fontColor.toHex(),
          'fontSize': fontSize,
          'typeface': typeface.getFontName(),
          'isBold': isBold,
          'isItalic': isItalic,
        };
      case CPDFFormType.pushButton:
        return {
          'fillColor': fillColor.toHex(),
          'borderColor': borderColor.toHex(),
          'borderWidth': borderWidth,
          'fontColor': fontColor.toHex(),
          'fontSize': fontSize,
          'typeface': typeface.getFontName(),
          'isBold': isBold,
          'isItalic': isItalic,
          'title': title
        };
      case CPDFFormType.signaturesFields:
        return {
          'fillColor': fillColor.toHex(),
          'borderColor': borderColor.toHex(),
          'borderWidth': borderWidth,
        };
      default:
        return {};
    }
  }
}
