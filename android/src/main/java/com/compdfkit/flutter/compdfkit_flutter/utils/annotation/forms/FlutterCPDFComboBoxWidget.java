package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.text.TextUtils;
import com.compdfkit.core.annotation.form.CPDFComboboxWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidgetItem;
import com.compdfkit.core.font.CPDFFont;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


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
    map.put("selectedIndexes", comboBoxWidget.getSelectedIndexes());
    map.put("fontColor", CAppUtils.toHexColor(comboBoxWidget.getFontColor()));
    map.put("fontSize", comboBoxWidget.getFontSize());

    String fontName = comboBoxWidget.getFontName();
    String familyName = CPDFFont.getFamilyName(comboBoxWidget.getFontName());
    String styleName = "Regular";
    if (TextUtils.isEmpty(familyName)){
      familyName = comboBoxWidget.getFontName();
    }else {
      List<String> styleNames = CPDFFont.getStyleName(familyName);
      if (styleNames != null) {
        for (String styleNameItem : styleNames) {
          if (fontName.endsWith(styleNameItem)){
            styleName = styleNameItem;
          }
        }
      }
    }

    map.put("familyName", familyName);
    map.put("styleName", styleName);
  }
}
