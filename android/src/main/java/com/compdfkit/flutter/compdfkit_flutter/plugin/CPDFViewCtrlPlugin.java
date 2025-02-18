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

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ENTER_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXIT_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_CURRENT_PAGE_INDEX;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_SIZE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_PAGE_IN_SCREEN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ADD_WATERMARK_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_BOTA_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DISPLAY_SETTINGS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_SECURITY_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_THUMBNAIL_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE;
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

import android.content.Context;
import android.graphics.Color;
import android.graphics.RectF;
import android.util.Log;

import androidx.annotation.NonNull;

import androidx.core.content.ContextCompat;
import com.compdfkit.flutter.compdfkit_flutter.R;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.utils.viewutils.CViewUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFIReaderViewCallback;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.tools.common.views.pdfview.CPreviewMode;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
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
    this.documentFragment.setInitListener((pdfView)->{
      documentPlugin.setReaderView(pdfView);
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
      });
      pdfView.setSaveCallback((s, uri) -> {
        if (methodChannel != null) {
          methodChannel.invokeMethod("saveDocument", "");
        }
      }, e -> {

      });
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
        break;
      case GET_SCALE:
        result.success((double) readerView.getScale());
        break;
      case SET_CAN_SCALE:
        boolean canScale = (boolean) call.arguments;
        readerView.setCanScale(canScale);
        break;
      case SET_READ_BACKGROUND_COLOR:
        String colorHex = call.argument("color");
        readerView.setReadBackgroundColor(Color.parseColor(colorHex));
        if (colorHex.equals("#FFFFFFFF")){
          pdfView.setBackgroundColor(ContextCompat.getColor(context, R.color.tools_pdf_view_ctrl_background_color));
        } else {
          pdfView.setBackgroundColor(
              CViewUtils.getColor(Color.parseColor(colorHex), 190));
        }
        break;
      case GET_READ_BACKGROUND_COLOR:
        String readBgColor =
            "#" + Integer.toHexString(readerView.getReadBackgroundColor()).toUpperCase();
        result.success(readBgColor);
        break;
      case SET_FORM_FIELD_HIGHLIGHT:
        readerView.setFormFieldHighlight((Boolean) call.arguments);
        break;
      case IS_FORM_FIELD_HIGHLIGHT:
        result.success(readerView.isFormFieldHighlight());
        break;
      case SET_LINK_HIGHLIGHT:
        readerView.setLinkHighlight((Boolean) call.arguments);
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
        break;
      case SET_PAGE_SPACING:
        int pageSpacing = (int) call.arguments;
        readerView.setPageSpacing(pageSpacing);
        readerView.reloadPages();
        break;
      case SET_VERTICAL_MODE:
        readerView.setVerticalMode((Boolean) call.arguments);
        break;
      case IS_VERTICAL_MODE:
        result.success(readerView.isVerticalMode());
        break;
      case SET_CONTINUE_MODE:
        readerView.setContinueMode((Boolean) call.arguments);
        break;
      case IS_CONTINUE_MODE:
        result.success(readerView.isContinueMode());
        break;
      case SET_DOUBLE_PAGE_MODE:
        readerView.setDoublePageMode((boolean) call.arguments);
        readerView.setCoverPageMode(false);
        break;
      case IS_DOUBLE_PAGE_MODE:
        result.success(readerView.isDoublePageMode());
        break;
      case SET_CROP_MODE:
        readerView.setCropMode((Boolean) call.arguments);
        break;
      case IS_CROP_MODE:
        result.success(readerView.isCropMode());
        break;
      case SET_DISPLAY_PAGE_INDEX:
        int pageIndex = call.argument("pageIndex");
        readerView.setDisplayPageIndex(pageIndex);
        break;
      case GET_CURRENT_PAGE_INDEX:
        result.success(readerView.getPageNum());
        break;
      case SET_PAGE_SAME_WIDTH:
        readerView.setPageSameWidth((Boolean) call.arguments);
        readerView.reloadPages();
        break;
      case SET_COVER_PAGE_MODE:
        readerView.setDoublePageMode((Boolean) call.arguments);
        readerView.setCoverPageMode((Boolean) call.arguments);
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
        break;
      case GET_PAGE_SIZE:
        boolean noZoomPage = call.argument("noZoom");
        int page = call.argument("pageIndex");
        RectF rectF;
        if (noZoomPage){
          rectF = readerView.getPageNoZoomSize(page);
        }else {
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
        break;
      case GET_PREVIEW_MODE:
        result.success(documentFragment.pdfToolBar.getMode().alias);
        break;
      case SHOW_THUMBNAIL_VIEW:
        boolean enterEditMode = (boolean) call.arguments;
        documentFragment.showPageEdit(enterEditMode);
        break;
      case SHOW_BOTA_VIEW:
        documentFragment.showBOTA();
        break;
      case SHOW_ADD_WATERMARK_VIEW:
        boolean saveAsNewFile = (boolean) call.arguments;
        documentFragment.showAddWatermarkDialog(saveAsNewFile);
        break;
      case SHOW_SECURITY_VIEW:
        documentFragment.showSecurityDialog();
        break;
      case SHOW_DISPLAY_SETTINGS_VIEW:
        documentFragment.showDisplaySettings(pdfView);
        break;
      case ENTER_SNIP_MODE:
        documentFragment.enterSnipMode();
        break;
      case EXIT_SNIP_MODE:
        documentFragment.exitScreenShot();
        break;
      default:
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:notImplemented");
        result.notImplemented();
        break;
    }
  }
}
