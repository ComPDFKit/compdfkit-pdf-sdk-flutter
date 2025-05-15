package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import static com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms.FlutterCPDFPushbuttonWidget.getActionType;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFInkAnnotation;
import com.compdfkit.core.annotation.CPDFLinkAnnotation;
import com.compdfkit.core.document.CPDFDestination;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.action.CPDFAction;
import com.compdfkit.core.document.action.CPDFAction.ActionType;
import com.compdfkit.core.document.action.CPDFGoToAction;
import com.compdfkit.core.document.action.CPDFUriAction;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import java.util.HashMap;
import java.util.Map;

public class FlutterCPDFLinkAnnotation extends FlutterCPDFBaseAnnotation {

  private CPDFDocument document;

  public void setDocument(CPDFDocument document) {
    this.document = document;
  }

  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFLinkAnnotation linkAnnotation = (CPDFLinkAnnotation) annotation;
    CPDFAction action = linkAnnotation.getLinkAction();
    if (action != null){
      Map<String, Object> actionMap = new HashMap<>();
      actionMap.put("actionType", getActionType(action));
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


}
