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
import androidx.annotation.NonNull;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.core.page.CPDFPage.PDFFlattenOption;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.annotation.pdfannotationlist.data.CPDFAnnotDatas;
import com.compdfkit.tools.common.utils.CFileUtils;
import java.io.File;
import java.util.ArrayList;

public final class DocumentTransferOps {

    private DocumentTransferOps() {
    }

    public static boolean importAnnotations(@NonNull CPDFDocumentContext context,
            @NonNull String sourcePath) {
        try {
            CPDFDocument document = context.requireDocument();
            String xfdfFilePath = FileUtils.getImportFilePath(context.getContext(), sourcePath);
            File file = new File(xfdfFilePath);
            if (!file.exists()) {
                return false;
            }

            File cacheFile = new File(context.getContext().getCacheDir(),
                    CFileUtils.CACHE_FOLDER + File.separator + "importAnnotCache/"
                            + CFileUtils.getFileNameNoExtension(document.getFileName()));
            cacheFile.mkdirs();

            boolean importResult = document.importAnnotations(xfdfFilePath,
                    cacheFile.getAbsolutePath());
            if (importResult && context.getReaderView() != null) {
                context.getReaderView().reloadPages();
            }
            return importResult;
        } catch (Exception e) {
            return false;
        }
    }

    public static String exportAnnotations(@NonNull CPDFDocumentContext context) {
        try {
            CPDFDocument document = context.requireDocument();
            File dirFile = new File(context.getContext().getFilesDir(),
                    "compdfkit/annotation/export/");
            dirFile.mkdirs();

            String fileName = CFileUtils.getFileNameNoExtension(document.getFileName());
            File cacheFile = new File(context.getContext().getCacheDir(),
                    CFileUtils.CACHE_FOLDER + File.separator + "exportAnnotCache/" + fileName);
            cacheFile.mkdirs();

            File saveFile = new File(dirFile, fileName + ".xfdf");
            saveFile = CFileUtils.renameNameSuffix(saveFile);
            boolean exportResult = document.exportAnnotations(saveFile.getAbsolutePath(),
                    cacheFile.getAbsolutePath());
            return exportResult ? saveFile.getAbsolutePath() : "";
        } catch (Exception e) {
            return "";
        }
    }

    public static boolean importWidgets(@NonNull CPDFDocumentContext context,
            @NonNull String sourcePath) {
        try {
            CPDFDocument document = context.requireDocument();
            String xfdfFilePath = FileUtils.getImportFilePath(context.getContext(), sourcePath);
            File file = new File(xfdfFilePath);
            if (!file.exists()) {
                return false;
            }
            boolean importResult = CPDFAnnotDatas.importWidgets(document, xfdfFilePath);
            if (importResult && context.getReaderView() != null) {
                context.getReaderView().reloadPages();
            }
            return importResult;
        } catch (Exception e) {
            return false;
        }
    }

    public static String exportWidgets(@NonNull CPDFDocumentContext context) {
        try {
            CPDFDocument document = context.requireDocument();
            File saveDir = new File(context.getContext().getFilesDir(),
                    "compdfkit/widgets/export/");
            saveDir.mkdirs();

            String fileName = CFileUtils.getFileNameNoExtension(document.getFileName());
            File cacheFile = new File(context.getContext().getCacheDir(),
                    CFileUtils.CACHE_FOLDER + File.separator + "widgetExportCache/" + fileName);
            cacheFile.mkdirs();

            File saveFile = new File(saveDir, fileName + "_widgets.xfdf");
            saveFile = CFileUtils.renameNameSuffix(saveFile);
            boolean exportResult = document.exportWidgets(saveFile.getAbsolutePath(),
                    cacheFile.getAbsolutePath());
            return exportResult ? saveFile.getAbsolutePath() : "";
        } catch (Exception e) {
            return "";
        }
    }

    public static boolean flattenAllPages(@NonNull CPDFDocumentContext context,
            @NonNull String savePath, boolean fontSubset) throws CPDFDocumentException {
        CPDFDocument document = context.requireDocument();
        boolean flattenResult = document.flattenAllPages(PDFFlattenOption.FLAT_NORMALDISPLAY);
        if (!flattenResult) {
            return false;
        }

        boolean saveResult;
        if (CPDFDocumentSourceResolver.isContentSource(savePath)) {
            saveResult = document.saveAs(Uri.parse(savePath), false, fontSubset);
        } else {
            saveResult = document.saveAs(savePath, false, false, fontSubset);
        }
        if (document.shouleReloadDocument()) {
            document.reload();
        }
        return saveResult;
    }

    public static boolean importDocument(@NonNull CPDFDocumentContext context,
            @NonNull String filePath, ArrayList<Integer> pages, int insertPosition,
            String password) {
        CPDFDocument document = context.requireDocument();
        String importDocumentPath = FileUtils.getImportFilePath(context.getContext(), filePath);
        CPDFDocument importDocument = new CPDFDocument(context.getContext());
        try {
            PDFDocumentError error = importDocument.open(importDocumentPath, password);
            if (error != PDFDocumentError.PDFDocumentErrorSuccess) {
                return false;
            }

            ArrayList<Integer> pageIndexes = pages;
            if (pageIndexes == null || pageIndexes.isEmpty()) {
                int pageCount = importDocument.getPageCount();
                pageIndexes = new ArrayList<>();
                for (int index = 0; index < pageCount; index++) {
                    pageIndexes.add(index);
                }
            }

            int[] pagesArray = new int[pageIndexes.size()];
            for (int index = 0; index < pageIndexes.size(); index++) {
                pagesArray[index] = pageIndexes.get(index);
            }

            int resolvedInsertPosition = insertPosition == -1 ? document.getPageCount()
                    : insertPosition;
            boolean importResult = document.importPages(importDocument, pagesArray,
                    resolvedInsertPosition);
            if (importResult && context.getReaderView() != null) {
                context.getReaderView().reloadPages();
            }
            return importResult;
        } finally {
            importDocument.close();
        }
    }
}