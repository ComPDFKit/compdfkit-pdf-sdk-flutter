/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import android.text.TextUtils;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentType;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Handles PDF standard (PDF/A, PDF/X, PDF/E, PDF/UA, PDF/VT) detection and conversion.
 *
 * <p>{@link CPDFDocument#convertType(PDFDocumentType)} converts the document in place and marks it
 * as changed. The converted content is then written to the caller's output path with
 * {@code saveAs}, which leaves the source file untouched, and the document is reloaded from its
 * original source afterwards so the in-memory state and the attached reader (when the document was
 * opened through a reader widget) go back to the pre-conversion content. When that reload fails the
 * call reports {@code PDF_STANDARD_RESTORE_FAILED} rather than success, because the opened document
 * is then still flagged as changed and saving it would overwrite the source file.
 *
 * <p>The Android entry point only accepts the target standard: the ICC output intent is produced by
 * the SDK itself in {@code CPDFDocument.checkOutputIntentPath()}, and the PDF/UA language and title
 * only exist on the private {@code nativeConvertTypeByPathAndUA} native without a public Java
 * wrapper. The channel payload therefore carries {@code font_subset} as the only option.
 */
public final class DocumentStandardOps {

    private static final String ERROR_INVALID_OUTPUT_PATH = "INVALID_OUTPUT_PATH";
    private static final String ERROR_DOCUMENT_INVALID = "DOCUMENT_INVALID";
    private static final String ERROR_ENCRYPTED = "ENCRYPTED_DOCUMENT_NOT_CONVERTIBLE";
    private static final String ERROR_CONVERT_FAILED = "PDF_STANDARD_CONVERT_FAILED";
    private static final String ERROR_SAVE_FAILED = "PDF_STANDARD_SAVE_FAILED";
    private static final String ERROR_RESTORE_FAILED = "PDF_STANDARD_RESTORE_FAILED";

    private DocumentStandardOps() {
    }

    public static void getStandardType(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.getDocument();
        if (document == null) {
            result.error(ERROR_DOCUMENT_INVALID, "The document is released or invalid.", null);
            return;
        }
        result.success(toChannelValue(document.getType()));
    }

    public static void convertToStandardAsync(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.getDocument();
        if (document == null) {
            result.error(ERROR_DOCUMENT_INVALID, "The document is released or invalid.", null);
            return;
        }

        String outputPath = call.argument("output_path");
        String typeValue = call.argument("type");
        Boolean fontSubsetArg = call.argument("font_subset");
        boolean fontSubset = fontSubsetArg == null || fontSubsetArg;

        PDFDocumentType targetType = fromChannelValue(typeValue);
        if (targetType == null) {
            result.error(ERROR_CONVERT_FAILED, "Unknown PDF standard type: " + typeValue, null);
            return;
        }

        String pathError = validateOutputPath(document, outputPath);
        if (pathError != null) {
            result.error(ERROR_INVALID_OUTPUT_PATH, pathError, null);
            return;
        }

        if (!TextUtils.isEmpty(document.getPassword())) {
            result.error(ERROR_ENCRYPTED,
                    "An encrypted document cannot be converted. Remove the password with saveAs "
                            + "first.", null);
            return;
        }

        // Committing the content editor has to happen on the main thread and before the document is
        // mutated, otherwise the pending edits are silently dropped by the reload below.
        CPDFViewCtrl pdfView = context.getPdfView();
        if (pdfView != null) {
            pdfView.exitEditMode();
        }

        CThreadPoolUtils.getInstance().executeIO(
                () -> convertToStandard(context, document, outputPath, targetType, fontSubset,
                        result));
    }

    private static void convertToStandard(@NonNull CPDFDocumentContext context,
            @NonNull CPDFDocument document, @NonNull String outputPath,
            @NonNull PDFDocumentType targetType, boolean fontSubset,
            @NonNull MethodChannel.Result result) {
        String errorCode = null;
        String errorMessage = null;
        boolean converted = false;
        try {
            if (!document.convertType(targetType)) {
                errorCode = ERROR_CONVERT_FAILED;
                errorMessage = "The native conversion to " + targetType.name() + " failed.";
            } else {
                converted = true;
                boolean saveResult;
                if (CPDFDocumentSourceResolver.isContentSource(outputPath)) {
                    saveResult = document.saveAs(CPDFDocumentSourceResolver.parseUri(outputPath),
                            false, fontSubset);
                } else {
                    saveResult = document.saveAs(outputPath, false, false, fontSubset);
                }
                if (!saveResult) {
                    errorCode = ERROR_SAVE_FAILED;
                    errorMessage =
                            "The conversion succeeded but writing " + outputPath + " failed.";
                }
            }
        } catch (Exception e) {
            errorCode = converted ? ERROR_SAVE_FAILED : ERROR_CONVERT_FAILED;
            errorMessage = "The conversion failed: " + e.getMessage();
        }

        // convertType() mutates the opened document, so it has to be reloaded from its original
        // source no matter whether saving the output succeeded. Doing this also drops the change
        // flag, which keeps a later save() from writing the converted content back to the source.
        final boolean needsReload = converted || document.shouleReloadDocument();
        final String code = errorCode;
        final String message = errorMessage;
        CThreadPoolUtils.getInstance().executeMain(() -> {
            String restoreError = needsReload ? restoreDocument(context, document) : null;
            if (code != null) {
                result.error(code, message, null);
            } else if (restoreError != null) {
                // The output file was written, but the opened document still holds the converted
                // content and is flagged as changed. Saving it now would overwrite the source, so
                // this has to surface as an error instead of a silent success.
                result.error(ERROR_RESTORE_FAILED, restoreError, null);
            } else {
                result.success(true);
            }
        });
    }

    /**
     * Reloads the document from its original source and refreshes the reader when the document was
     * opened through a reader widget.
     *
     * @return {@code null} when the document was restored, otherwise a message describing why it
     *         was not.
     */
    @Nullable
    private static String restoreDocument(@NonNull CPDFDocumentContext context,
            @NonNull CPDFDocument document) {
        PDFDocumentError error;
        try {
            error = document.reload();
        } catch (Exception e) {
            return "The converted document could not be reloaded from its original source: "
                    + e.getMessage() + ". Do not save it, the source file would be overwritten "
                    + "with the converted content.";
        }
        if (error != PDFDocumentError.PDFDocumentErrorSuccess) {
            return "The converted document could not be reloaded from its original source ("
                    + error.name() + "). Do not save it, the source file would be overwritten "
                    + "with the converted content.";
        }
        try {
            CPDFReaderView readerView = context.getReaderView();
            if (readerView != null) {
                readerView.reloadPages2();
            }
        } catch (Exception ignored) {
            // The document itself is restored; refreshing the reader is best effort.
        }
        return null;
    }

    @Nullable
    private static String validateOutputPath(@NonNull CPDFDocument document,
            @Nullable String outputPath) {
        if (TextUtils.isEmpty(outputPath)) {
            return "output_path must not be empty.";
        }
        if (CPDFDocumentSourceResolver.isContentSource(outputPath)) {
            // A content Uri produced by ComPDFKit.createUri() already points at a writable
            // document; there is no parent directory to check.
            return null;
        }
        File output = new File(outputPath);
        File parent = output.getParentFile();
        if (parent == null || !parent.exists()) {
            return "The parent directory of " + outputPath + " does not exist.";
        }
        if (!parent.canWrite()) {
            return "The directory " + parent.getAbsolutePath() + " is not writable.";
        }
        String currentPath = document.getAbsolutePath();
        if (!TextUtils.isEmpty(currentPath) && currentPath.equals(output.getAbsolutePath())) {
            return "output_path must differ from the path of the current document.";
        }
        return null;
    }

    private static final Map<PDFDocumentType, String> TYPE_TO_VALUE = new HashMap<>();
    private static final Map<String, PDFDocumentType> VALUE_TO_TYPE = new HashMap<>();

    static {
        register(PDFDocumentType.PDFType, "pdf");
        register(PDFDocumentType.PDFTypeA1a, "pdf_a_1a");
        register(PDFDocumentType.PDFTypeA1b, "pdf_a_1b");
        register(PDFDocumentType.PDFTypeA2a, "pdf_a_2a");
        register(PDFDocumentType.PDFTypeA2u, "pdf_a_2u");
        register(PDFDocumentType.PDFTypeA2b, "pdf_a_2b");
        register(PDFDocumentType.PDFTypeA3a, "pdf_a_3a");
        register(PDFDocumentType.PDFTypeA3u, "pdf_a_3u");
        register(PDFDocumentType.PDFTypeA3b, "pdf_a_3b");
        register(PDFDocumentType.PDFTypeX1a, "pdf_x_1a");
        register(PDFDocumentType.PDFTypeX3, "pdf_x_3");
        register(PDFDocumentType.PDFTypeX4, "pdf_x_4");
        register(PDFDocumentType.PDFTypeE1, "pdf_e_1");
        register(PDFDocumentType.PDFTypeE2, "pdf_e_2");
        register(PDFDocumentType.PDFTypeUA1, "pdf_ua_1");
        register(PDFDocumentType.PDFTypeVT1, "pdf_vt_1");
        register(PDFDocumentType.PDFTypeVT2, "pdf_vt_2");
    }

    private static void register(PDFDocumentType type, String value) {
        TYPE_TO_VALUE.put(type, value);
        VALUE_TO_TYPE.put(value, type);
    }

    @NonNull
    static String toChannelValue(@Nullable PDFDocumentType type) {
        String value = type == null ? null : TYPE_TO_VALUE.get(type);
        return value == null ? "pdf" : value;
    }

    @Nullable
    static PDFDocumentType fromChannelValue(@Nullable String value) {
        return value == null ? null : VALUE_TO_TYPE.get(value);
    }
}
