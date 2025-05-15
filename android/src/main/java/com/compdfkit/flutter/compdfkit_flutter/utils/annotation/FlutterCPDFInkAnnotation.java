package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFInkAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFInkAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFInkAnnotation inkAnnotation = (CPDFInkAnnotation) annotation;
    map.put("color", CAppUtils.toHexColor(inkAnnotation.getColor()));
    map.put("alpha", (double) inkAnnotation.getAlpha());
    map.put("borderWidth", inkAnnotation.getBorderWidth());
  }


}
