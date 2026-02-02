package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.graphics.RectF;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.CPDFBorderEffectType;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFCircleAnnotation;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;

public class FlutterCPDFCircleAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFCircleAnnotation circleAnnotation = (CPDFCircleAnnotation) annotation;
    map.put("borderColor", CAppUtils.toHexColor(circleAnnotation.getBorderColor()));
    map.put("borderAlpha", (double) circleAnnotation.getBorderAlpha());
    map.put("fillColor", CAppUtils.toHexColor(circleAnnotation.getFillColor()));
    map.put("fillAlpha", (double) circleAnnotation.getFillAlpha());
    map.put("borderWidth", circleAnnotation.getBorderWidth());
    map.put("bordEffectType", CPDFEnumConvertUtil.bordEffectTypeToString(circleAnnotation.getBordEffectType()));
    CPDFBorderStyle borderStyle = circleAnnotation.getBorderStyle();
    if (borderStyle != null){
      float[] dashArr = borderStyle.getDashArr();
      if (dashArr != null && dashArr.length == 2){
        map.put("dashGap", borderStyle.getDashArr()[1]);
      }
    }
  }


  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);
    CPDFCircleAnnotation circleAnnotation = (CPDFCircleAnnotation) annotation;
    String borderColor = annotMap.get("borderColor").toString();
    double borderAlpha = (double) annotMap.get("borderAlpha");
    String fillColor = annotMap.get("fillColor").toString();
    double fillAlpha = (double) annotMap.get("fillAlpha");
    double borderWidth = (double) annotMap.get("borderWidth");
    String bordEffectType = annotMap.get("bordEffectType").toString();
    double dashGap = (double) annotMap.get("dashGap");
    circleAnnotation.setBorderColor(Color.parseColor(borderColor));
    circleAnnotation.setBorderAlpha((int) borderAlpha);
    circleAnnotation.setFillColor(Color.parseColor(fillColor));
    circleAnnotation.setFillAlpha((int) fillAlpha);
    circleAnnotation.setBorderWidth((float) borderWidth);
    CPDFBorderEffectType cpdfBorderEffectType = CPDFEnumConvertUtil.stringToBordEffectType(bordEffectType);
    if (cpdfBorderEffectType != circleAnnotation.getBordEffectType()){
      circleAnnotation.setBordEffectType(cpdfBorderEffectType);
    }
    CPDFBorderStyle borderStyle = circleAnnotation.getBorderStyle();
    if (borderStyle != null){
      float[] dashArr = borderStyle.getDashArr();
      if (dashArr != null && dashArr.length == 2){
        dashArr[1] = (float) dashGap;
      }else {
        dashArr = new float[]{8.0F, (float) dashGap};
      }
      if (dashGap > 0){
        borderStyle.setStyle(Style.Border_Dashed);
      }else {
        borderStyle.setStyle(Style.Border_Solid);
      }
      borderStyle.setDashArr(dashArr);
      circleAnnotation.setBorderStyle(borderStyle);
    }
  }

  @Override
  public CPDFAnnotation addAnnotation(com.compdfkit.core.document.CPDFDocument document, HashMap<String, Object> annotMap) {
    super.addAnnotation(document, annotMap);
    int pageIndex = (int) annotMap.get("page");
    String title = annotMap.get("title").toString();
    String content = annotMap.get("content").toString();
    HashMap<String, Object> rectMap = (HashMap<String, Object>) annotMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");

    com.compdfkit.core.page.CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFCircleAnnotation circleAnnotation = (CPDFCircleAnnotation) page.addAnnot(CPDFAnnotation.Type.CIRCLE);
    if (circleAnnotation.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);

      circleAnnotation.setRect(rectF);
      circleAnnotation.setTitle(title);
      circleAnnotation.setContent(content);

      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        circleAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        circleAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        circleAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        circleAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }

      updateAnnotation(circleAnnotation, annotMap);

      circleAnnotation.updateAp();
    }
    return circleAnnotation;
  }
}
