package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFTextAnnotation;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;

public class FlutterCPDFNoteAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFTextAnnotation textAnnotation = (CPDFTextAnnotation) annotation;
    map.put("type", "note");
    map.put("color", CAppUtils.toHexColor(textAnnotation.getColor()));
    map.put("alpha", (double) textAnnotation.getAlpha());
  }


  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);
    String hexColor = annotMap.get("color").toString();
    double alpha = (double) annotMap.get("alpha");
    CPDFTextAnnotation textAnnotation = (CPDFTextAnnotation) annotation;
    textAnnotation.setColor(Color.parseColor(hexColor));
    textAnnotation.setAlpha((int) alpha);
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

    String hexColor = annotMap.get("color").toString();
    double alpha = (double) annotMap.get("alpha");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFTextAnnotation textAnnotation = (CPDFTextAnnotation) page.addAnnot(CPDFAnnotation.Type.TEXT);
    if (textAnnotation.isValid()){
      android.graphics.RectF rectF = new android.graphics.RectF((float) left, (float) top, (float) right, (float) bottom);
      textAnnotation.setRect(rectF);
      textAnnotation.setTitle(title);
      textAnnotation.setContent(content);
      textAnnotation.setColor(Color.parseColor(hexColor));
      textAnnotation.setAlpha((int) alpha);
      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        textAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        textAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      }else {
        textAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        textAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }
      textAnnotation.updateAp();
    }
    return textAnnotation;
  }


}
