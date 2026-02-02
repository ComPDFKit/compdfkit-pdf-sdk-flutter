package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.graphics.PointF;
import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFLineAnnotation;
import com.compdfkit.core.annotation.CPDFLineAnnotation.LineType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FlutterCPDFLineAnnotation extends FlutterCPDFBaseAnnotation {


    @Override
    public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
        CPDFLineAnnotation lineAnnotation = (CPDFLineAnnotation) annotation;
        if (lineAnnotation.getLineHeadType() == LineType.LINETYPE_NONE
            && lineAnnotation.getLineTailType() == LineType.LINETYPE_NONE) {
            map.put("type", "line");
        } else {
            map.put("type", "arrow");
        }
        PointF[] linePoints = lineAnnotation.getLinePoints();
        List<List<Double>> points = new ArrayList<>();
        if (linePoints != null) {
            for (PointF linePoint : linePoints) {
                points.add(Arrays.asList((double) linePoint.x, (double) linePoint.y));
            }
            map.put("points", points);
        }
        map.put("borderColor", CAppUtils.toHexColor(lineAnnotation.getBorderColor()));
        map.put("borderAlpha", (double) lineAnnotation.getBorderAlpha());
        map.put("fillColor", CAppUtils.toHexColor(lineAnnotation.getFillColor()));
        map.put("fillAlpha", (double) lineAnnotation.getFillAlpha());
        map.put("borderWidth", lineAnnotation.getBorderWidth());
        map.put("lineHeadType",
            CPDFEnumConvertUtil.lineTypeToString(lineAnnotation.getLineHeadType()));
        map.put("lineTailType",
            CPDFEnumConvertUtil.lineTypeToString(lineAnnotation.getLineTailType()));
        CPDFBorderStyle borderStyle = lineAnnotation.getBorderStyle();
        if (borderStyle != null) {
            float[] dashArr = borderStyle.getDashArr();
            if (dashArr != null && dashArr.length == 2) {
                map.put("dashGap", borderStyle.getDashArr()[1]);
            }
        }

    }


    @Override
    public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
        super.updateAnnotation(annotation, annotMap);
        CPDFLineAnnotation lineAnnotation = (CPDFLineAnnotation) annotation;
        String borderColor = annotMap.get("borderColor").toString();
        double borderAlpha = (double) annotMap.get("borderAlpha");
        double borderWidth = (double) annotMap.get("borderWidth");

        String fillColor = annotMap.get("fillColor").toString();
        double fillAlpha = (double) annotMap.get("fillAlpha");

        double dashGap = (double) annotMap.get("dashGap");

        Style style;
        if (dashGap == 0.0) {
            style = Style.Border_Solid;
        } else {
            style = Style.Border_Dashed;
        }
        CPDFBorderStyle borderStyle = new CPDFBorderStyle(style,
            (float) borderWidth, new float[]{8.0F, (float) dashGap});
        lineAnnotation.setBorderStyle(borderStyle);

        lineAnnotation.setBorderColor(Color.parseColor(borderColor));
        lineAnnotation.setBorderAlpha((int) borderAlpha);
        lineAnnotation.setBorderWidth((float) borderWidth);
        lineAnnotation.setFillColor(Color.parseColor(fillColor));
        lineAnnotation.setFillAlpha((int) fillAlpha);

        LineType startLineType = CPDFEnumConvertUtil.stringToLineType(
            annotMap.get("lineHeadType").toString());
        LineType tailLineType = CPDFEnumConvertUtil.stringToLineType(
            annotMap.get("lineTailType").toString());

        lineAnnotation.setLineType(startLineType, tailLineType);
    }

    @Override
    public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
        super.addAnnotation(document, annotMap);
        int pageIndex = (int) annotMap.get("page");
        String title = annotMap.get("title").toString();
        String content = annotMap.get("content").toString();
        double borderWidth = (double) annotMap.get("borderWidth");

        List<List<Double>> points = (List<List<Double>>) annotMap.get("points");

        CPDFPage page = document.pageAtIndex(pageIndex);
        CPDFLineAnnotation lineAnnotation = (CPDFLineAnnotation) page.addAnnot(
            CPDFAnnotation.Type.LINE);
        if (lineAnnotation.isValid()) {
            if (points != null && points.size() == 2){
                List<Double> startPointList = points.get(0);
                List<Double> endPointList = points.get(1);

                PointF startPoint = new PointF(startPointList.get(0).floatValue(), startPointList.get(1).floatValue());
                PointF endPoint = new PointF(endPointList.get(0).floatValue(), endPointList.get(1).floatValue());

                RectF rectF = convertLinePoint(startPoint, endPoint, (float) borderWidth);
                lineAnnotation.setRect(rectF);
                lineAnnotation.setLinePoints(startPoint, endPoint);
            }

            if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
                long createDateTimestamp = (long) annotMap.get("createDate");
                lineAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
                lineAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
            } else {
                lineAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
                lineAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
            }

            // Set endpoints: from bottom-left to top-right within rect
            lineAnnotation.setTitle(title);
            lineAnnotation.setContent(content);

            updateAnnotation(lineAnnotation, annotMap);

            lineAnnotation.updateAp();
        }
        return lineAnnotation;
    }


    private RectF convertLinePoint(PointF startPoint, PointF endPoint, float borderWidth) {
        RectF area = new RectF();
        area.left = Math.min(startPoint.x, endPoint.x);
        area.right = Math.max(startPoint.x, endPoint.x);
        area.top = Math.max(startPoint.y, endPoint.y);
        area.bottom = Math.min(startPoint.y, endPoint.y);
        area.left -= borderWidth * 2;
        area.top += borderWidth * 2;
        area.right += borderWidth * 2;
        area.bottom -= borderWidth * 2;
        return area;
    }
}
