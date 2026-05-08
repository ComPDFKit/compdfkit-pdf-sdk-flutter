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

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_IMAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_LINK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_SIGNATURE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PREPARE_NEXT_STAMP;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_ANNOTATION_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_DEFAULT_ANNOTATION_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_EDIT_AREA_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SHOW_WIDGET_PROPERTIES_VIEW;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_EVENT_SUBSCRIPTION;

import android.util.Log;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.CPDFStampAnnotation.StandardStamp;
import com.compdfkit.core.annotation.CPDFStampAnnotation.TextStamp;
import com.compdfkit.core.annotation.CPDFStampAnnotation.TextStampColor;
import com.compdfkit.core.annotation.CPDFStampAnnotation.TextStampShape;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.edit.CPDFEditArea;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFViewCtrlPlugin;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEditAreaUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFPageUtil;
import com.compdfkit.flutter.compdfkit_flutter.viewer.CPDFViewContext;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.utils.annotation.CPDFAnnotationManager;
import com.compdfkit.tools.common.views.pdfproperties.CAnnotationType;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CAnnotStyle;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.CStyleType;
import com.compdfkit.tools.common.views.pdfproperties.pdfstyle.manager.CStyleManager;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;

public final class ViewerPropertyOps {

    private ViewerPropertyOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result,
            CPDFDocumentFragment documentFragment, CPDFViewCtrl pdfView,
            CPDFReaderView readerView, CPDFDocumentPlugin documentPlugin,
            CPDFViewContext viewContext) {
        switch (call.method) {
            case SHOW_DEFAULT_ANNOTATION_PROPERTIES_VIEW:
                String key = (String) call.arguments;
                CAnnotationType annotType = CPDFEnumConvertUtil.strongToAnnotationType(key);
                documentFragment.annotationToolbar.showAnnotStyleDialog(annotType.getStyleType());
                result.success(null);
                return true;
            case SHOW_ANNOTATION_PROPERTIES_VIEW:
            case SHOW_WIDGET_PROPERTIES_VIEW:
                int pageIndex = call.argument("page");
                String uuid = call.argument("uuid");
                CPDFPageUtil pageUtil = documentPlugin.getPageUtil();
                pageUtil.setDocument(readerView.getPDFDocument());
                CPDFAnnotation annotation = pageUtil.getAnnotation(pageIndex, uuid);
                if (annotation != null) {
                    CPDFPageView pageView = (CPDFPageView) readerView.getChild(pageIndex);
                    CPDFBaseAnnotImpl baseAnnot = pageView != null ? pageView.getAnnotImpl(annotation)
                            : null;
                    if (baseAnnot != null) {
                        CPDFAnnotationManager.showPropertiesDialog(
                                documentFragment.getParentFragmentManager(), baseAnnot, pageView);
                    } else {
                        CPDFAnnotationManager.showPropertiesDialog(
                                documentFragment.getParentFragmentManager(), annotation, pageView);
                    }
                }
                result.success(null);
                return true;
            case SHOW_EDIT_AREA_PROPERTIES_VIEW:
                int editPageIndex = call.argument("page");
                String editUuid = call.argument("uuid");
                String areaType = call.argument("type");
                CPDFDocument document = readerView.getPDFDocument();
                CPDFEditArea editArea = CPDFEditAreaUtil.getEditArea(document, editPageIndex,
                        editUuid, areaType);
                if (editArea != null) {
                    CPDFPageView pageView = (CPDFPageView) readerView.getChild(editPageIndex);
                    CPDFAnnotationManager.showPropertiesDialog(
                            documentFragment.getParentFragmentManager(), editArea, pageView);
                }
                result.success(null);
                return true;
            case PREPARE_NEXT_SIGNATURE:
                String signImagePath = (String) call.arguments;
                CStyleManager signatureStyleManager = new CStyleManager(pdfView);
                CAnnotStyle signatureStyle = signatureStyleManager.getStyle(CStyleType.ANNOT_SIGNATURE);
                signatureStyle.setImagePath(signImagePath);
                signatureStyleManager.updateStyle(signatureStyle);
                result.success(null);
                return true;
            case PREPARE_NEXT_IMAGE:
                String imagePath = (String) call.arguments;
                CStyleManager imageStyleManager = new CStyleManager(pdfView);
                CAnnotStyle imageStyle = imageStyleManager.getStyle(CStyleType.ANNOT_PIC);
                imageStyle.setImagePath(imagePath);
                imageStyleManager.updateStyle(imageStyle);
                result.success(null);
                return true;
            case PREPARE_NEXT_STAMP:
                String stampType = call.argument("type");
                CStyleManager stampStyleManager = new CStyleManager(pdfView);
                CAnnotStyle stampStyle = stampStyleManager.getStyle(CStyleType.ANNOT_STAMP);
                if ("image".equals(stampType)) {
                    String stampImagePath = call.argument("imagePath");
                    stampStyle.setImagePath(stampImagePath);
                } else if ("standard".equals(stampType)) {
                    String standardType = call.argument("standardStamp");
                    StandardStamp standardStamp = StandardStamp.str2Enum(standardType);
                    stampStyle.setStandardStamp(standardStamp);
                } else if ("text".equals(stampType)) {
                    String content = call.argument("content");
                    String date = call.argument("date");
                    String shape = call.argument("shape");
                    String color = call.argument("color");

                    TextStampShape textStampShape = CPDFEnumConvertUtil.stringToStampShape(shape);
                    TextStampColor textStampColor = CPDFEnumConvertUtil.stringToStampColor(color);
                    TextStamp textStamp = new TextStamp(content, date, textStampShape.id,
                            textStampColor.id);
                    stampStyle.setTextStamp(textStamp);
                }
                stampStyleManager.updateStyle(stampStyle);
                result.success(null);
                return true;
            case PREPARE_NEXT_LINK:
                HashMap<String, Object> linkAnnotationMap = (HashMap<String, Object>) call.arguments;
                int linkPageIndex = call.argument("page");
                String annotPtr = call.argument("uuid");

                CPDFAnnotation linkAnnotation = documentPlugin.getPageUtil().getAnnotation(linkPageIndex,
                        annotPtr);
                if (linkAnnotation == null || linkAnnotation.getType() != Type.LINK) {
                    result.error("PREPARE_NEXT_LINK_ERROR", "Link annotation not found", null);
                    return true;
                }
                boolean updateResult = documentPlugin.getPageUtil().updateAnnotation(linkAnnotation,
                        linkAnnotationMap);
                CPDFPageView linkPageView = (CPDFPageView) pdfView.getCPdfReaderView()
                        .getChild(linkPageIndex);
                if (linkPageView != null && updateResult) {
                    linkPageView.addAnnotation(linkAnnotation, false);
                    linkPageView.invalidate();
                }
                result.success(null);
                return true;
            case UPDATE_EVENT_SUBSCRIPTION:
                String eventName = call.argument("event");
                Boolean subscribe = call.argument("subscribe");
                if (eventName != null && subscribe != null) {
                    if (subscribe) {
                        viewContext.getSubscribedEvents().add(eventName);
                        Log.d(CPDFViewCtrlPlugin.LOG_TAG, "Event subscribed: " + eventName);
                    } else {
                        viewContext.getSubscribedEvents().remove(eventName);
                        Log.d(CPDFViewCtrlPlugin.LOG_TAG, "Event unsubscribed: " + eventName);
                    }
                }
                result.success(null);
                return true;
            default:
                return false;
        }
    }
}