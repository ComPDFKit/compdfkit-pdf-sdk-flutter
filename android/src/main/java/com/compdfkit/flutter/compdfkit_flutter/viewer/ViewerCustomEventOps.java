/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.tools.common.utils.customevent.CPDFCustomEventField;
import com.compdfkit.tools.common.utils.customevent.CPDFCustomEventType;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CStyleType;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

public final class ViewerCustomEventOps {

    private static final String EVENT_ANNOTATION_STYLE_DIALOG_DISMISSED = "onAnnotationStyleDialogDismissed";
    private static final String EVENT_FORM_STYLE_DIALOG_DISMISSED = "onFormStyleDialogDismissed";
    private static final String EVENT_CONTENT_EDITOR_STYLE_DIALOG_DISMISSED = "onContentEditorStyleDialogDismissed";

    private static final String EVENT_ADD_WATERMARK_DIALOG_DISMISSED = "onAddWatermarkDialogDismissed";

    private static final String EVENT_SEARCH_BACK_BUTTON_TAPPED = "onSearchBackButtonTapped";

    private ViewerCustomEventOps() {
    }

    public static void handle(MethodChannel channel, CPDFViewContext viewContext,
            Map<String, Object> extraMap) {
        String customEventType = String.valueOf(extraMap.get("customEventType"));
        CPDFDocumentPlugin documentPlugin = viewContext.getDocumentPlugin();
        CPDFReaderView readerView = viewContext.getReaderView();

        switch (customEventType) {
            case CPDFCustomEventType.ADD_WATERMARK_DIALOG_DISMISSED:
                ViewerEventDispatcher.dispatch(channel, EVENT_ADD_WATERMARK_DIALOG_DISMISSED, null);
                return;
            case CPDFCustomEventType.SEARCH_BACK_BUTTON_TAPPED:
                ViewerEventDispatcher.dispatch(channel, EVENT_SEARCH_BACK_BUTTON_TAPPED, null);
                return;
            case CPDFCustomEventType.ANNOTATION_STYLE_DIALOG_DISMISSED:
                Map<String, Object> data = new HashMap<>();
                data.put("type", CPDFEnumConvertUtil.styleTypeToString(
                    CStyleType.valueOf(extraMap.get(CPDFCustomEventField.STYLE_TYPE).toString())));

                ViewerEventDispatcher.dispatch(channel, EVENT_ANNOTATION_STYLE_DIALOG_DISMISSED, data);
                return;

            case CPDFCustomEventType.FORM_STYLE_DIALOG_DISMISSED:
                Map<String, Object> eventData1 = new HashMap<>();
                eventData1.put("type", CPDFEnumConvertUtil.styleTypeToString(
                    CStyleType.valueOf(extraMap.get(CPDFCustomEventField.STYLE_TYPE).toString())));

                ViewerEventDispatcher.dispatch(channel, EVENT_FORM_STYLE_DIALOG_DISMISSED, eventData1);
                return;
            case CPDFCustomEventType.CONTENT_EDITOR_STYLE_DIALOG_DISMISSED:
                Map<String, Object> eventData2 = new HashMap<>();
                eventData2.put("type", CPDFEnumConvertUtil.styleTypeToString(
                    CStyleType.valueOf(extraMap.get(CPDFCustomEventField.STYLE_TYPE).toString())));
                ViewerEventDispatcher.dispatch(channel, EVENT_CONTENT_EDITOR_STYLE_DIALOG_DISMISSED, eventData2);
                return;
            case CPDFCustomEventType.TOOLBAR_ITEM_TAPPED:
                ViewerEventDispatcher.dispatch(channel, "onCustomToolbarItemTapped",
                        extraMap.get("identifier"));
                return;
            case CPDFCustomEventType.CONTEXT_MENU_ITEM_TAPPED:
                if (readerView != null && readerView.getPDFDocument() != null) {
                    documentPlugin.getPageUtil().setDocument(readerView.getPDFDocument());
                }
                Map<String, Object> eventData = documentPlugin.getPageUtil()
                        .parseCustomContextMenuEvent(extraMap);
                ViewerEventDispatcher.dispatch(channel, "onCustomContextMenuItemTapped",
                        eventData);
                return;
            case CPDFCustomEventType.INTERCEPT_ANNOTATION_DO_ACTION:
                dispatchAnnotationAction(channel, documentPlugin, readerView, extraMap,
                        CPDFCustomEventField.ANNOTATION, "onInterceptAnnotationAction");
                return;
            case CPDFCustomEventType.INTERCEPT_WIDGET_DO_ACTION:
                dispatchAnnotationAction(channel, documentPlugin, readerView, extraMap,
                        CPDFCustomEventField.WIDGET, "onInterceptWidgetAction");
                return;
            default:
                return;
        }
    }

    private static void dispatchAnnotationAction(MethodChannel channel,
            CPDFDocumentPlugin documentPlugin, CPDFReaderView readerView,
            Map<String, Object> extraMap, String payloadKey, String eventName) {
        if (!extraMap.containsKey(payloadKey) || readerView == null || readerView.getPDFDocument() == null) {
            return;
        }
        CPDFAnnotation annotation = (CPDFAnnotation) extraMap.get(payloadKey);
        if (annotation == null) {
            return;
        }
        HashMap<String, Object> annotData = ViewerAnnotationCodec.encode(documentPlugin,
                readerView.getPDFDocument(), annotation);
        ViewerEventDispatcher.dispatch(channel, eventName, annotData);
    }
}