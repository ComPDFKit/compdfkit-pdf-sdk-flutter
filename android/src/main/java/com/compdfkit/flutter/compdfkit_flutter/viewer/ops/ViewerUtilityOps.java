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

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATIONS_VISIBLE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CLEAR_DISPLAY_RECT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.DISMISS_CONTEXT_MENU;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_DIGITAL_SIGNATURE_STATUS_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HIDE_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_ANNOTATIONS_VISIBLE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_CURRENT_INK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_TEXT_SEARCH_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.VERIFY_DIGITAL_SIGNATURE_STATUS;

import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public final class ViewerUtilityOps {

    private ViewerUtilityOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result,
            CPDFDocumentFragment documentFragment, CPDFReaderView readerView) {
        switch (call.method) {
            case VERIFY_DIGITAL_SIGNATURE_STATUS:
                documentFragment.verifyDocumentSignStatus();
                result.success(null);
                return true;
            case HIDE_DIGITAL_SIGNATURE_STATUS_VIEW:
                documentFragment.hideDigitalSignStatusView();
                result.success(null);
                return true;
            case CLEAR_DISPLAY_RECT:
                readerView.setDisplayPageRectangles(null);
                readerView.setShowDisplayPageRect(false);
                result.success(true);
                return true;
            case DISMISS_CONTEXT_MENU:
                if (readerView.getContextMenuShowListener() != null) {
                    readerView.getContextMenuShowListener().dismissContextMenu();
                }
                result.success(true);
                return true;
            case SHOW_TEXT_SEARCH_VIEW:
                documentFragment.showTextSearchView();
                result.success(null);
                return true;
            case HIDE_TEXT_SEARCH_VIEW:
                documentFragment.hideTextSearchView();
                result.success(null);
                return true;
            case SAVE_CURRENT_INK:
                readerView.getInkDrawHelper().onSave();
                result.success(null);
                return true;
            case ANNOTATIONS_VISIBLE:
                boolean annotationsVisible = (boolean) call.arguments;
                readerView.setAnnotationsVisible(annotationsVisible);
                result.success(null);
                return true;
            case IS_ANNOTATIONS_VISIBLE:
                result.success(readerView.isAnnotationsVisible());
                return true;
            default:
                return false;
        }
    }
}