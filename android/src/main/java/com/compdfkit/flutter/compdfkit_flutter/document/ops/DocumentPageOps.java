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
import androidx.annotation.Nullable;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentImageMode;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
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

    public static Map<String, Object> extractImages(@NonNull CPDFDocumentContext context,
            @NonNull String directoryPath, @Nullable ArrayList<Integer> pages) {
        CPDFDocument document = context.requireDocument();
        File outputDirectory = new File(directoryPath);
        if (outputDirectory.exists() && !outputDirectory.isDirectory()) {
            throw new IllegalArgumentException("directory_path is not a directory: " + directoryPath);
        }
        if (!outputDirectory.exists() && !outputDirectory.mkdirs()) {
            throw new IllegalArgumentException("Failed to create directory: " + directoryPath);
        }

        boolean success;
        if (pages == null || pages.isEmpty()) {
            success = document.extractImage(outputDirectory.getAbsolutePath(),
                    (pageIndex, imageIndex, index) -> extractImageName(document, pageIndex,
                            imageIndex, index));
        } else {
            int[] pageArray = new int[pages.size()];
            for (int index = 0; index < pages.size(); index++) {
                pageArray[index] = pages.get(index);
            }
            success = document.extractImage(outputDirectory.getAbsolutePath(), pageArray,
                    (pageIndex, imageIndex, index) -> extractImageName(document, pageIndex,
                            imageIndex, index));
        }

        List<String> imagePaths = success ? listFilePaths(outputDirectory) : new ArrayList<>();
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("count", imagePaths.size());
        result.put("directory_path", outputDirectory.getAbsolutePath());
        result.put("image_paths", imagePaths);
        return result;
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

    public static boolean copyPage(@NonNull CPDFDocumentContext context, int pageIndex,
            int insertIndex) {
        CPDFDocument document = context.requireDocument();
        int pageCount = document.getPageCount();
        if (pageIndex < 0 || pageIndex >= pageCount) {
            return false;
        }
        int targetIndex = insertIndex;
        if (targetIndex == -1) {
            targetIndex = pageCount;
        }
        if (targetIndex < 0 || targetIndex > pageCount) {
            return false;
        }
        CPDFPage copiedPage = document.copyPage(pageIndex, targetIndex);
        return copiedPage != null && copiedPage.isValid();
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

    private static String extractImageName(@NonNull CPDFDocument document, int pageIndex,
            int imageIndex, int index) {
        return sanitizeFileName(document.getFileName()) + "_" + pageIndex + "_" + imageIndex + "_"
                + index;
    }

    private static String sanitizeFileName(@Nullable String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return "document";
        }
        int dotIndex = fileName.lastIndexOf('.');
        String baseName = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
        String sanitized = baseName.replaceAll("[^a-zA-Z0-9._-]", "_");
        return sanitized.isEmpty() ? "document" : sanitized;
    }

    private static List<String> listFilePaths(@NonNull File directory) {
        File[] files = directory.listFiles();
        List<String> paths = new ArrayList<>();
        if (files == null) {
            return paths;
        }
        for (File file : files) {
            if (file.isFile()) {
                paths.add(file.getAbsolutePath());
            }
        }
        Collections.sort(paths);
        return paths;
    }
}
