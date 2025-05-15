package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;


public class FlutterCPDFCheckBoxWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFCheckboxWidget checkboxWidget = (CPDFCheckboxWidget) widget;
    map.put("type", "checkBox");
    map.put("isChecked", checkboxWidget.isChecked());
    map.put("checkStyle",
        checkboxWidget.getCheckStyle().name().replaceAll("CK_", "").toLowerCase());
    map.put("checkColor", CAppUtils.toHexColor(checkboxWidget.getCheckColor()));
  }
}
