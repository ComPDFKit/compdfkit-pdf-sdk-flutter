package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFFreetextAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.annotation.form.CPDFTextWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.BorderStyle;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;
import java.util.Objects;


public class FlutterCPDFTextFieldWidget extends FlutterCPDFBaseWidget {


  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFTextWidget textWidget = (CPDFTextWidget) widget;
    map.put("type", "textField");
    map.put("title", textWidget.getFieldName());
    map.put("text", textWidget.getText());
    map.put("isMultiline", textWidget.isMultiLine());
    map.put("fontColor", CAppUtils.toHexColor(textWidget.getFontColor()));
    map.put("fontSize", textWidget.getFontSize());
    map.put("alignment", CPDFEnumConvertUtil.textAlignmentToString(textWidget.getTextAlignment()));

    String psName = textWidget.getFontName();
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(psName);

    map.put("familyName", names[0]);
    map.put("styleName", names[1]);
  }

  public void setText(CPDFAnnotation annotation, String text) {
    CPDFTextWidget textWidget = (CPDFTextWidget) annotation;
    textWidget.setText(text);
  }


  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateWidget(annotation, annotMap);
    if (!annotation.isValid()){
        return;
    }
    CPDFTextWidget textWidget = (CPDFTextWidget) annotation;

    String text = annotMap.get("text").toString();
    String fontColor = annotMap.get("fontColor").toString();
    double fontSize = (double) annotMap.get("fontSize");
    String alignment = annotMap.get("alignment").toString();
    boolean isMultiline = (boolean) annotMap.get("isMultiline");
    String familyName = annotMap.get("familyName").toString();
    String styleName = annotMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    textWidget.setText(text);
    textWidget.setFontColor(Color.parseColor(fontColor));
    textWidget.setFontSize((float) fontSize);

    textWidget.setTextAlignment(CPDFEnumConvertUtil.stringToTextAlignment(alignment));
    textWidget.setMultiLine(isMultiline);
    textWidget.setFontName(psName);
  }

  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {
    int pageIndex = (int) widgetMap.get("page");
    String title = widgetMap.get("title").toString();
    HashMap<String, Object> rectMap = (HashMap<String, Object>) widgetMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFTextWidget textWidget = (CPDFTextWidget) page.addFormWidget(
        WidgetType.Widget_TextField);
    if (textWidget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      textWidget.setRect(rectF);
      if (TextUtils.isEmpty(title)){
        textWidget.setFieldName(CAppUtils.getDefaultFiledName("Text Field_"));
      } else {
        textWidget.setFieldName(title);
      }
      if (widgetMap.get("createDate") != null){
        long createDateTimestamp = (long) widgetMap.get("createDate");
        textWidget.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        textWidget.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        textWidget.setCreationDate(TTimeUtil.getCurrentDate());
        textWidget.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }
      textWidget.setTextFieldSpecial(false);
      textWidget.setBorderStyles(BorderStyle.BS_Solid);
      updateWidget(textWidget, widgetMap);
      textWidget.updateAp();
    }
    return textWidget;
  }
}
