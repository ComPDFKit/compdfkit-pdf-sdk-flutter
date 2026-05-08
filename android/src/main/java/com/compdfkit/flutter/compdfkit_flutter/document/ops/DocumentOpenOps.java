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
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;

public final class DocumentOpenOps {

    private DocumentOpenOps() {
    }

    public static OpenResult open(@NonNull CPDFDocumentContext context, @NonNull String filePath,
            String password) {
        CPDFDocument document = context.requireDocument();
        Object source;
        PDFDocumentError error;
        if (CPDFDocumentSourceResolver.isUriSource(filePath)) {
            source = CPDFDocumentSourceResolver.parseUri(filePath);
            error = document.open(CPDFDocumentSourceResolver.parseUri(filePath), password);
        } else {
            source = filePath;
            error = document.open(filePath, password);
        }

        CPDFViewCtrl pdfView = context.getPdfView();
        if (error == PDFDocumentError.PDFDocumentErrorSuccess && pdfView != null) {
            pdfView.setPDFDocument(document, source, 0, error, null);
        }
        return new OpenResult(error, source);
    }

    public static String toFlutterResult(@NonNull PDFDocumentError error) {
        switch (error) {
            case PDFDocumentErrorSuccess:
                return "success";
            case PDFDocumentErrorPassword:
                return "errorPassword";
            case PDFDocumentErrorFile:
                return "errorFile";
            case PDFDocumentErrorPage:
                return "errorPage";
            case PDFDocumentErrorFormat:
                return "errorFormat";
            case PDFDocumentErrorSecurity:
                return "errorSecurity";
            case PDFDocumentNotVerifyLicense:
                return "notVerifyLicense";
            case PDFDocumentErrorNoReadPermission:
                return "noReadPermission";
            case PDFDocumentErrorUnknown:
            default:
                return "unknown";
        }
    }

    public static final class OpenResult {

        private final PDFDocumentError error;
        private final Object source;

        OpenResult(PDFDocumentError error, Object source) {
            this.error = error;
            this.source = source;
        }

        public PDFDocumentError getError() {
            return error;
        }

        public Object getSource() {
            return source;
        }
    }
}