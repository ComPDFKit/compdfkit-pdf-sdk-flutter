/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import java.util.HashSet;
import java.util.Set;

public final class CPDFViewContext {

    private final int viewId;
    private final CPDFDocumentPlugin documentPlugin;
    private final Set<String> subscribedEvents = new HashSet<>();

    private CPDFDocumentFragment documentFragment;
    private CPDFViewCtrl pdfView;

    public CPDFViewContext(int viewId, @NonNull CPDFDocumentPlugin documentPlugin) {
        this.viewId = viewId;
        this.documentPlugin = documentPlugin;
    }

    public int getViewId() {
        return viewId;
    }

    @NonNull
    public CPDFDocumentPlugin getDocumentPlugin() {
        return documentPlugin;
    }

    @NonNull
    public Set<String> getSubscribedEvents() {
        return subscribedEvents;
    }

    public void attachDocumentFragment(@Nullable CPDFDocumentFragment documentFragment) {
        this.documentFragment = documentFragment;
    }

    public void attachPdfView(@Nullable CPDFViewCtrl pdfView) {
        this.pdfView = pdfView;
    }

    @Nullable
    public CPDFDocumentFragment getDocumentFragment() {
        return documentFragment;
    }

    @Nullable
    public CPDFViewCtrl getPdfView() {
        return pdfView;
    }

    @Nullable
    public CPDFReaderView getReaderView() {
        if (pdfView == null) {
            return null;
        }
        return pdfView.getCPdfReaderView();
    }

    public void clear() {
        subscribedEvents.clear();
        documentFragment = null;
        pdfView = null;
    }
}