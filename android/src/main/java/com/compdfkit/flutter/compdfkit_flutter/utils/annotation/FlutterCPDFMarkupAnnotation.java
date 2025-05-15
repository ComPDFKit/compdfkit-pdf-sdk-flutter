package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFMarkupAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    if (annotation instanceof com.compdfkit.core.annotation.CPDFMarkupAnnotation){
      com.compdfkit.core.annotation.CPDFMarkupAnnotation markupAnnotation = (com.compdfkit.core.annotation.CPDFMarkupAnnotation) annotation;
      map.put("markedText", markupAnnotation.getMarkedText());
      map.put("color", CAppUtils.toHexColor(markupAnnotation.getColor()));
      map.put("alpha", (double) markupAnnotation.getAlpha());

    }
  }
}
