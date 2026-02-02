package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;



import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.CPDFLinkAnnotation;
import com.compdfkit.core.annotation.CPDFSoundAnnotation;
import com.compdfkit.core.document.CPDFDestination;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.action.CPDFAction;
import com.compdfkit.core.document.action.CPDFAction.ActionType;
import com.compdfkit.core.document.action.CPDFGoToAction;
import com.compdfkit.core.document.action.CPDFUriAction;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFSoundAnnotation extends FlutterCPDFBaseAnnotation {

  private CPDFDocument document;

  public void setDocument(CPDFDocument document) {
    this.document = document;
  }

  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {

  }

  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);


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

    String soundPath = annotMap.get("soundPath").toString();

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFSoundAnnotation soundAnnotation = (CPDFSoundAnnotation) page.addAnnot(Type.SOUND);
    if (soundAnnotation.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      soundAnnotation.setTitle(title);
      soundAnnotation.setContent(content);
      soundAnnotation.setRect(rectF);
      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        soundAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        soundAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      }else {
        soundAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        soundAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }
      if (!TextUtils.isEmpty(soundPath)){
        File file = new File(soundPath);
        if (file.exists()){
          soundAnnotation.setSoundPath(file.getAbsolutePath());
        }
      }
    }
    return soundAnnotation;
  }
}
