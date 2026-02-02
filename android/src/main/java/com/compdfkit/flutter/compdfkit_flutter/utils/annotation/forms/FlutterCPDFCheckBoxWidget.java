package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget.CheckboxStyle;
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


public class FlutterCPDFCheckBoxWidget extends FlutterCPDFBaseWidget {

    @Override
    public void covert(CPDFWidget widget, HashMap<String, Object> map) {
        CPDFCheckboxWidget checkboxWidget = (CPDFCheckboxWidget) widget;
        map.put("type", "checkBox");
        map.put("isChecked", checkboxWidget.isChecked());
        map.put("checkStyle", CPDFEnumConvertUtil.checkStyleToString(checkboxWidget.getCheckStyle()));
        map.put("checkColor", CAppUtils.toHexColor(checkboxWidget.getColor()));
    }

    @Override
    public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
        super.updateWidget(annotation, annotMap);
        CPDFCheckboxWidget checkboxWidget = (CPDFCheckboxWidget) annotation;

        boolean isChecked = (boolean) annotMap.get("isChecked");
        String checkStyle = annotMap.get("checkStyle").toString();
        String checkColor = annotMap.get("checkColor").toString();

        checkboxWidget.setChecked(isChecked);
        checkboxWidget.setCheckStyle(CPDFEnumConvertUtil.stringToCheckStyle(checkStyle));
        checkboxWidget.setColor(Color.parseColor(checkColor));
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
        CPDFCheckboxWidget widget = (CPDFCheckboxWidget) page.addFormWidget(
            WidgetType.Widget_CheckBox);
        if (widget.isValid()){
            RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
            widget.setRect(rectF);

            widget.setCheckBoxStyle(CheckboxStyle.CHECKBOX_TICK);
            widget.setBorderStyles(BorderStyle.BS_Solid);
            if (TextUtils.isEmpty(title)){
                widget.setFieldName(CAppUtils.getDefaultFiledName("Check Button_"));
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
