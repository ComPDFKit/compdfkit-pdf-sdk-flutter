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

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ENTER_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXIT_SNIP_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RELOAD_PAGES_2;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PREVIEW_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ADD_WATERMARK_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_BOTA_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DISPLAY_SETTINGS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DOCUMENT_INFO_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_SECURITY_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_THUMBNAIL_VIEW;

import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.pdf.config.CPDFWatermarkConfig;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.tools.common.views.pdfview.CPreviewMode;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.Map;

public final class ViewerPreviewOps {

    private ViewerPreviewOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result,
            CPDFDocumentFragment documentFragment, CPDFViewCtrl pdfView) {
        switch (call.method) {
            case SET_PREVIEW_MODE:
                String alias = (String) call.arguments;
                CPreviewMode previewMode = CPreviewMode.fromAlias(alias);
                documentFragment.setPreviewMode(previewMode);
                result.success(null);
                return true;
            case GET_PREVIEW_MODE:
                result.success(documentFragment.pdfToolBar.getMode().alias);
                return true;
            case SHOW_THUMBNAIL_VIEW:
                boolean enableEditMode = (boolean) call.arguments;
                documentFragment.showPageEdit(false, enableEditMode);
                result.success(null);
                return true;
            case SHOW_BOTA_VIEW:
                documentFragment.showBOTA();
                result.success(null);
                return true;
            case SHOW_ADD_WATERMARK_VIEW:
                Map<String, Object> configMap = (Map<String, Object>) call.arguments;
                if (configMap == null) {
                    documentFragment.showAddWatermarkDialog();
                } else {
                    documentFragment.showAddWatermarkDialog(CPDFWatermarkConfig.fromMap(configMap));
                }
                result.success(null);
                return true;
            case SHOW_SECURITY_VIEW:
                documentFragment.showSecurityDialog();
                result.success(null);
                return true;
            case SHOW_DISPLAY_SETTINGS_VIEW:
                documentFragment.showDisplaySettings(pdfView);
                result.success(null);
                return true;
            case SHOW_DOCUMENT_INFO_VIEW:
                documentFragment.showDocumentInfo(pdfView);
                result.success(null);
                return true;
            case ENTER_SNIP_MODE:
                documentFragment.enterSnipMode();
                result.success(null);
                return true;
            case EXIT_SNIP_MODE:
                documentFragment.exitScreenShot();
                result.success(null);
                return true;
            case RELOAD_PAGES:
                documentFragment.pdfView.getCPdfReaderView().reloadPages();
                result.success(null);
                return true;
            case RELOAD_PAGES_2:
                documentFragment.pdfView.getCPdfReaderView().reloadPages2();
                result.success(null);
                return true;
            default:
                return false;
        }
    }
}