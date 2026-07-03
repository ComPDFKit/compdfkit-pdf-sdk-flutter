/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. This notice
 * may not be removed from this file.
 */
package com.compdfkit.flutter.compdfkit_flutter.utils;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFWidget;
import java.util.HashMap;
import org.junit.Test;

public class CPDFPageUtilTest {

  @Test
  public void addAnnotations_withNullReaderView_addsAnnotationWithoutCrash() {
    CPDFDocument document = mock(CPDFDocument.class);
    CPDFAnnotation annotation = mock(CPDFAnnotation.class);
    FlutterCPDFAnnotation annotationImpl = mock(FlutterCPDFAnnotation.class);
    HashMap<String, Object> annotationMap = createNoteAnnotationMap(0);
    CPDFPageUtil pageUtil = new CPDFPageUtil();

    when(document.getPageCount()).thenReturn(1);
    when(annotationImpl.addAnnotation(document, annotationMap)).thenReturn(annotation);
    when(annotation.isValid()).thenReturn(true);
    pageUtil.annotImpls.clear();
    pageUtil.annotImpls.put(CPDFAnnotation.Type.TEXT, annotationImpl);
    pageUtil.setDocument(document);

    boolean result = pageUtil.addAnnotations(null, createList(annotationMap));

    assertTrue(result);
    verify(annotationImpl).addAnnotation(document, annotationMap);
  }

  @Test
  public void addWidgets_withNullReaderView_addsWidgetWithoutCrash() {
    CPDFDocument document = mock(CPDFDocument.class);
    CPDFWidget widget = mock(CPDFWidget.class);
    FlutterCPDFWidget widgetImpl = mock(FlutterCPDFWidget.class);
    HashMap<String, Object> widgetMap = createTextFieldWidgetMap(0);
    CPDFPageUtil pageUtil = new CPDFPageUtil();

    when(document.getPageCount()).thenReturn(1);
    when(widgetImpl.addWidget(document, widgetMap)).thenReturn(widget);
    when(widget.isValid()).thenReturn(true);
    pageUtil.widgetsImpls.clear();
    pageUtil.widgetsImpls.put(CPDFWidget.WidgetType.Widget_TextField, widgetImpl);
    pageUtil.setDocument(document);

    boolean result = pageUtil.addWidgets(null, createList(widgetMap));

    assertTrue(result);
    verify(widgetImpl).addWidget(document, widgetMap);
  }

  @Test
  public void addAnnotations_withInvalidPage_returnsFalseAndSkipsAdd() {
    CPDFDocument document = mock(CPDFDocument.class);
    FlutterCPDFAnnotation annotationImpl = mock(FlutterCPDFAnnotation.class);
    HashMap<String, Object> annotationMap = createNoteAnnotationMap(0);
    CPDFPageUtil pageUtil = new CPDFPageUtil();

    when(document.getPageCount()).thenReturn(0);
    pageUtil.annotImpls.clear();
    pageUtil.annotImpls.put(CPDFAnnotation.Type.TEXT, annotationImpl);
    pageUtil.setDocument(document);

    boolean result = pageUtil.addAnnotations(null, createList(annotationMap));

    assertFalse(result);
    verify(annotationImpl, never()).addAnnotation(document, annotationMap);
  }

  @Test
  public void addWidgets_withInvalidPage_returnsFalseAndSkipsAdd() {
    CPDFDocument document = mock(CPDFDocument.class);
    FlutterCPDFWidget widgetImpl = mock(FlutterCPDFWidget.class);
    HashMap<String, Object> widgetMap = createTextFieldWidgetMap(0);
    CPDFPageUtil pageUtil = new CPDFPageUtil();

    when(document.getPageCount()).thenReturn(0);
    pageUtil.widgetsImpls.clear();
    pageUtil.widgetsImpls.put(CPDFWidget.WidgetType.Widget_TextField, widgetImpl);
    pageUtil.setDocument(document);

    boolean result = pageUtil.addWidgets(null, createList(widgetMap));

    assertFalse(result);
    verify(widgetImpl, never()).addWidget(document, widgetMap);
  }

  private static HashMap<String, Object> createNoteAnnotationMap(int pageIndex) {
    HashMap<String, Object> annotation = new HashMap<>();
    annotation.put("type", "note");
    annotation.put("page", pageIndex);
    annotation.put("title", "Note");
    annotation.put("content", "Created by test");
    annotation.put("rect", createRectMap());
    annotation.put("color", "#00FF00");
    annotation.put("alpha", 255.0);
    return annotation;
  }

  private static HashMap<String, Object> createTextFieldWidgetMap(int pageIndex) {
    HashMap<String, Object> widget = new HashMap<>();
    widget.put("type", "textField");
    widget.put("page", pageIndex);
    widget.put("title", "Field");
    widget.put("rect", createRectMap());
    widget.put("borderColor", "#000000");
    widget.put("fillColor", "#FFFFFF");
    widget.put("borderWidth", 2.0);
    widget.put("text", "hello");
    widget.put("fontColor", "#000000");
    widget.put("fontSize", 18.0);
    widget.put("alignment", "left");
    widget.put("isMultiline", true);
    widget.put("familyName", "Helvetica");
    widget.put("styleName", "Regular");
    return widget;
  }

  private static HashMap<String, Object> createRectMap() {
    HashMap<String, Object> rect = new HashMap<>();
    rect.put("left", 10.0);
    rect.put("top", 20.0);
    rect.put("right", 110.0);
    rect.put("bottom", 70.0);
    return rect;
  }

  private static <T> java.util.List<T> createList(T item) {
    return new java.util.ArrayList<>(java.util.Collections.singletonList(item));
  }
}
