/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATIONS_VISIBLE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHANGE_EDIT_TYPE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CLEAR_DISPLAY_RECT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.DISMISS_CONTEXT_MENU;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ENTER_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXIT_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_CURRENT_PAGE_INDEX;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DEFAULT_ANNOTATION_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DEFAULT_WIDGET_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FORM_CREATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_SIZE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_DIGITAL_SIGNATURE_STATUS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_ANNOTATIONS_VISIBLE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_PAGE_IN_SCREEN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_IMAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_LINK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_SIGNATURE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_STAMP;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES_2;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_CURRENT_INK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CAN_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DEFAULT_ANNOTATION_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DEFAULT_WIDGET_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DISPLAY_PAGE_INDEX;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FIXED_SCROLL;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_CREATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_MARGIN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SAME_WIDTH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SPACING;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_WIDGET_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ADD_WATERMARK_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ANNOTATION_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_BOTA_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DEFAULT_ANNOTATION_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DISPLAY_SETTINGS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_EDIT_AREA_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_SECURITY_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_THUMBNAIL_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_WIDGET_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_EVENT_SUBSCRIPTION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.VERIFY_DIGITAL_SIGNATURE_STATUS;

import android.content.Context;
import android.graphics.Color;
import android.graphics.RectF;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.edit.CPDFEditArea;
import com.compdfkit.core.edit.OnEditStatusChangeListener;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.flutter.compdfkit_flutter.bridge.BaseMethodChannelPlugin;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEditAreaUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.flutter.compdfkit_flutter.viewer.CPDFViewContext;
import com.compdfkit.flutter.compdfkit_flutter.viewer.CPDFViewRegistry;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ViewerAnnotationCodec;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ViewerCustomEventOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ViewerEventDispatcher;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerAnnotationOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerDisplayOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerEditorOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerPropertyOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerPreviewOps;
import com.compdfkit.flutter.compdfkit_flutter.viewer.ops.ViewerUtilityOps;
import com.compdfkit.tools.common.interfaces.CPDFCustomEventCallback;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.utils.customevent.CPDFCustomEventCallbackHelper;
import com.compdfkit.tools.common.views.pdfproperties.CAnnotationType;
import com.compdfkit.tools.common.views.pdfview.CPDFIReaderViewCallback;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.tools.contenteditor.CEditToolbar;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import com.compdfkit.ui.reader.CPDFSelectAnnotCallback;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CPDFViewCtrlPlugin extends BaseMethodChannelPlugin implements CPDFCustomEventCallback {

    private CPDFDocumentFragment documentFragment;

    private final CPDFViewContext viewContext;

    public CPDFViewCtrlPlugin(Context context, BinaryMessenger binaryMessenger, int viewId) {
        super(context, binaryMessenger);

        // Register document plugin,get document info
        CPDFDocumentPlugin documentPlugin = new CPDFDocumentPlugin(context, binaryMessenger,
                String.valueOf(viewId));
        documentPlugin.register();
        viewContext = new CPDFViewContext(viewId, documentPlugin);
        CPDFViewRegistry.register(viewContext);
    }

    public void setDocumentFragment(CPDFDocumentFragment documentFragment) {
        this.documentFragment = documentFragment;
        viewContext.attachDocumentFragment(documentFragment);
        this.documentFragment.setInitListener((pdfView) -> {
            viewContext.getDocumentPlugin().setReaderView(pdfView);
            viewContext.attachPdfView(pdfView);
            ViewerEventDispatcher.dispatch(methodChannel, "onDocumentIsReady", null);
            pdfView.addReaderViewCallback(new CPDFIReaderViewCallback() {
                @Override
                public void onMoveToChild(int pageIndex) {
                    super.onMoveToChild(pageIndex);
                    io.flutter.Log.e("ComPDFKit", "onMoveToChild:" + pageIndex);
                    Map<String, Object> map = new HashMap<>();
                    map.put("pageIndex", pageIndex);
                    ViewerEventDispatcher.dispatch(methodChannel, "onPageChanged", map);
                }

                @Override
                public void onTapMainDocArea() {
                    super.onTapMainDocArea();
                    ViewerEventDispatcher.dispatch(methodChannel, "onTapMainDocArea", null);
                }
            });
            pdfView.setSaveCallback((s, uri) -> {
                ViewerEventDispatcher.dispatch(methodChannel, "saveDocument", "");
            }, e -> {

            });
            CPDFReaderView readerView = pdfView.getCPdfReaderView();
            readerView.getUndoManager().addOnUndoHistoryChangeListener(
                    (cpdfUndoManager, operation, type) -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("canUndo", cpdfUndoManager.canUndo());
                        map.put("canRedo", cpdfUndoManager.canRedo());
                        ViewerEventDispatcher.dispatch(methodChannel,
                                "onAnnotationHistoryChanged", map);
                    });

            pdfView.addEditStatusChangeListener(new OnEditStatusChangeListener() {
                @Override
                public void onBegin(int i) {

                }

                @Override
                public void onUndoRedo(int pageIndex, boolean canUndo, boolean canRedo) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("canUndo", canUndo);
                    map.put("canRedo", canRedo);
                    map.put("pageIndex", pageIndex);
                    ViewerEventDispatcher.dispatch(methodChannel,
                            "onContentEditorHistoryChanged", map);
                }

                @Override
                public void onExit() {

                }
            });
            documentFragment.setAddAnnotCallback((cpdfPageView, cpdfBaseAnnot) -> {
                String eventName = cpdfBaseAnnot.getAnnotType() == Type.WIDGET
                        ? "formFieldsCreated" : "annotationsCreated";
                // Only parse and send data when event is subscribed
                if (viewContext.getSubscribedEvents().contains(eventName)) {
                    HashMap<String, Object> annotData = ViewerAnnotationCodec.encode(
                        viewContext.getDocumentPlugin(),
                            documentFragment.pdfView.getCPdfReaderView()
                                    .getPDFDocument(),
                            cpdfBaseAnnot.onGetAnnotation());
                    ViewerEventDispatcher.dispatchIfSubscribed(methodChannel, viewContext,
                        eventName, annotData);
                }
            });

            readerView.setSelectAnnotCallback(new CPDFSelectAnnotCallback() {
                @Override
                public void onAnnotationSelected(CPDFPageView cpdfPageView,
                        CPDFBaseAnnotImpl<CPDFAnnotation> cpdfBaseAnnot) {
                    String eventName = cpdfBaseAnnot.getAnnotType() == Type.WIDGET
                            ? "formFieldsSelected" : "annotationsSelected";
                    // Only parse and send data when event is subscribed
                        if (viewContext.getSubscribedEvents().contains(eventName)) {
                        HashMap<String, Object> annotData = ViewerAnnotationCodec.encode(
                            viewContext.getDocumentPlugin(),
                                documentFragment.pdfView.getCPdfReaderView()
                                        .getPDFDocument(),
                                cpdfBaseAnnot.onGetAnnotation());
                        ViewerEventDispatcher.dispatchIfSubscribed(methodChannel, viewContext,
                            eventName, annotData);
                    }
                }

                @Override
                public void onAnnotationDeselected(CPDFPageView cpdfPageView,
                        @Nullable CPDFBaseAnnotImpl<CPDFAnnotation> cpdfBaseAnnot) {
                    if (cpdfBaseAnnot != null) {
                        String eventName = cpdfBaseAnnot.getAnnotType() == Type.WIDGET
                                ? "formFieldsDeselected" : "annotationsDeselected";
                        // Only parse and send data when event is subscribed
                        if (viewContext.getSubscribedEvents().contains(eventName)) {
                            HashMap<String, Object> annotData = ViewerAnnotationCodec.encode(
                                viewContext.getDocumentPlugin(),
                                    documentFragment.pdfView.getCPdfReaderView()
                                            .getPDFDocument(),
                                    cpdfBaseAnnot.onGetAnnotation());
                            ViewerEventDispatcher.dispatchIfSubscribed(methodChannel, viewContext,
                                    eventName, annotData);
                        }
                    }
                }
            });

            pdfView.addSelectEditAreaChangeListener(type -> {
                if (type == CEditToolbar.SELECT_AREA_NONE) {
                    // Only send event when subscribed
                    if (viewContext.getSubscribedEvents().contains("editorSelectionDeselected")) {
                        ViewerEventDispatcher.dispatchIfSubscribed(methodChannel, viewContext,
                                "editorSelectionDeselected", null);
                    }
                    return;
                }
                // Only parse and send data when editorSelectionSelected is subscribed
                if (!viewContext.getSubscribedEvents().contains("editorSelectionSelected")) {
                    return;
                }
                CPDFEditArea editArea = readerView.getSelectEditArea();
                if (editArea == null) {
                    return;
                }
                CPDFPageView pageView = (CPDFPageView) readerView.getChild(
                        editArea.getPageNum());
                if (pageView == null) {
                    return;
                }
                HashMap<String, Object> map = CPDFEditAreaUtil.getEditAreaMap(pageView,
                        readerView.getSelectEditArea());
                ViewerEventDispatcher.dispatchIfSubscribed(methodChannel, viewContext,
                    "editorSelectionSelected", map);
            });

            documentFragment.annotationToolbar.addAnnotationCreatePreparedListener((type, cpdfAnnotation) -> {
                Map<String, Object> map = new HashMap<>();
                if (type == CAnnotationType.PIC) {
                    map.put("type", "pictures");
                } else {
                    map.put("type", type.name().toLowerCase());
                }
                if (cpdfAnnotation != null) {
                    map.put("annotation", ViewerAnnotationCodec.encode(
                            viewContext.getDocumentPlugin(), readerView.getPDFDocument(),
                            cpdfAnnotation));
                }
                ViewerEventDispatcher.dispatch(methodChannel, "onAnnotationCreationPrepared", map);
            });

        });

        documentFragment.setPageEditDialogOnBackListener(() -> {
            ViewerEventDispatcher.dispatch(methodChannel, "onPageEditDialogBackPress", "");
        });

        documentFragment.setFillScreenChangeListener(isFillScreen -> {
            ViewerEventDispatcher.dispatch(methodChannel, "onFullScreenChanged", isFillScreen);
        });
        CPDFCustomEventCallbackHelper.getInstance().addCustomEventCallback(this);
    }

    @Override
    public void unregister() {
        CPDFCustomEventCallbackHelper.getInstance().removeCustomEventCallback(this);
        CPDFViewRegistry.unregister(viewContext.getViewId());
        viewContext.clear();
        if (viewContext.getDocumentPlugin() != null) {
            viewContext.getDocumentPlugin().unregister();
        }
        documentFragment = null;
        super.unregister();
    }

    @Override
    public void click(Map<String, Object> extraMap) {
        ViewerCustomEventOps.handle(methodChannel, viewContext, extraMap);
    }

    @Override
    public String methodName() {
        return "com.compdfkit.flutter.ui.pdfviewer." + viewContext.getViewId();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:" + call.method);

        if (documentFragment == null) {
            Log.e(LOG_TAG,
                    "CPDFViewCtrlFlutter:onMethodCall: documentFragment is Null return not implemented.");
            result.notImplemented();
        }
        CPDFViewCtrl pdfView = documentFragment.pdfView;
        CPDFReaderView readerView = pdfView.getCPdfReaderView();
        if (ViewerDisplayOps.handle(call, result, context, pdfView, readerView)) {
            return;
        }
        if (ViewerPreviewOps.handle(call, result, documentFragment, pdfView)) {
            return;
        }
        if (ViewerAnnotationOps.handle(call, result, documentFragment, pdfView)) {
            return;
        }
        if (ViewerEditorOps.handle(call, result, documentFragment, readerView)) {
            return;
        }
        if (ViewerUtilityOps.handle(call, result, documentFragment, readerView)) {
            return;
        }
        if (ViewerPropertyOps.handle(call, result, documentFragment, pdfView, readerView,
                viewContext.getDocumentPlugin(), viewContext)) {
            return;
        }
        switch (call.method) {
            case SET_DISPLAY_PAGE_INDEX: {
                int pageIndex = call.argument("pageIndex");

                List<Map<String, Object>> rectList = call.argument("rectList");
                if (rectList != null && rectList.size() > 0) {
                    List<RectF> androidRectList = new ArrayList<>();
                    for (Map<String, Object> rectMap : rectList) {
                        float rectLeft = ((Number) rectMap.get("left")).floatValue();
                        float rectTop = ((Number) rectMap.get("top")).floatValue();
                        float rectRight = ((Number) rectMap.get("right")).floatValue();
                        float rectBottom = ((Number) rectMap.get("bottom")).floatValue();
                        RectF pageRectF = new RectF(rectLeft, rectTop, rectRight, rectBottom);
                        androidRectList.add(convertScreenRectF(readerView, pageIndex, pageRectF));
                    }
                    RectF[] rectArray = androidRectList.toArray(new RectF[0]);
                    readerView.setDisplayPageIndex(pageIndex, rectArray);
                } else {
                    readerView.setDisplayPageIndex(pageIndex);
                }
                result.success(null);
                break;
            }
            case GET_CURRENT_PAGE_INDEX:
                result.success(readerView.getPageNum());
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private RectF convertScreenRectF(CPDFReaderView readerView, int pageIndex, RectF pageRectF) {
        CPDFPage page = readerView.getPDFDocument().pageAtIndex(pageIndex);
        RectF screenPageRect = readerView.getPageSize(pageIndex);
        return page.convertRectFromPage(readerView.isCropMode(), screenPageRect.width(),
                screenPageRect.height(), pageRectF);
    }
}
