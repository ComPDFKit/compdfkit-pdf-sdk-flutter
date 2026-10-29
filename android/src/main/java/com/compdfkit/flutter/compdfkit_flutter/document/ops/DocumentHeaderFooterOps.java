/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFHeaderFooter;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Handles document header and footer channel operations. */
public final class DocumentHeaderFooterOps {

    private static final String ERROR_HEADER_FOOTER_FAIL = "HEADER_FOOTER_FAIL";

    private DocumentHeaderFooterOps() {
    }

    public static void getHeaderFooter(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFHeaderFooter headerFooter = context.requireDocument().getHeaderFooter();
        if (headerFooter == null) {
            result.success(null);
            return;
        }
        try {
            Map<String, Object> value = toMap(headerFooter);
            result.success(hasContent(value) ? value : null);
        } finally {
//            headerFooter.release();
        }
    }

    public static void updateHeaderFooter(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFHeaderFooter headerFooter = context.requireDocument().getHeaderFooter();
        if (headerFooter == null) {
            result.success(false);
            return;
        }
        try {
            String validationError = apply(call, headerFooter);
            if (validationError != null) {
                result.error(ERROR_HEADER_FOOTER_FAIL, validationError, null);
                return;
            }
            headerFooter.update();
            reloadPagesIfAttached(context);
            result.success(true);
        } finally {
//            headerFooter.release();
        }
    }

    public static void clearHeaderFooter(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFHeaderFooter headerFooter = context.requireDocument().getHeaderFooter();
        if (headerFooter == null) {
            result.success(false);
            return;
        }
        try {
            headerFooter.clear();
            reloadPagesIfAttached(context);
            result.success(true);
        } finally {
//            headerFooter.release();
        }
    }

    @SuppressWarnings("unchecked")
    private static String apply(@NonNull MethodCall call, @NonNull CPDFHeaderFooter headerFooter) {
        String pages = call.argument("pages");
        Map<String, Object> margin = call.argument("margin");
        List<Map<String, Object>> slots = call.argument("slots");
        if (TextUtils.isEmpty(pages)) {
            return "Header/footer pages cannot be empty.";
        }
        if (margin == null || slots == null || slots.isEmpty()) {
            return "Header/footer margin and slots are required.";
        }
        Number left = number(margin.get("left"));
        Number top = number(margin.get("top"));
        Number right = number(margin.get("right"));
        Number bottom = number(margin.get("bottom"));
        if (left == null || top == null || right == null || bottom == null) {
            return "Header/footer margin is invalid.";
        }
        headerFooter.setPages(pages);
        headerFooter.setMargin(left.floatValue(), top.floatValue(), right.floatValue(), bottom.floatValue());
        for (int index = 0; index < 6; index++) {
            headerFooter.setText(index, "");
        }
        for (Map<String, Object> slot : slots) {
            int index = positionIndex(slot.get("position"));
            Number fontSize = number(slot.get("font_size"));
            if (index < 0 || fontSize == null || fontSize.floatValue() <= 0) {
                return "Header/footer slot is invalid.";
            }
            String text = string(slot.get("text"));
            String fontName = string(slot.get("font_name"));
            String color = string(slot.get("text_color"));
            headerFooter.setText(index, text);
            headerFooter.setFontName(index, TextUtils.isEmpty(fontName) ? "Helvetica" : fontName);
            headerFooter.setFontSize(index, fontSize.floatValue());
            try {
                headerFooter.setTextColor(index, Color.parseColor(
                        TextUtils.isEmpty(color) ? "#FF000000" : color));
            } catch (IllegalArgumentException error) {
                return "Header/footer text_color is invalid.";
            }
        }
        return null;
    }

    private static Map<String, Object> toMap(@NonNull CPDFHeaderFooter headerFooter) {
        Map<String, Object> result = new HashMap<>();
        result.put("pages", headerFooter.getPages() == null ? "" : headerFooter.getPages());
        RectF margin = headerFooter.getMargin();
        Map<String, Object> marginMap = new HashMap<>();
        marginMap.put("left", margin == null ? 0d : (double) margin.left);
        marginMap.put("top", margin == null ? 0d : (double) margin.top);
        marginMap.put("right", margin == null ? 0d : (double) margin.right);
        marginMap.put("bottom", margin == null ? 0d : (double) margin.bottom);
        result.put("margin", marginMap);
        List<Map<String, Object>> slots = new ArrayList<>();
        for (int index = 0; index < 6; index++) {
            Map<String, Object> slot = new HashMap<>();
            slot.put("position", positionName(index));
            slot.put("text", headerFooter.getText(index) == null ? "" : headerFooter.getText(index));
            slot.put("font_name", headerFooter.getFontName(index) == null
                    ? "Helvetica" : headerFooter.getFontName(index));
            slot.put("font_size", (double) headerFooter.getFontSize(index));
            slot.put("text_color", String.format("#%08X", headerFooter.getTextColor(index)));
            slots.add(slot);
        }
        result.put("slots", slots);
        return result;
    }

    private static boolean hasContent(@NonNull Map<String, Object> value) {
        Object rawSlots = value.get("slots");
        if (!(rawSlots instanceof List)) {
            return false;
        }
        for (Object rawSlot : (List<?>) rawSlots) {
            if (rawSlot instanceof Map && !TextUtils.isEmpty(string(((Map<?, ?>) rawSlot).get("text")))) {
                return true;
            }
        }
        return false;
    }

    private static int positionIndex(Object value) {
        if (!(value instanceof String)) {
            return -1;
        }
        switch ((String) value) {
            case "header_left": return 0;
            case "header_center": return 1;
            case "header_right": return 2;
            case "footer_left": return 3;
            case "footer_center": return 4;
            case "footer_right": return 5;
            default: return -1;
        }
    }

    private static String positionName(int index) {
        switch (index) {
            case 0: return "header_left";
            case 1: return "header_center";
            case 2: return "header_right";
            case 3: return "footer_left";
            case 4: return "footer_center";
            case 5: return "footer_right";
            default: return "header_left";
        }
    }

    private static String string(Object value) {
        return value instanceof String ? (String) value : "";
    }

    private static Number number(Object value) {
        return value instanceof Number ? (Number) value : null;
    }

    private static void reloadPagesIfAttached(@NonNull CPDFDocumentContext context) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            readerView.reloadPages();
        }
    }
}
