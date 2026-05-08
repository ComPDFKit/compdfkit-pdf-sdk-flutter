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
import android.graphics.Color;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.tools.common.utils.glide.CPDFWrapper;
import com.compdfkit.tools.common.utils.glide.wrapper.impl.CPDFDocumentPageWrapper;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;

public final class DocumentRenderOps {

    private DocumentRenderOps() {
    }

    public static void renderPageToImage(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        int pageIndex = call.argument("page_index");
        if (pageIndex < 0 || pageIndex >= document.getPageCount()) {
            result.error("GET_PAGE_IMAGE_BYTES_FAIL", "Invalid page index: " + pageIndex, null);
            return;
        }
        int width = call.argument("width");
        int height = call.argument("height");
        String colorHex = call.argument("background_color");
        boolean drawAnnot = call.argument("draw_annot");
        boolean drawForm = call.argument("draw_form");
        String compression = call.argument("compression");

        CPDFDocumentPageWrapper pageWrapper = new CPDFDocumentPageWrapper(document, pageIndex);
        pageWrapper.setBackgroundColor(Color.parseColor(colorHex));
        pageWrapper.setDrawAnnotation(drawAnnot);
        pageWrapper.setDrawForms(drawForm);

        CPDFWrapper wrapper = new CPDFWrapper(pageWrapper);

        Glide.with(document.getContext())
                .asBitmap()
                .load(wrapper)
                .override(width, height)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .into(new CustomTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource,
                            @Nullable Transition<? super Bitmap> transition) {
                        switch (compression) {
                            case "jpeg":
                                Log.i("ComPDFKit-Flutter", "renderPageToImage:jpeg");
                                ByteArrayOutputStream jpegStream = new ByteArrayOutputStream();
                                resource.compress(Bitmap.CompressFormat.JPEG, 85, jpegStream);
                                result.success(jpegStream.toByteArray());
                                break;
                            case "png":
                                Log.i("ComPDFKit-Flutter", "renderPageToImage:png");
                                ByteArrayOutputStream pngStream = new ByteArrayOutputStream();
                                resource.compress(Bitmap.CompressFormat.PNG, 100, pngStream);
                                result.success(pngStream.toByteArray());
                                break;
                            default:
                                result.error("GET_PAGE_IMAGE_BYTES_FAIL",
                                        "Unsupported compression: " + compression, null);
                                break;
                        }
                        Glide.get(document.getContext()).clearMemory();
                    }

                    @Override
                    public void onLoadCleared(@Nullable Drawable placeholder) {
                    }
                });
    }

    public static void renderAnnotationAppearance(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        Integer pageIndex = call.argument("page_index");
        String annotPtr = call.argument("uuid");
        HashMap<String, Object> options = call.argument("options");
        if (pageIndex == null || pageIndex < 0 || pageIndex >= document.getPageCount()) {
            result.error("RENDER_ANNOTATION_APPEARANCE_FAIL",
                    "Invalid page index: " + pageIndex, null);
            return;
        }
        if (TextUtils.isEmpty(annotPtr)) {
            result.error("RENDER_ANNOTATION_APPEARANCE_FAIL", "Annotation uuid is empty", null);
            return;
        }

        CThreadPoolUtils.getInstance().executeIO(() -> {
            Bitmap bitmap = null;
            try {
                CPDFAnnotation annotation = context.getPageCodec().getAnnotation(pageIndex,
                        annotPtr);
                if (annotation == null || !annotation.isValid()) {
                    result.error("RENDER_ANNOTATION_APPEARANCE_FAIL",
                            "Annotation was not found", null);
                    return;
                }
                RectF rect = annotation.getRect();
                if (rect == null) {
                    result.error("RENDER_ANNOTATION_APPEARANCE_FAIL",
                            "Annotation rect is empty", null);
                    return;
                }
                int[] renderSize = resolveAnnotationAppearanceRenderSize(rect, options);
                bitmap = Bitmap.createBitmap(renderSize[0], renderSize[1],
                        Bitmap.Config.ARGB_8888);
                if (!annotation.getAppearanceByPixel(bitmap,
                        CPDFAnnotation.AppearanceType.Normal)) {
                    result.error("RENDER_ANNOTATION_APPEARANCE_FAIL",
                            "Failed to render annotation appearance", null);
                    return;
                }
                result.success(compressBitmap(bitmap, options));
            } catch (Exception e) {
                result.error("RENDER_ANNOTATION_APPEARANCE_FAIL", e.getMessage(), null);
            } finally {
                if (bitmap != null && !bitmap.isRecycled()) {
                    bitmap.recycle();
                }
            }
        });
    }

    private static byte[] compressBitmap(@NonNull Bitmap bitmap,
            @Nullable HashMap<String, Object> options) {
        String compression = getStringOption(options, "compression", "png");
        int quality = getIntOption(options, "quality", 100);
        Bitmap.CompressFormat format = "jpeg".equals(compression)
                ? Bitmap.CompressFormat.JPEG
                : Bitmap.CompressFormat.PNG;
        int compressedQuality = format == Bitmap.CompressFormat.JPEG ? quality : 100;
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(format, compressedQuality, outputStream);
        return outputStream.toByteArray();
    }

    private static int[] resolveAnnotationAppearanceRenderSize(@NonNull RectF rect,
            @Nullable HashMap<String, Object> options) {
        int baseWidth = Math.max(1, Math.round(Math.abs(rect.width())));
        int baseHeight = Math.max(1, Math.round(Math.abs(rect.height())));
        int targetWidth = getIntOption(options, "target_width", 0);
        int targetHeight = getIntOption(options, "target_height", 0);
        double scale = getDoubleOption(options, "scale", 3.0);

        if (targetWidth > 0 && targetHeight > 0) {
            return new int[]{targetWidth, targetHeight};
        }
        if (targetWidth > 0) {
            int resolvedHeight = Math.max(1,
                    Math.round(targetWidth * (baseHeight / (float) baseWidth)));
            return new int[]{targetWidth, resolvedHeight};
        }
        if (targetHeight > 0) {
            int resolvedWidth = Math.max(1,
                    Math.round(targetHeight * (baseWidth / (float) baseHeight)));
            return new int[]{resolvedWidth, targetHeight};
        }

        int scaledWidth = Math.max(1, (int) Math.round(baseWidth * scale));
        int scaledHeight = Math.max(1, (int) Math.round(baseHeight * scale));
        return new int[]{scaledWidth, scaledHeight};
    }

    private static int getIntOption(@Nullable HashMap<String, Object> options, @NonNull String key,
            int defaultValue) {
        if (options == null) {
            return defaultValue;
        }
        Object value = options.get(key);
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return defaultValue;
    }

    private static double getDoubleOption(@Nullable HashMap<String, Object> options,
            @NonNull String key, double defaultValue) {
        if (options == null) {
            return defaultValue;
        }
        Object value = options.get(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return defaultValue;
    }

    private static String getStringOption(@Nullable HashMap<String, Object> options,
            @NonNull String key, @NonNull String defaultValue) {
        if (options == null) {
            return defaultValue;
        }
        Object value = options.get(key);
        if (value instanceof String && !TextUtils.isEmpty((String) value)) {
            return (String) value;
        }
        return defaultValue;
    }
}