package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.tools.common.utils.date.CDateUtil;
import java.util.HashMap;
import java.util.Map;

public abstract class FlutterCPDFBaseAnnotation implements FlutterCPDFAnnotation {

  @Override
  public HashMap<String, Object> getAnnotation(com.compdfkit.core.annotation.CPDFAnnotation annotation) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("type", annotation.getType().name().toLowerCase());
    map.put("page", annotation.pdfPage.getPageNum());
    map.put("title", annotation.getTitle());
    map.put("content", annotation.getContent());
    map.put("uuid", annotation.getAnnotPtr()+"");
    RectF rect = annotation.getRect();
    if (rect != null){
      Map<String, Float> rectMap = new HashMap<>();
      rectMap.put("left", CAppUtils.roundTo2f(rect.left));
      rectMap.put("top", CAppUtils.roundTo2f(rect.top));
      rectMap.put("right", CAppUtils.roundTo2f(rect.right));
      rectMap.put("bottom", CAppUtils.roundTo2f(rect.bottom));
      map.put("rect", rectMap);
    }
    CPDFDate modifyDate = annotation.getRecentlyModifyDate();
    CPDFDate createDate = annotation.getCreationDate();
    if (modifyDate != null) {
      map.put("modifyDate", CDateUtil.transformToTimestamp(modifyDate));
    }
    if (createDate != null) {
      map.put("createDate", CDateUtil.transformToTimestamp(createDate));
    }
    getAnnotationConvert(annotation, map);
    return map;
  }

  public abstract void getAnnotationConvert(com.compdfkit.core.annotation.CPDFAnnotation annotation, HashMap<String, Object> map);

  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    String title = annotMap.get("title").toString();
    String content = annotMap.get("content").toString();
    annotation.setTitle(title);
    annotation.setContent(content);
  }

  @Override
  public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
    return null;
  }
}
