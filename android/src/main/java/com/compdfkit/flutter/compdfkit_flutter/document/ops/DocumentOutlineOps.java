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
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFBookmarkUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFOutlineJsonUtil;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import java.util.List;
import java.util.Map;

public final class DocumentOutlineOps {

    private DocumentOutlineOps() {
    }

    public static Map<String, Object> getOutlineRoot(@NonNull CPDFDocumentContext context) {
        return CPDFOutlineJsonUtil.getOutlineJson(context.requireDocument());
    }

    public static Map<String, Object> newOutlineRoot(@NonNull CPDFDocumentContext context) {
        return CPDFOutlineJsonUtil.newOutlineRoot(context.requireDocument());
    }

    public static boolean addOutline(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call) {
        return CPDFOutlineJsonUtil.addOutline(context.requireDocument(), call);
    }

    public static boolean removeOutline(@NonNull CPDFDocumentContext context,
            @NonNull String outlineUuid) {
        return CPDFOutlineJsonUtil.deleteOutline(context.requireDocument(), outlineUuid);
    }

    public static boolean updateOutline(@NonNull CPDFDocumentContext context,
            @NonNull String uuid, @NonNull String title, int pageIndex) {
        return CPDFOutlineJsonUtil.updateOutlineTitle(context.requireDocument(), uuid, title,
                pageIndex);
    }

    public static boolean moveToOutline(@NonNull CPDFDocumentContext context,
            @NonNull String uuid, String parentUuid, int insertIndex) {
        return CPDFOutlineJsonUtil.moveTo(context.requireDocument(), uuid, parentUuid,
                insertIndex);
    }

    public static boolean hasBookmark(@NonNull CPDFDocumentContext context, int pageIndex) {
        return context.requireDocument().hasBookmark(pageIndex);
    }

    public static boolean removeBookmark(@NonNull CPDFDocumentContext context, int pageIndex) {
        boolean result = context.requireDocument().removeBookmark(pageIndex);
        invalidateReader(context);
        return result;
    }

    public static List<Map<String, Object>> getBookmarks(@NonNull CPDFDocumentContext context) {
        return CPDFBookmarkUtil.getBookmarks(context.requireDocument());
    }

    public static boolean addBookmark(@NonNull CPDFDocumentContext context, @NonNull String title,
            int pageIndex) {
        boolean result = CPDFBookmarkUtil.addBookmark(context.requireDocument(), title, pageIndex);
        invalidateReader(context);
        return result;
    }

    public static boolean updateBookmark(@NonNull CPDFDocumentContext context,
            @NonNull String uuid, @NonNull String title) {
        return CPDFBookmarkUtil.updateBookmark(context.requireDocument(), uuid, title);
    }

    private static void invalidateReader(@NonNull CPDFDocumentContext context) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            readerView.invalidateAllChildren();
        }
    }
}