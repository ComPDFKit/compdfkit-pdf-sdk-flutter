package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.CPDFBorderEffectType;
import com.compdfkit.core.annotation.CPDFCircleAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFCircleAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFCircleAnnotation circleAnnotation = (CPDFCircleAnnotation) annotation;
    map.put("borderColor", CAppUtils.toHexColor(circleAnnotation.getBorderColor()));
    map.put("borderAlpha", (double) circleAnnotation.getBorderAlpha());
    map.put("fillColor", CAppUtils.toHexColor(circleAnnotation.getFillColor()));
    map.put("fillAlpha", (double) circleAnnotation.getFillAlpha());
    map.put("borderWidth", circleAnnotation.getBorderWidth());
    map.put("bordEffectType", circleAnnotation.getBordEffectType() == CPDFBorderEffectType.CPDFBorderEffectTypeSolid ? "solid" : "cloudy");

  }
}
