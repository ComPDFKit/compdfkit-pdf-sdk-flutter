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

import android.net.Uri;
import android.graphics.RectF;
import androidx.annotation.NonNull;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentImageMode;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public final class DocumentPageOps {

    private DocumentPageOps() {
    }

    public static boolean splitDocumentPages(@NonNull CPDFDocumentContext context,
            @NonNull String savePath, @NonNull ArrayList<Integer> pages)
            throws CPDFDocumentException {
        CPDFDocument document = context.requireDocument();
        CPDFDocument newDocument = CPDFDocument.createDocument(context.getContext());
        try {
            int[] pagesArray = new int[pages.size()];
            for (int index = 0; index < pages.size(); index++) {
                pagesArray[index] = pages.get(index);
            }
            newDocument.importPages(document, pagesArray, 0);
            if (CPDFDocumentSourceResolver.isContentSource(savePath)) {
                return newDocument.saveAs(Uri.parse(savePath), false, true);
            }
            return newDocument.saveAs(savePath, false, false, true);
        } finally {
            newDocument.close();
        }
    }

    public static Map<String, Float> getPageSize(@NonNull CPDFDocumentContext context,
            int pageIndex) {
        RectF rectF = context.requireDocument().getPageSize(pageIndex);
        Map<String, Float> pageSizeMap = new HashMap<>();
        pageSizeMap.put("width", rectF.width());
        pageSizeMap.put("height", rectF.height());
        return pageSizeMap;
    }

    public static boolean insertImageWithPath(@NonNull CPDFDocumentContext context, int pageIndex,
            int width, int height, @NonNull String imagePath) {
        CPDFPage insertPage = context.requireDocument().insertPageWithImagePath(pageIndex, width,
                height, imagePath, PDFDocumentImageMode.PDFDocumentImageModeScaleAspectFit);
        return insertPage != null && insertPage.isValid();
    }

    public static boolean insertBlankPage(@NonNull CPDFDocumentContext context, int pageIndex,
            int width, int height) {
        CPDFPage page = context.requireDocument().insertBlankPage(pageIndex, width, height);
        return page != null && page.isValid();
    }

    public static int getPageRotation(@NonNull CPDFDocumentContext context, int pageIndex) {
        CPDFPage cpdfPage = context.requireDocument().pageAtIndex(pageIndex);
        if (cpdfPage == null) {
            throw new IllegalArgumentException("Page not found at index: " + pageIndex);
        }
        return cpdfPage.getRotation();
    }

    public static boolean setPageRotation(@NonNull CPDFDocumentContext context, int pageIndex,
            int rotation) {
        CPDFPage cpdfPage = context.requireDocument().pageAtIndex(pageIndex);
        if (cpdfPage == null) {
            throw new IllegalArgumentException("Page not found at index: " + pageIndex);
        }
        return cpdfPage.setRotation(rotation);
    }

    public static boolean removePages(@NonNull CPDFDocumentContext context,
            @NonNull ArrayList<Integer> pages) {
        int[] pagesArray = new int[pages.size()];
        for (int index = 0; index < pages.size(); index++) {
            pagesArray[index] = pages.get(index);
        }
        return context.requireDocument().removePages(pagesArray);
    }

    public static boolean movePage(@NonNull CPDFDocumentContext context, int sourcePageIndex,
            int targetPageIndex) {
        return context.requireDocument().movePage(sourcePageIndex, targetPageIndex);
    }
}