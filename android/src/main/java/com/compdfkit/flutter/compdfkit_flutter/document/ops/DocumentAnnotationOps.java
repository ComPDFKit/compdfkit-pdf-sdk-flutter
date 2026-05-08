/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.codec.CPDFPageCodec;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;

public final class DocumentAnnotationOps {

    private static final String REMOVE_FAIL = "REMOVE_FAIL";
    private static final String UPDATE_ANNOTATION_FAIL = "UPDATE_ANNOTATION_FAIL";

    private DocumentAnnotationOps() {
    }

    public static ArrayList<HashMap<String, Object>> getAnnotations(
            @NonNull CPDFDocumentContext context, int pageIndex) {
        return context.getPageCodec().getAnnotations(pageIndex);
    }

    public static ArrayList<HashMap<String, Object>> getWidgets(@NonNull CPDFDocumentContext context,
            int pageIndex) {
        return context.getPageCodec().getWidgets(pageIndex);
    }

    public static void removeAnnotation(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @NonNull MethodChannel.Result result) {
        CPDFPageCodec pageCodec = context.getPageCodec();
        CPDFAnnotation annotation = pageCodec.getAnnotation(pageIndex, annotPtr);
        if (annotation == null) {
            Log.e("ComPDFKit-Flutter",
                    "not found this annotation, pageIndex:" + pageIndex + ", annotPtr:" + annotPtr);
            result.error(REMOVE_FAIL, "not found this annotation", "");
            return;
        }

        CPDFViewCtrl pdfView = context.getPdfView();
        if (pdfView != null) {
            CPDFPageView pageView = (CPDFPageView) pdfView.getCPdfReaderView().getChild(pageIndex);
            if (pageView != null) {
                CPDFBaseAnnotImpl baseAnnot = pageView.getAnnotImpl(annotation);
                pageView.deleteAnnotation(baseAnnot);
                result.success(true);
                return;
            }
        }
        result.success(pageCodec.deleteAnnotation(pageIndex, annotPtr));
    }

    public static void updateAnnotation(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable HashMap<String, Object> properties,
            @NonNull MethodChannel.Result result) {
        CPDFPageCodec pageCodec = context.getPageCodec();
        CPDFAnnotation annotation = pageCodec.getAnnotation(pageIndex, annotPtr);
        if (annotation == null || !annotation.isValid()) {
            result.error(UPDATE_ANNOTATION_FAIL, "not found this annotation", "");
            return;
        }

        boolean updateResult = pageCodec.updateAnnotation(annotation, properties);
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
            if (pageView != null) {
                CPDFBaseAnnotImpl annotImpl = pageView.getAnnotImpl(annotation);
                if (annotImpl != null) {
                    annotImpl.onAnnotAttrChange();
                } else if (updateResult && annotation.isValid()) {
                    pageView.addAnnotation(annotation, false);
                }
                pageView.invalidate();
            }
        }
        result.success(true);
    }

    public static void updateWidget(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable HashMap<String, Object> properties,
            @NonNull MethodChannel.Result result) {
        CPDFPageCodec pageCodec = context.getPageCodec();
        CPDFAnnotation annotation = pageCodec.getAnnotation(pageIndex, annotPtr);
        if (annotation == null || !annotation.isValid()) {
            result.error(UPDATE_ANNOTATION_FAIL, "not found this annotation", "");
            return;
        }

        pageCodec.updateWidget(pageIndex, annotPtr, properties);
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
            if (pageView != null) {
                CPDFBaseAnnotImpl annotImpl = pageView.getAnnotImpl(annotation);
                if (annotImpl != null) {
                    annotImpl.onAnnotAttrChange();
                }
                pageView.invalidate();
            }
        }
        result.success(true);
    }

    public static boolean addAnnotations(@NonNull CPDFDocumentContext context,
            @Nullable ArrayList<HashMap<String, Object>> annotList) {
        return context.getPageCodec().addAnnotations(context.getReaderView(), annotList);
    }

    public static boolean addWidgets(@NonNull CPDFDocumentContext context,
            @Nullable ArrayList<HashMap<String, Object>> widgetList) {
        return context.getPageCodec().addWidgets(context.getReaderView(), widgetList);
    }

    public static boolean removeAllAnnotations(@NonNull CPDFDocumentContext context) {
        boolean deleteResult = context.requireDocument().removeAllAnnotations();
        if (deleteResult && context.getReaderView() != null) {
            context.getReaderView().invalidateAllChildren();
        }
        return deleteResult;
    }
}