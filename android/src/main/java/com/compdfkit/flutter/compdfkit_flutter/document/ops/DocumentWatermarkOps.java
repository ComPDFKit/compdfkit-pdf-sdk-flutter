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

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.watermark.CPDFWatermark;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class DocumentWatermarkOps {

    private static final String ERROR_WATERMARK_FAIL = "WATERMARK_FAIL";
    private static final ExecutorService IMAGE_EXECUTOR = Executors.newSingleThreadExecutor();
    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());

    private DocumentWatermarkOps() {
    }

    public static void createWatermark(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        String type = call.argument("type");
        CPDFWatermark.Type watermarkType = toWatermarkType(type);
        if (watermarkType == CPDFWatermark.Type.WATERMARK_TYPE_UNKWON) {
            result.error(ERROR_WATERMARK_FAIL, "Invalid watermark type", "");
            return;
        }

        String validationError = validateWatermarkInput(call, watermarkType, true);
        if (validationError != null) {
            result.error(ERROR_WATERMARK_FAIL, validationError, "");
            return;
        }

        if (watermarkType == CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            applyImageWatermark(call, result, imageInfo -> {
                CPDFWatermark watermark = document.createWatermark(watermarkType);
                if (watermark == null || !applyWatermark(call, watermark, imageInfo)) {
                    result.error(ERROR_WATERMARK_FAIL, "Failed to create watermark", "");
                    return;
                }
                watermark.update();
                watermark.release();
                reloadPagesIfAttached(context);
                result.success(true);
            });
            return;
        }

        CPDFWatermark watermark = document.createWatermark(watermarkType);
        if (watermark == null || !applyWatermark(call, watermark, null)) {
            result.error(ERROR_WATERMARK_FAIL, "Failed to create watermark", "");
            return;
        }
        watermark.update();
        watermark.release();
        reloadPagesIfAttached(context);
        result.success(true);
    }

    public static void getWatermarkCount(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        result.success(context.requireDocument().getWatermarkCount());
    }

    public static void getWatermark(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFWatermark watermark = getWatermarkAt(context.requireDocument(), call);
        if (watermark == null) {
            result.success(null);
            return;
        }
        boolean exportImage = getBoolean(call, "export_image", false);
        Map<String, Object> info = toMap(context, watermark, getIndex(call), exportImage);
        watermark.release();
        result.success(info);
    }

    public static void getWatermarks(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        boolean exportImages = getBoolean(call, "export_images", false);
        List<Map<String, Object>> watermarks = new ArrayList<>();
        for (int i = 0; i < document.getWatermarkCount(); i++) {
            CPDFWatermark watermark = document.getWatermark(i);
            if (watermark == null) {
                continue;
            }
            watermarks.add(toMap(context, watermark, i, exportImages));
            watermark.release();
        }
        result.success(watermarks);
    }

    public static void updateWatermark(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        CPDFWatermark watermark = getWatermarkAt(document, call);
        if (watermark == null) {
            result.success(false);
            return;
        }

        String type = call.argument("type");
        CPDFWatermark.Type watermarkType = toWatermarkType(type);
        if (watermarkType != CPDFWatermark.Type.WATERMARK_TYPE_UNKWON
                && watermark.getType() != watermarkType) {
            watermark.release();
            result.success(false);
            return;
        }

        String validationError = validateWatermarkInput(call, watermark.getType(), false);
        if (validationError != null) {
            watermark.release();
            result.error(ERROR_WATERMARK_FAIL, validationError, "");
            return;
        }

        if (watermark.getType() == CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            String imagePath = call.argument("image_path");
            if (TextUtils.isEmpty(imagePath)) {
                boolean success = applyWatermark(call, watermark, null);
                if (success) {
                    watermark.update();
                    reloadPagesIfAttached(context);
                }
                watermark.release();
                result.success(success);
                return;
            }
            applyImageWatermark(call, result, imageInfo -> {
                boolean success = applyWatermark(call, watermark, imageInfo);
                if (success) {
                    watermark.update();
                    reloadPagesIfAttached(context);
                }
                watermark.release();
                result.success(success);
            });
            return;
        }

        boolean success = applyWatermark(call, watermark, null);
        if (success) {
            watermark.update();
            reloadPagesIfAttached(context);
        }
        watermark.release();
        result.success(success);
    }

    public static void removeWatermark(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFWatermark watermark = getWatermarkAt(context.requireDocument(), call);
        if (watermark == null) {
            result.success(false);
            return;
        }
        boolean success = watermark.clear();
        watermark.release();
        if (success) {
            reloadPagesIfAttached(context);
        }
        result.success(success);
    }

    public static void removeAllWatermarks(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        for (int watermarkCount = document.getWatermarkCount(); watermarkCount > 0;
                watermarkCount--) {
            CPDFWatermark watermark = document.getWatermark(watermarkCount - 1);
            if (watermark != null) {
                watermark.clear();
                watermark.release();
            }
        }
        reloadPagesIfAttached(context);
        result.success(null);
    }

    private static boolean applyWatermark(@NonNull MethodCall call,
            @NonNull CPDFWatermark watermark, @Nullable ImageInfo imageInfo) {
        String textContent = call.argument("text_content");
        String textColor = call.argument("text_color");
        int fontSize = getInt(call, "font_size", 30);
        double scale = getDouble(call, "scale", 1.0);
        double rotation = getDouble(call, "rotation", 45.0);
        double opacity = getDouble(call, "opacity", 1.0);
        String vertalign = call.argument("vertical_alignment");
        String horizalign = call.argument("horizontal_alignment");
        int vertOffset = getInt(call, "vertical_offset", 0);
        int horizOffset = getInt(call, "horizontal_offset", 0);
        String pages = call.argument("pages");
        boolean isFront = getBoolean(call, "is_front", true);
        boolean isFullScreen = getBoolean(call, "is_tile_page", false);
        int horizontalSpacing = getInt(call, "horizontal_spacing", 0);
        int verticalSpacing = getInt(call, "vertical_spacing", 0);

        CPDFWatermark.Type type = watermark.getType();
        if (type == CPDFWatermark.Type.WATERMARK_TYPE_TEXT) {
            watermark.setText(textContent == null ? "" : textContent);
            watermark.setTextRGBColor(Color.parseColor(
                    TextUtils.isEmpty(textColor) ? "#000000" : textColor));
            watermark.setFontSize(fontSize);
        } else if (type == CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            if (imageInfo != null) {
                watermark.setImage(imageInfo.path, "", imageInfo.width, imageInfo.height);
            }
        } else {
            return false;
        }

        watermark.setScale((float) scale);
        watermark.setRotation((float) -Math.toRadians(rotation));
        watermark.setOpacity((float) opacity);
        watermark.setVertalign(toVertAlign(vertalign));
        watermark.setHorizalign(toHorizAlign(horizalign));
        watermark.setVertOffset(vertOffset);
        watermark.setHorizOffset(horizOffset);
        watermark.setPages(pages == null ? "" : pages);
        watermark.setFront(isFront);
        watermark.setFullScreen(isFullScreen);
        watermark.setHorizontalSpacing(horizontalSpacing);
        watermark.setVerticalSpacing(verticalSpacing);
        return true;
    }

    @Nullable
    private static String validateWatermarkInput(@NonNull MethodCall call,
            @NonNull CPDFWatermark.Type type, boolean isCreate) {
        String pages = call.argument("pages");
        if (TextUtils.isEmpty(pages)) {
            return "The page range cannot be empty, please set the page range, for example: pages: \"0,1,2,3\"";
        }

        if (type == CPDFWatermark.Type.WATERMARK_TYPE_TEXT) {
            String textContent = call.argument("text_content");
            if (TextUtils.isEmpty(textContent)) {
                return "Add text watermark, the text cannot be empty";
            }
        } else if (type == CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            String imagePath = call.argument("image_path");
            if (isCreate && TextUtils.isEmpty(imagePath)) {
                return "image path is empty";
            }
        }
        return null;
    }

    private static Map<String, Object> toMap(@NonNull CPDFDocumentContext context,
            @NonNull CPDFWatermark watermark, int index, boolean exportImage) {
        Map<String, Object> map = new HashMap<>();
        ExportedImage exportedImage = exportWatermarkImage(context, watermark, index, exportImage);
        map.put("index", index);
        map.put("type", fromWatermarkType(watermark.getType()));
        map.put("text_content", watermark.getText());
        map.put("image_path", exportedImage.path);
        map.put("is_image_exported", exportedImage.exported);
        map.put("text_color", toHexColor(watermark.getTextRGBColor()));
        map.put("font_size", watermark.getFontSize());
        map.put("scale", watermark.getScale());
        map.put("rotation", -Math.toDegrees(watermark.getRotation()));
        map.put("opacity", watermark.getOpacity());
        map.put("vertical_alignment", fromVertAlign(watermark.getVertalign()));
        map.put("horizontal_alignment", fromHorizAlign(watermark.getHorizalign()));
        map.put("vertical_offset", watermark.getVertOffset());
        map.put("horizontal_offset", watermark.getHorizOffset());
        map.put("pages", watermark.getPages());
        map.put("is_front", watermark.isFront());
        map.put("is_tile_page", watermark.isFullScreen());
        map.put("horizontal_spacing", watermark.getHorizontalSpacing());
        map.put("vertical_spacing", watermark.getVerticalSpacing());
        return map;
    }

    @NonNull
    private static ExportedImage exportWatermarkImage(@NonNull CPDFDocumentContext context,
            @NonNull CPDFWatermark watermark, int index, boolean exportImage) {
        if (!exportImage || watermark.getType() != CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            return ExportedImage.empty();
        }
        Bitmap bitmap = watermark.getImage();
        if (bitmap == null) {
            return ExportedImage.empty();
        }
        FileOutputStream outputStream = null;
        try {
            File directory = new File(context.getContext().getCacheDir(),
                    "compdfkit/watermarks/" + context.requireDocument().hashCode());
            if (!directory.exists() && !directory.mkdirs()) {
                return ExportedImage.empty();
            }
            File file = new File(directory, "watermark_" + index + "_"
                    + System.currentTimeMillis() + "_" + UUID.randomUUID() + ".png");
            outputStream = new FileOutputStream(file);
            boolean success = bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
            outputStream.flush();
            if (!success) {
                return ExportedImage.empty();
            }
            return new ExportedImage(file.getAbsolutePath(), true);
        } catch (Exception e) {
            Log.e("ComPDFKit-Flutter", "Failed to export watermark image", e);
            return ExportedImage.empty();
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException ignored) {
                }
            }
        }
    }

    private static void applyImageWatermark(@NonNull MethodCall call,
            @NonNull MethodChannel.Result result,
            @NonNull ImageCallback callback) {
        String imagePath = call.argument("image_path");
        if (TextUtils.isEmpty(imagePath)) {
            result.error(ERROR_WATERMARK_FAIL, "Image path is empty", "");
            return;
        }
        IMAGE_EXECUTOR.execute(() -> {
            ImageInfo imageInfo = decodeImageInfo(imagePath);
            MAIN_HANDLER.post(() -> {
                if (imageInfo == null) {
                    result.error(ERROR_WATERMARK_FAIL, "Failed to decode image", "");
                    return;
                }
                callback.onImageLoaded(imageInfo);
            });
        });
    }

    @Nullable
    private static ImageInfo decodeImageInfo(@NonNull String imagePath) {
        try {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(imagePath, options);
            if (options.outWidth <= 0 || options.outHeight <= 0) {
                return null;
            }
            return new ImageInfo(imagePath, options.outWidth, options.outHeight);
        } catch (Exception e) {
            Log.e("ComPDFKit-Flutter", "Failed to decode watermark image", e);
            return null;
        }
    }

    @Nullable
    private static CPDFWatermark getWatermarkAt(@NonNull CPDFDocument document,
            @NonNull MethodCall call) {
        int index = getIndex(call);
        if (index < 0 || index >= document.getWatermarkCount()) {
            return null;
        }
        return document.getWatermark(index);
    }

    private static int getIndex(@NonNull MethodCall call) {
        return getInt(call, "index", -1);
    }

    private static int getInt(@NonNull MethodCall call, @NonNull String key, int defaultValue) {
        Object value = call.argument(key);
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return defaultValue;
    }

    private static double getDouble(@NonNull MethodCall call, @NonNull String key,
            double defaultValue) {
        Object value = call.argument(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return defaultValue;
    }

    private static boolean getBoolean(@NonNull MethodCall call, @NonNull String key,
            boolean defaultValue) {
        Object value = call.argument(key);
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        return defaultValue;
    }

    private static CPDFWatermark.Type toWatermarkType(@Nullable String type) {
        if ("text".equals(type)) {
            return CPDFWatermark.Type.WATERMARK_TYPE_TEXT;
        }
        if ("image".equals(type)) {
            return CPDFWatermark.Type.WATERMARK_TYPE_IMG;
        }
        return CPDFWatermark.Type.WATERMARK_TYPE_UNKWON;
    }

    private static String fromWatermarkType(@NonNull CPDFWatermark.Type type) {
        if (type == CPDFWatermark.Type.WATERMARK_TYPE_IMG) {
            return "image";
        }
        return "text";
    }

    private static CPDFWatermark.Vertalign toVertAlign(@Nullable String value) {
        if ("top".equals(value)) {
            return CPDFWatermark.Vertalign.WATERMARK_VERTALIGN_TOP;
        }
        if ("bottom".equals(value)) {
            return CPDFWatermark.Vertalign.WATERMARK_VERTALIGN_BOTTOM;
        }
        return CPDFWatermark.Vertalign.WATERMARK_VERTALIGN_CENTER;
    }

    private static String fromVertAlign(@NonNull CPDFWatermark.Vertalign value) {
        switch (value) {
            case WATERMARK_VERTALIGN_TOP:
                return "top";
            case WATERMARK_VERTALIGN_BOTTOM:
                return "bottom";
            case WATERMARK_VERTALIGN_CENTER:
            case WATERMARK_VERTALIGN_UNKOWN:
            default:
                return "center";
        }
    }

    private static CPDFWatermark.Horizalign toHorizAlign(@Nullable String value) {
        if ("left".equals(value)) {
            return CPDFWatermark.Horizalign.WATERMARK_HORIZALIGN_LEFT;
        }
        if ("right".equals(value)) {
            return CPDFWatermark.Horizalign.WATERMARK_HORIZALIGN_RIGHT;
        }
        return CPDFWatermark.Horizalign.WATERMARK_HORIZALIGN_CENTER;
    }

    private static String fromHorizAlign(@NonNull CPDFWatermark.Horizalign value) {
        switch (value) {
            case WATERMARK_HORIZALIGN_LEFT:
                return "left";
            case WATERMARK_HORIZALIGN_RIGHT:
                return "right";
            case WATERMARK_HORIZALIGN_CENTER:
            case WATERMARK_HORIZALIGN_UNKOWN:
            default:
                return "center";
        }
    }

    private static String toHexColor(int color) {
        return String.format("#%08X", color);
    }

    private static void reloadPagesIfAttached(@NonNull CPDFDocumentContext context) {
        CPDFReaderView readerView = context.getReaderView();
        if (readerView != null) {
            readerView.reloadPages2();
        }
    }

    private interface ImageCallback {
        void onImageLoaded(@NonNull ImageInfo imageInfo);
    }

    private static class ImageInfo {
        final String path;
        final int width;
        final int height;

        ImageInfo(@NonNull String path, int width, int height) {
            this.path = path;
            this.width = width;
            this.height = height;
        }
    }

    private static class ExportedImage {
        final String path;
        final boolean exported;

        ExportedImage(@NonNull String path, boolean exported) {
            this.path = path;
            this.exported = exported;
        }

        static ExportedImage empty() {
            return new ExportedImage("", false);
        }
    }
}
