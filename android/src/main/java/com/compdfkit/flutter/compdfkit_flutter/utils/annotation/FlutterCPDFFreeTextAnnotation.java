package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import android.graphics.Color;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFFreetextAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFFreeTextAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFFreetextAnnotation freetextAnnotation = (CPDFFreetextAnnotation) annotation;
    map.put("alpha", (double) freetextAnnotation.getAlpha());
    CPDFTextAttribute textAttribute = freetextAnnotation.getFreetextDa();
    Map<String, Object> textAttributeMap = new HashMap<>();
    textAttributeMap.put("color", CAppUtils.toHexColor(textAttribute.getColor()));
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(textAttribute.getFontName());
    map.put("alignment", CPDFEnumConvertUtil.freeTextAlignmentToString(freetextAnnotation.getFreetextAlignment()));
    textAttributeMap.put("familyName", names[0]);
    textAttributeMap.put("styleName", names[1]);
    textAttributeMap.put("fontSize", textAttribute.getFontSize());
    map.put("textAttribute", textAttributeMap);
  }

  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);
    CPDFFreetextAnnotation freetextAnnotation = (CPDFFreetextAnnotation) annotation;
    double alpha = (double) annotMap.get("alpha");
    String alignment = annotMap.get("alignment").toString();

    HashMap<String, Object> textAttributeMap = (HashMap<String, Object>) annotMap.get("textAttribute");
    String textColor = textAttributeMap.get("color").toString();
    double fontSize = (double) textAttributeMap.get("fontSize");
    String familyName = textAttributeMap.get("familyName").toString();
    String styleName = textAttributeMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    freetextAnnotation.setAlpha((int) alpha);
    freetextAnnotation.setFreetextAlignment(CPDFEnumConvertUtil.stringToFreeTextAlignment(alignment));
    freetextAnnotation.setFreetextDa(new CPDFTextAttribute(psName, (float) fontSize,
        Color.parseColor(textColor)));

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

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFFreetextAnnotation freetextAnnotation = (CPDFFreetextAnnotation) page.addAnnot(CPDFAnnotation.Type.FREETEXT);
    if (freetextAnnotation.isValid()){
      android.graphics.RectF rectF = new android.graphics.RectF((float) left, (float) top, (float) right, (float) bottom);
      freetextAnnotation.setRect(rectF);
      freetextAnnotation.setTitle(title);
      freetextAnnotation.setContent(content);
      freetextAnnotation.setBorderWidth(0);

      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        freetextAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        freetextAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        freetextAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        freetextAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }

      updateAnnotation(freetextAnnotation, annotMap);

      freetextAnnotation.updateAp();
    }
    return freetextAnnotation;
  }
}
