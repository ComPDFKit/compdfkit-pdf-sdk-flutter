package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.BorderStyle;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;


public class FlutterCPDFRadioButtonWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFRadiobuttonWidget radiobuttonWidget = (CPDFRadiobuttonWidget) widget;
    map.put("type", "radioButton");
    map.put("isChecked", radiobuttonWidget.isChecked());
    map.put("checkStyle", CPDFEnumConvertUtil.checkStyleToString(radiobuttonWidget.getCheckStyle()));
    map.put("checkColor", CAppUtils.toHexColor(radiobuttonWidget.getColor()));
  }

  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateWidget(annotation, annotMap);
    CPDFRadiobuttonWidget radiobuttonWidget = (CPDFRadiobuttonWidget) annotation;

    boolean isChecked = (boolean) annotMap.get("isChecked");
    String checkStyle = annotMap.get("checkStyle").toString();
    String checkColor = annotMap.get("checkColor").toString();

    radiobuttonWidget.setChecked(isChecked);
    radiobuttonWidget.setCheckStyle(CPDFEnumConvertUtil.stringToCheckStyle(checkStyle));
    radiobuttonWidget.setColor(Color.parseColor(checkColor));
  }

  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {
    int pageIndex = (int) widgetMap.get("page");
    HashMap<String, Object> rectMap = (HashMap<String, Object>) widgetMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");
    String title = widgetMap.get("title").toString();

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFRadiobuttonWidget widget = (CPDFRadiobuttonWidget) page.addFormWidget(
        WidgetType.Widget_RadioButton);
    if (widget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);

      widget.setRect(rectF);
      widget.setBorderStyles(BorderStyle.BS_Solid);

      if (TextUtils.isEmpty(title)){
        widget.setFieldName(CAppUtils.getDefaultFiledName("Radio Button_"));
      } else {
        widget.setFieldName(title);
      }
      if (widgetMap.get("createDate") != null){
        long createDateTimestamp = (long) widgetMap.get("createDate");
        widget.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        widget.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        widget.setCreationDate(TTimeUtil.getCurrentDate());
        widget.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }

      updateWidget(widget, widgetMap);
      widget.updateAp();
    }
    return widget;
  }
}
