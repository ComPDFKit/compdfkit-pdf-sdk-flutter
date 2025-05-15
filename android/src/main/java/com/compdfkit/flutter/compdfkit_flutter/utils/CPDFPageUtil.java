/**
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;


import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFCircleAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFFreeTextAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFInkAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFLineAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFLinkAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFMarkupAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFNoteAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFSquareAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFStampAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFCheckBoxWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFComboBoxWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFListBoxWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFPushbuttonWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFRadioButtonWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFSignatureFieldsWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFTextFieldWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFWidget;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class CPDFPageUtil {
  private CPDFDocument document;

  HashMap<Type, FlutterCPDFAnnotation> annotImpls = new HashMap<>();

  HashMap<WidgetType, FlutterCPDFWidget> widgetsImpls = new HashMap<>();

  public CPDFPageUtil() {
    annotImpls = createAnnotationImpl();
    widgetsImpls = getWidgetsImpl();
  }


  private HashMap<Type, FlutterCPDFAnnotation> createAnnotationImpl(){
    HashMap<Type, FlutterCPDFAnnotation> map = new HashMap<>();
    FlutterCPDFMarkupAnnotation markupAnnotation = new FlutterCPDFMarkupAnnotation();
    map.put(Type.TEXT, new FlutterCPDFNoteAnnotation());
    map.put(Type.HIGHLIGHT, markupAnnotation);
    map.put(Type.UNDERLINE, markupAnnotation);
    map.put(Type.SQUIGGLY, markupAnnotation);
    map.put(Type.STRIKEOUT, markupAnnotation);
    map.put(Type.INK, new FlutterCPDFInkAnnotation());
    map.put(Type.CIRCLE, new FlutterCPDFCircleAnnotation());
    map.put(Type.SQUARE, new FlutterCPDFSquareAnnotation());
    map.put(Type.LINE, new FlutterCPDFLineAnnotation());
    map.put(Type.STAMP, new FlutterCPDFStampAnnotation());
    map.put(Type.FREETEXT, new FlutterCPDFFreeTextAnnotation());
    map.put(Type.SOUND, markupAnnotation);
    map.put(Type.LINK, new FlutterCPDFLinkAnnotation());
    return map;
  }

  private HashMap<WidgetType, FlutterCPDFWidget> getWidgetsImpl(){
    HashMap<WidgetType, FlutterCPDFWidget> map = new HashMap<>();
    map.put(WidgetType.Widget_TextField, new FlutterCPDFTextFieldWidget());
    map.put(WidgetType.Widget_ListBox, new FlutterCPDFListBoxWidget());
    map.put(WidgetType.Widget_ComboBox,  new FlutterCPDFComboBoxWidget());
    map.put(WidgetType.Widget_RadioButton,  new FlutterCPDFRadioButtonWidget());
    map.put(WidgetType.Widget_CheckBox,  new FlutterCPDFCheckBoxWidget());
    map.put(WidgetType.Widget_SignatureFields,  new FlutterCPDFSignatureFieldsWidget());
    map.put(WidgetType.Widget_PushButton,  new FlutterCPDFPushbuttonWidget());
    return map;
  }

  public void setDocument(CPDFDocument document) {
    this.document = document;
  }

  public ArrayList<HashMap<String, Object>> getAnnotations(int pageIndex){
    if (document == null) {
      return null;
    }
    CPDFPage page = document.pageAtIndex(pageIndex);
    List<CPDFAnnotation> annotations = page.getAnnotations();
    if (annotations == null || !page.isValid()){
      return null;
    }
    ArrayList<HashMap<String, Object>> array = new ArrayList<>();
    for (CPDFAnnotation annotation : annotations) {
      FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(annotation.getType());
      if (rcpdfAnnotation != null){
        if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation){
          ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
        }
        HashMap<String, Object> map = rcpdfAnnotation.getAnnotation(annotation);
        if (map != null){
          array.add(map);
        }
      }
    }
    return array;
  }

  public ArrayList<HashMap<String, Object>> getWidgets(int pageIndex){
    if (document == null) {
      return null;
    }
    CPDFPage page = document.pageAtIndex(pageIndex);
    List<CPDFAnnotation> annotations = page.getAnnotations();
    if (annotations == null || !page.isValid()){
      return null;
    }
    ArrayList<HashMap<String, Object>> array = new ArrayList<>();
    for (CPDFAnnotation annotation : annotations) {
      if (annotation.getType() != Type.WIDGET){
        continue;
      }
      CPDFWidget widget = (CPDFWidget) annotation;
      FlutterCPDFWidget rcpdfWidget = widgetsImpls.get(widget.getWidgetType());
      if (rcpdfWidget != null){
        if (rcpdfWidget instanceof FlutterCPDFPushbuttonWidget){
          ((FlutterCPDFPushbuttonWidget) rcpdfWidget).setDocument(document);
        }
        HashMap<String, Object> writableMap = rcpdfWidget.getWidget(annotation);
        if (writableMap != null){
          array.add(writableMap);
        }
      }
    }
    return array;
  }

  public void setTextWidgetText(int pageIndex, String annotPtr, String text) {
    if (document == null) {
      return;
    }
    CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
    FlutterCPDFTextFieldWidget textFieldWidget = ((FlutterCPDFTextFieldWidget) widgetsImpls.get(WidgetType.Widget_TextField));
    if (textFieldWidget != null && annotation != null) {
      textFieldWidget.setText(annotation, text);
    }
  }

  public void updateAp(int pageIndex, String annotPtr){
    CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
    if (annotation != null){
      annotation.updateAp();
    }
  }

  public void setChecked(int pageIndex, String annotPtr, boolean checked) {
    if (document == null) {
      return;
    }
    CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
    if (annotation.getType() != Type.WIDGET){
      return;
    }
    FlutterCPDFWidget widget = (FlutterCPDFWidget) annotation;
    if (widget instanceof CPDFRadiobuttonWidget){
      ((CPDFRadiobuttonWidget) widget).setChecked(checked);
    } else if (widget instanceof CPDFCheckboxWidget) {
      ((CPDFCheckboxWidget) widget).setChecked(checked);
    }
  }

  public boolean addWidgetImageSignature(int pageIndex, String annotPtr, String imagePath){
    CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
    FlutterCPDFSignatureFieldsWidget signatureFieldsWidget = ((FlutterCPDFSignatureFieldsWidget) widgetsImpls.get(WidgetType.Widget_SignatureFields));
    if (signatureFieldsWidget != null && annotation != null) {
      return signatureFieldsWidget.addImageSignatures(document.getContext(), annotation, imagePath);
    }
    return false;
  }


  public CPDFAnnotation getAnnotation(int pageIndex, String annotPtr){
    CPDFPage page = document.pageAtIndex(pageIndex);
    List<CPDFAnnotation> annotations = page.getAnnotations();
    if (annotations == null || !page.isValid()){
      return null;
    }
    for (CPDFAnnotation annotation : annotations) {
      if (annotation.getAnnotPtr() == Long.parseLong(annotPtr)){
        return annotation;
      }
    }
    return null;
  }

  public boolean deleteAnnotation(int pageIndex, String annotPtr){
    CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
    if (annotation != null){
      CPDFPage page = document.pageAtIndex(pageIndex);
      return page.deleteAnnotation(annotation);
    }else {
      return false;
    }
  }

}
