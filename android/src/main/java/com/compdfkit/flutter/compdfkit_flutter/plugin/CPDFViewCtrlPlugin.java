/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHANGE_EDIT_TYPE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CLEAR_DISPLAY_RECT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.DISMISS_CONTEXT_MENU;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ENTER_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXIT_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_CURRENT_PAGE_INDEX;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FORM_CREATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_SIZE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_DIGITAL_SIGNATURE_STATUS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_PAGE_IN_SCREEN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES_2;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_CURRENT_INK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_CREATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_WIDGET_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ADD_WATERMARK_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_BOTA_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DISPLAY_SETTINGS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_SECURITY_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_THUMBNAIL_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CAN_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DISPLAY_PAGE_INDEX;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FIXED_SCROLL;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SAME_WIDTH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_MARGIN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SPACING;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.VERIFY_DIGITAL_SIGNATURE_STATUS;

import android.content.Context;
import android.graphics.Color;
import android.graphics.RectF;
import android.util.Log;

import androidx.annotation.NonNull;

import androidx.core.content.ContextCompat;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.edit.CPDFEditManager;
import com.compdfkit.core.edit.OnEditStatusChangeListener;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.undo.CPDFUndoManager;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.pdf.config.CPDFWatermarkConfig;
import com.compdfkit.tools.common.views.pdfproperties.CAnnotationType;
import com.compdfkit.tools.common.views.pdfview.CPDFIReaderViewCallback;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.tools.common.views.pdfview.CPreviewMode;
import com.compdfkit.ui.reader.CPDFReaderView;
import com.compdfkit.ui.reader.CPDFReaderView.ViewMode;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CPDFViewCtrlPlugin extends BaseMethodChannelPlugin {

  private int viewId;

  private CPDFDocumentFragment documentFragment;

  private CPDFDocumentPlugin documentPlugin;

  public CPDFViewCtrlPlugin(Context context, BinaryMessenger binaryMessenger, int viewId) {
    super(context, binaryMessenger);
    this.viewId = viewId;

    // Register document plugin,get document info
    documentPlugin = new CPDFDocumentPlugin(context, binaryMessenger, String.valueOf(viewId));
    documentPlugin.register();
  }

  public void setDocumentFragment(CPDFDocumentFragment documentFragment) {
    this.documentFragment = documentFragment;
    this.documentFragment.setInitListener((pdfView) -> {
      documentPlugin.setReaderView(pdfView);
      if (methodChannel != null) {
        methodChannel.invokeMethod("onDocumentIsReady", null);
      }
      pdfView.addReaderViewCallback(new CPDFIReaderViewCallback() {
        @Override
        public void onMoveToChild(int pageIndex) {
          super.onMoveToChild(pageIndex);
          io.flutter.Log.e("ComPDFKit", "onMoveToChild:" + pageIndex);
          Map<String, Object> map = new HashMap<>();
          map.put("pageIndex", pageIndex);
          if (methodChannel != null) {
            methodChannel.invokeMethod("onPageChanged", map);
          }
        }

        @Override
        public void onTapMainDocArea() {
          super.onTapMainDocArea();
          if (methodChannel != null) {
            methodChannel.invokeMethod("onTapMainDocArea", null);
          }
        }
      });
      pdfView.setSaveCallback((s, uri) -> {
        if (methodChannel != null) {
          methodChannel.invokeMethod("saveDocument", "");
        }
      }, e -> {

      });
      CPDFReaderView readerView = pdfView.getCPdfReaderView();

      readerView.getUndoManager().addOnUndoHistoryChangeListener(
          (cpdfUndoManager, operation, type) -> {
            Map<String, Object> map = new HashMap<>();
            map.put("canUndo", cpdfUndoManager.canUndo());
            map.put("canRedo", cpdfUndoManager.canRedo());
            if (methodChannel != null) {
              methodChannel.invokeMethod("onAnnotationHistoryChanged", map);
            }
          });

      CPDFEditManager editManager = readerView.getEditManager();
      if (editManager != null){
        editManager.addEditStatusChangeListener(new OnEditStatusChangeListener() {
          @Override
          public void onBegin(int i) {

          }

          @Override
          public void onUndoRedo(int pageIndex, boolean canUndo, boolean canRedo) {
            Map<String, Object> map = new HashMap<>();
            map.put("canUndo", canUndo);
            map.put("canRedo", canRedo);
            map.put("pageIndex", pageIndex);
            if (methodChannel != null) {
              methodChannel.invokeMethod("onContentEditorHistoryChanged", map);
            }
          }

          @Override
          public void onExit() {

          }
        });
      }

    });
    documentFragment.setPageEditDialogOnBackListener(() -> {
      if (methodChannel != null) {
        methodChannel.invokeMethod("onPageEditDialogBackPress", "");
      }
    });
    documentFragment.setFillScreenChangeListener(isFillScreen -> {
      if (methodChannel != null) {
        methodChannel.invokeMethod("onFullScreenChanged", isFillScreen);
      }
    });
  }

  @Override
  public String methodName() {
    return "com.compdfkit.flutter.ui.pdfviewer." + viewId;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:" + call.method);

    if (documentFragment == null) {
      Log.e(LOG_TAG,
          "CPDFViewCtrlFlutter:onMethodCall: documentFragment is Null return not implemented.");
      result.notImplemented();
    }
    CPDFViewCtrl pdfView = documentFragment.pdfView;
    CPDFReaderView readerView = pdfView.getCPdfReaderView();
    switch (call.method) {
      case SET_SCALE:
        double scaleValue = (double) call.arguments;
        readerView.setScale((float) scaleValue);
        result.success(null);
        break;
      case GET_SCALE:
        result.success((double) readerView.getScale());
        break;
      case SET_CAN_SCALE:
        boolean canScale = (boolean) call.arguments;
        readerView.setCanScale(canScale);
        result.success(null);
        break;
      case SET_READ_BACKGROUND_COLOR:
        String colorHex = call.argument("color");
        String displayMode = call.argument("displayMode");
        readerView.setReadBackgroundColor(Color.parseColor(colorHex));
        switch (displayMode) {
          case "light":
            pdfView.setBackgroundColor(ContextCompat.getColor(context,
                com.compdfkit.tools.R.color.tools_pdf_view_ctrl_background_color));
            break;
          case "dark":
            pdfView.setBackgroundColor(ContextCompat.getColor(context,
                com.compdfkit.tools.R.color.tools_pdf_view_ctrl_background_color_dark));
            break;
          case "sepia":
            pdfView.setBackgroundColor(ContextCompat.getColor(context,
                com.compdfkit.tools.R.color.tools_pdf_view_ctrl_background_color_sepia));
            break;
          case "reseda":
            pdfView.setBackgroundColor(ContextCompat.getColor(context,
                com.compdfkit.tools.R.color.tools_pdf_view_ctrl_background_color_reseda));
            break;
        }
        result.success(null);
        break;
      case SET_WIDGET_BACKGROUND_COLOR:
        String widgetColorHex = (String) call.arguments;
        try {
          pdfView.setBackgroundColor(Color.parseColor(widgetColorHex));
        } catch (Exception e) {
        }
        result.success(null);
        break;
      case GET_READ_BACKGROUND_COLOR:
        String readBgColor =
            "#" + Integer.toHexString(readerView.getReadBackgroundColor()).toUpperCase();
        result.success(readBgColor);
        break;
      case SET_FORM_FIELD_HIGHLIGHT:
        readerView.setFormFieldHighlight((Boolean) call.arguments);
        result.success(null);
        break;
      case IS_FORM_FIELD_HIGHLIGHT:
        result.success(readerView.isFormFieldHighlight());
        break;
      case SET_LINK_HIGHLIGHT:
        readerView.setLinkHighlight((Boolean) call.arguments);
        result.success(null);
        break;
      case IS_LINK_HIGHLIGHT:
        result.success(readerView.isLinkHighlight());
        break;
      case SET_MARGIN:
        int left = call.argument("left");
        int top = call.argument("top");
        int right = call.argument("right");
        int bottom = call.argument("bottom");
        readerView.setReaderViewHorizontalMargin(left, right);
        readerView.setReaderViewTopMargin(top);
        readerView.setReaderViewBottomMargin(bottom);
        readerView.reloadPages();
        result.success(null);
        break;
      case SET_PAGE_SPACING:
        int pageSpacing = (int) call.arguments;
        readerView.setPageSpacing(pageSpacing);
        readerView.reloadPages();
        result.success(null);
        break;
      case SET_VERTICAL_MODE:
        readerView.setVerticalMode((Boolean) call.arguments);
        pdfView.updateScaleForLayout();
        result.success(null);
        break;
      case IS_VERTICAL_MODE:
        result.success(readerView.isVerticalMode());
        break;
      case SET_CONTINUE_MODE:
        readerView.setContinueMode((Boolean) call.arguments);
        pdfView.updateScaleForLayout();
        result.success(null);
        break;
      case IS_CONTINUE_MODE:
        result.success(readerView.isContinueMode());
        break;
      case SET_DOUBLE_PAGE_MODE:
        readerView.setDoublePageMode((boolean) call.arguments);
        readerView.setCoverPageMode(false);
        pdfView.updateScaleForLayout();
        result.success(null);
        break;
      case IS_DOUBLE_PAGE_MODE:
        result.success(readerView.isDoublePageMode());
        break;
      case SET_CROP_MODE:
        readerView.setCropMode((Boolean) call.arguments);
        result.success(null);
        break;
      case IS_CROP_MODE:
        result.success(readerView.isCropMode());
        break;
      case SET_DISPLAY_PAGE_INDEX:{
        int pageIndex = call.argument("pageIndex");

        List<Map<String, Object>> rectList = call.argument("rectList");
        if (rectList != null && rectList.size() > 0) {
          List<RectF> androidRectList = new ArrayList<>();
          for (Map<String, Object> rectMap : rectList) {
            float rectLeft = ((Number) rectMap.get("left")).floatValue();
            float rectTop = ((Number) rectMap.get("top")).floatValue();
            float rectRight = ((Number) rectMap.get("right")).floatValue();
            float rectBottom = ((Number) rectMap.get("bottom")).floatValue();
            RectF pageRectF = new RectF(rectLeft, rectTop, rectRight, rectBottom);
            androidRectList.add(convertScreenRectF(readerView, pageIndex, pageRectF));
          }
          RectF[] rectArray = androidRectList.toArray(new RectF[0]);
          readerView.setDisplayPageIndex(pageIndex, rectArray);
        } else {
          readerView.setDisplayPageIndex(pageIndex);
        }
        result.success(null);
        break;
      }
      case GET_CURRENT_PAGE_INDEX:
        result.success(readerView.getPageNum());
        break;
      case SET_PAGE_SAME_WIDTH:
        readerView.setPageSameWidth((Boolean) call.arguments);
        readerView.reloadPages();
        result.success(null);
        break;
      case SET_COVER_PAGE_MODE:
        readerView.setDoublePageMode((Boolean) call.arguments);
        readerView.setCoverPageMode((Boolean) call.arguments);
        pdfView.updateScaleForLayout();
        result.success(null);
        break;
      case IS_COVER_PAGE_MODE:
        result.success(readerView.isCoverPageMode());
        break;
      case IS_PAGE_IN_SCREEN:
        int pageIndex1 = (int) call.arguments;
        result.success(readerView.isPageInScreen(pageIndex1));
        break;
      case SET_FIXED_SCROLL:
        readerView.setFixedScroll((Boolean) call.arguments);
        result.success(null);
        break;
      case GET_PAGE_SIZE:
        boolean noZoomPage = call.argument("noZoom");
        int page = call.argument("pageIndex");
        RectF rectF;
        if (noZoomPage) {
          rectF = readerView.getPageNoZoomSize(page);
        } else {
          rectF = readerView.getPageSize(page);
        }
        Map<String, Float> pageSizeMap = new HashMap<>();
        pageSizeMap.put("width", rectF.width());
        pageSizeMap.put("height", rectF.height());
        result.success(pageSizeMap);
        break;
      case SET_PREVIEW_MODE:
        String alias = (String) call.arguments;
        CPreviewMode previewMode = CPreviewMode.fromAlias(alias);
        documentFragment.setPreviewMode(previewMode);
        result.success(null);
        break;
      case GET_PREVIEW_MODE:
        result.success(documentFragment.pdfToolBar.getMode().alias);
        break;
      case SHOW_THUMBNAIL_VIEW:
        boolean enableEditMode = (boolean) call.arguments;
        documentFragment.showPageEdit(false, enableEditMode);
        result.success(null);
        break;
      case SHOW_BOTA_VIEW:
        documentFragment.showBOTA();
        result.success(null);
        break;
      case SHOW_ADD_WATERMARK_VIEW:{
        Map<String, Object> configMap = (Map<String, Object>) call.arguments;
        if (configMap == null){
          documentFragment.showAddWatermarkDialog();
        }else {
          documentFragment.showAddWatermarkDialog(CPDFWatermarkConfig.fromMap(configMap));
        }
        result.success(null);
        break;
      }
      case SHOW_SECURITY_VIEW:
        documentFragment.showSecurityDialog();
        result.success(null);
        break;
      case SHOW_DISPLAY_SETTINGS_VIEW:
        documentFragment.showDisplaySettings(pdfView);
        result.success(null);
        break;
      case ENTER_SNIP_MODE:
        documentFragment.enterSnipMode();
        result.success(null);
        break;
      case EXIT_SNIP_MODE:
        documentFragment.exitScreenShot();
        result.success(null);
        break;
      case RELOAD_PAGES:
        documentFragment.pdfView.getCPdfReaderView().reloadPages();
        result.success(null);
        break;
      case RELOAD_PAGES_2:
        documentFragment.pdfView.getCPdfReaderView().reloadPages2();
        result.success(null);
        break;
      case SET_ANNOTATION_MODE:
        String typeStr = call.arguments();

        CAnnotationType type;
        try {
          switch (typeStr) {
            case "note":
              type = CAnnotationType.TEXT;
              break;
            case "pictures":
              type = CAnnotationType.PIC;
              break;
            default:
              type = CAnnotationType.valueOf(typeStr.toUpperCase());
              break;
          }
        } catch (Exception e) {
          type = CAnnotationType.UNKNOWN;
        }
        documentFragment.annotationToolbar.switchAnnotationType(type);
        result.success(null);
        break;
      case GET_ANNOTATION_MODE:
        CAnnotationType annotationType = documentFragment.annotationToolbar.toolListAdapter.getCurrentAnnotType();
        switch (annotationType) {
          case TEXT:
            result.success("note");
            break;
          case PIC:
            result.success("pictures");
            break;
          default:
            result.success(annotationType.name().toLowerCase());
            break;
        }
        break;
      case ANNOTATION_CAN_UNDO: {
        CPDFUndoManager annotationUndoManager = documentFragment.pdfView.getCPdfReaderView()
            .getUndoManager();
        result.success(annotationUndoManager.canUndo());
        break;
      }
      case ANNOTATION_CAN_REDO: {
        CPDFUndoManager annotationUndoManager = documentFragment.pdfView.getCPdfReaderView()
            .getUndoManager();
        result.success(annotationUndoManager.canRedo());
        break;
      }
      case ANNOTATION_UNDO: {
        documentFragment.annotationToolbar.annotUndo();
        result.success(null);
        break;
      }
      case ANNOTATION_REDO: {
        documentFragment.annotationToolbar.annotRedo();
        result.success(null);
        break;
      }
      case CHANGE_EDIT_TYPE:{
        List<Integer> types = (List<Integer>) call.arguments;

        if (readerView.getViewMode() != ViewMode.PDFEDIT && readerView.getViewMode() != ViewMode.ALL){
          result.error("1002", "Current mode is not contentEditor mode, please switch to CPDFViewMode.contentEditor mode first.", null);
          return;
        }
        CPDFEditManager editManager = readerView.getEditManager();
        if (editManager!= null){
          int editType = 0;
          for (Integer t : types) {
            editType = t | editType;
          }
          editManager.changeEditType(editType);
          documentFragment.editToolBar.updateTypeStatus();
          result.success(true);
        }else {
          result.error("1001","EditManager is null, please check if Edit feature is enabled.",null);
        }
        break;
      }
      case CONTENT_EDITOR_CAN_REDO:{
        CPDFEditManager editManager = readerView.getEditManager();
        if (editManager == null){
          result.success(false);
          return;
        }
        result.success(editManager.canRedo());
        break;
      }
      case CONTENT_EDITOR_CAN_UNDO:{
        CPDFEditManager editManager = readerView.getEditManager();
        if (editManager == null){
          result.success(false);
          return;
        }
        result.success(editManager.canUndo());
        break;
      }
      case CONTENT_EDITOR_UNDO:{
        CPDFEditManager editManager = readerView.getEditManager();
        if (editManager == null){
          result.success(false);
          return;
        }
        if (editManager.canUndo()){
          editManager.undo();
          result.success(true);
        }else {
          result.success(false);
        }
        break;
      }
      case CONTENT_EDITOR_REDO:{
        CPDFEditManager editManager = readerView.getEditManager();
        if (editManager == null){
          result.success(false);
          return;
        }
        if (editManager.canRedo()){
          editManager.redo();
          result.success(true);
        }else {
          result.success(false);
        }
        break;
      }
      case SET_FORM_CREATION_MODE:{
        setFormMode(call, result);
        break;
      }
      case GET_FORM_CREATION_MODE:{
        result.success(getFormMode(readerView));
        break;
      }
      case VERIFY_DIGITAL_SIGNATURE_STATUS:{
        documentFragment.verifyDocumentSignStatus();
        result.success(null);
        break;
      }
      case HIDE_DIGITAL_SIGNATURE_STATUS_VIEW:{
        documentFragment.hideDigitalSignStatusView();
        result.success(null);
        break;
      }
      case CLEAR_DISPLAY_RECT:{
        readerView.setDisplayPageRectangles(null);
        readerView.setShowDisplayPageRect(false);
        result.success(true);
        break;
      }
      case DISMISS_CONTEXT_MENU:{
        if (readerView.getContextMenuShowListener() != null) {
          readerView.getContextMenuShowListener().dismissContextMenu();
        }
        result.success(true);
        break;
      }
      case SHOW_TEXT_SEARCH_VIEW: {
        documentFragment.showTextSearchView();
        result.success(null);
        break;
      }
      case HIDE_TEXT_SEARCH_VIEW: {
        documentFragment.hideTextSearchView();
        result.success(null);
        break;
      }
      case SAVE_CURRENT_INK: {
        readerView.getInkDrawHelper().onSave();
        result.success(null);
        break;
      }
      default:
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:notImplemented");
        result.notImplemented();
        break;
    }
  }

  private void setFormMode(MethodCall call, MethodChannel.Result result){
    String mode = (String) call.arguments;
    WidgetType type = CPDFConfigurationUtils.getWidgetType(mode);
    documentFragment.formToolBar.switchFormMode(type);
    result.success(true);
  }

  private String getFormMode(CPDFReaderView readerView){
    switch (readerView.getCurrentFocusedFormType()) {
      case Widget_TextField:
        return "textField";
      case Widget_CheckBox:
        return "checkBox";
      case Widget_RadioButton:
        return "radioButton";
      case Widget_ListBox:
        return "listBox";
      case Widget_ComboBox:
        return "comboBox";
      case Widget_PushButton:
        return "pushButton";
      case Widget_SignatureFields:
        return "signaturesFields";
      default:return "unknown";
    }
  }

  private RectF convertScreenRectF(CPDFReaderView readerView, int pageIndex, RectF pageRectF){
    CPDFPage page = readerView.getPDFDocument().pageAtIndex(pageIndex);
    RectF screenPageRect = readerView.getPageSize(pageIndex);
    return page.convertRectFromPage(readerView.isCropMode(), screenPageRect.width(), screenPageRect.height(), pageRectF);
  }
}
