/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.graphics.Color;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFLineAnnotation.LineType;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.tools.common.pdf.config.annot.AnnotShapeAttr.AnnotLineType;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CAnnotStyle;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CAnnotStyle.Alignment;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CStyleType;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.manager.CStyleManager;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.manager.provider.CGlobalStyleProvider;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.attribute.CPDFAnnotAttribute;
import com.compdfkit.ui.attribute.CPDFCircleAttr;
import com.compdfkit.ui.attribute.CPDFFreetextAttr;
import com.compdfkit.ui.attribute.CPDFHighlightAttr;
import com.compdfkit.ui.attribute.CPDFInkAttr;
import com.compdfkit.ui.attribute.CPDFLineAttr;
import com.compdfkit.ui.attribute.CPDFReaderAttribute;
import com.compdfkit.ui.attribute.CPDFSquareAttr;
import com.compdfkit.ui.attribute.CPDFSquigglyAttr;
import com.compdfkit.ui.attribute.CPDFStrikeoutAttr;
import com.compdfkit.ui.attribute.CPDFTextAttr;
import com.compdfkit.ui.attribute.CPDFUnderlineAttr;
import com.compdfkit.ui.attribute.form.CPDFCheckboxAttr;
import com.compdfkit.ui.attribute.form.CPDFComboboxAttr;
import com.compdfkit.ui.attribute.form.CPDFListboxAttr;
import com.compdfkit.ui.attribute.form.CPDFPushButtonAttr;
import com.compdfkit.ui.attribute.form.CPDFRadiobuttonAttr;
import com.compdfkit.ui.attribute.form.CPDFSignatureWidgetAttr;
import com.compdfkit.ui.attribute.form.CPDFTextfieldAttr;
import com.compdfkit.ui.reader.CPDFReaderView;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class CPDFAttrUtils {

  public static HashMap<String, Object> getDefaultAnnotAttr(CPDFViewCtrl pdfView) {
    HashMap<String, Object> annotAttr = new HashMap<>();
    CPDFReaderView readerView = pdfView.getCPdfReaderView();
    CPDFReaderAttribute readerAttribute = readerView.getReaderAttribute();
    CPDFAnnotAttribute annotAttribute = readerAttribute.getAnnotAttribute();
    annotAttr.put("noteAttr", getNoteAttr(annotAttribute.getTextAttr()));
    annotAttr.put("highlightAttr", getHighlightAttr(annotAttribute.getHighlightAttr()));
    annotAttr.put("strikeoutAttr", getStrikeoutAttr(annotAttribute.getStrikeoutAttr()));
    annotAttr.put("underlineAttr", getUnderlineAttr(annotAttribute.getUnderlineAttr()));
    annotAttr.put("squigglyAttr", getSquigglyAttr(annotAttribute.getSquigglyAttr()));
    annotAttr.put("inkAttr", getInkAttr(annotAttribute.getInkAttr()));
    annotAttr.put("squareAttr", getSquareAttr(annotAttribute.getSquareAttr()));
    annotAttr.put("circleAttr", getCircleAttr(annotAttribute.getCircleAttr()));
    annotAttr.put("lineAttr", getLineAttr(annotAttribute.getLineAttr()));
    annotAttr.put("arrowAttr", getArrowAttr(pdfView));
    annotAttr.put("freetextAttr", getFreetextAttr(annotAttribute.getFreetextAttr()));
    return annotAttr;
  }

  private static Map<String, Object> getNoteAttr(CPDFTextAttr textAttr) {
    Map<String, Object> noteAttr = new HashMap<>();
    noteAttr.put("color", CAppUtils.toHexColor(textAttr.getColor()));
    noteAttr.put("alpha", (double) textAttr.getAlpha());
    return noteAttr;
  }

  private static Map<String, Object> getHighlightAttr(CPDFHighlightAttr highlightAttr) {
    Map<String, Object> markupAttr = new HashMap<>();
    // Add other markup attributes as needed
    markupAttr.put("color", CAppUtils.toHexColor(highlightAttr.getColor()));
    markupAttr.put("alpha", (double) highlightAttr.getAlpha());
    return markupAttr;
  }

  private static Map<String, Object> getStrikeoutAttr(CPDFStrikeoutAttr strikeoutAttr) {
    Map<String, Object> strikeoutAttrMap = new HashMap<>();
    // Add other strikeout attributes as needed
    strikeoutAttrMap.put("color", CAppUtils.toHexColor(strikeoutAttr.getColor()));
    strikeoutAttrMap.put("alpha", (double) strikeoutAttr.getAlpha());
    return strikeoutAttrMap;
  }

  private static Map<String, Object> getUnderlineAttr(CPDFUnderlineAttr underlineAttr) {
    Map<String, Object> underlineMap = new HashMap<>();
    // Add other text attributes as needed
    underlineMap.put("color", CAppUtils.toHexColor(underlineAttr.getColor()));
    underlineMap.put("alpha", (double) underlineAttr.getAlpha());
    return underlineMap;
  }

  private static Map<String, Object> getSquigglyAttr(CPDFSquigglyAttr squigglyAttr) {
    Map<String, Object> squigglyMap = new HashMap<>();
    // Add other squiggly attributes as needed
    squigglyMap.put("color", CAppUtils.toHexColor(squigglyAttr.getColor()));
    squigglyMap.put("alpha", (double) squigglyAttr.getAlpha());
    return squigglyMap;
  }

  private static Map<String, Object> getInkAttr(CPDFInkAttr inkAttr) {
    Map<String, Object> inkMap = new HashMap<>();
    // Add other ink attributes as needed
    inkMap.put("color", CAppUtils.toHexColor(inkAttr.getColor()));
    inkMap.put("alpha", (double) inkAttr.getAlpha());
    inkMap.put("borderWidth", inkAttr.getBorderWidth());
    return inkMap;
  }

  private static Map<String, Object> getSquareAttr(CPDFSquareAttr squareAttr) {
    Map<String, Object> squareMap = new HashMap<>();
    squareMap.put("fillColor", CAppUtils.toHexColor(squareAttr.getFillColor()));
    squareMap.put("borderColor", CAppUtils.toHexColor(squareAttr.getBorderColor()));
    squareMap.put("colorAlpha", (double) squareAttr.getFillAlpha());
    squareMap.put("borderWidth", squareAttr.getBorderWidth());
    squareMap.put("borderStyle", getBorderStyleAttr(squareAttr.getBorderStyle()));
    return squareMap;
  }

  private static Map<String, Object> getCircleAttr(CPDFCircleAttr circleAttr) {
    Map<String, Object> circleAttrMap = new HashMap<>();
    circleAttrMap.put("fillColor", CAppUtils.toHexColor(circleAttr.getFillColor()));
    circleAttrMap.put("borderColor", CAppUtils.toHexColor(circleAttr.getBorderColor()));
    circleAttrMap.put("colorAlpha", (double) circleAttr.getFillAlpha());
    circleAttrMap.put("borderWidth", circleAttr.getBorderWidth());
    circleAttrMap.put("borderStyle", getBorderStyleAttr(circleAttr.getBorderStyle()));
    return circleAttrMap;
  }

  private static Map<String, Object> getLineAttr(CPDFLineAttr lineAttr) {
    Map<String, Object> lineAttrMap = new HashMap<>();
    lineAttrMap.put("fillColor", CAppUtils.toHexColor(lineAttr.getFillColor()));
    lineAttrMap.put("borderColor", CAppUtils.toHexColor(lineAttr.getBorderColor()));
    lineAttrMap.put("borderAlpha", (double) lineAttr.getBorderAlpha());
    lineAttrMap.put("borderWidth", lineAttr.getBorderWidth());
    lineAttrMap.put("borderStyle", getBorderStyleAttr(lineAttr.getBorderStyle()));
    return lineAttrMap;
  }

  private static Map<String, Object> getArrowAttr(CPDFViewCtrl pdfView) {
    Map<String, Object> arrowAttrMap = new HashMap<>();
    CGlobalStyleProvider globalStyleProvider = new CGlobalStyleProvider(pdfView, false);
    CAnnotStyle annotStyle = globalStyleProvider.getStyle(CStyleType.ANNOT_ARROW);
    if (annotStyle != null) {
      arrowAttrMap.put("fillColor", CAppUtils.toHexColor(annotStyle.getFillColor()));
      arrowAttrMap.put("borderColor", CAppUtils.toHexColor(annotStyle.getLineColor()));
      arrowAttrMap.put("borderAlpha", (double) annotStyle.getLineColorOpacity());
      arrowAttrMap.put("borderWidth", annotStyle.getBorderWidth());
      arrowAttrMap.put("borderStyle", getBorderStyleAttr(annotStyle.getBorderStyle()));
      arrowAttrMap.put("startLineType", CPDFEnumConvertUtil.lineTypeToString(annotStyle.getStartLineType()));
      arrowAttrMap.put("tailLineType", CPDFEnumConvertUtil.lineTypeToString(annotStyle.getTailLineType()));
    }
    return arrowAttrMap;
  }

  private static Map<String, Object> getFreetextAttr(CPDFFreetextAttr freetextAttr) {
    Map<String, Object> freetextMap = new HashMap<>();
    CPDFTextAttribute textAttribute = freetextAttr.getTextAttribute();
    freetextMap.put("fontColor", CAppUtils.toHexColor(textAttribute.getColor()));
    freetextMap.put("fontSize", textAttribute.getFontSize());
    freetextMap.put("fontColorAlpha", (double) freetextAttr.getAlpha());
    String psName = textAttribute.getFontName();
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(psName);

    freetextMap.put("familyName", names[0]);
    freetextMap.put("styleName", names[1]);

    freetextMap.put("alignment", CPDFEnumConvertUtil.freeTextAlignmentToString(freetextAttr.getAlignment()));
    return freetextMap;
  }

  private static Map<String, Object> getBorderStyleAttr(CPDFBorderStyle borderStyle) {
    Map<String, Object> borderStyleMap = new HashMap<>();
    borderStyleMap.put("width", borderStyle.getBorderWidth());
    if (Objects.requireNonNull(borderStyle.getStyle()) == Style.Border_Dashed) {
      borderStyleMap.put("style", "dashed");
    } else {
      borderStyleMap.put("style", "solid");
    }
    if (borderStyle.getDashArr() != null && borderStyle.getDashArr().length > 1) {
      borderStyleMap.put("dashGap", borderStyle.getDashArr()[1]);
    }
    return borderStyleMap;
  }

  public static void setDefaultAnnotAttr(CPDFViewCtrl pdfView, String type, Map<String, Object> attrMap) {
    switch (type) {
      case "note":
        setNoteAttr(pdfView, attrMap);
        break;
      case "highlight":
        setMarkupAttr(pdfView, CStyleType.ANNOT_HIGHLIGHT, attrMap);
        break;
      case "underline":
        setMarkupAttr(pdfView, CStyleType.ANNOT_UNDERLINE, attrMap);
        break;
      case "strikeout":
        setMarkupAttr(pdfView, CStyleType.ANNOT_STRIKEOUT, attrMap);
        break;
      case "squiggly":
        setMarkupAttr(pdfView, CStyleType.ANNOT_SQUIGGLY, attrMap);
        break;
      case "ink":
        setInkAttr(pdfView, attrMap);
        break;
      case "circle":
        setShapeAttr(pdfView, CStyleType.ANNOT_CIRCLE, attrMap);
        break;
      case "square":
        setShapeAttr(pdfView, CStyleType.ANNOT_SQUARE, attrMap);
        break;
      case "line":
        setShapeAttr(pdfView, CStyleType.ANNOT_LINE, attrMap);
        break;
      case "arrow":
        setArrowAttr(pdfView, attrMap);
        break;
      case "freetext":
        setFreetextAttr(pdfView, attrMap);
        break;
      case "textField":
        setTextFieldAttr(pdfView, attrMap);
        break;
      case "checkBox":
        setCheckBoxAttr(pdfView, attrMap);
        break;
      case "radioButton":
        setRadioButtonAttr(pdfView, attrMap);
        break;
      case "comboBox":
        setComboBoxAttr(pdfView, attrMap);
        break;
      case "listBox":
        setListBoxAttr(pdfView, attrMap);
        break;
      case "signaturesFields":
        setFormSignAttr(pdfView, attrMap);
        break;
      case "pushButton":
        setPushButtonAttr(pdfView, attrMap);
        break;
      default:
        break;
    }
  }

  private static void setNoteAttr(CPDFViewCtrl pdfView, Map<String, Object> noteAttrMap) {
    String color = (String) noteAttrMap.get("color");
    double alpha = (double) noteAttrMap.get("alpha");
    new CStyleManager.Builder()
        .setNote(Color.parseColor(color), (int) alpha)
        .onStore(pdfView, true);
  }

  private static void setMarkupAttr(CPDFViewCtrl pdfView, CStyleType type, Map<String, Object> attrMap) {
    String color = (String) attrMap.get("color");
    double alpha = (double) attrMap.get("alpha");
    new CStyleManager.Builder()
        .setMarkup(type, Color.parseColor(color), (int) alpha)
        .onStore(pdfView, true);
  }

  private static void setInkAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String color = (String) attrMap.get("color");
    double alpha = (double) attrMap.get("alpha");
    double borderWidth = (double) attrMap.get("borderWidth");
    new CStyleManager.Builder()
        .setInkAttribute(Color.parseColor(color), (int) alpha, (int) borderWidth, (int) borderWidth)
        .onStore(pdfView, true);
  }

  private static void setShapeAttr(CPDFViewCtrl pdfView, CStyleType styleType, Map<String, Object> attrMap) {
    CStyleManager manager = new CStyleManager(new CGlobalStyleProvider(pdfView.getCPdfReaderView(), true));
    CAnnotStyle style = manager.getStyle(styleType);
    if (attrMap.get("fillColor") != null) {
      style.setFillColor(Color.parseColor((String) attrMap.get("fillColor")));
    }
    if (attrMap.get("borderColor") != null) {
      style.setBorderColor(Color.parseColor((String) attrMap.get("borderColor")));
    }
    if (attrMap.get("colorAlpha") != null) {
      double colorAlpha = (double) attrMap.get("colorAlpha");
      style.setFillColorOpacity((int) colorAlpha);
      style.setLineColorOpacity((int) colorAlpha);
    }
    if (attrMap.get("borderAlpha") != null) {
      // line shape
      double colorAlpha = (double) attrMap.get("borderAlpha");
      style.setFillColorOpacity((int) colorAlpha);
      style.setLineColorOpacity((int) colorAlpha);
    }
    if (attrMap.get("borderWidth") != null) {
      double borderWidth = (double) attrMap.get("borderWidth");
      style.setBorderWidth((float) borderWidth);
    }
    if (attrMap.get("borderStyle") != null) {
      Map<String, Object> borderStyle = (Map<String, Object>) attrMap.get("borderStyle");
      if (borderStyle.get("style") != null && borderStyle.get("dashGap") != null) {
        String styleStr = (String) borderStyle.get("style");
        double dashGap = (double) borderStyle.get("dashGap");
        Style borderStyleEnum = styleStr.equals("solid") ? Style.Border_Solid : Style.Border_Dashed;
        style.setBorderStyle(
            new CPDFBorderStyle(borderStyleEnum, style.getBorderWidth(), new float[] { 8.0F, (float) dashGap }));
      }
    }
    if (attrMap.get("startLineType") != null) {
      String startLineTypeStr = (String) attrMap.get("startLineType");
      style.setStartLineType(CPDFEnumConvertUtil.stringToLineType(startLineTypeStr));
    }
    if (attrMap.get("tailLineType") != null) {
      String tailLineTypeStr = (String) attrMap.get("tailLineType");
      style.setTailLineType(CPDFEnumConvertUtil.stringToLineType(tailLineTypeStr));
    }
    manager.updateStyle(style);
  }

  private static void setArrowAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    CStyleManager manager = new CStyleManager(new CGlobalStyleProvider(pdfView.getCPdfReaderView(), true));
    CAnnotStyle arrowAttr = manager.getStyle(CStyleType.ANNOT_ARROW);

    if (attrMap.get("borderColor") != null) {
      arrowAttr.setBorderColor(Color.parseColor((String) attrMap.get("borderColor")));
      arrowAttr.setFillColor(Color.parseColor((String) attrMap.get("borderColor")));
    }
    if (attrMap.get("borderAlpha") != null) {
      double borderAlpha = (double) attrMap.get("borderAlpha");
      arrowAttr.setFillColorOpacity((int) borderAlpha);
      arrowAttr.setLineColorOpacity((int) borderAlpha);
    }
    if (attrMap.get("borderWidth") != null) {
      double borderWidth = (double) attrMap.get("borderWidth");
      arrowAttr.setBorderWidth((float) borderWidth);
    }
    if (attrMap.get("borderStyle") != null) {
      Map<String, Object> borderStyle = (Map<String, Object>) attrMap.get("borderStyle");
      if (borderStyle.get("style") != null && borderStyle.get("dashGap") != null) {
        String styleStr = (String) borderStyle.get("style");
        double dashGap = (double) borderStyle.get("dashGap");
        Style style = styleStr.equals("solid") ? Style.Border_Solid : Style.Border_Dashed;
        arrowAttr.setBorderStyle(
            new CPDFBorderStyle(style, arrowAttr.getBorderWidth(), new float[] { 8.0F, (float) dashGap }));
      }
    }
    if (attrMap.get("startLineType") != null) {
      String startLineTypeStr = (String) attrMap.get("startLineType");
      arrowAttr.setStartLineType(CPDFEnumConvertUtil.stringToLineType(startLineTypeStr));
    }
    if (attrMap.get("tailLineType") != null) {
      String tailLineTypeStr = (String) attrMap.get("tailLineType");
      arrowAttr.setTailLineType(CPDFEnumConvertUtil.stringToLineType(tailLineTypeStr));
    }
    manager.updateStyle(arrowAttr);
  }

  private static void setFreetextAttr(CPDFViewCtrl pdfView, Map<String, Object> freetextAttrMap) {
    String fontColor = (String) freetextAttrMap.get("fontColor");
    double fontSize = (double) freetextAttrMap.get("fontSize");
    double fontColorAlpha = (double) freetextAttrMap.get("fontColorAlpha");
    String familyName = (String) freetextAttrMap.get("familyName");
    String styleName = (String) freetextAttrMap.get("styleName");
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);
    String alignment = (String) freetextAttrMap.get("alignment");

    CAnnotStyle style = new CAnnotStyle(CStyleType.ANNOT_FREETEXT);
    style.setFontColor(Color.parseColor(fontColor));
    style.setTextColorOpacity((int) fontColorAlpha);
    style.setFontSize((int) fontSize);
    style.setExternFontName(psName);
    style.setAlignment(Alignment.valueOf(alignment.toUpperCase()));

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setTextFieldAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String fontColor = (String) attrMap.get("fontColor");
    double fontSize = (double) attrMap.get("fontSize");
    String familyName = (String) attrMap.get("familyName");
    String styleName = (String) attrMap.get("styleName");
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);
    String alignment = (String) attrMap.get("alignment");
    boolean multiline = (boolean) attrMap.get("multiline");

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_TEXT_FIELD);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setFontColor(Color.parseColor(fontColor));
    style.setFontSize((int) fontSize);
    style.setExternFontName(psName);
    style.setFormMultiLine(multiline);

    style.setAlignment(Alignment.valueOf(alignment.toUpperCase()));
    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setCheckBoxAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String checkedColor = (String) attrMap.get("checkedColor");
    boolean isChecked = (boolean) attrMap.get("isChecked");
    String checkedStyle = (String) attrMap.get("checkedStyle");

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_CHECK_BOX);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setColor(Color.parseColor(checkedColor));
    style.setChecked(isChecked);
    style.setCheckStyle(CPDFEnumConvertUtil.stringToCheckStyle(checkedStyle));

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setRadioButtonAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String checkedColor = (String) attrMap.get("checkedColor");
    boolean isChecked = (boolean) attrMap.get("isChecked");
    String checkedStyle = (String) attrMap.get("checkedStyle");

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_RADIO_BUTTON);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setColor(Color.parseColor(checkedColor));
    style.setChecked(isChecked);
    style.setCheckStyle(CPDFEnumConvertUtil.stringToCheckStyle(checkedStyle));

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setListBoxAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String fontColor = (String) attrMap.get("fontColor");
    double fontSize = (double) attrMap.get("fontSize");
    String familyName = (String) attrMap.get("familyName");
    String styleName = (String) attrMap.get("styleName");
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_LIST_BOX);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setFontColor(Color.parseColor(fontColor));
    style.setFontSize((int) fontSize);
    style.setExternFontName(psName);

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setComboBoxAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String fontColor = (String) attrMap.get("fontColor");
    double fontSize = (double) attrMap.get("fontSize");
    String familyName = (String) attrMap.get("familyName");
    String styleName = (String) attrMap.get("styleName");
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_COMBO_BOX);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setFontColor(Color.parseColor(fontColor));
    style.setFontSize((int) fontSize);
    style.setExternFontName(psName);

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setFormSignAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_SIGNATURE_FIELDS);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  private static void setPushButtonAttr(CPDFViewCtrl pdfView, Map<String, Object> attrMap) {
    String fillColor = (String) attrMap.get("fillColor");
    String borderColor = (String) attrMap.get("borderColor");
    double borderWidth = (double) attrMap.get("borderWidth");
    String fontColor = (String) attrMap.get("fontColor");
    double fontSize = (double) attrMap.get("fontSize");
    String familyName = (String) attrMap.get("familyName");
    String styleName = (String) attrMap.get("styleName");
    String title = (String) attrMap.get("title");
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    CAnnotStyle style = new CAnnotStyle(CStyleType.FORM_PUSH_BUTTON);
    style.setFillColor(Color.parseColor(fillColor));
    style.setBorderColor(Color.parseColor(borderColor));
    style.setBorderWidth((float) borderWidth);
    style.setFontColor(Color.parseColor(fontColor));
    style.setFontSize((int) fontSize);
    style.setExternFontName(psName);
    style.setFormDefaultValue(title);

    new CStyleManager.Builder()
        .setAnnotStyle(style)
        .onStore(pdfView, true);
  }

  public static HashMap<String, Object> getDefaultWidgetAttr(CPDFViewCtrl pdfView) {
    HashMap<String, Object> widgetAttr = new HashMap<>();
    CPDFReaderView readerView = pdfView.getCPdfReaderView();
    CPDFReaderAttribute readerAttribute = readerView.getReaderAttribute();
    CPDFAnnotAttribute annotAttribute = readerAttribute.getAnnotAttribute();
    widgetAttr.put("textFieldAttr", getTextFieldAttr(annotAttribute.getTextfieldAttr()));
    widgetAttr.put("checkBoxAttr", getCheckBoxAttr(annotAttribute.getCheckboxAttr()));
    widgetAttr.put("radioButtonAttr", getRadioButtonAttr(annotAttribute.getRadiobuttonAttr()));
    widgetAttr.put("listBoxAttr", getListBoxAttr(annotAttribute.getListboxAttr()));
    widgetAttr.put("comboBoxAttr", getComboBoxAttr(annotAttribute.getComboboxAttr()));
    widgetAttr.put("pushButtonAttr", getPushButtonAttr(annotAttribute.getPushButtonAttr()));
    widgetAttr.put("signaturesFieldsAttr", getSignatureWidgetAttr(annotAttribute.getSignatureWidgetAttr()));
    return widgetAttr;
  }

  private static Map<String, Object> getTextFieldAttr(CPDFTextfieldAttr textFieldAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(textFieldAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(textFieldAttr.getBorderColor()));
    map.put("borderWidth", textFieldAttr.getBorderWidth());
    map.put("fontColor", CAppUtils.toHexColor(textFieldAttr.getFontColor()));
    map.put("fontSize", textFieldAttr.getFontSize());
    switch (textFieldAttr.getTextAlignment()) {
      case ALIGNMENT_CENTER:
        map.put("alignment", "center");
        break;
      case ALIGNMENT_RIGHT:
        map.put("alignment", "right");
        break;
      default:
        map.put("alignment", "left");
        break;
    }
    map.put("multiline", textFieldAttr.isMultiline());
    String[] font = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(textFieldAttr.getFontName());
    map.put("familyName", font[0]);
    map.put("styleName", font[1]);
    return map;
  }

  private static Map<String, Object> getCheckBoxAttr(CPDFCheckboxAttr checkboxAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(checkboxAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(checkboxAttr.getBorderColor()));
    map.put("borderWidth", checkboxAttr.getBorderWidth());
    map.put("checkedColor", CAppUtils.toHexColor(checkboxAttr.getColor()));
    map.put("isChecked", checkboxAttr.isChecked());
    map.put("checkedStyle", checkboxAttr.getCheckStyle().name().replaceAll("CK_", "").toLowerCase());
    return map;
  }

  private static Map<String, Object> getRadioButtonAttr(CPDFRadiobuttonAttr radiobuttonAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(radiobuttonAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(radiobuttonAttr.getBorderColor()));
    map.put("borderWidth", radiobuttonAttr.getBorderWidth());
    map.put("checkedColor", CAppUtils.toHexColor(radiobuttonAttr.getColor()));
    map.put("isChecked", radiobuttonAttr.isChecked());
    map.put("checkedStyle", radiobuttonAttr.getCheckStyle().name().replaceAll("CK_", "").toLowerCase());
    return map;
  }

  private static Map<String, Object> getListBoxAttr(CPDFListboxAttr listBoxAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(listBoxAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(listBoxAttr.getBorderColor()));
    map.put("borderWidth", listBoxAttr.getBorderWidth());
    map.put("fontColor", CAppUtils.toHexColor(listBoxAttr.getFontColor()));
    map.put("fontSize", listBoxAttr.getFontSize());
    String[] font = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(listBoxAttr.getFontName());
    map.put("familyName", font[0]);
    map.put("styleName", font[1]);
    return map;
  }

  private static Map<String, Object> getComboBoxAttr(CPDFComboboxAttr comboBoxAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(comboBoxAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(comboBoxAttr.getBorderColor()));
    map.put("borderWidth", comboBoxAttr.getBorderWidth());
    map.put("fontColor", CAppUtils.toHexColor(comboBoxAttr.getFontColor()));
    map.put("fontSize", comboBoxAttr.getFontSize());
    String[] font = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(comboBoxAttr.getFontName());
    map.put("familyName", font[0]);
    map.put("styleName", font[1]);
    return map;
  }

  private static Map<String, Object> getPushButtonAttr(CPDFPushButtonAttr pushButtonAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("title", pushButtonAttr.getButtonTitle());
    map.put("fillColor", CAppUtils.toHexColor(pushButtonAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(pushButtonAttr.getBorderColor()));
    map.put("borderWidth", pushButtonAttr.getBorderWidth());
    map.put("fontColor", CAppUtils.toHexColor(pushButtonAttr.getFontColor()));
    map.put("fontSize", pushButtonAttr.getFontSize());
    String[] font = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(pushButtonAttr.getFontName());
    map.put("familyName", font[0]);
    map.put("styleName", font[1]);
    return map;
  }

  private static Map<String, Object> getSignatureWidgetAttr(CPDFSignatureWidgetAttr signatureWidgetAttr) {
    Map<String, Object> map = new HashMap<>();
    map.put("fillColor", CAppUtils.toHexColor(signatureWidgetAttr.getFillColor()));
    map.put("borderColor", CAppUtils.toHexColor(signatureWidgetAttr.getBorderColor()));
    map.put("borderWidth", signatureWidgetAttr.getBorderWidth());
    return map;
  }

}
