package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.CPDFBorderEffectType;
import com.compdfkit.core.annotation.CPDFSquareAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFSquareAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFSquareAnnotation squareAnnotation = (CPDFSquareAnnotation) annotation;
    map.put("borderColor", CAppUtils.toHexColor(squareAnnotation.getBorderColor()));
    map.put("borderAlpha", (double) squareAnnotation.getBorderAlpha());
    map.put("fillColor", CAppUtils.toHexColor(squareAnnotation.getFillColor()));
    map.put("fillAlpha", (double) squareAnnotation.getFillAlpha());
    map.put("borderWidth", squareAnnotation.getBorderWidth());
    map.put("bordEffectType", squareAnnotation.getBordEffectType() == CPDFBorderEffectType.CPDFBorderEffectTypeSolid ? "solid" : "cloudy");

  }
}
