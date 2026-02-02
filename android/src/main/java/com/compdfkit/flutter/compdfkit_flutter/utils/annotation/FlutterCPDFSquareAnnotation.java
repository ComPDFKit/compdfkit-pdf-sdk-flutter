package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.BorderEffectIntensity;
import com.compdfkit.core.annotation.CPDFAnnotation.CPDFBorderEffectType;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFFreetextAnnotation;
import com.compdfkit.core.annotation.CPDFSquareAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TMathUtils;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.ui.attribute.CPDFFreetextAttr;
import com.compdfkit.ui.utils.CPDFTextUtils;
import java.util.HashMap;

public class FlutterCPDFSquareAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFSquareAnnotation squareAnnotation = (CPDFSquareAnnotation) annotation;
    map.put("borderColor", CAppUtils.toHexColor(squareAnnotation.getBorderColor()));
    map.put("borderAlpha", (double) squareAnnotation.getBorderAlpha());
    map.put("fillColor", CAppUtils.toHexColor(squareAnnotation.getFillColor()));
    map.put("fillAlpha", (double) squareAnnotation.getFillAlpha());
    map.put("borderWidth", squareAnnotation.getBorderWidth());
    map.put("bordEffectType", CPDFEnumConvertUtil.bordEffectTypeToString(squareAnnotation.getBordEffectType()));
    CPDFBorderStyle borderStyle = squareAnnotation.getBorderStyle();
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
    CPDFSquareAnnotation squareAnnotation = (CPDFSquareAnnotation) annotation;
    String borderColor = annotMap.get("borderColor").toString();
    double borderAlpha = (double) annotMap.get("borderAlpha");
    String fillColor = annotMap.get("fillColor").toString();
    double fillAlpha = (double) annotMap.get("fillAlpha");
    double borderWidth = (double) annotMap.get("borderWidth");
    String bordEffectType = annotMap.get("bordEffectType").toString();
    double dashGap = (double) annotMap.get("dashGap");

    squareAnnotation.setBorderColor(Color.parseColor(borderColor));
    squareAnnotation.setBorderAlpha((int) borderAlpha);
    squareAnnotation.setFillColor(Color.parseColor(fillColor));
    squareAnnotation.setFillAlpha((int) fillAlpha);
    squareAnnotation.setBorderWidth((float) borderWidth);
    CPDFBorderEffectType cpdfBorderEffectType = CPDFEnumConvertUtil.stringToBordEffectType(bordEffectType);
    if (cpdfBorderEffectType != squareAnnotation.getBordEffectType()){
      squareAnnotation.setBordEffectType(cpdfBorderEffectType);
    }
    CPDFBorderStyle borderStyle = squareAnnotation.getBorderStyle();
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
      squareAnnotation.setBorderStyle(borderStyle);
    }
  }

  @Override
  public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
    super.addAnnotation(document, annotMap);
    int pageIndex = (int) annotMap.get("page");
    String title = annotMap.get("title").toString();
    String content = annotMap.get("content").toString();
    HashMap<String, Object> rectMap = (HashMap<String, Object>) annotMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFSquareAnnotation squareAnnotation = (CPDFSquareAnnotation) page.addAnnot(Type.SQUARE);
    if (squareAnnotation.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);

      squareAnnotation.setRect(rectF);
      squareAnnotation.setTitle(title);
      squareAnnotation.setContent(content);
      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        squareAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        squareAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        squareAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        squareAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }

      updateAnnotation(squareAnnotation, annotMap);
      squareAnnotation.updateAp();
    }
    return squareAnnotation;
  }
}
