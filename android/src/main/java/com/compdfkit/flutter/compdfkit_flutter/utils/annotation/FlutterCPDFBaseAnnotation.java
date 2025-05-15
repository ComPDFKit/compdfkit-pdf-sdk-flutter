package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.common.CPDFDate;
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
    Map<String, Float> rectMap = new HashMap<>();
    rectMap.put("left", rect.left);
    rectMap.put("top", rect.top);
    rectMap.put("right", rect.right);
    rectMap.put("bottom", rect.bottom);
    map.put("rect", rectMap);

    CPDFDate modifyDate = annotation.getRecentlyModifyDate();
    CPDFDate createDate = annotation.getCreationDate();
    if (modifyDate != null) {
      map.put("modifyDate", CDateUtil.transformToTimestamp(modifyDate));
    }
    if (createDate != null) {
      map.put("createDate", CDateUtil.transformToTimestamp(createDate));
    }
    covert(annotation, map);
    return map;
  }

  public abstract void covert(com.compdfkit.core.annotation.CPDFAnnotation annotation, HashMap<String, Object> map);
}
