/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFAnnotation.Type;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import java.util.HashMap;

public final class ViewerAnnotationCodec {

    private ViewerAnnotationCodec() {
    }

    public static HashMap<String, Object> encode(CPDFDocumentPlugin documentPlugin,
            CPDFDocument document, CPDFAnnotation annotation) {
        documentPlugin.getPageUtil().setDocument(document);
        if (annotation.getType() == Type.WIDGET) {
            return documentPlugin.getPageUtil().getWidgetData((CPDFWidget) annotation);
        }
        return documentPlugin.getPageUtil().getAnnotationData(annotation);
    }
}