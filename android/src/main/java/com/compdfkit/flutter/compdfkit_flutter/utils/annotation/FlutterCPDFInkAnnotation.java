package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.graphics.PointF;
import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.CPDFBorderStyle;
import com.compdfkit.core.annotation.CPDFBorderStyle.Style;
import com.compdfkit.core.annotation.CPDFInkAnnotation;
import com.compdfkit.core.annotation.CPDFLineAnnotation;
import com.compdfkit.core.annotation.CPDFLineAnnotation.LineType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class FlutterCPDFInkAnnotation extends FlutterCPDFBaseAnnotation {


    @Override
    public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
        CPDFInkAnnotation inkAnnotation = (CPDFInkAnnotation) annotation;
        map.put("color", CAppUtils.toHexColor(inkAnnotation.getColor()));
        map.put("alpha", (double) inkAnnotation.getAlpha());
        map.put("borderWidth", inkAnnotation.getBorderWidth());
        PointF[][] pointfs = inkAnnotation.getInkPath();
        List<List<List<Double>>> inkPath = new ArrayList<>();
        if (pointfs != null) {
            for (PointF[] stroke : pointfs) {
                List<List<Double>> strokeList = new ArrayList<>();
                if (stroke != null) {
                    for (PointF p : stroke) {
                        List<Double> point = new ArrayList<>(2);
                        point.add(CAppUtils.roundTo2(p.x));
                        point.add(CAppUtils.roundTo2(p.y));
                        strokeList.add(point);
                    }
                }
                inkPath.add(strokeList);
            }
        }
        map.put("inkPath", inkPath);
    }


    @Override
    public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
        super.updateAnnotation(annotation, annotMap);
        String hexColor = annotMap.get("color").toString();
        double alpha = (double) annotMap.get("alpha");
        double borderWidth = (double) annotMap.get("borderWidth");
        CPDFInkAnnotation inkAnnotation = (CPDFInkAnnotation) annotation;
        inkAnnotation.setColor(Color.parseColor(hexColor));
        inkAnnotation.setAlpha((int) alpha);
        inkAnnotation.setBorderWidth((float) borderWidth);
    }

    @Override
    public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
        int pageIndex = (int) annotMap.get("page");
        String title = annotMap.get("title").toString();
        String content = annotMap.get("content").toString();
        HashMap<String, Object> rectMap = (HashMap<String, Object>) annotMap.get("rect");
        double left = (double) rectMap.get("left");
        double top = (double) rectMap.get("top");
        double right = (double) rectMap.get("right");
        double bottom = (double) rectMap.get("bottom");

        String color = annotMap.get("color").toString();
        double alpha = (double) annotMap.get("alpha");
        double borderWidth = (double) annotMap.get("borderWidth");

        List<List<List<Double>>> points = (List<List<List<Double>>>) annotMap.get("inkPath");

        CPDFPage page = document.pageAtIndex(pageIndex);
        CPDFInkAnnotation inkAnnotation = (CPDFInkAnnotation) page.addAnnot(
            Type.INK);

        if (inkAnnotation.isValid()) {

            inkAnnotation.setTitle(title);
            inkAnnotation.setContent(content);
            inkAnnotation.setBorderWidth((float) borderWidth);
            inkAnnotation.setColor(Color.parseColor(color));
            inkAnnotation.setAlpha((int) alpha);

            if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
                long createDateTimestamp = (long) annotMap.get("createDate");
                inkAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
                inkAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
            } else {
                inkAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
                inkAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
            }

            RectF pageSize = document.getPageSize(pageIndex);
            if (pageSize == null || pageSize.isEmpty()) {
                return inkAnnotation;
            }

            int lineCount = points != null ? points.size() : 0;
            PointF[][] path = new PointF[lineCount][];

            RectF rect = null;
            for (int lineIndex = 0; lineIndex < lineCount; lineIndex++) {
                List<List<Double>> stroke = points.get(lineIndex);
                int pointCount = stroke != null ? stroke.size() : 0;
                PointF[] linePath = new PointF[pointCount];

                for (int pointIndex = 0; pointIndex < pointCount; pointIndex++) {
                    List<Double> p = stroke.get(pointIndex);
                    double x = (p != null && p.size() > 0) ? (p.get(0) != null ? p.get(0) : 0d) : 0d;
                    double y = (p != null && p.size() > 1) ? (p.get(1) != null ? p.get(1) : 0d) : 0d;

                    float fx = (float) x;
                    float fy = (float) y;

                    if (rect == null) {
                        rect = new RectF(fx, fy, fx, fy);
                    } else {
                        rect.union(fx, fy);
                    }

                    linePath[pointIndex] = new PointF(fx, fy);
                }
                path[lineIndex] = linePath;
            }
            if (rect != null) {
                float scaleValue = 1F;
                float dx = (float) borderWidth / scaleValue / 2f;
                rect.inset(-dx, -dx);
            } else {
                rect = new RectF((float) left, (float) top, (float) right, (float) bottom);
            }

            inkAnnotation.setInkPath(path);
            inkAnnotation.setRect(rect);
            inkAnnotation.updateAp();
        }
        return inkAnnotation;
    }
}
