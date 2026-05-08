/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import androidx.annotation.NonNull;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentSaveType;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import io.flutter.plugin.common.MethodChannel;

public final class DocumentSaveOps {

    private DocumentSaveOps() {
    }

    public static void save(@NonNull CPDFDocumentContext context, boolean saveIncremental,
            boolean fontSubSet, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        if (context.getPdfView() != null) {
            context.getPdfView().savePDF(saveIncremental, fontSubSet, (s, uri) -> result.success(true),
                    e -> result.success(false));
            return;
        }
        try {
            if (!document.hasChanges()) {
                result.success(true);
                return;
            }
            boolean save = document.save(
                    saveIncremental ? PDFDocumentSaveType.PDFDocumentSaveIncremental
                            : PDFDocumentSaveType.PDFDocumentSaveNoIncremental,
                    fontSubSet);
            if (document.shouleReloadDocument()) {
                document.reload();
            }
            result.success(save);
        } catch (CPDFDocumentException e) {
            result.success(false);
        }
    }

    public static boolean saveAs(@NonNull CPDFDocumentContext context, @NonNull String savePath,
            boolean removeSecurity, boolean fontSubSet) throws CPDFDocumentException {
        CPDFDocument document = context.requireDocument();
        if (context.getPdfView() != null) {
            context.getPdfView().exitEditMode();
        }
        boolean saveResult;
        if (CPDFDocumentSourceResolver.isContentSource(savePath)) {
            saveResult = document.saveAs(CPDFDocumentSourceResolver.parseUri(savePath),
                    removeSecurity, fontSubSet);
        } else {
            saveResult = document.saveAs(savePath, removeSecurity, false, fontSubSet);
        }
        return saveResult;
    }
}