package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFLineAnnotation;
import com.compdfkit.core.annotation.CPDFLineAnnotation.LineType;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFLineAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFLineAnnotation lineAnnotation = (CPDFLineAnnotation) annotation;
    if (lineAnnotation.getLineHeadType() == LineType.LINETYPE_NONE
        && lineAnnotation.getLineTailType() == LineType.LINETYPE_NONE) {
      map.put("type", "line");
    } else {
      map.put("type", "arrow");
    }
    map.put("borderColor", CAppUtils.toHexColor(lineAnnotation.getBorderColor()));
    map.put("borderAlpha", (double) lineAnnotation.getBorderAlpha());
    map.put("fillColor", CAppUtils.toHexColor(lineAnnotation.getFillColor()));
    map.put("fillAlpha", (double) lineAnnotation.getFillAlpha());
    map.put("borderWidth", lineAnnotation.getBorderWidth());
    map.put("lineHeadType", getLineType(lineAnnotation.getLineHeadType()));
    map.put("lineTailType", getLineType(lineAnnotation.getLineTailType()));
  }

  private String getLineType(CPDFLineAnnotation.LineType lineType) {
    switch (lineType) {
      case LINETYPE_ARROW:
        return "openArrow";
      case LINETYPE_CIRCLE:
        return "circle";
      case LINETYPE_DIAMOND:
        return "diamond";
      case LINETYPE_SQUARE:
        return "square";
      case LINETYPE_CLOSEDARROW:
        return "closedArrow";
      case LINETYPE_NONE:
        return "none";
      default:
        return "unknown";
    }
  }

}
