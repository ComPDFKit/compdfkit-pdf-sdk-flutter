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
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.compdfkit.core.annotation.CPDFImageScaleType;
import com.compdfkit.core.document.CPDFBackground;
import com.compdfkit.core.document.CPDFBackground.CPDFBackgroundAlign;
import com.compdfkit.core.document.CPDFBackground.Type;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.ui.reader.CPDFReaderView;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/** Document background get, update, and clear operations. */
public final class DocumentBackgroundOps {

    private static final String ERROR = "BACKGROUND_FAIL";

    private DocumentBackgroundOps() {
    }

    public static void getBackground(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFBackground background = context.requireDocument().getBackground();
        if (background == null) {
            result.success(null);
            return;
        }
        // TODO: Android SDK document.getBackground().getPages() currently returns an
        // empty value and needs to be fixed upstream.
        String pages = background.getPages();
        result.success(toMap(background, pages == null ? "" : pages));
    }

    public static void updateBackground(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFBackground background = context.requireDocument().getBackground();
        if (background == null) {
            result.success(false);
            return;
        }
        String error = apply(call, background);
        if (error != null) {
            result.error(ERROR, error, null);
            return;
        }
        background.update();
        reload(context);
        result.success(true);
    }

    public static void clearBackground(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFBackground background = context.requireDocument().getBackground();
        if (background == null) {
            result.success(false);
            return;
        }
        background.clear();
        reload(context);
        result.success(true);
    }

    private static String apply(MethodCall call, CPDFBackground background) {
        String pages = call.argument("pages");
        String type = call.argument("type");
        Number opacity = call.argument("opacity");
        Number scale = call.argument("scale");
        Number rotation = call.argument("rotation");
        Number horizontalOffset = call.argument("horizontal_offset");
        Number verticalOffset = call.argument("vertical_offset");
        Boolean allowView = call.argument("allow_view");
        Boolean allowPrint = call.argument("allow_print");
        CPDFBackgroundAlign horizontalAlignment = parseHorizontalAlignment(
                call.argument("horizontal_alignment"));
        CPDFBackgroundAlign verticalAlignment = parseVerticalAlignment(
                call.argument("vertical_alignment"));

        if (TextUtils.isEmpty(pages) || type == null || opacity == null || scale == null
                || rotation == null || horizontalOffset == null || verticalOffset == null
                || allowView == null || allowPrint == null || horizontalAlignment == null
                || verticalAlignment == null) {
            return "Background payload is invalid.";
        }

        boolean success = true;
        success = background.setPages(pages) && success;
        success = background.setOpacity(opacity.floatValue()) && success;
        success = background.setScale(scale.floatValue()) && success;
        success = background.setRotation(rotation.floatValue()) && success;
        success = background.setHorizalign(horizontalAlignment) && success;
        success = background.setVertalign(verticalAlignment) && success;
        success = background.setXOffset(horizontalOffset.floatValue()) && success;
        success = background.setYOffset(verticalOffset.floatValue()) && success;
        success = background.setAllowsView(allowView) && success;
        success = background.setAllowsPrint(allowPrint) && success;

        if ("color".equals(type)) {
            String color = call.argument("color");
            if (TextUtils.isEmpty(color)) {
                return "A color background requires color.";
            }
            try {
                success = background.setType(Type.Color) && success;
                success = background.setColor(Color.parseColor(color)) && success;
            } catch (IllegalArgumentException error) {
                return "Background color is invalid.";
            }
        } else if ("image".equals(type)) {
            String imagePath = call.argument("image_path");
            if (TextUtils.isEmpty(imagePath) || !new File(imagePath).isFile()) {
                return "Background image_path does not exist.";
            }
            success = background.setType(Type.Image) && success;
            success = background.setImage(imagePath, null,
                    CPDFImageScaleType.SCALETYPE_fitCenter) && success;
        } else {
            return "Background type is invalid.";
        }

        return success ? null : "Native SDK failed to update the background.";
    }

    private static Map<String, Object> toMap(CPDFBackground background, String pages) {
        Map<String, Object> value = new HashMap<>();
        Type type = background.getType();
        value.put("pages", pages);
        value.put("type", type == Type.Image ? "image" : "color");
        if (type == Type.Color) {
            value.put("color", String.format("#%08X", background.getColor()));
        }
        value.put("opacity", (double) background.getOpacity());
        value.put("scale", (double) background.getScale());
        value.put("rotation", (double) background.getRotation());
        value.put("horizontal_alignment", horizontalAlignment(background.getHorizalign()));
        value.put("vertical_alignment", verticalAlignment(background.getVertalign()));
        value.put("horizontal_offset", (double) background.getXOffset());
        value.put("vertical_offset", (double) background.getYOffset());
        value.put("allow_view", background.isAllowsView());
        value.put("allow_print", background.isAllowsPrint());
        return value;
    }

    private static CPDFBackgroundAlign parseHorizontalAlignment(Object value) {
        if ("left".equals(value)) {
            return CPDFBackgroundAlign.Left;
        }
        if ("center".equals(value)) {
            return CPDFBackgroundAlign.Center;
        }
        if ("right".equals(value)) {
            return CPDFBackgroundAlign.Right;
        }
        return null;
    }

    private static CPDFBackgroundAlign parseVerticalAlignment(Object value) {
        if ("top".equals(value)) {
            return CPDFBackgroundAlign.Top;
        }
        if ("center".equals(value)) {
            return CPDFBackgroundAlign.Center;
        }
        if ("bottom".equals(value)) {
            return CPDFBackgroundAlign.Bottom;
        }
        return null;
    }

    private static String horizontalAlignment(CPDFBackgroundAlign value) {
        if (value == CPDFBackgroundAlign.Left) {
            return "left";
        }
        if (value == CPDFBackgroundAlign.Right) {
            return "right";
        }
        return "center";
    }

    private static String verticalAlignment(CPDFBackgroundAlign value) {
        if (value == CPDFBackgroundAlign.Top) {
            return "top";
        }
        if (value == CPDFBackgroundAlign.Bottom) {
            return "bottom";
        }
        return "center";
    }

    private static void reload(CPDFDocumentContext context) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            readerView.reloadPages();
        }
    }
}
