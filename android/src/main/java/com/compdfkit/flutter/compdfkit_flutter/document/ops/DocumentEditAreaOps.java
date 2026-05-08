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

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.edit.CPDFEditArea;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEditAreaUtil;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import com.compdfkit.ui.reader.CPDFReaderView.ViewMode;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;

public final class DocumentEditAreaOps {

    private DocumentEditAreaOps() {
    }

    public static void removeEditArea(@NonNull CPDFDocumentContext context, int pageIndex,
            @NonNull String uuid, @NonNull String editAreaType,
            @NonNull MethodChannel.Result result) {
        boolean removed = CPDFEditAreaUtil.removeEditArea(context.requireDocument(), pageIndex,
                uuid, editAreaType);
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null && readerView.getContextMenuShowListener() != null) {
            readerView.getContextMenuShowListener().dismissContextMenu();
        }
        result.success(removed);
    }

    public static void createNewTextArea(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int pageIndex = call.argument("page_index");
        HashMap<String, Object> attr = call.argument("attr");

        HashMap<String, Object> dataMap = new HashMap<>();
        dataMap.put("attr", attr);
        dataMap.put("content", call.argument("content"));
        dataMap.put("x", call.argument("x"));
        dataMap.put("y", call.argument("y"));
        dataMap.put("max_width", call.argument("max_width"));
        dataMap.put("page_index", pageIndex);
        dataMap.put("isEditMode", isEditMode(context));

        CPDFEditArea editArea = CPDFEditAreaUtil.createNewTextArea(context.requireDocument(),
                dataMap);
        if (editArea != null) {
            refreshPageEditUi(context, pageIndex);
            result.success(true);
            return;
        }
        result.success(false);
    }

    public static void createNewImageArea(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int pageIndex = call.argument("page_index");
        HashMap<String, Object> imageData = call.argument("image_data");

        HashMap<String, Object> dataMap = new HashMap<>();
        dataMap.put("image_data", imageData);
        dataMap.put("x", call.argument("x"));
        dataMap.put("y", call.argument("y"));
        dataMap.put("width", call.argument("width"));
        dataMap.put("page_index", pageIndex);
        dataMap.put("isEditMode", isEditMode(context));

        CPDFDocument document = context.requireDocument();
        CPDFEditAreaUtil.createNewImageArea(document, dataMap, editArea -> {
            if (editArea != null) {
                refreshPageEditUi(context, pageIndex);
                result.success(true);
                return;
            }
            result.success(false);
        });
    }

    private static boolean isEditMode(@NonNull CPDFDocumentContext context) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView == null) {
            return false;
        }
        return readerView.getViewMode() == ViewMode.PDFEDIT;
    }

    private static void refreshPageEditUi(@NonNull CPDFDocumentContext context, int pageIndex) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView == null) {
            return;
        }
        CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
        if (pageView == null) {
            return;
        }
        if (readerView.getViewMode() != ViewMode.PDFEDIT) {
            pageView.endEdit();
        }
        pageView.onUpdateUI(pageIndex);
    }
}