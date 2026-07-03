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
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.codec.CPDFPageCodec;
import com.compdfkit.tools.common.utils.annotation.CAnnotationCreationContext;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.proxy.form.CPDFSignatureWidgetImpl;
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

    public static void addAnnotationReply(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String content, @Nullable String title,
            @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotation(pageIndex, annotPtr);
        if (annotation == null || !annotation.isValid()) {
            result.success(null);
            return;
        }
        HashMap<String, Object> reply = context.getPageCodec().addAnnotationReply(annotation,
                content, title);
        refreshReaderView(context, pageIndex);
        result.success(reply);
    }

    public static void getAnnotationReplies(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotation(pageIndex, annotPtr);
        if (annotation == null || !annotation.isValid()) {
            result.success(new ArrayList<HashMap<String, Object>>());
            return;
        }
        result.success(context.getPageCodec().getAnnotationReplies(annotation));
    }

    public static void updateAnnotationReply(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @Nullable String content, @Nullable String title,
            @NonNull MethodChannel.Result result) {
        boolean updated = context.getPageCodec().updateAnnotationReply(pageIndex, annotPtr, nativeId,
                replyKey, parentUuid, content, title);
        if (!updated) {
            result.success(false);
            return;
        }
        refreshReaderView(context, pageIndex);
        result.success(true);
    }

    public static void removeAnnotationReply(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @NonNull MethodChannel.Result result) {
        boolean removed = context.getPageCodec().removeAnnotationReply(pageIndex, annotPtr, nativeId,
                replyKey, parentUuid);
        if (!removed) {
            result.success(false);
            return;
        }
        refreshReaderView(context, pageIndex);
        result.success(true);
    }

    public static void removeAllAnnotationReplies(@NonNull CPDFDocumentContext context,
            int pageIndex, @NonNull String annotPtr, @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotation(pageIndex, annotPtr);
        if (annotation == null || !annotation.isValid()) {
            result.success(false);
            return;
        }
        boolean removed = context.getPageCodec().removeAllAnnotationReplies(annotation);
        refreshReaderView(context, pageIndex);
        result.success(removed);
    }

    public static void setAnnotationMarkState(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @Nullable String markState,
            @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotationOrReply(pageIndex,
                annotPtr, nativeId, replyKey, parentUuid);
        if (annotation == null || !annotation.isValid()) {
            result.success(false);
            return;
        }
        result.success(context.getPageCodec().setAnnotationMarkState(annotation, markState));
    }

    public static void getAnnotationMarkState(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotationOrReply(pageIndex,
                annotPtr, nativeId, replyKey, parentUuid);
        if (annotation == null || !annotation.isValid()) {
            result.success("unmarked");
            return;
        }
        result.success(context.getPageCodec().getAnnotationMarkState(annotation));
    }

    public static void setAnnotationReviewState(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @Nullable String reviewState,
            @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotationOrReply(pageIndex,
                annotPtr, nativeId, replyKey, parentUuid);
        if (annotation == null || !annotation.isValid()) {
            result.success(false);
            return;
        }
        result.success(context.getPageCodec().setAnnotationReviewState(annotation, reviewState));
    }

    public static void getAnnotationReviewState(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr, @Nullable String nativeId, @Nullable String replyKey,
            @Nullable String parentUuid, @NonNull MethodChannel.Result result) {
        CPDFAnnotation annotation = context.getPageCodec().getAnnotationOrReply(pageIndex,
                annotPtr, nativeId, replyKey, parentUuid);
        if (annotation == null || !annotation.isValid()) {
            result.success("none");
            return;
        }
        result.success(context.getPageCodec().getAnnotationReviewState(annotation));
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

        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
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
        return CAnnotationCreationContext.callProgrammatic(
                () -> context.getPageCodec().addAnnotations(context.getReaderView(), annotList));
    }

    public static boolean addWidgets(@NonNull CPDFDocumentContext context,
            @Nullable ArrayList<HashMap<String, Object>> widgetList) {
        return CAnnotationCreationContext.callProgrammatic(
                () -> context.getPageCodec().addWidgets(context.getReaderView(), widgetList));
    }

    public static void addWidgetImageSignature(@NonNull CPDFDocumentContext context,
            int pageIndex, @NonNull String annotPtr, @Nullable String imagePath,
            @NonNull MethodChannel.Result result) {
        boolean success = context.getPageCodec().addWidgetImageSignature(pageIndex, annotPtr,
                imagePath);
        if (success) {
            refreshSignatureWidget(context, pageIndex, annotPtr);
        }
        result.success(success);
    }

    public static boolean removeAllAnnotations(@NonNull CPDFDocumentContext context) {
        boolean deleteResult = context.requireDocument().removeAllAnnotations();
        CPDFReaderView readerView = context.getReaderView();
        if (deleteResult && readerView != null) {
            readerView.invalidateAllChildren();
        }
        return deleteResult;
    }

    private static void refreshReaderView(@NonNull CPDFDocumentContext context, int pageIndex) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView == null) {
            return;
        }
        CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
        if (pageView != null) {
            pageView.invalidate();
        } else {
            readerView.invalidateAllChildren();
        }
    }

    private static void refreshSignatureWidget(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String annotPtr) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView == null) {
            return;
        }
        CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
        if (pageView == null) {
            readerView.invalidateAllChildren();
            return;
        }
        CPDFAnnotation annotation = context.getPageCodec().getAnnotation(pageIndex, annotPtr);
        if (annotation instanceof CPDFWidget) {
            CPDFBaseAnnotImpl annotImpl = pageView.getAnnotImpl(annotation);
            if (annotImpl instanceof CPDFSignatureWidgetImpl) {
                ((CPDFSignatureWidgetImpl) annotImpl).refresh();
            } else if (annotImpl != null) {
                annotImpl.onAnnotAttrChange();
            }
        }
        pageView.invalidate();
    }
}
