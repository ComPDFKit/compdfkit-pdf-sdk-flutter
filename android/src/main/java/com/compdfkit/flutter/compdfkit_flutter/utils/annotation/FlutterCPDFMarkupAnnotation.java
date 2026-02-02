package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import android.graphics.RectF;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFFreetextAnnotation;
import com.compdfkit.core.annotation.CPDFHighlightAnnotation;
import com.compdfkit.core.annotation.CPDFMarkupAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFTextSelection;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;

public class FlutterCPDFMarkupAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    if (annotation instanceof com.compdfkit.core.annotation.CPDFMarkupAnnotation){
      com.compdfkit.core.annotation.CPDFMarkupAnnotation markupAnnotation = (com.compdfkit.core.annotation.CPDFMarkupAnnotation) annotation;
      map.put("markedText", markupAnnotation.getMarkedText());
      map.put("color", CAppUtils.toHexColor(markupAnnotation.getColor()));
      map.put("alpha", (double) markupAnnotation.getAlpha());
    }
  }

  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);
    CPDFMarkupAnnotation markupAnnotation = (CPDFMarkupAnnotation) annotation;
    String hexColor = annotMap.get("color").toString();
    double alpha = (double) annotMap.get("alpha");
    markupAnnotation.setColor(Color.parseColor(hexColor));
    markupAnnotation.setAlpha((int) alpha);
  }

  @Override
  public CPDFAnnotation addAnnotation(CPDFDocument document, HashMap<String, Object> annotMap) {
    String annotationType = annotMap.get("type").toString();
    CPDFAnnotation.Type type = CPDFEnumConvertUtil.stringToCPDFAnnotType(annotationType);
    int pageIndex = (int) annotMap.get("page");
    String title = annotMap.get("title").toString();
    String content = annotMap.get("content").toString();
    HashMap<String, Object> rectMap = (HashMap<String, Object>) annotMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");

    String markedText = annotMap.get("markedText").toString();
    String color = annotMap.get("color").toString();
    double alpha = (double) annotMap.get("alpha");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFMarkupAnnotation markupAnnotation = (CPDFMarkupAnnotation) page.addAnnot(type);
    if (markupAnnotation.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);

      CPDFTextSelection[] selections  = page.getTextPage().getSelectionsByLineForRect(rectF);
      RectF[] rectFs;
        if (selections != null) {
          rectFs = new RectF[selections.length];
          for (int i = 0; i < selections.length; i++) {
            rectFs[i] = selections[i].getRectF();
          }
        }else {
          rectFs = new RectF[]{rectF};
        }
      markupAnnotation.setQuadRects(rectFs);
      markupAnnotation.setTitle(title);
      markupAnnotation.setContent(content);
      markupAnnotation.setMarkedText(markedText);
      markupAnnotation.setRect(rectF);
      markupAnnotation.setColor(Color.parseColor(color));
      markupAnnotation.setAlpha((int) alpha);
      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        markupAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        markupAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      }else {
        markupAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        markupAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }
      markupAnnotation.updateAp();
    }

    return markupAnnotation;
  }
}
