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
import androidx.fragment.app.FragmentActivity;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.tools.common.utils.print.CPDFPrintUtils;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.utils.viewutils.CViewUtils;
import io.flutter.plugin.common.MethodChannel;

public final class DocumentTaskOps {

    private DocumentTaskOps() {
    }

    public static void saveAsync(@NonNull CPDFDocumentContext context, boolean saveIncremental,
            boolean fontSubset, @NonNull MethodChannel.Result result) {
        CThreadPoolUtils.getInstance().executeIO(
                () -> DocumentSaveOps.save(context, saveIncremental, fontSubset, result));
    }

    public static void saveAsAsync(@NonNull CPDFDocumentContext context, @NonNull String savePath,
            boolean removeSecurity, boolean fontSubset,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.requireDocument();
        CThreadPoolUtils.getInstance().executeIO(() -> {
            try {
                boolean saveResult = DocumentSaveOps.saveAs(context, savePath, removeSecurity,
                        fontSubset);
                CThreadPoolUtils.getInstance().executeMain(() -> {
                    try {
                        if (document.shouleReloadDocument()) {
                            document.reload();
                            if (context.getPdfView() != null) {
                                context.getPdfView().getCPdfReaderView().reloadPages2();
                            }
                        }
                    } catch (Exception ignored) {
                    }
                    result.success(saveResult);
                });
            } catch (CPDFDocumentException e) {
                result.error("SAVE_FAIL",
                        "The current saved directory is: " + savePath
                                + ", please make sure you have write permission to this directory",
                        "");
            }
        });
    }

    public static void removePasswordAsync(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CThreadPoolUtils.getInstance().executeIO(() -> {
            try {
                result.success(DocumentSecurityOps.removePassword(context));
            } catch (Exception e) {
                result.error("SAVE_FAIL",
                        "An exception occurs when remove document opening password and saving it.,"
                                + e.getMessage(),
                        "");
            }
        });
    }

    public static void setPasswordAsync(@NonNull CPDFDocumentContext context,
            @NonNull String userPassword, @NonNull String ownerPassword,
            boolean allowsPrinting, boolean allowsCopying, @NonNull String encryptAlgo,
            @NonNull MethodChannel.Result result) {
        CThreadPoolUtils.getInstance().executeIO(() -> {
            try {
                boolean saveResult = DocumentSecurityOps.setPassword(context, userPassword,
                        ownerPassword, allowsPrinting, allowsCopying, encryptAlgo);
                result.success(saveResult);
            } catch (Exception e) {
                result.error("SAVE_FAIL",
                        "An exception occurs when setting a document opening password and saving it.,"
                                + e.getMessage(),
                        "");
            }
        });
    }

    public static void print(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        if (context.getPdfView() == null) {
            result.success(null);
            return;
        }
        FragmentActivity fragmentActivity = CViewUtils.getFragmentActivity(
                context.getPdfView().getContext());
        if (fragmentActivity != null) {
            CPDFPrintUtils.printCurrentDocument(fragmentActivity, context.requireDocument());
        }
        result.success(null);
    }
}