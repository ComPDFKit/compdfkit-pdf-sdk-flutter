/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. This notice
 * may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.PointF;
import android.graphics.RectF;
import android.util.Log;
import androidx.annotation.Nullable;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFReplyAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFComboboxWidget;
import com.compdfkit.core.annotation.form.CPDFListboxWidget;
import com.compdfkit.core.annotation.form.CPDFPushbuttonWidget;
import com.compdfkit.core.annotation.form.CPDFRadiobuttonWidget;
import com.compdfkit.core.annotation.form.CPDFSignatureWidget;
import com.compdfkit.core.annotation.form.CPDFTextWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.utils.TTimeUtil;
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
import com.compdfkit.tools.common.utils.date.CDateUtil;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class CPDFPageUtil {

    private static final String REPLY_STABLE_ID_PREFIX = "compdfkit-flutter-reply:";

    private CPDFDocument document;

    private Context context;

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

    public void setContext(Context context) {
        this.context = context;
        FlutterCPDFAnnotation stampAnnotation = annotImpls.get(Type.STAMP);
        if (stampAnnotation instanceof FlutterCPDFStampAnnotation) {
            ((FlutterCPDFStampAnnotation) stampAnnotation).setContext(context);
        }
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
        FlutterCPDFWidget rcpdfWidget = getWidgetImpl(widget);
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

    public HashMap<String, Object> addAnnotationReply(CPDFAnnotation annotation,
            @Nullable String content, @Nullable String title) {
        if (annotation == null || !annotation.isValid()) {
            return null;
        }
        CPDFReplyAnnotation reply = annotation.createReplyAnnotation();
        if (reply == null || !reply.isValid()) {
            return null;
        }
        if (content != null) {
            reply.setContent(content);
        }
        if (title != null) {
            reply.setTitle(title);
        }
        ensureReplyStableId(reply);
        reply.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
        return getReplyAnnotationData(reply, annotation, getReplyIndex(annotation, reply));
    }

    public ArrayList<HashMap<String, Object>> getAnnotationReplies(CPDFAnnotation annotation) {
        ArrayList<HashMap<String, Object>> replies = new ArrayList<>();
        if (annotation == null || !annotation.isValid()) {
            return replies;
        }
        CPDFReplyAnnotation[] replyAnnotations = annotation.getAllReplyAnnotations();
        if (replyAnnotations == null) {
            return replies;
        }
        for (int i = 0; i < replyAnnotations.length; i++) {
            CPDFReplyAnnotation reply = replyAnnotations[i];
            if (reply == null || !reply.isValid()) {
                continue;
            }
            HashMap<String, Object> map = getReplyAnnotationData(reply, annotation, i);
            if (map != null) {
                replies.add(map);
            }
        }
        return replies;
    }

    public boolean updateAnnotationReply(int pageIndex, String replyId, @Nullable String nativeId,
            @Nullable String replyKey, @Nullable String parentUuid,
            @Nullable String content, @Nullable String title) {
        CPDFReplyAnnotation reply = getReplyAnnotation(pageIndex, replyId, nativeId, replyKey,
                parentUuid);
        if (reply == null || !reply.isValid()) {
            return false;
        }
        if (content != null) {
            reply.setContent(content);
        }
        if (title != null) {
            reply.setTitle(title);
        }
        reply.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
        return true;
    }

    public boolean removeAnnotationReply(int pageIndex, String replyId, @Nullable String nativeId,
            @Nullable String replyKey, @Nullable String parentUuid) {
        CPDFReplyAnnotation reply = getReplyAnnotation(pageIndex, replyId, nativeId, replyKey,
                parentUuid);
        if (reply == null || !reply.isValid()) {
            return false;
        }
        CPDFPage page = reply.pdfPage != null ? reply.pdfPage : document.pageAtIndex(pageIndex);
        return page != null && page.deleteAnnotation(reply);
    }

    public boolean removeAllAnnotationReplies(CPDFAnnotation annotation) {
        if (annotation == null || !annotation.isValid()) {
            return false;
        }
        CPDFReplyAnnotation[] replyAnnotations = annotation.getAllReplyAnnotations();
        if (replyAnnotations == null || replyAnnotations.length == 0) {
            return true;
        }
        boolean result = true;
        for (CPDFReplyAnnotation reply : replyAnnotations) {
            if (reply == null || !reply.isValid()) {
                continue;
            }
            CPDFPage page = reply.pdfPage != null ? reply.pdfPage : annotation.pdfPage;
            if (page == null) {
                result = false;
                continue;
            }
            result = page.deleteAnnotation(reply) && result;
        }
        return result;
    }

    public boolean setAnnotationMarkState(CPDFAnnotation annotation, @Nullable String state) {
        if (annotation == null || !annotation.isValid()) {
            return false;
        }
        return annotation.setMarkedAnnotState(stringToMarkState(state));
    }

    public String getAnnotationMarkState(CPDFAnnotation annotation) {
        if (annotation == null || !annotation.isValid()) {
            return "unmarked";
        }
        CPDFAnnotation.MarkState state = annotation.getMarkedAnnotState();
        return state == CPDFAnnotation.MarkState.MARKED ? "marked" : "unmarked";
    }

    public boolean setAnnotationReviewState(CPDFAnnotation annotation, @Nullable String state) {
        if (annotation == null || !annotation.isValid()) {
            return false;
        }
        return annotation.setReviewAnnotState(stringToReviewState(state));
    }

    public String getAnnotationReviewState(CPDFAnnotation annotation) {
        if (annotation == null || !annotation.isValid()) {
            return "none";
        }
        return reviewStateToString(annotation.getReviewAnnotState());
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
            FlutterCPDFWidget rcpdfWidget = getWidgetImpl(widget);
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
        CPDFWidget widget = (CPDFWidget) annotation;
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
        if (document == null || annotPtr == null) {
            return null;
        }
        long targetPtr;
        try {
            targetPtr = Long.parseLong(annotPtr);
        } catch (NumberFormatException e) {
            return null;
        }
        CPDFPage page = document.pageAtIndex(pageIndex);
        List<CPDFAnnotation> annotations = page.getAnnotations();
        if (annotations == null || !page.isValid()) {
            return null;
        }
        for (CPDFAnnotation annotation : annotations) {
            if (annotation.getAnnotPtr() == targetPtr) {
                return annotation;
            }
        }
        return null;
    }

    private FlutterCPDFWidget getWidgetImpl(CPDFWidget widget) {
        if (widget instanceof CPDFTextWidget) {
            return widgetsImpls.get(WidgetType.Widget_TextField);
        } else if (widget instanceof CPDFCheckboxWidget) {
            return widgetsImpls.get(WidgetType.Widget_CheckBox);
        } else if (widget instanceof CPDFRadiobuttonWidget) {
            return widgetsImpls.get(WidgetType.Widget_RadioButton);
        } else if (widget instanceof CPDFListboxWidget) {
            return widgetsImpls.get(WidgetType.Widget_ListBox);
        } else if (widget instanceof CPDFComboboxWidget) {
            return widgetsImpls.get(WidgetType.Widget_ComboBox);
        } else if (widget instanceof CPDFSignatureWidget) {
            return widgetsImpls.get(WidgetType.Widget_SignatureFields);
        } else if (widget instanceof CPDFPushbuttonWidget) {
            return widgetsImpls.get(WidgetType.Widget_PushButton);
        }
        return widgetsImpls.get(widget.getWidgetType());
    }

    public CPDFAnnotation getAnnotationOrReply(int pageIndex, String annotPtr) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation != null) {
            return annotation;
        }
        return getReplyAnnotation(pageIndex, annotPtr);
    }

    public CPDFAnnotation getAnnotationOrReply(int pageIndex, String annotPtr,
            @Nullable String nativeId, @Nullable String replyKey, @Nullable String parentUuid) {
        CPDFAnnotation annotation = getAnnotation(pageIndex, annotPtr);
        if (annotation != null) {
            return annotation;
        }
        return getReplyAnnotation(pageIndex, annotPtr, nativeId, replyKey, parentUuid);
    }

    public CPDFReplyAnnotation getReplyAnnotation(int pageIndex, String annotPtr) {
        return getReplyAnnotation(pageIndex, annotPtr, null, null, null);
    }

    public CPDFReplyAnnotation getReplyAnnotation(int pageIndex, String replyId,
            @Nullable String nativeId, @Nullable String replyKey, @Nullable String parentUuid) {
        if (document == null || replyId == null) {
            return null;
        }
        CPDFReplyAnnotation reply = getReplyAnnotationFromPage(pageIndex, replyId, nativeId,
                replyKey, parentUuid);
        if (reply != null) {
            return reply;
        }
        int pageCount = document.getPageCount();
        for (int i = 0; i < pageCount; i++) {
            if (i == pageIndex) {
                continue;
            }
            reply = getReplyAnnotationFromPage(i, replyId, nativeId, replyKey, parentUuid);
            if (reply != null) {
                return reply;
            }
        }
        return null;
    }

    private CPDFReplyAnnotation getReplyAnnotationFromPage(int pageIndex, String replyId,
            @Nullable String nativeId, @Nullable String replyKey, @Nullable String parentUuid) {
        if (pageIndex < 0 || pageIndex >= document.getPageCount()) {
            return null;
        }
        CPDFPage page = document.pageAtIndex(pageIndex);
        if (page == null || !page.isValid()) {
            return null;
        }
        List<CPDFAnnotation> annotations = page.getAnnotations();
        if (annotations == null) {
            return null;
        }
        for (CPDFAnnotation annotation : annotations) {
            if (annotation == null || !annotation.isValid()) {
                continue;
            }
            CPDFReplyAnnotation[] replies = annotation.getAllReplyAnnotations();
            if (replies == null) {
                continue;
            }
            for (int i = 0; i < replies.length; i++) {
                CPDFReplyAnnotation reply = replies[i];
                if (isTargetReply(annotation, reply, i, replyId, nativeId, replyKey, parentUuid)) {
                    return reply;
                }
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

    private HashMap<String, Object> getReplyAnnotationData(CPDFReplyAnnotation reply,
            @Nullable CPDFAnnotation parent, int replyIndex) {
        if (reply == null || !reply.isValid()) {
            return null;
        }
        String nativeId = reply.getAnnotPtr() + "";
        String parentUuid = parent != null ? parent.getAnnotPtr() + "" : "";
        String stableId = reply.getName();
        HashMap<String, Object> map = new HashMap<>();
        map.put("type", "unknown");
        map.put("page", reply.pdfPage.getPageNum());
        map.put("title", reply.getTitle());
        map.put("content", reply.getContent());
        map.put("uuid", hasText(stableId) ? stableId : nativeId);
        map.put("nativeId", nativeId);
        map.put("replyKey", buildReplyKey(parent, reply, replyIndex));
        map.put("parentUuid", parentUuid);
        RectF rect = reply.getRect();
        if (rect != null) {
            Map<String, Float> rectMap = new HashMap<>();
            rectMap.put("left", CAppUtils.roundTo2f(rect.left));
            rectMap.put("top", CAppUtils.roundTo2f(rect.top));
            rectMap.put("right", CAppUtils.roundTo2f(rect.right));
            rectMap.put("bottom", CAppUtils.roundTo2f(rect.bottom));
            map.put("rect", rectMap);
        }
        if (reply.getCreationDate() != null) {
            map.put("createDate", CDateUtil.transformToTimestamp(reply.getCreationDate()));
        }
        if (reply.getRecentlyModifyDate() != null) {
            map.put("modifyDate", CDateUtil.transformToTimestamp(reply.getRecentlyModifyDate()));
        }
        map.put("markState", getAnnotationMarkState(reply));
        map.put("reviewState", getAnnotationReviewState(reply));
        return map;
    }

    private boolean isTargetReply(@Nullable CPDFAnnotation parent,
            @Nullable CPDFReplyAnnotation reply, int replyIndex, @Nullable String replyId,
            @Nullable String nativeId, @Nullable String replyKey, @Nullable String parentUuid) {
        if (reply == null || !reply.isValid()) {
            return false;
        }
        String stableId = reply.getName();
        if (hasText(stableId) && stableId.equals(replyId)) {
            return true;
        }
        String runtimeId = reply.getAnnotPtr() + "";
        if (runtimeId.equals(replyId) || runtimeId.equals(nativeId)) {
            return true;
        }
        if (hasText(replyKey) && replyKey.equals(buildReplyKey(parent, reply, replyIndex))) {
            return true;
        }
        return hasText(parentUuid) && parent != null
                && parentUuid.equals(parent.getAnnotPtr() + "") && runtimeId.equals(replyId);
    }

    private String ensureReplyStableId(CPDFReplyAnnotation reply) {
        String name = reply.getName();
        if (hasText(name)) {
            return name;
        }
        String stableId = REPLY_STABLE_ID_PREFIX + UUID.randomUUID();
        if (reply.setName(stableId)) {
            return stableId;
        }
        name = reply.getName();
        return hasText(name) ? name : "";
    }

    private int getReplyIndex(CPDFAnnotation parent, CPDFReplyAnnotation targetReply) {
        CPDFReplyAnnotation[] replies = parent.getAllReplyAnnotations();
        if (replies == null) {
            return -1;
        }
        for (int i = 0; i < replies.length; i++) {
            CPDFReplyAnnotation reply = replies[i];
            if (reply != null && reply.isValid()
                    && reply.getAnnotPtr() == targetReply.getAnnotPtr()) {
                return i;
            }
        }
        return -1;
    }

    private String buildReplyKey(@Nullable CPDFAnnotation parent,
            @Nullable CPDFReplyAnnotation reply, int replyIndex) {
        if (reply == null || !reply.isValid()) {
            return "";
        }
        String parentUuid = parent != null ? parent.getAnnotPtr() + "" : "";
        RectF rect = reply.getRect();
        return parentUuid + "|" + replyIndex + "|" + safeString(reply.getTitle()) + "|"
                + safeString(reply.getContent()) + "|" + dateToMillis(reply.getCreationDate()) + "|"
                + dateToMillis(reply.getRecentlyModifyDate()) + "|" + rectKey(rect);
    }

    private long dateToMillis(@Nullable CPDFDate date) {
        if (date == null) {
            return 0L;
        }
        return CDateUtil.transformToTimestamp(date);
    }

    private String rectKey(@Nullable RectF rect) {
        if (rect == null) {
            return "";
        }
        return CAppUtils.roundTo2f(rect.left) + "," + CAppUtils.roundTo2f(rect.top) + ","
                + CAppUtils.roundTo2f(rect.right) + "," + CAppUtils.roundTo2f(rect.bottom);
    }

    private String safeString(@Nullable String value) {
        return value == null ? "" : value;
    }

    private boolean hasText(@Nullable String value) {
        return value != null && value.length() > 0;
    }

    private CPDFAnnotation.MarkState stringToMarkState(@Nullable String state) {
        if ("marked".equals(state)) {
            return CPDFAnnotation.MarkState.MARKED;
        }
        return CPDFAnnotation.MarkState.UNMARKED;
    }

    private CPDFAnnotation.ReviewState stringToReviewState(@Nullable String state) {
        if ("accepted".equals(state)) {
            return CPDFAnnotation.ReviewState.REVIEW_ACCEPTED;
        }
        if ("rejected".equals(state)) {
            return CPDFAnnotation.ReviewState.REVIEW_REJECTED;
        }
        if ("cancelled".equals(state)) {
            return CPDFAnnotation.ReviewState.REVIEW_CANCELLED;
        }
        if ("completed".equals(state)) {
            return CPDFAnnotation.ReviewState.REVIEW_COMPLETED;
        }
        if ("error".equals(state)) {
            return CPDFAnnotation.ReviewState.REVIEW_ERROR;
        }
        return CPDFAnnotation.ReviewState.REVIEW_NONE;
    }

    private String reviewStateToString(CPDFAnnotation.ReviewState state) {
        if (state == CPDFAnnotation.ReviewState.REVIEW_ACCEPTED) {
            return "accepted";
        }
        if (state == CPDFAnnotation.ReviewState.REVIEW_REJECTED) {
            return "rejected";
        }
        if (state == CPDFAnnotation.ReviewState.REVIEW_CANCELLED) {
            return "cancelled";
        }
        if (state == CPDFAnnotation.ReviewState.REVIEW_COMPLETED) {
            return "completed";
        }
        if (state == CPDFAnnotation.ReviewState.REVIEW_ERROR) {
            return "error";
        }
        return "none";
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
        if (document == null || annotations == null) {
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
                allSuccess = false;
                continue;
            }
            FlutterCPDFAnnotation rcpdfAnnotation = annotImpls.get(type);
            if (rcpdfAnnotation != null) {
                if (rcpdfAnnotation instanceof FlutterCPDFLinkAnnotation) {
                    ((FlutterCPDFLinkAnnotation) rcpdfAnnotation).setDocument(document);
                }
                CPDFAnnotation annotation = rcpdfAnnotation.addAnnotation(document, annotMap);
                if (annotation != null && annotation.isValid()) {
                    if (readerView != null) {
                        CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
                        if (pageView != null) {
                            pageView.addAnnotation(annotation, false);
                        }
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
        if (document == null || widgets == null) {
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
                allSuccess = false;
                continue;
            }
            FlutterCPDFWidget cpdfWidget = widgetsImpls.get(type);
            if (cpdfWidget != null) {
                if (cpdfWidget instanceof FlutterCPDFPushbuttonWidget) {
                    ((FlutterCPDFPushbuttonWidget) cpdfWidget).setDocument(document);
                }
                CPDFWidget widget = cpdfWidget.addWidget(document, widgetMap);
                if (widget != null && widget.isValid()) {
                    if (readerView != null) {
                        CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
                        if (pageView != null) {
                            pageView.addAnnotation(widget, false);
                        }
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
