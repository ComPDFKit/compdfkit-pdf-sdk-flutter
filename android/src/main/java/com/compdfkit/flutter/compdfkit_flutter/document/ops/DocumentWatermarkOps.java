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
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.watermark.CPDFWatermark;
import com.compdfkit.core.watermark.CPDFWatermark.Type;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.tools.common.utils.threadpools.SimpleBackgroundTask;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public final class DocumentWatermarkOps {

    private DocumentWatermarkOps() {
    }

    public static void createWatermark(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFViewCtrl pdfView = context.getPdfView();
        if (pdfView == null) {
            result.error("WATERMARK_FAIL", "CPDFViewCtrl is null", "");
            return;
        }

        CPDFDocument document = context.requireDocument();
        String type = call.argument("type");
        String textContent = call.argument("text_content");
        String imagePath = call.argument("image_path");
        String textColor = call.argument("text_color");
        int fontSize = call.argument("font_size");
        float scale = ((Double) call.argument("scale")).floatValue();
        float rotation = ((Double) call.argument("rotation")).floatValue();
        float opacity = ((Double) call.argument("opacity")).floatValue();
        String verticalAlignment = call.argument("vertical_alignment");
        String horizontalAlignment = call.argument("horizontal_alignment");
        float verticalOffset = ((Double) call.argument("vertical_offset")).floatValue();
        float horizontalOffset = ((Double) call.argument("horizontal_offset")).floatValue();
        String pages = call.argument("pages");
        boolean isFront = call.argument("is_front");
        boolean isTilePage = call.argument("is_tile_page");
        float horizontalSpacing = ((Double) call.argument("horizontal_spacing")).floatValue();
        float verticalSpacing = ((Double) call.argument("vertical_spacing")).floatValue();

        if (TextUtils.isEmpty(pages)) {
            result.error("WATERMARK_FAIL",
                    "The page range cannot be empty, please set the page range, for example: pages: \"0,1,2,3\"",
                    "");
            return;
        }
        if ("image".equals(type) && TextUtils.isEmpty(imagePath)) {
            Log.e("ComPDFKit-Flutter", "image path:" + imagePath);
            result.error("WATERMARK_FAIL", "image path is empty.", "");
            return;
        }

        new SimpleBackgroundTask<Bitmap>(pdfView.getContext()) {
            @Override
            public Bitmap onRun() {
                if ("text".equals(type)) {
                    return null;
                }
                try {
                    return Glide.with(pdfView.getContext()).asBitmap().load(imagePath)
                            .submit(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL).get();
                } catch (Exception e) {
                    return null;
                }
            }

            @Override
            public void onSuccess(Bitmap bitmap) {
                CPDFWatermark watermark;
                if ("text".equals(type)) {
                    watermark = document.createWatermark(Type.WATERMARK_TYPE_TEXT);
                    watermark.setText(textContent);
                    watermark.setFontName("Helvetica");
                    watermark.setTextRGBColor(Color.parseColor(textColor));
                    watermark.setFontSize(fontSize);
                } else {
                    if (bitmap == null) {
                        result.error("WATERMARK_FAIL", "image path is invalid. bitmap == null",
                                "");
                        return;
                    }
                    watermark = document.createWatermark(Type.WATERMARK_TYPE_IMG);
                    watermark.setImage(bitmap, bitmap.getWidth(), bitmap.getHeight());
                }

                watermark.setOpacity(opacity);
                watermark.setFront(isFront);
                watermark.setHorizalign(
                        CPDFEnumConvertUtil.stringToHorizAlign(horizontalAlignment));
                watermark.setVertalign(CPDFEnumConvertUtil.stringToVertAlign(verticalAlignment));
                watermark.setRotation((float) -(rotation * Math.PI / 180));
                watermark.setVertOffset(verticalOffset);
                watermark.setHorizOffset(horizontalOffset);
                watermark.setScale(scale);
                watermark.setPages(pages);
                watermark.setFullScreen(isTilePage);
                watermark.setHorizontalSpacing(horizontalSpacing);
                watermark.setVerticalSpacing(verticalSpacing);
                watermark.update();
                watermark.release();
                pdfView.getCPdfReaderView().reloadPages();
                result.success(true);
            }
        }.execute();
    }

    public static void removeAllWatermarks(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        for (int watermarkCount = document.getWatermarkCount(); watermarkCount > 0;
                watermarkCount--) {
            document.getWatermark(watermarkCount - 1).clear();
        }
        if (context.getReaderView() != null) {
            context.getReaderView().reloadPages();
        }
        result.success(null);
    }
}