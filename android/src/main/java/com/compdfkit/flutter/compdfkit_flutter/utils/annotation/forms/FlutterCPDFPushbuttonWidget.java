package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFTextAttribute;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget.CheckboxStyle;
import com.compdfkit.core.annotation.form.CPDFPushbuttonWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.BorderStyle;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDestination;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.action.CPDFAction;
import com.compdfkit.core.document.action.CPDFAction.ActionType;
import com.compdfkit.core.document.action.CPDFGoToAction;
import com.compdfkit.core.document.action.CPDFNamedAction;
import com.compdfkit.core.document.action.CPDFUriAction;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import java.util.HashMap;
import java.util.Map;


public class FlutterCPDFPushbuttonWidget extends FlutterCPDFBaseWidget {

  private CPDFDocument document;

  public void setDocument(CPDFDocument document) {
    this.document = document;
  }

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFPushbuttonWidget pushbuttonWidget = (CPDFPushbuttonWidget) widget;
    map.put("type", "pushButton");
    map.put("buttonTitle", pushbuttonWidget.getButtonTitle());
    CPDFAction action = pushbuttonWidget.getButtonAction();
    if (action != null){
      Map<String, Object> actionMap = new HashMap<>();
      actionMap.put("actionType", CPDFEnumConvertUtil.actionTypeToString(action));
      switch (action.getActionType()){
          case PDFActionType_URI:
              CPDFUriAction uriAction = (CPDFUriAction) action;
              actionMap.put("uri", uriAction.getUri());
              break;
          case PDFActionType_GoTo:
              CPDFGoToAction goToAction = (CPDFGoToAction) action;
              if (document != null && goToAction != null){
                  CPDFDestination destination = goToAction.getDestination(document);
                  actionMap.put("pageIndex",destination != null ? destination.getPageIndex() : 0);
              }
              break;
          case PDFActionType_Named:
              CPDFNamedAction namedAction = (CPDFNamedAction) action;
              actionMap.put("namedAction", CPDFEnumConvertUtil.namedActionToString(namedAction.getNamedAction()));
              break;
          default:
              break;
      }
      map.put("action", actionMap);
    }
    map.put("fontColor", CAppUtils.toHexColor(pushbuttonWidget.getFontColor()));
    map.put("fontSize", pushbuttonWidget.getFontSize());

    String psName = pushbuttonWidget.getFontName();
    String[] names = CPDFEnumConvertUtil.parseFamilyAndStyleFromPsName(psName);

    map.put("familyName", names[0]);
    map.put("styleName", names[1]);
  }

  @Override
  public void updateWidget(CPDFAnnotation annotation, HashMap<String, Object> annotMap) {
    super.updateWidget(annotation, annotMap);
    CPDFPushbuttonWidget pushButtonWidget = (CPDFPushbuttonWidget) annotation;

    String buttonTitle = annotMap.get("buttonTitle").toString();
    String fontColor = annotMap.get("fontColor").toString();
    double fontSize = (double) annotMap.get("fontSize");
    String familyName = annotMap.get("familyName").toString();
    String styleName = annotMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);

    pushButtonWidget.setFontName(psName);
    pushButtonWidget.setButtonTitle(buttonTitle);
    pushButtonWidget.setFontSize((float) fontSize);
    pushButtonWidget.setFontColor(Color.parseColor(fontColor));

    HashMap<String, Object> actionMap = (HashMap<String, Object>) annotMap.get("action");
    if (actionMap != null){
      String actionTypeStr = actionMap.get("actionType").toString();
      ActionType actionType = CPDFEnumConvertUtil.stringToActionType(actionTypeStr);
      switch(actionType){
          case PDFActionType_URI:
              String uri = actionMap.get("uri").toString();
              CPDFUriAction uriAction = new CPDFUriAction();
              uriAction.setUri(uri);
              pushButtonWidget.setButtonAction(uriAction);
              break;
          case PDFActionType_GoTo:
              int pageIndex = (int) actionMap.get("pageIndex");
              float height = annotation.pdfPage.getSize().height();
              CPDFDestination destination = new CPDFDestination(pageIndex, 0F, height, 1F);
              CPDFGoToAction goToAction = new CPDFGoToAction();
              goToAction.setDestination(document, destination);
              pushButtonWidget.setButtonAction(goToAction);
              break;
          case PDFActionType_Named:
                String namedActionStr = actionMap.get("namedAction").toString();
                CPDFNamedAction namedAction = new CPDFNamedAction();
                namedAction.setNamedAction(CPDFEnumConvertUtil.stringToNamedAction(namedActionStr));
                pushButtonWidget.setButtonAction(namedAction);
                break;
          default:
              break;
      }
    }
  }

  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {
    int pageIndex = (int) widgetMap.get("page");
    HashMap<String, Object> rectMap = (HashMap<String, Object>) widgetMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");
    String title = widgetMap.get("title").toString();

    String fillColor = widgetMap.get("fillColor").toString();
    String borderColor = widgetMap.get("borderColor").toString();
    double borderWidth = (double) widgetMap.get("borderWidth");

    String buttonTitle = widgetMap.get("buttonTitle").toString();
    String fontColor = widgetMap.get("fontColor").toString();
    double fontSize = (double) widgetMap.get("fontSize");
    String familyName = widgetMap.get("familyName").toString();
    String styleName = widgetMap.get("styleName").toString();
    String psName = CPDFTextAttribute.FontNameHelper.obtainFontName(familyName, styleName);


    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFPushbuttonWidget widget = (CPDFPushbuttonWidget) page.addFormWidget(
        WidgetType.Widget_PushButton);
    if (widget != null && widget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      widget.setRect(rectF);
      if (TextUtils.isEmpty(title)){
        widget.setFieldName(CAppUtils.getDefaultFiledName("Push Button_"));
      } else {
        widget.setFieldName(title);
      }
      if (widgetMap.get("createDate") != null){
        long createDateTimestamp = (long) widgetMap.get("createDate");
        widget.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        widget.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        widget.setCreationDate(TTimeUtil.getCurrentDate());
        widget.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }


      widget.setFontName(psName);
      widget.setButtonTitle(buttonTitle);
      widget.setFontSize((float) fontSize);
      widget.setFontColor(Color.parseColor(fontColor));

      HashMap<String, Object> actionMap = (HashMap<String, Object>) widgetMap.get("action");
      if (actionMap != null){
        String actionTypeStr = actionMap.get("actionType").toString();
        ActionType actionType = CPDFEnumConvertUtil.stringToActionType(actionTypeStr);
        switch (actionType){
            case PDFActionType_URI:
                String uri = actionMap.get("uri").toString();
                CPDFUriAction uriAction = new CPDFUriAction();
                uriAction.setUri(uri);
                widget.setButtonAction(uriAction);
                break;
            case PDFActionType_GoTo:
                int targetPageIndex = (int) actionMap.get("pageIndex");
                float height = document.pageAtIndex(targetPageIndex).getSize().height();
                CPDFDestination destination = new CPDFDestination(targetPageIndex, 0F, height, 1F);
                CPDFGoToAction goToAction = new CPDFGoToAction();
                goToAction.setDestination(document, destination);
                widget.setButtonAction(goToAction);
                break;
            case PDFActionType_Named:
                String namedActionStr = actionMap.get("namedAction").toString();
                CPDFNamedAction namedAction = new CPDFNamedAction();
                namedAction.setNamedAction(CPDFEnumConvertUtil.stringToNamedAction(namedActionStr));
                widget.setButtonAction(namedAction);
                break;
        }
      }
      widget.setFillColor(Color.parseColor(fillColor));
      widget.setBorderColor(Color.parseColor(borderColor));
      widget.setBorderWidth((float) borderWidth);
      widget.setBorderStyles(BorderStyle.BS_Solid);

      widget.updateAp();
    }
    return widget;
  }
}
