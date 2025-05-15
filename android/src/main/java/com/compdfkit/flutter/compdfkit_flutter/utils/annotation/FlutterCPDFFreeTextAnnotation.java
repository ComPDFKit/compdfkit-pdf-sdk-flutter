package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.text.TextUtils;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFFreetextAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.font.CPDFFont;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FlutterCPDFFreeTextAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFFreetextAnnotation freetextAnnotation = (CPDFFreetextAnnotation) annotation;
    map.put("alpha", (double) freetextAnnotation.getAlpha());
    CPDFTextAttribute textAttribute = freetextAnnotation.getFreetextDa();
    Map<String, Object> textAttributeMap = new HashMap<>();
    textAttributeMap.put("color", CAppUtils.toHexColor(textAttribute.getColor()));

    String fontName = textAttribute.getFontName();
    String familyName = CPDFFont.getFamilyName(textAttribute.getFontName());
    String styleName = "Regular";
    if (TextUtils.isEmpty(familyName)){
      familyName = textAttribute.getFontName();
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

    textAttributeMap.put("familyName", familyName);
    textAttributeMap.put("styleName", styleName);
    textAttributeMap.put("fontSize", textAttribute.getFontSize());

    switch (freetextAnnotation.getFreetextAlignment()){
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

    map.put("textAttribute", textAttributeMap);
  }
}
