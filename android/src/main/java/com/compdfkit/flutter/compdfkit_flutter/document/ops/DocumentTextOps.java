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

import android.graphics.RectF;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFTextPage;
import com.compdfkit.core.page.CPDFTextRange;
import com.compdfkit.core.page.CPDFTextSelection;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class DocumentTextOps {

    private DocumentTextOps() {
    }

    public static String getPageText(@NonNull CPDFDocumentContext context, int pageIndex) {
        CPDFTextPage textPage = requireTextPage(context, pageIndex);
        int count = textPage.getCountChars();
        if (count <= 0) {
            return "";
        }
        return textPage.getText(new CPDFTextRange(0, count));
    }

    public static String getPageTextInRect(@NonNull CPDFDocumentContext context, int pageIndex,
            @Nullable HashMap<String, Object> rectMap) {
        CPDFTextPage textPage = requireTextPage(context, pageIndex);
        RectF rect = requireRect(rectMap);
        return textPage.getBoundedText(rect);
    }

    public static List<Map<String, Object>> getPageTextLines(
            @NonNull CPDFDocumentContext context, int pageIndex) {
        CPDFTextPage textPage = requireTextPage(context, pageIndex);
        int count = textPage.getCountChars();
        List<Map<String, Object>> lines = new ArrayList<>();
        if (count <= 0) {
            return lines;
        }

        CPDFTextSelection[] selections = textPage.getSelectionsByLineForRange(
                new CPDFTextRange(0, count));
        if (selections == null) {
            return lines;
        }
        for (int index = 0; index < selections.length; index++) {
            CPDFTextSelection selection = selections[index];
            if (selection == null || !selection.isValid()
                    || selection.getTextRange() == null || selection.getRectF() == null) {
                continue;
            }
            lines.add(toLineMap(pageIndex, lines.size(), selection));
        }
        return lines;
    }

    @NonNull
    private static CPDFTextPage requireTextPage(@NonNull CPDFDocumentContext context,
            int pageIndex) {
        CPDFDocument document = context.requireDocument();
        if (pageIndex < 0 || pageIndex >= document.getPageCount()) {
            throw new IllegalArgumentException("Invalid page index: " + pageIndex);
        }
        CPDFPage page = document.pageAtIndex(pageIndex);
        if (page == null || !page.isValid()) {
            throw new IllegalArgumentException("Page not found at index: " + pageIndex);
        }
        CPDFTextPage textPage = page.getTextPage();
        if (textPage == null || !textPage.isValid()) {
            throw new IllegalArgumentException("Text page is unavailable at index: " + pageIndex);
        }
        return textPage;
    }

    @NonNull
    private static RectF requireRect(@Nullable HashMap<String, Object> rectMap) {
        if (rectMap == null) {
            throw new IllegalArgumentException("rect cannot be null");
        }
        RectF rect = new RectF(
                numberValue(rectMap.get("left")),
                numberValue(rectMap.get("top")),
                numberValue(rectMap.get("right")),
                numberValue(rectMap.get("bottom")));
        if (Math.abs(rect.width()) < 0.1F || Math.abs(rect.height()) < 0.1F) {
            throw new IllegalArgumentException("rect width and height must be greater than 0");
        }
        return rect;
    }

    private static float numberValue(@Nullable Object value) {
        if (value instanceof Number) {
            return ((Number) value).floatValue();
        }
        if (value instanceof String) {
            return Float.parseFloat((String) value);
        }
        return 0F;
    }

    @NonNull
    private static Map<String, Object> toLineMap(int pageIndex, int lineIndex,
            @NonNull CPDFTextSelection selection) {
        CPDFTextRange range = selection.getTextRange();
        RectF rect = selection.getRectF();
        Map<String, Object> lineMap = new HashMap<>();
        lineMap.put("page_index", pageIndex);
        lineMap.put("line_index", lineIndex);
        lineMap.put("location", range.location);
        lineMap.put("length", range.length);
        lineMap.put("rect", toRectMap(rect));
        return lineMap;
    }

    @NonNull
    private static Map<String, Float> toRectMap(@NonNull RectF rect) {
        Map<String, Float> rectMap = new HashMap<>();
        rectMap.put("left", rect.left);
        rectMap.put("top", rect.top);
        rectMap.put("right", rect.right);
        rectMap.put("bottom", rect.bottom);
        return rectMap;
    }
}
