package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;



import android.graphics.Color;
import android.graphics.RectF;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.CPDFLinkAnnotation;
import com.compdfkit.core.annotation.CPDFMarkupAnnotation;
import com.compdfkit.core.document.CPDFDestination;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.action.CPDFAction;
import com.compdfkit.core.document.action.CPDFAction.ActionType;
import com.compdfkit.core.document.action.CPDFGoToAction;
import com.compdfkit.core.document.action.CPDFUriAction;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFTextSelection;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFLinkAnnotation extends FlutterCPDFBaseAnnotation {

  private CPDFDocument document;

  public void setDocument(CPDFDocument document) {
    this.document = document;
  }

  @Override
  public void getAnnotationConvert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFLinkAnnotation linkAnnotation = (CPDFLinkAnnotation) annotation;
    CPDFAction action = linkAnnotation.getLinkAction();
    if (action != null){
      Map<String, Object> actionMap = new HashMap<>();
      actionMap.put("actionType", CPDFEnumConvertUtil.actionTypeToString(action));
      if (action.getActionType() == ActionType.PDFActionType_URI){
        CPDFUriAction uriAction = (CPDFUriAction) action;
        String uri = uriAction.getUri();
        actionMap.put("uri", uri);
      } else if (action.getActionType() == ActionType.PDFActionType_GoTo){
        CPDFGoToAction goToAction = (CPDFGoToAction) action;
        if (document != null){
          CPDFDestination destination = goToAction.getDestination(document);
          actionMap.put("pageIndex", destination.getPageIndex());
        }
      }
      map.put("action", actionMap);
    }
  }

  @Override
  public void updateAnnotation(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateAnnotation(annotation, annotMap);

    CPDFLinkAnnotation linkAnnotation = (CPDFLinkAnnotation) annotation;
    HashMap<String, Object> actionMap = (HashMap<String, Object>) annotMap.get("action");
    if (actionMap != null){
      String actionType = actionMap.get("actionType").toString();
      if (actionType.equals("uri")){
        String uri = actionMap.get("uri").toString();
        CPDFUriAction uriAction = new CPDFUriAction();
        uriAction.setUri(uri);
        linkAnnotation.setLinkAction(uriAction);
      } else if (actionType.equals("goTo")){
        if (document != null){
          int pageIndex = (int) actionMap.get("pageIndex");
          float height = document.pageAtIndex(pageIndex).getSize().height();
          CPDFDestination destination = new CPDFDestination(pageIndex, 0F, height, 1F);
          CPDFGoToAction goToAction = new CPDFGoToAction();
          goToAction.setDestination(document, destination);
          linkAnnotation.setLinkAction(goToAction);
        }
      }
    }

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

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFLinkAnnotation linkAnnotation = (CPDFLinkAnnotation) page.addAnnot(Type.LINK);
    if (linkAnnotation.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      linkAnnotation.setTitle(title);
      linkAnnotation.setContent(content);
      linkAnnotation.setRect(rectF);

      if (annotMap.containsKey("createDate") && annotMap.get("createDate")!= null){
        long createDateTimestamp = (long) annotMap.get("createDate");
        linkAnnotation.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        linkAnnotation.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        linkAnnotation.setCreationDate(TTimeUtil.getCurrentDate());
        linkAnnotation.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }

      updateAnnotation(linkAnnotation, annotMap);

      linkAnnotation.updateAp();
    }

    return linkAnnotation;
  }
}
