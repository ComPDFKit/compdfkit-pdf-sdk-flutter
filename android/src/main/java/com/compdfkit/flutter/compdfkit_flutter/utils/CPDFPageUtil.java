/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. This notice
 * may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.graphics.Bitmap;
import android.graphics.PointF;
import android.graphics.RectF;
import android.util.Log;
import androidx.annotation.Nullable;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.edit.CPDFEditImageArea;
import com.compdfkit.core.edit.CPDFEditPathArea;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFCircleAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFFreeTextAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFInkAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFLineAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFLinkAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFMarkupAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFNoteAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.utils.annotation.FlutterCPDFSoundAnnotation;
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
import com.compdfkit.ui.edit.CPDFEditTextSelections;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

public class CPDFPageUtil {

    private CPDFDocument document;

    HashMap<Type, FlutterCPDFAnnotation> annotImpls = new HashMap<>();

    HashMap<WidgetType, FlutterCPDFWidget> widgetsImpls = new HashMap<>();

    public CPDFPageUtil() {
        annotImpls = createAnnotationImpl();
        widgetsImpls = getWidgetsImpl();
    }

    private HashMap<Type, FlutterCPDFAnnotation> createAnnotationImpl() {
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
        map.put(Type.SOUND, new FlutterCPDFSoundAnnotation());
        map.put(Type.LINK, new FlutterCPDFLinkAnnotation());
        return map;
    }

    private HashMap<WidgetType, FlutterCPDFWidget> getWidgetsImpl() {
        HashMap<WidgetType, FlutterCPDFWidget> map = new HashMap<>();
        map.put(WidgetType.Widget_TextField, new FlutterCPDFTextFieldWidget());
        map.put(WidgetType.Widget_ListBox, new FlutterCPDFListBoxWidget());
        map.put(WidgetType.Widget_ComboBox, new FlutterCPDFComboBoxWidget());
        map.put(WidgetType.Widget_RadioButton, new FlutterCPDFRadioButtonWidget());
        map.put(WidgetType.Widget_CheckBox, new FlutterCPDFCheckBoxWidget());
        map.put(WidgetType.Widget_SignatureFields, new FlutterCPDFSignatureFieldsWidget());
        map.put(WidgetType.Widget_PushButton, new FlutterCPDFPushbuttonWidget());
        return map;
    }

    public void setDocument(CPDFDocument document) {
        this.document = document;
    }

    public HashMap<String, Object> getAnnotationData(CPDFAnnotation annotation) {
        if (document == null) {
            return new HashMap<>();
        }
        FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(annotation.getType());
        if (rcpdfAnnotation != null) {
            if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation) {
                ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
            }
            return rcpdfAnnotation.getAnnotation(annotation);
        }
        return new HashMap<>();
    }

    public HashMap<String, Object> getWidgetData(CPDFWidget widget) {
        if (document == null) {
            return new HashMap<>();
        }
        FlutterCPDFWidget rcpdfWidget = widgetsImpls.get(widget.getWidgetType());
        if (rcpdfWidget != null) {
            if (rcpdfWidget instanceof FlutterCPDFPushbuttonWidget) {
                ((FlutterCPDFPushbuttonWidget) rcpdfWidget).setDocument(document);
            }
            return rcpdfWidget.getWidget(widget);
        }
        return new HashMap<>();
    }

    public ArrayList<HashMap<String, Object>> getAnnotations(int pageIndex) {
        if (document == null) {
            return null;
        }
        CPDFPage page = document.pageAtIndex(pageIndex);
        List<CPDFAnnotation> annotations = page.getAnnotations();
        if (annotations == null || !page.isValid()) {
            return null;
        }
        ArrayList<HashMap<String, Object>> array = new ArrayList<>();
        for (CPDFAnnotation annotation : annotations) {
            if (annotation == null || !annotation.isValid()) {
                continue;
            }
            FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(annotation.getType());
            if (rcpdfAnnotation != null) {
                if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation) {
                    ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
                }
                HashMap<String, Object> map = rcpdfAnnotation.getAnnotation(annotation);
                if (map != null) {
                    array.add(map);
                }
            }
        }
        return array;
    }

    public ArrayList<HashMap<String, Object>> getWidgets(int pageIndex) {
        if (document == null) {
            return null;
        }
        CPDFPage page = document.pageAtIndex(pageIndex);
        List<CPDFAnnotation> annotations = page.getAnnotations();
        if (annotations == null || !page.isValid()) {
            return null;
        }
        ArrayList<HashMap<String, Object>> array = new ArrayList<>();
        for (CPDFAnnotation annotation : annotations) {
            if (annotation == null || !annotation.isValid()) {
                continue;
            }
            if (annotation.getType() != Type.WIDGET) {
                continue;
            }
            CPDFWidget widget = (CPDFWidget) annotation;
            FlutterCPDFWidget rcpdfWidget = widgetsImpls.get(widget.getWidgetType());
            if (rcpdfWidget != null) {
                if (rcpdfWidget instanceof FlutterCPDFPushbuttonWidget) {
                    ((FlutterCPDFPushbuttonWidget) rcpdfWidget).setDocument(document);
                }
                HashMap<String, Object> writableMap = rcpdfWidget.getWidget(annotation);
                if (writableMap != null) {
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
        FlutterCPDFTextFieldWidget textFieldWidget = ((FlutterCPDFTextFieldWidget) widgetsImpls.get(
                WidgetType.Widget_TextField));
        if (textFieldWidget != null && annotation != null) {
            textFieldWidget.setText(annotation, text);
        }
    }

    public void updateAp(int pageIndex, String annotPtr) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation != null) {
            annotation.updateAp();
        }
    }

    public void setChecked(int pageIndex, String annotPtr, boolean checked) {
        if (document == null) {
            return;
        }
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation.getType() != Type.WIDGET) {
            return;
        }
        FlutterCPDFWidget widget = (FlutterCPDFWidget) annotation;
        if (widget instanceof CPDFRadiobuttonWidget) {
            ((CPDFRadiobuttonWidget) widget).setChecked(checked);
        } else if (widget instanceof CPDFCheckboxWidget) {
            ((CPDFCheckboxWidget) widget).setChecked(checked);
        }
    }

    public boolean addWidgetImageSignature(int pageIndex, String annotPtr, String imagePath) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        FlutterCPDFSignatureFieldsWidget signatureFieldsWidget = ((FlutterCPDFSignatureFieldsWidget) widgetsImpls.get(
                WidgetType.Widget_SignatureFields));
        if (signatureFieldsWidget != null && annotation != null) {
            return signatureFieldsWidget.addImageSignatures(document.getContext(), annotation,
                    imagePath);
        }
        return false;
    }

    public CPDFAnnotation getAnnotation(int pageIndex, String annotPtr) {
        CPDFPage page = document.pageAtIndex(pageIndex);
        List<CPDFAnnotation> annotations = page.getAnnotations();
        if (annotations == null || !page.isValid()) {
            return null;
        }
        for (CPDFAnnotation annotation : annotations) {
            if (annotation.getAnnotPtr() == Long.parseLong(annotPtr)) {
                return annotation;
            }
        }
        return null;
    }

    public boolean deleteAnnotation(int pageIndex, String annotPtr) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation != null) {
            CPDFPage page = document.pageAtIndex(pageIndex);
            return page.deleteAnnotation(annotation);
        } else {
            return false;
        }
    }

    public boolean updateAnnotation(CPDFAnnotation annotation,
            HashMap<String, Object> properties) {
        if (annotation != null) {
            FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(annotation.getType());
            if (rcpdfAnnotation != null) {
                if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation) {
                    ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
                }
                rcpdfAnnotation.updateAnnotation(annotation, properties);
                annotation.updateAp();
                return true;
            }
        }
        return false;
    }

    public boolean updateWidget(int pageIndex, String annotPtr,
            HashMap<String, Object> properties) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation != null) {
            CPDFWidget widget = (CPDFWidget) annotation;
            FlutterCPDFWidget rcpdfWidget = widgetsImpls.get(widget.getWidgetType());
            if (rcpdfWidget != null) {
                if (rcpdfWidget instanceof FlutterCPDFPushbuttonWidget) {
                    ((FlutterCPDFPushbuttonWidget) rcpdfWidget).setDocument(document);
                }
                rcpdfWidget.updateWidget(widget, properties);
                annotation.updateAp();
            }
        }
        return false;
    }

    public Map<String, Object> parseCustomContextMenuEvent(Map<String, Object> extraMap) {
        Map<String, Object> result = new HashMap<>();
        if (extraMap == null) {
            return result;
        }
        for (Map.Entry<String, Object> entry : extraMap.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            switch (key) {
                case "rect":
                    if (value instanceof RectF) {
                        RectF rectF = (RectF) value;
                        Map<String, Float> rectMap = new HashMap<>();
                        rectMap.put("left", rectF.left);
                        rectMap.put("top", rectF.top);
                        rectMap.put("right", rectF.right);
                        rectMap.put("bottom", rectF.bottom);
                        result.put("rect", rectMap);
                    }
                    break;
                case "widget":
                    if (value instanceof CPDFWidget) {
                        CPDFWidget widget = (CPDFWidget) value;
                        result.put("widget", getWidgetData(widget));
                    }
                    break;
                case "annotation":
                    if (value instanceof CPDFAnnotation) {
                        CPDFAnnotation annotation = (CPDFAnnotation) value;
                        result.put("annotation", getAnnotationData(annotation));
                    }
                    break;
                case "editArea":
                    if (value instanceof CPDFEditImageArea) {
                        Map<String, Object> editAreaMap = CPDFEditAreaUtil.getEditImageAreaMap(
                                (CPDFEditImageArea) value);
                        result.put("editArea", editAreaMap);
                    } else if (value instanceof CPDFEditPathArea) {
                        Map<String, Object> editAreaMap = CPDFEditAreaUtil.getEditPathAreaMap(
                                (CPDFEditPathArea) value);
                        result.put("editArea", editAreaMap);
                    } else if (value instanceof CPDFEditTextSelections) {
                        Map<String, Object> editAreaMap = CPDFEditAreaUtil.getEditTextAreaMap(
                                (CPDFEditTextSelections) value);
                        result.put("editArea", editAreaMap);
                    }
                    break;
                case "point":
                    PointF pointF = (PointF) value;
                    Map<String, Object> pointMap = new HashMap<>();
                    pointMap.put("x", pointF.x);
                    pointMap.put("y", pointF.y);
                    result.put("point", pointMap);
                    break;
                case "image":
                    // screenshot Context menu.
                    if (value instanceof Bitmap) {
                        Bitmap bitmap = (Bitmap) value;
                        ByteArrayOutputStream pngStream = new ByteArrayOutputStream();
                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, pngStream);
                        byte[] pngByteArray = pngStream.toByteArray();
                        result.put("image", pngByteArray);
                    }
                    break;
                default:
                    result.put(key, value);
                    break;
            }
        }
        return result;
    }

    public boolean addAnnotations(@Nullable CPDFReaderView readerView, List<HashMap<String, Object>> annotations) {
        if (document == null) {
            return false;
        }
        boolean allSuccess = true;
        HashSet<Integer> pageIndexes = new HashSet<>();
        for (HashMap<String, Object> annotMap : annotations) {
            int pageIndex = (int) annotMap.get("page");
            String annotationType = annotMap.get("type").toString();
            CPDFAnnotation.Type type = CPDFEnumConvertUtil.stringToCPDFAnnotType(annotationType);
            pageIndexes.add(pageIndex);
            if (pageIndex < 0 || pageIndex >= document.getPageCount()) {
                Log.w("ComPDFKit", "Failed to add annotation of type: " + annotationType
                        + " due to invalid page index: " + pageIndex + ". Skipping.");
                continue;
            }
            FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(type);
            if (rcpdfAnnotation != null) {
                if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation) {
                    ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
                }
                CPDFAnnotation annotation = rcpdfAnnotation.addAnnotation(document, annotMap);
                if (annotation != null && annotation.isValid()) {
                    CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
                    if (pageView != null) {
                        pageView.addAnnotation(annotation, false);
                    }
                } else {
                    allSuccess = false;
                }
            } else {
                allSuccess = false;
            }
        }
        return allSuccess;
    }

    public boolean addWidgets(@Nullable CPDFReaderView readerView, List<HashMap<String, Object>> widgets) {
        if (document == null) {
            return false;
        }
        boolean allSuccess = true;
        HashSet<Integer> pageIndexes = new HashSet<>();
        for (HashMap<String, Object> widgetMap : widgets) {
            int pageIndex = (int) widgetMap.get("page");
            String widgetTypeStr = widgetMap.get("type").toString();
            WidgetType type = CPDFEnumConvertUtil.stringToWidgetType(widgetTypeStr);
            pageIndexes.add(pageIndex);
            if (pageIndex < 0 || pageIndex >= document.getPageCount()) {
                Log.w("ComPDFKit", "Failed to add widget of type: " + widgetTypeStr + " due to invalid page index: "
                        + pageIndex + ". Skipping.");
                continue;
            }
            FlutterCPDFWidget cpdfWidget = widgetsImpls.get(type);
            if (cpdfWidget != null) {
                if (cpdfWidget instanceof FlutterCPDFPushbuttonWidget) {
                    ((FlutterCPDFPushbuttonWidget) cpdfWidget).setDocument(document);
                }
                CPDFWidget widget = cpdfWidget.addWidget(document, widgetMap);
                if (widget != null && widget.isValid()) {
                    CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
                    if (pageView != null) {
                        pageView.addAnnotation(widget, false);
                    }
                } else {
                    allSuccess = false;
                }
            } else {
                allSuccess = false;
            }
        }
        return allSuccess;
    }
}
