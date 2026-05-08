/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer.ops;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_SIZE;
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
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CAN_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CONTINUE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_COVER_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_CROP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DOUBLE_PAGE_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FIXED_SCROLL;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_FIELD_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_LINK_HIGHLIGHT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_MARGIN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SAME_WIDTH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_SPACING;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_READ_BACKGROUND_COLOR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_SCALE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_VERTICAL_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_WIDGET_BACKGROUND_COLOR;

import android.content.Context;
import android.graphics.Color;
import android.graphics.RectF;
import androidx.core.content.ContextCompat;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

public final class ViewerDisplayOps {

    private ViewerDisplayOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result, Context context,
            CPDFViewCtrl pdfView, CPDFReaderView readerView) {
        switch (call.method) {
            case SET_SCALE:
                double scaleValue = (double) call.arguments;
                readerView.setScale((float) scaleValue);
                result.success(null);
                return true;
            case GET_SCALE:
                result.success((double) readerView.getScale());
                return true;
            case SET_CAN_SCALE:
                boolean canScale = (boolean) call.arguments;
                readerView.setCanScale(canScale);
                result.success(null);
                return true;
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
                    default:
                        break;
                }
                result.success(null);
                return true;
            case SET_WIDGET_BACKGROUND_COLOR:
                String widgetColorHex = (String) call.arguments;
                try {
                    pdfView.setBackgroundColor(Color.parseColor(widgetColorHex));
                } catch (Exception e) {
                    // Ignore invalid colors to preserve existing behavior.
                }
                result.success(null);
                return true;
            case GET_READ_BACKGROUND_COLOR:
                String readBgColor = "#" + Integer.toHexString(readerView.getReadBackgroundColor()).toUpperCase();
                result.success(readBgColor);
                return true;
            case SET_FORM_FIELD_HIGHLIGHT:
                readerView.setFormFieldHighlight((Boolean) call.arguments);
                result.success(null);
                return true;
            case IS_FORM_FIELD_HIGHLIGHT:
                result.success(readerView.isFormFieldHighlight());
                return true;
            case SET_LINK_HIGHLIGHT:
                readerView.setLinkHighlight((Boolean) call.arguments);
                result.success(null);
                return true;
            case IS_LINK_HIGHLIGHT:
                result.success(readerView.isLinkHighlight());
                return true;
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
                return true;
            case SET_PAGE_SPACING:
                int pageSpacing = (int) call.arguments;
                readerView.setPageSpacing(pageSpacing);
                readerView.reloadPages();
                result.success(null);
                return true;
            case SET_VERTICAL_MODE:
                readerView.setVerticalMode((Boolean) call.arguments);
                pdfView.updateScaleForLayout();
                result.success(null);
                return true;
            case IS_VERTICAL_MODE:
                result.success(readerView.isVerticalMode());
                return true;
            case SET_CONTINUE_MODE:
                readerView.setContinueMode((Boolean) call.arguments);
                pdfView.updateScaleForLayout();
                result.success(null);
                return true;
            case IS_CONTINUE_MODE:
                result.success(readerView.isContinueMode());
                return true;
            case SET_DOUBLE_PAGE_MODE:
                readerView.setDoublePageMode((boolean) call.arguments);
                readerView.setCoverPageMode(false);
                pdfView.updateScaleForLayout();
                result.success(null);
                return true;
            case IS_DOUBLE_PAGE_MODE:
                result.success(readerView.isDoublePageMode());
                return true;
            case SET_CROP_MODE:
                readerView.setCropMode((Boolean) call.arguments);
                result.success(null);
                return true;
            case IS_CROP_MODE:
                result.success(readerView.isCropMode());
                return true;
            case SET_PAGE_SAME_WIDTH:
                readerView.setPageSameWidth((Boolean) call.arguments);
                readerView.reloadPages();
                result.success(null);
                return true;
            case SET_COVER_PAGE_MODE:
                readerView.setDoublePageMode((Boolean) call.arguments);
                readerView.setCoverPageMode((Boolean) call.arguments);
                pdfView.updateScaleForLayout();
                result.success(null);
                return true;
            case IS_COVER_PAGE_MODE:
                result.success(readerView.isCoverPageMode());
                return true;
            case IS_PAGE_IN_SCREEN:
                int pageIndex = (int) call.arguments;
                result.success(readerView.isPageInScreen(pageIndex));
                return true;
            case SET_FIXED_SCROLL:
                readerView.setFixedScroll((Boolean) call.arguments);
                result.success(null);
                return true;
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
                return true;
            default:
                return false;
        }
    }
}