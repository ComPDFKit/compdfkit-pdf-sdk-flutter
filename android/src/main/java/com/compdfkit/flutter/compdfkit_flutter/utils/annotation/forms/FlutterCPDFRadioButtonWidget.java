package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;


public class FlutterCPDFRadioButtonWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFRadiobuttonWidget radiobuttonWidget = (CPDFRadiobuttonWidget) widget;
    map.put("type", "radioButton");
    map.put("isChecked", radiobuttonWidget.isChecked());
    map.put("checkStyle",
        radiobuttonWidget.getCheckStyle().name().replaceAll("CK_", "").toLowerCase());
    map.put("checkColor", CAppUtils.toHexColor(radiobuttonWidget.getCheckColor()));

  }
}
