/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. This notice
 * may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;

import android.graphics.Color;
import android.graphics.RectF;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFRedactAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;

import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFRedactAnnotation extends FlutterCPDFBaseAnnotation {

    @Override
    public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
        CPDFRedactAnnotation redact = (CPDFRedactAnnotation) annotation;
        map.remove("markState");
        map.remove("reviewState");
        map.put("overlayText", redact.getOverLayText());
        map.put("fillColor", toHexColor(redact.getFillColor()));
        int outlineColor = redact.getOutlineColor();
        map.put("outlineColor", outlineColor == Color.TRANSPARENT
                ? null
                : toHexColor(outlineColor));
        map.put("alignment", CPDFEnumConvertUtil.freeTextAlignmentToString(
                redact.getTextAlignment()));

        CPDFTextAttribute textAttribute = redact.getTextDa();
        if (textAttribute != null) {
            Map<String, Object> textAttributeMap = new HashMap<>();
            textAttributeMap.put("color", toHexColor(textAttribute.getColor()));
            String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(
                    textAttribute.getFontName());
            textAttributeMap.put("familyName", names[0]);
            textAttributeMap.put("styleName", names[1]);
            textAttributeMap.put("fontSize", textAttribute.getFontSize());
            map.put("textAttribute", textAttributeMap);
        }

    }

    @Override
    public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
        super.updateAnnotation(annotation, annotMap);
        CPDFRedactAnnotation redact = (CPDFRedactAnnotation) annotation;

        Object overlayText = annotMap.get("overlayText");
        if (overlayText instanceof String) {
            redact.setOverLayText((String) overlayText);
        }
        Object fillColor = annotMap.get("fillColor");
        if (fillColor instanceof String) {
            redact.setFillColor(Color.parseColor((String) fillColor));
        }
        Object outlineColor = annotMap.get("outlineColor");
        if (outlineColor instanceof String) {
            redact.setOutlineColor(Color.parseColor((String) outlineColor));
        } else if (annotMap.containsKey("outlineColor")) {
            redact.clearOutlineColor();
        }
        Object alignment = annotMap.get("alignment");
        if (alignment instanceof String) {
            redact.setTextAlignment(
                    CPDFEnumConvertUtil.stringToFreeTextAlignment((String) alignment));
        }

        Object rawTextAttribute = annotMap.get("textAttribute");
        if (rawTextAttribute instanceof Map) {
            Map<?, ?> textAttribute = (Map<?, ?>) rawTextAttribute;
            String familyName = stringValue(textAttribute.get("familyName"), "Helvetica");
            String styleName = stringValue(textAttribute.get("styleName"), "");
            float fontSize = numberValue(textAttribute.get("fontSize"), 12).floatValue();
            String color = stringValue(textAttribute.get("color"), "#FF000000");
            String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);
            redact.setTextDa(new CPDFTextAttribute(psName, fontSize, Color.parseColor(color)));
        }

    }

    @Override
    public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
        int pageIndex = numberValue(annotMap.get("page"), 0).intValue();
        CPDFPage page = document.pageAtIndex(pageIndex);
        if (page == null || !page.isValid()) {
            return null;
        }
        CPDFRedactAnnotation redact =
                (CPDFRedactAnnotation) page.addAnnot(CPDFAnnotation.Type.REDACT);
        if (redact == null || !redact.isValid()) {
            return redact;
        }

        Object rawRect = annotMap.get("rect");
        if (rawRect instanceof Map) {
            Map<?, ?> rect = (Map<?, ?>) rawRect;
            redact.setRect(new RectF(
                    numberValue(rect.get("left"), 0).floatValue(),
                    numberValue(rect.get("top"), 0).floatValue(),
                    numberValue(rect.get("right"), 0).floatValue(),
                    numberValue(rect.get("bottom"), 0).floatValue()));
        }
        redact.setTitle(stringValue(annotMap.get("title"), ""));
        redact.setContent(stringValue(annotMap.get("content"), ""));

        Object createDate = annotMap.get("createDate");
        if (createDate instanceof Number) {
            long timestamp = ((Number) createDate).longValue();
            redact.setCreationDate(TTimeUtil.fromTimestamp(timestamp));
            redact.setRecentlyModifyDate(TTimeUtil.fromTimestamp(timestamp));
        } else {
            redact.setCreationDate(TTimeUtil.getCurrentDate());
            redact.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
        }
        updateAnnotation(redact, annotMap);
        redact.updateAp();
        return redact;
    }

    private static Number numberValue(Object value, Number fallback) {
        return value instanceof Number ? (Number) value : fallback;
    }

    private static String stringValue(Object value, String fallback) {
        return value instanceof String ? (String) value : fallback;
    }

    private static String toHexColor(int color) {
        return String.format("#%08X", color);
    }
}
