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

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ANNOTATION_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DEFAULT_ANNOTATION_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DEFAULT_WIDGET_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_ANNOTATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DEFAULT_ANNOTATION_ATTR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_DEFAULT_WIDGET_ATTR;

import com.compdfkit.core.undo.CPDFUndoManager;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFAttrUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.views.pdfproperties.CAnnotationType;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.Map;

public final class ViewerAnnotationOps {

    private ViewerAnnotationOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result,
            CPDFDocumentFragment documentFragment, CPDFViewCtrl pdfView) {
        switch (call.method) {
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
                return true;
            case GET_ANNOTATION_MODE:
                CAnnotationType annotationType = documentFragment.annotationToolbar.toolListAdapter
                        .getCurrentAnnotType();
                switch (annotationType) {
                    case TEXT:
                        result.success("note");
                        return true;
                    case PIC:
                        result.success("pictures");
                        return true;
                    default:
                        result.success(annotationType.name().toLowerCase());
                        return true;
                }
            case ANNOTATION_CAN_UNDO:
                CPDFUndoManager undoManager = documentFragment.pdfView.getCPdfReaderView()
                        .getUndoManager();
                result.success(undoManager.canUndo());
                return true;
            case ANNOTATION_CAN_REDO:
                CPDFUndoManager redoManager = documentFragment.pdfView.getCPdfReaderView()
                        .getUndoManager();
                result.success(redoManager.canRedo());
                return true;
            case ANNOTATION_UNDO:
                documentFragment.annotationToolbar.annotUndo();
                result.success(null);
                return true;
            case ANNOTATION_REDO:
                documentFragment.annotationToolbar.annotRedo();
                result.success(null);
                return true;
            case GET_DEFAULT_ANNOTATION_ATTR:
                result.success(CPDFAttrUtils.getDefaultAnnotAttr(pdfView));
                return true;
            case SET_DEFAULT_ANNOTATION_ATTR:
            case SET_DEFAULT_WIDGET_ATTR:
                String annotType = call.argument("type");
                Map<String, Object> attrMap = call.argument("attr");
                if (annotType.equals("editorText")) {
                    result.error("SET_DEFAULT_ANNOTATION_ATTR_ERROR",
                            "editorText is not supported", null);
                    return true;
                }
                CPDFAttrUtils.setDefaultAnnotAttr(pdfView, annotType, attrMap);
                documentFragment.annotationToolbar.updateItemColor();
                result.success(null);
                return true;
            case GET_DEFAULT_WIDGET_ATTR:
                result.success(CPDFAttrUtils.getDefaultWidgetAttr(pdfView));
                return true;
            default:
                return false;
        }
    }
}