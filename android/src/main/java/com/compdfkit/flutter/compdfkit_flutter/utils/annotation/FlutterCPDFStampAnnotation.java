package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.RectF;
import android.text.TextUtils;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFStampAnnotation;
import com.compdfkit.core.annotation.CPDFStampAnnotation.TextStamp;
import com.compdfkit.core.annotation.CPDFStampAnnotation.TextStampShape;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFStampAnnotation extends FlutterCPDFBaseAnnotation {

    private Context context;

    public void setContext(Context context) {
        this.context = context;
    }

    @Override
    public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
        CPDFStampAnnotation stampAnnotation = (CPDFStampAnnotation) annotation;
        if (stampAnnotation.isStampSignature()) {
            map.put("type", "signature");
        } else {
            String stampTypeStr = CPDFEnumConvertUtil.stampTypeToString(
                stampAnnotation.getStampType());
            switch (stampAnnotation.getStampType()) {
                case STANDARD_STAMP:
                    map.put("type", "stamp");
                    map.put("stampType", stampTypeStr);
                    map.put("standardStamp",
                        CPDFEnumConvertUtil.standardStampToString(
                            stampAnnotation.getStandardStamp()));
                    break;
                case TEXT_STAMP:
                    map.put("type", "stamp");
                    map.put("stampType", stampTypeStr);
                    HashMap<String, Object> textStampMap = new HashMap<>();
                    TextStamp textStamp = stampAnnotation.getTextStamp();
                    textStampMap.put("content", textStamp.getContent());
                    textStampMap.put("date", textStamp.getDate());
                    textStampMap.put("shape",
                        CPDFEnumConvertUtil.stampShapeToString(textStamp.getTextStampShape()));
                    textStampMap.put("color",
                        CPDFEnumConvertUtil.stampColorToString(textStamp.getTextStampColor()));
                    map.put("textStamp", textStampMap);
                    break;
                case IMAGE_STAMP:
                    map.put("type", "pictures");
                    map.put("stampType", stampTypeStr);
                    break;
            }
        }
    }

    @Override
    public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
        super.updateAnnotation(annotation, annotMap);
    }

    @Override
    public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
        super.addAnnotation(document, annotMap);
        int pageIndex = (int) annotMap.get("page");
        String title = annotMap.get("title").toString();
        String content = annotMap.get("content").toString();
        HashMap<String, Object> rectMap = (HashMap<String, Object>) annotMap.get("rect");
        double left = (double) rectMap.get("left");
        double top = (double) rectMap.get("top");
        double right = (double) rectMap.get("right");
        double bottom = (double) rectMap.get("bottom");

        String stampTypeStr = annotMap.get("stampType").toString();

        CPDFPage page = document.pageAtIndex(pageIndex);
        CPDFStampAnnotation stampAnnotation = (CPDFStampAnnotation) page.addAnnot(
            CPDFAnnotation.Type.STAMP);
        if (stampAnnotation.isValid()) {

            stampAnnotation.setTitle(title);
            stampAnnotation.setContent(content);

            if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
                long createDateTimestamp = (long) annotMap.get("createDate");
                stampAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
                stampAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
            } else {
                stampAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
                stampAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
            }

            CPDFStampAnnotation.StampType stampType = CPDFEnumConvertUtil.stringToStampType(
                stampTypeStr);
            if (stampType == CPDFStampAnnotation.StampType.STANDARD_STAMP) {
                String standardStampStr = annotMap.get("standardStamp").toString();
                stampAnnotation.setStandardStamp(
                    CPDFEnumConvertUtil.stringToStandardStamp(standardStampStr));
                RectF sourceRect = stampAnnotation.getRect();
                RectF adjusted = computeAdjustedRect(sourceRect, (float) left, (float) top, (float) right, (float) bottom);
                stampAnnotation.setRect(adjusted);
            } else if (stampType == CPDFStampAnnotation.StampType.TEXT_STAMP) {
                HashMap<String, Object> textStampMap = (HashMap<String, Object>) annotMap.get(
                    "textStamp");
                String textStampContent = textStampMap.get("content").toString();
                String date = textStampMap.get("date").toString();
                TextStampShape shape = CPDFEnumConvertUtil.stringToStampShape(
                    textStampMap.get("shape").toString());
                CPDFStampAnnotation.TextStampColor color = CPDFEnumConvertUtil.stringToStampColor(
                    textStampMap.get("color").toString());
                TextStamp textStamp = new TextStamp(textStampContent, date, shape.id, color.id);
                stampAnnotation.setTextStamp(textStamp);
                RectF sourceRect = stampAnnotation.getRect();
                RectF adjusted = computeAdjustedRect(sourceRect, (float) left, (float) top, (float) right, (float) bottom);
                stampAnnotation.setRect(adjusted);
            } else if (stampType == CPDFStampAnnotation.StampType.IMAGE_STAMP) {
                Bitmap bitmap = resolveImageBitmap(annotMap);
                if (bitmap != null) {
                    RectF sourceRect = new RectF(0, 0, bitmap.getWidth(), bitmap.getHeight());
                    stampAnnotation.setRect(computeAdjustedRect(sourceRect,(float) left, (float) top, (float) right, (float) bottom));
                    stampAnnotation.updateApWithBitmap(bitmap);
                } else {
                    Log.e("ComPDFKit", "Failed to decode image annotation payload.");
                    return null;
                }

                if (annotMap.containsKey("isStampSignature")){
                    boolean isStampSignature = (boolean) annotMap.get("isStampSignature");
                    if (isStampSignature){
                        stampAnnotation.setStampSignature(true);
                    }
                }
            }
            // IMAGE_STAMP creation typically requires image resource prepared elsewhere.
            stampAnnotation.updateAp();
        }
        return stampAnnotation;
    }

    private RectF computeAdjustedRect(RectF sourceRect, float left, float top, float right, float bottom) {
        RectF rectF = new RectF(left, top, right, bottom);
        float targetWidth = rectF.width();
        float aspect = (sourceRect.width() == 0f) ? 1f : Math.abs(sourceRect.height() / sourceRect.width());
        float targetHeight = targetWidth * aspect;
        return new RectF(left, top, left + targetWidth, top + targetHeight);
    }

    private Bitmap resolveImageBitmap(HashMap<String, Object> annotMap) {
        Object imageDataObject = annotMap.get("imageData");
        if (imageDataObject instanceof Map) {
            return resolveBitmapFromImageData((Map<String, Object>) imageDataObject);
        }

        Object legacyImageObject = annotMap.get("image");
        if (legacyImageObject == null) {
            return null;
        }

        String base64Image = legacyImageObject.toString();
        if (TextUtils.isEmpty(base64Image)) {
            return null;
        }
        return CAppUtils.base64ToBitmap(base64Image);
    }

    private Bitmap resolveBitmapFromImageData(Map<String, Object> imageDataMap) {
        String type = imageDataMap.get("type") == null ? "base64" : imageDataMap.get("type").toString();
        String data = imageDataMap.get("data") == null ? "" : imageDataMap.get("data").toString();

        switch (type) {
            case "filePath":
                return BitmapFactory.decodeFile(data);
            case "asset": {
                if (context == null) {
                    return null;
                }
                String path = FileUtils.assetToTempFile(context, data);
                return path == null ? null : BitmapFactory.decodeFile(path);
            }
            case "uri": {
                if (context == null) {
                    return null;
                }
                String path = FileUtils.uriToFilePath(context, data);
                return path == null ? null : BitmapFactory.decodeFile(path);
            }
            case "base64":
            default:
                if (TextUtils.isEmpty(data)) {
                    return null;
                }
                return CAppUtils.base64ToBitmap(data);
        }
    }


}
