/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFBates;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Handles Bates numbering channel operations. */
public final class DocumentBatesOps {
    private static final String ERROR = "BATES_FAIL";

    private DocumentBatesOps() {}

    public static void getBates(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFBates bates = context.requireDocument().getBates();
        if (bates == null) { result.success(null); return; }
        try {
            Map<String, Object> value = toMap(bates);
            result.success(hasContent(value) ? value : null);
        } finally {  }
    }

    public static void updateBates(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFBates bates = context.requireDocument().getBates();
        if (bates == null) { result.success(false); return; }
        try {
            String error = apply(call, bates);
            if (error != null) { result.error(ERROR, error, null); return; }
            bates.update();
            reload(context);
            result.success(true);
        } finally {  }
    }

    public static void clearBates(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFBates bates = context.requireDocument().getBates();
        if (bates == null) { result.success(false); return; }
        try { bates.clear(); reload(context); result.success(true); }
        finally {  }
    }

    @SuppressWarnings("unchecked")
    private static String apply(MethodCall call, CPDFBates bates) {
        String pages = call.argument("pages");
        Map<String, Object> margin = call.argument("margin");
        List<Map<String, Object>> slots = call.argument("slots");
        if (TextUtils.isEmpty(pages) || margin == null || slots == null || slots.isEmpty()) {
            return "Bates payload is invalid.";
        }
        Number left = number(margin.get("left"));
        Number top = number(margin.get("top"));
        Number right = number(margin.get("right"));
        Number bottom = number(margin.get("bottom"));
        if (left == null || top == null || right == null || bottom == null) {
            return "Bates margin is invalid.";
        }
        bates.setPages(pages);
        bates.setMargin(left.floatValue(), top.floatValue(), right.floatValue(), bottom.floatValue());
        bates.setPageOffset(intValue(call.argument("page_offset"), 0));
        bates.setRules(intValue(call.argument("rule"), 2));
        for (int index = 0; index < 6; index++) bates.setText(index, "");
        for (Map<String, Object> slot : slots) {
            int index = positionIndex(slot.get("position"));
            Number size = number(slot.get("font_size"));
            if (index < 0 || size == null || size.floatValue() <= 0) return "Bates slot is invalid.";
            bates.setText(index, string(slot.get("text")));
            bates.setFontName(index, stringOr(slot.get("font_name"), "Helvetica"));
            bates.setFontSize(index, size.floatValue());
            try {
                bates.setTextColor(index, Color.parseColor(stringOr(slot.get("text_color"), "#FF000000")));
            } catch (IllegalArgumentException error) { return "Bates text_color is invalid."; }
        }
        return null;
    }

    private static Map<String, Object> toMap(CPDFBates bates) {
        Map<String, Object> value = new HashMap<>();
        value.put("pages", bates.getPages() == null ? "" : bates.getPages());
        RectF margin = bates.getMargin();
        Map<String, Object> marginMap = new HashMap<>();
        marginMap.put("left", margin == null ? 0d : (double) margin.left);
        marginMap.put("top", margin == null ? 0d : (double) margin.top);
        marginMap.put("right", margin == null ? 0d : (double) margin.right);
        marginMap.put("bottom", margin == null ? 0d : (double) margin.bottom);
        value.put("margin", marginMap);
        value.put("page_offset", bates.getPageOffset());
        value.put("rule", bates.getRules());
        List<Map<String, Object>> slots = new ArrayList<>();
        for (int index = 0; index < 6; index++) {
            Map<String, Object> slot = new HashMap<>();
            slot.put("position", positionName(index));
            slot.put("text", string(bates.getText(index)));
            slot.put("font_name", stringOr(bates.getFontName(index), "Helvetica"));
            slot.put("font_size", (double) bates.getFontSize(index));
            slot.put("text_color", String.format("#%08X", bates.getTextColor(index)));
            slots.add(slot);
        }
        value.put("slots", slots);
        return value;
    }

    private static boolean hasContent(Map<String, Object> value) {
        Object raw = value.get("slots");
        if (!(raw instanceof List)) return false;
        for (Object item : (List<?>) raw) {
            if (item instanceof Map && !TextUtils.isEmpty(string(((Map<?, ?>) item).get("text")))) return true;
        }
        return false;
    }

    private static int positionIndex(Object value) {
        if (!(value instanceof String)) return -1;
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
        return new String[] {"header_left", "header_center", "header_right", "footer_left", "footer_center", "footer_right"}[index];
    }

    private static String string(Object value) { return value instanceof String ? (String) value : ""; }
    private static String stringOr(Object value, String fallback) {
        String text = string(value);
        return TextUtils.isEmpty(text) ? fallback : text;
    }
    private static Number number(Object value) { return value instanceof Number ? (Number) value : null; }
    private static int intValue(Object value, int fallback) {
        return value instanceof Number ? ((Number) value).intValue() : fallback;
    }
    private static void reload(CPDFDocumentContext context) {
        CPDFReaderView view = context.getReaderView();
        if (view != null) view.reloadPages();
    }
}
