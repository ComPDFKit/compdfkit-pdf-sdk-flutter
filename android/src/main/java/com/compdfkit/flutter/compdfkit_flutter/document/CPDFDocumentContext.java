/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.document.codec.CPDFPageCodec;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;

public class CPDFDocumentContext {

    private final String documentUid;
    private final Context appContext;
    private final CPDFPageCodec pageCodec;

    private CPDFDocument document;
    private CPDFViewCtrl pdfView;

    public CPDFDocumentContext(@NonNull Context context, @NonNull String documentUid) {
        this.documentUid = documentUid;
        this.appContext = context.getApplicationContext();
        this.pageCodec = new CPDFPageCodec();
        this.pageCodec.setContext(context);
    }

    public String getDocumentUid() {
        return documentUid;
    }

    public Context getContext() {
        return appContext;
    }

    public CPDFPageCodec getPageCodec() {
        CPDFDocument activeDocument = resolveDocument();
        pageCodec.setDocument(activeDocument);
        return pageCodec;
    }

    public void attachReaderView(@NonNull CPDFViewCtrl pdfView) {
        this.pdfView = pdfView;
        this.document = pdfView.getCPdfReaderView().getPDFDocument();
        getPageCodec();
    }

    public void attachDocument(@Nullable CPDFDocument document) {
        this.document = document;
        getPageCodec();
    }

    @Nullable
    public CPDFViewCtrl getPdfView() {
        return pdfView;
    }

    @Nullable
    public CPDFReaderView getReaderView() {
        if (pdfView == null || pdfView.getCPdfReaderView() == null) {
            return null;
        }
        return pdfView.getCPdfReaderView();
    }

    @Nullable
    public CPDFDocument getDocument() {
        return resolveDocument();
    }

    public CPDFDocument requireDocument() {
        CPDFDocument activeDocument = resolveDocument();
        if (activeDocument == null) {
            throw new IllegalStateException("CPDFDocument is null for uid: " + documentUid);
        }
        return activeDocument;
    }

    @Nullable
    private CPDFDocument resolveDocument() {
        if (pdfView != null && pdfView.getCPdfReaderView() != null) {
            return pdfView.getCPdfReaderView().getPDFDocument();
        }
        return document;
    }
}