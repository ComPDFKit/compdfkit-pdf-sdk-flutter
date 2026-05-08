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
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFSearchUtil;
import com.compdfkit.ui.textsearch.CPDFTextSearcher;
import com.compdfkit.ui.textsearch.ITextSearcher;
import io.flutter.plugin.common.MethodCall;

public final class DocumentSearchOps {

    private DocumentSearchOps() {
    }

    public static Object searchText(@NonNull CPDFDocumentContext context,
            @NonNull String keywords, int options) {
        CPDFDocument document = context.requireDocument();
        return CPDFSearchUtil.search(document, resolveTextSearcher(context, document), keywords,
                options);
    }

    public static void selectText(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call) {
        CPDFSearchUtil.selection(context.getContext(), context.getPdfView(),
                context.requireDocument(), call);
    }

    public static void clearSearch(@NonNull CPDFDocumentContext context) {
        CPDFSearchUtil.clearSearch(context.getContext(), context.getPdfView(),
                context.requireDocument());
    }

    public static String getSearchText(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call) {
        return CPDFSearchUtil.getText(context.requireDocument(), call);
    }

    private static ITextSearcher resolveTextSearcher(@NonNull CPDFDocumentContext context,
            @NonNull CPDFDocument document) {
        if (context.getReaderView() != null) {
            return context.getReaderView().getTextSearcher();
        }
        return new CPDFTextSearcher(context.getContext(), document);
    }
}