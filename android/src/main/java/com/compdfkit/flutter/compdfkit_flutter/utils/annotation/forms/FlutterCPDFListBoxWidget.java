package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.annotation.form.CPDFListboxWidget;
import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.annotation.form.CPDFWidgetItem;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.ArrayList;
import java.util.HashMap;


public class FlutterCPDFListBoxWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFListboxWidget listboxWidget = (CPDFListboxWidget) widget;
    map.put("type", "listBox");
    ArrayList<HashMap<String, String>> options = new ArrayList<>();
    CPDFWidgetItem[] items = listboxWidget.getOptions();
    if (items != null && items.length > 0){
      for (CPDFWidgetItem item : items) {
        HashMap<String, String> option = new HashMap<>();
        option.put("text", item.text);
        option.put("value", item.value);
        options.add(option);
      }
    }
    map.put("options", options);
    int[] selectedIndexes = listboxWidget.getSelectedIndexes();
    int index = (selectedIndexes != null && selectedIndexes.length > 0) ? selectedIndexes[0] : 0;
    map.put("selectItemAtIndex", index);
    map.put("fontColor", CAppUtils.toHexColor(listboxWidget.getFontColor()));
    map.put("fontSize", listboxWidget.getFontSize());

    String psName = listboxWidget.getFontName();
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(psName);

    map.put("familyName", names[0]);
    map.put("styleName", names[1]);
  }

  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateWidget(annotation, annotMap);
    CPDFListboxWidget listBoxWidget = (CPDFListboxWidget) annotation;

    String fontColor = annotMap.get("fontColor").toString();
    double fontSize = (double) annotMap.get("fontSize");
    String familyName = annotMap.get("familyName").toString();
    String styleName = annotMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    listBoxWidget.setFontColor(Color.parseColor(fontColor));
    listBoxWidget.setFontSize((float) fontSize);
    listBoxWidget.setFontName(psName);

    ArrayList<HashMap<String, String>> options =
        (ArrayList<HashMap<String, String>>) annotMap.get("options");
    CPDFWidgetItem[] optionItems = null;
    if (options != null && options.size() > 0) {
      optionItems = new CPDFWidgetItem[options.size()];
      for (int i = 0; i < options.size(); i++) {
        HashMap<String, String> option = options.get(i);
        String text = option.get("text");
        String value = option.get("value");
        optionItems[i] = new CPDFWidgetItem(text, value);
      }
    }
    int selectItemAtIndex = (int) annotMap.get("selectItemAtIndex");
    listBoxWidget.setOptionItems(optionItems);
    listBoxWidget.setSelectedIndexes(new int[]{selectItemAtIndex});
  }


  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {

    int pageIndex = (int) widgetMap.get("page");
    HashMap<String, Object> rectMap = (HashMap<String, Object>) widgetMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");
    String title = (String) widgetMap.get("title");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFListboxWidget widget = (CPDFListboxWidget) page.addFormWidget(
        WidgetType.Widget_ListBox);
    if (widget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      widget.setRect(rectF);
      if (TextUtils.isEmpty(title)){
        widget.setFieldName(CAppUtils.getDefaultFiledName("List Box_"));
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
