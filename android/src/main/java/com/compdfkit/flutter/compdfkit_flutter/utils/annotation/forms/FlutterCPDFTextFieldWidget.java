package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFTextWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.font.CPDFFont;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;
import java.util.List;


public class FlutterCPDFTextFieldWidget extends FlutterCPDFBaseWidget {


  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFTextWidget textWidget = (CPDFTextWidget) widget;
    map.put("type", "textField");
    map.put("text", textWidget.getText());
    map.put("isMultiline", textWidget.isMultiLine());
    map.put("fontColor", CAppUtils.toHexColor(textWidget.getFontColor()));
    map.put("fontSize", textWidget.getFontSize());
    switch (textWidget.getTextAlignment()){
      case ALIGNMENT_RIGHT:
        map.put("alignment", "right");
        break;
      case ALIGNMENT_CENTER:
        map.put("alignment", "center");
        break;
      default:
        map.put("alignment", "left");
        break;
    }

    String fontName = textWidget.getFontName();
    String familyName = CPDFFont.getFamilyName(textWidget.getFontName());
    String styleName = "Regular";
    if (TextUtils.isEmpty(familyName)){
      familyName = textWidget.getFontName();
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

  public void setText(CPDFAnnotation annotation, String text) {
    CPDFTextWidget textWidget = (CPDFTextWidget) annotation;
    textWidget.setText(text);
  }
}
