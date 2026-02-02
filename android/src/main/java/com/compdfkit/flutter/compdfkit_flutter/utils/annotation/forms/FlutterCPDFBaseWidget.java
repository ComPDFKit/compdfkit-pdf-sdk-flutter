/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. This notice
 * may not be removed from this file.
 */
package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.tools.common.utils.date.CDateUtil;
import java.util.HashMap;
import java.util.Map;

public abstract class FlutterCPDFBaseWidget implements FlutterCPDFWidget {

  @Override
  public HashMap<String, Object> getWidget(CPDFAnnotation annotation) {
    HashMap<String, Object> map = new HashMap<>();
    CPDFWidget widget = (CPDFWidget) annotation;
    map.put("page", widget.pdfPage.getPageNum());
    map.put("title", widget.getFieldName());
    map.put("uuid", widget.getAnnotPtr() + "");

    RectF rect = annotation.getRect();
    Map<String, Float> rectMap = new HashMap<>();
    rectMap.put("left", CAppUtils.roundTo2f(rect.left));
    rectMap.put("top", CAppUtils.roundTo2f(rect.top));
    rectMap.put("right", CAppUtils.roundTo2f(rect.right));
    rectMap.put("bottom", CAppUtils.roundTo2f(rect.bottom));
    map.put("rect", rectMap);

    CPDFDate modifyDate = annotation.getRecentlyModifyDate();
    CPDFDate createDate = annotation.getCreationDate();
    if (modifyDate != null) {
      map.put("modifyDate", CDateUtil.transformToTimestamp(modifyDate));
    }
    if (createDate != null) {
      map.put("createDate", CDateUtil.transformToTimestamp(createDate));
    }

    map.put("borderColor", CAppUtils.toHexColor(widget.getBorderColor()));
    map.put("borderWidth", widget.getBorderWidth());
    map.put("fillColor", CAppUtils.toHexColor(widget.getFillColor()));

    covert(widget, map);
    return map;
  }

  public abstract void covert(CPDFWidget widget, HashMap<String, Object> map);

  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    CPDFWidget widget = (CPDFWidget) annotation;
    String title = annotMap.get("title").toString();
    String fillColor = annotMap.get("fillColor").toString();
    String borderColor = annotMap.get("borderColor").toString();
    double borderWidth = (double) annotMap.get("borderWidth");
    widget.setFieldName(title);
    widget.setFillColor(Color.parseColor(fillColor));
    widget.setBorderColor(Color.parseColor(borderColor));
    widget.setBorderWidth((float) borderWidth);
  }

  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {
    return null;
  }
}
