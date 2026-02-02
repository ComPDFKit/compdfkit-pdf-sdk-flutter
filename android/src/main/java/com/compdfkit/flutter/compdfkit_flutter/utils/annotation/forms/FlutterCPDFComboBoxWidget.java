package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.annotation.form.CPDFComboboxWidget;
import com.compdfkit.core.annotation.form.CPDFListboxWidget;
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


public class FlutterCPDFComboBoxWidget extends FlutterCPDFBaseWidget {
  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFComboboxWidget comboBoxWidget = (CPDFComboboxWidget) widget;
    map.put("type", "comboBox");
    ArrayList<HashMap<String, String>> options = new ArrayList<>();
    CPDFWidgetItem[] items = comboBoxWidget.getOptions();
    if (items != null && items.length > 0){
      for (CPDFWidgetItem item : items) {
        HashMap<String, String> option = new HashMap<>();
        option.put("text", item.text);
        option.put("value", item.value);
        options.add(option);
      }
    }
    map.put("options", options);
    int[] selectedIndexes = comboBoxWidget.getSelectedIndexes();
    int index = (selectedIndexes != null && selectedIndexes.length > 0) ? selectedIndexes[0] : 0;
    map.put("selectItemAtIndex", index);

    map.put("fontColor", CAppUtils.toHexColor(comboBoxWidget.getFontColor()));
    map.put("fontSize", comboBoxWidget.getFontSize());

    String psName = comboBoxWidget.getFontName();
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(psName);

    map.put("familyName", names[0]);
    map.put("styleName", names[1]);
  }


  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateWidget(annotation, annotMap);
    CPDFComboboxWidget comboBoxWidget = (CPDFComboboxWidget) annotation;

    String fontColor = annotMap.get("fontColor").toString();
    double fontSize = (double) annotMap.get("fontSize");
    String familyName = annotMap.get("familyName").toString();
    String styleName = annotMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    comboBoxWidget.setFontColor(Color.parseColor(fontColor));
    comboBoxWidget.setFontSize((float) fontSize);
    comboBoxWidget.setFontName(psName);

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
    comboBoxWidget.setOptionItems(optionItems);
    comboBoxWidget.setSelectedIndexes(new int[]{selectItemAtIndex});
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
    CPDFComboboxWidget widget = (CPDFComboboxWidget) page.addFormWidget(
        WidgetType.Widget_ComboBox);
    if (widget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      widget.setRect(rectF);
      if (TextUtils.isEmpty(title)){
        widget.setFieldName(CAppUtils.getDefaultFiledName("Combo Box_"));
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
