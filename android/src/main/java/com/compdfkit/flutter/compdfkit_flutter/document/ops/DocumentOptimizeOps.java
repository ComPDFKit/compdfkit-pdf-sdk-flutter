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
import com.compdfkit.core.document.CPDFDocument.CPDFColorSpaceConvertOptions;
import com.compdfkit.core.document.CPDFDocument.CPDFCompressAlgorithm;
import com.compdfkit.core.document.CPDFDocument.CPDFImageOptimizeOptions;
import com.compdfkit.core.document.CPDFDocument.CPDFOptimizeOptions;
import com.compdfkit.core.document.CPDFDocument.CPDFOptimizeResult;
import com.compdfkit.core.document.CPDFDocument.OptimizeListener;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Handles document optimization, i.e. the compression pipeline exposed by
 * {@link CPDFDocument#optimizeSaveAsCopy(String, CPDFOptimizeOptions, boolean, OptimizeListener)}.
 *
 * <p>The only entry point is {@code optimize_document_to_file}, which writes an optimized copy to
 * the caller's path. There is no in-memory variant: the SDK no longer exposes
 * {@code CPDFDocument.optimize(...)}.
 *
 * <p>The save-as-copy native closes the current document as soon as the copy is written. That would
 * leave an attached reader pointing at a released document, so this class reloads the document from
 * its original source afterwards, exactly like {@link DocumentStandardOps} does after an in-place
 * conversion. When that reload fails the call reports {@code OPTIMIZE_RESTORE_FAILED} instead of
 * success, because the in-memory document then still holds the optimized content and saving it
 * would overwrite the source file.
 *
 * <p>Progress is pushed back to Dart over the same per-document MethodChannel with
 * {@link CPDFConstants.ChannelMethod#ON_OPTIMIZE_PROGRESS}; the plugin has no EventChannel.
 * Cancellation is cooperative: {@code cancel_optimize} flips a flag that the native
 * {@link OptimizeListener#isCancelled()} polls at every page boundary. A cancelled run is not an
 * error, it resolves with {@code cancelled = true}.
 *
 * <p>Only one run per document may be in flight, so a stale run cannot race the reload of a newer
 * one. A second concurrent call fails with {@code OPTIMIZE_ALREADY_RUNNING}.
 */
public final class DocumentOptimizeOps {

    private static final String ERROR_DOCUMENT_INVALID = "DOCUMENT_INVALID";
    private static final String ERROR_INVALID_OUTPUT_PATH = "INVALID_OUTPUT_PATH";
    private static final String ERROR_INVALID_OPTIONS = "INVALID_OPTIMIZE_OPTIONS";
    private static final String ERROR_ALREADY_RUNNING = "OPTIMIZE_ALREADY_RUNNING";
    private static final String ERROR_OPTIMIZE_FAILED = "OPTIMIZE_FAILED";
    private static final String ERROR_RESTORE_FAILED = "OPTIMIZE_RESTORE_FAILED";

    /** Cancellation flags of the runs currently in flight, keyed by document uid. */
    private static final Map<String, AtomicBoolean> RUNNING = new HashMap<>();

    private DocumentOptimizeOps() {
    }

    public static void getOptimizeOptions(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.getDocument();
        if (document == null) {
            result.error(ERROR_DOCUMENT_INVALID, "The document is released or invalid.", null);
            return;
        }
        result.success(encodeOptions(document.getOptimizeOptions()));
    }

    public static void optimizeToFileAsync(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel channel, @NonNull MethodCall call,
            @NonNull MethodChannel.Result result) {
        CPDFDocument document = context.getDocument();
        if (document == null) {
            result.error(ERROR_DOCUMENT_INVALID, "The document is released or invalid.", null);
            return;
        }
        String outputPath = call.argument("output_path");
        String pathError = validateOutputPath(document, outputPath);
        if (pathError != null) {
            result.error(ERROR_INVALID_OUTPUT_PATH, pathError, null);
            return;
        }
        runAsync(context, channel, call, result, outputPath);
    }

    /**
     * Requests cancellation of the run currently in flight on this document. Doing nothing when no
     * run is in flight keeps the Dart side free of "is one running" bookkeeping.
     */
    public static void cancelOptimize(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        AtomicBoolean cancelled;
        synchronized (RUNNING) {
            cancelled = RUNNING.get(context.getDocumentUid());
        }
        if (cancelled != null) {
            cancelled.set(true);
        }
        result.success(null);
    }

    /**
     * Decodes the options, claims the per-document run slot and runs the optimization on an IO
     * thread.
     *
     * @param outputPath the already validated path the optimized copy is written to.
     */
    private static void runAsync(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel channel, @NonNull MethodCall call,
            @NonNull MethodChannel.Result result, @NonNull String outputPath) {
        CPDFDocument document = context.getDocument();
        if (document == null) {
            result.error(ERROR_DOCUMENT_INVALID, "The document is released or invalid.", null);
            return;
        }

        CPDFOptimizeOptions options;
        try {
            // A missing options payload means "use whatever the document already holds".
            options = call.hasArgument("options") && call.argument("options") != null
                    ? decodeOptions(call.argument("options"), document)
                    : document.getOptimizeOptions();
        } catch (IllegalArgumentException e) {
            result.error(ERROR_INVALID_OPTIONS, e.getMessage(), null);
            return;
        }

        Boolean fontSubsetArg = call.argument("font_subset");
        boolean fontSubset = fontSubsetArg != null && fontSubsetArg;

        final String uid = context.getDocumentUid();
        AtomicBoolean cancelled = new AtomicBoolean(false);
        synchronized (RUNNING) {
            if (RUNNING.containsKey(uid)) {
                result.error(ERROR_ALREADY_RUNNING,
                        "Another optimize run is already in flight on this document.", null);
                return;
            }
            RUNNING.put(uid, cancelled);
        }

        // Committing the content editor has to happen on the main thread and before the document is
        // mutated, otherwise the pending edits are silently dropped.
        CPDFViewCtrl pdfView = context.getPdfView();
        if (pdfView != null) {
            pdfView.exitEditMode();
        }

        final CPDFOptimizeOptions finalOptions = options;
        CThreadPoolUtils.getInstance().executeIO(() -> {
            try {
                optimizeToFile(context, channel, document, finalOptions, outputPath, fontSubset,
                        cancelled, result);
            } finally {
                // Exclusivity has to outlive the native work: the completion above is posted to
                // the main thread and may still have to reload the document there. Posting the
                // release after it keeps the main-thread queue order, so a follow-up run cannot
                // start while the reload of this one is still pending.
                CThreadPoolUtils.getInstance().executeMain(() -> {
                    synchronized (RUNNING) {
                        RUNNING.remove(uid);
                    }
                });
            }
        });
    }

    private static void optimizeToFile(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel channel, @NonNull CPDFDocument document,
            @NonNull CPDFOptimizeOptions options, @NonNull String outputPath, boolean fontSubset,
            @NonNull AtomicBoolean cancelled, @NonNull MethodChannel.Result result) {
        CPDFOptimizeResult optimizeResult = null;
        String errorMessage = null;
        try {
            optimizeResult = document.optimizeSaveAsCopy(outputPath, options, fontSubset,
                    listener(channel, cancelled));
        } catch (Exception e) {
            errorMessage = "The optimize run failed: " + e.getMessage();
        }

        final CPDFOptimizeResult finalResult = optimizeResult;
        final String finalErrorMessage = errorMessage;
        // The native closes the current document once the copy is written, so it always has to be
        // reloaded from its original source before the reader touches it again. A cancelled run
        // may have been stopped after that close, so every run that reached the native call is
        // reloaded, not only the successful ones.
        final boolean needsReload = document.shouleReloadDocument() || finalResult != null;
        CThreadPoolUtils.getInstance().executeMain(() -> {
            String restoreError = needsReload ? restoreDocument(context, document) : null;
            String failure = finalErrorMessage;
            if (failure == null) {
                if (finalResult == null) {
                    failure = "The optimize run returned no result.";
                } else if (!finalResult.ok && !finalResult.cancelled) {
                    failure = "The optimize run failed.";
                }
            }
            if (restoreError != null) {
                // A failed reload outranks whatever else went wrong: the opened document still
                // holds the optimized content, so saving it would overwrite the source. The
                // caller has to be told that, even when the run itself failed too.
                result.error(ERROR_RESTORE_FAILED,
                        failure == null ? restoreError : failure + " " + restoreError, null);
                return;
            }
            if (failure != null) {
                result.error(ERROR_OPTIMIZE_FAILED, failure, null);
                return;
            }
            result.success(encodeResult(finalResult));
        });
    }

    /**
     * Builds the native listener that forwards page progress to Dart and polls the cancel flag.
     */
    @NonNull
    private static OptimizeListener listener(@NonNull MethodChannel channel,
            @NonNull AtomicBoolean cancelled) {
        return new OptimizeListener() {
            @Override
            public boolean isCancelled() {
                return cancelled.get();
            }

            @Override
            public void onUpdate(int pageIndex) {
                // The native run is on an IO thread; MethodChannel calls have to be marshalled back
                // to the main thread.
                CThreadPoolUtils.getInstance().executeMain(() -> {
                    Map<String, Object> payload = new HashMap<>();
                    payload.put("page_index", pageIndex);
                    channel.invokeMethod(CPDFConstants.ChannelMethod.ON_OPTIMIZE_PROGRESS, payload);
                });
            }
        };
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
            return "The optimized document could not be reloaded from its original source: "
                    + e.getMessage() + ". Do not save it, the source file would be overwritten "
                    + "with the optimized content.";
        }
        if (error != PDFDocumentError.PDFDocumentErrorSuccess) {
            return "The optimized document could not be reloaded from its original source ("
                    + error.name() + "). Do not save it, the source file would be overwritten "
                    + "with the optimized content.";
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

    // region codec

    @NonNull
    private static Map<String, Object> encodeOptions(@Nullable CPDFOptimizeOptions options) {
        CPDFOptimizeOptions source = options == null ? new CPDFOptimizeOptions() : options;
        Map<String, Object> map = new HashMap<>();
        map.put("flags", source.optimizeFlags);
        map.put("image_quality", (double) source.imageQuality);
        map.put("color_image_options", encodeImageOptions(source.colorImageOptions));
        map.put("grayscale_image_options", encodeImageOptions(source.grayscaleImageOptions));
        map.put("monochrome_image_options", encodeImageOptions(source.monochromeImageOptions));
        map.put("color_space_convert", encodeColorSpaceConvert(source.colorSpaceConvert));
        return map;
    }

    @NonNull
    private static Map<String, Object> encodeImageOptions(
            @Nullable CPDFImageOptimizeOptions options) {
        CPDFImageOptimizeOptions source =
                options == null ? new CPDFImageOptimizeOptions() : options;
        Map<String, Object> map = new HashMap<>();
        map.put("upper_ppi", source.upperPpi);
        map.put("target_ppi", source.targetPpi);
        map.put("quality", source.quality);
        map.put("block_size", source.blockSize);
        map.put("compress_algorithm", toChannelValue(source.compressAlgorithm));
        return map;
    }

    @NonNull
    private static Map<String, Object> encodeColorSpaceConvert(
            @Nullable CPDFColorSpaceConvertOptions options) {
        CPDFColorSpaceConvertOptions source =
                options == null ? new CPDFColorSpaceConvertOptions() : options;
        Map<String, Object> map = new HashMap<>();
        map.put("icc_data", source.iccData);
        map.put("rgb_to_cmyk", source.rgbToCmyk);
        return map;
    }

    @NonNull
    private static Map<String, Object> encodeResult(@NonNull CPDFOptimizeResult result) {
        Map<String, Object> map = new HashMap<>();
        map.put("ok", result.ok);
        map.put("cancelled", result.cancelled);
        map.put("pages_processed", result.pagesProcessed);
        map.put("steps_us", result.stepsUs);
        map.put("save_us", result.saveUs);
        return map;
    }

    /**
     * Decodes the Dart payload. Missing entries fall back to the values the document already holds
     * so a partial payload cannot silently reset unrelated settings.
     */
    @Nullable
    private static CPDFOptimizeOptions decodeOptions(@Nullable Object payload,
            @NonNull CPDFDocument document) {
        if (payload == null) {
            return null;
        }
        if (!(payload instanceof Map)) {
            throw new IllegalArgumentException("options must be a map.");
        }
        Map<?, ?> map = (Map<?, ?>) payload;
        CPDFOptimizeOptions current = document.getOptimizeOptions();
        CPDFOptimizeOptions options =
                current == null ? new CPDFOptimizeOptions() : new CPDFOptimizeOptions(current);

        Object flags = map.get("flags");
        if (flags instanceof Number) {
            options.optimizeFlags = ((Number) flags).intValue();
        }
        Object imageQuality = map.get("image_quality");
        if (imageQuality instanceof Number) {
            float quality = ((Number) imageQuality).floatValue();
            if (quality < 0F || quality > 100F) {
                throw new IllegalArgumentException("image_quality must be between 0 and 100.");
            }
            options.imageQuality = quality;
        }
        options.colorImageOptions = decodeImageOptions(map.get("color_image_options"),
                options.colorImageOptions, "color_image_options");
        options.grayscaleImageOptions = decodeImageOptions(map.get("grayscale_image_options"),
                options.grayscaleImageOptions, "grayscale_image_options");
        options.monochromeImageOptions = decodeImageOptions(map.get("monochrome_image_options"),
                options.monochromeImageOptions, "monochrome_image_options");
        options.colorSpaceConvert =
                decodeColorSpaceConvert(map.get("color_space_convert"), options.colorSpaceConvert);
        return options;
    }

    @NonNull
    private static CPDFImageOptimizeOptions decodeImageOptions(@Nullable Object payload,
            @Nullable CPDFImageOptimizeOptions fallback, @NonNull String field) {
        CPDFImageOptimizeOptions options = fallback == null
                ? new CPDFImageOptimizeOptions()
                : new CPDFImageOptimizeOptions(fallback);
        if (payload == null) {
            return options;
        }
        if (!(payload instanceof Map)) {
            throw new IllegalArgumentException(field + " must be a map.");
        }
        Map<?, ?> map = (Map<?, ?>) payload;
        options.upperPpi = requirePositive(map.get("upper_ppi"), options.upperPpi,
                field + ".upper_ppi");
        options.targetPpi = requirePositive(map.get("target_ppi"), options.targetPpi,
                field + ".target_ppi");
        options.blockSize = requirePositive(map.get("block_size"), options.blockSize,
                field + ".block_size");
        Object quality = map.get("quality");
        if (quality instanceof Number) {
            int value = ((Number) quality).intValue();
            if (value < 0 || value > 100) {
                throw new IllegalArgumentException(
                        field + ".quality must be between 0 and 100.");
            }
            options.quality = value;
        }
        Object algorithm = map.get("compress_algorithm");
        if (algorithm instanceof String) {
            CPDFCompressAlgorithm resolved = fromChannelValue((String) algorithm);
            if (resolved == null) {
                throw new IllegalArgumentException(
                        "Unknown " + field + ".compress_algorithm: " + algorithm);
            }
            options.compressAlgorithm = resolved;
        }
        return options;
    }

    @NonNull
    private static CPDFColorSpaceConvertOptions decodeColorSpaceConvert(@Nullable Object payload,
            @Nullable CPDFColorSpaceConvertOptions fallback) {
        CPDFColorSpaceConvertOptions options = fallback == null
                ? new CPDFColorSpaceConvertOptions()
                : new CPDFColorSpaceConvertOptions(fallback);
        if (payload == null) {
            return options;
        }
        if (!(payload instanceof Map)) {
            throw new IllegalArgumentException("color_space_convert must be a map.");
        }
        Map<?, ?> map = (Map<?, ?>) payload;
        Object iccData = map.get("icc_data");
        if (iccData instanceof byte[]) {
            options.iccData = (byte[]) iccData;
        } else if (map.containsKey("icc_data") && iccData == null) {
            options.iccData = null;
        } else if (iccData != null) {
            throw new IllegalArgumentException("color_space_convert.icc_data must be bytes.");
        }
        Object rgbToCmyk = map.get("rgb_to_cmyk");
        if (rgbToCmyk instanceof Boolean) {
            options.rgbToCmyk = (Boolean) rgbToCmyk;
        }
        return options;
    }

    private static int requirePositive(@Nullable Object value, int fallback,
            @NonNull String field) {
        if (!(value instanceof Number)) {
            return fallback;
        }
        int resolved = ((Number) value).intValue();
        if (resolved <= 0) {
            throw new IllegalArgumentException(field + " must be greater than 0.");
        }
        return resolved;
    }

    private static final Map<CPDFCompressAlgorithm, String> ALGORITHM_TO_VALUE = new HashMap<>();
    private static final Map<String, CPDFCompressAlgorithm> VALUE_TO_ALGORITHM = new HashMap<>();

    static {
        // The wire format is a string rather than the native ordinal, because the iOS
        // CPDF_COMP_ALG enum numbers the same algorithms differently.
        registerAlgorithm(CPDFCompressAlgorithm.kNone, "none");
        registerAlgorithm(CPDFCompressAlgorithm.kFlate, "flate");
        registerAlgorithm(CPDFCompressAlgorithm.kRunLength, "run_length");
        registerAlgorithm(CPDFCompressAlgorithm.kDCT, "jpeg");
        registerAlgorithm(CPDFCompressAlgorithm.kJBIG2, "jbig2");
        registerAlgorithm(CPDFCompressAlgorithm.kJPX, "jpeg2000");
    }

    private static void registerAlgorithm(CPDFCompressAlgorithm algorithm, String value) {
        ALGORITHM_TO_VALUE.put(algorithm, value);
        VALUE_TO_ALGORITHM.put(value, algorithm);
    }

    @NonNull
    static String toChannelValue(@Nullable CPDFCompressAlgorithm algorithm) {
        String value = algorithm == null ? null : ALGORITHM_TO_VALUE.get(algorithm);
        return value == null ? "none" : value;
    }

    @Nullable
    static CPDFCompressAlgorithm fromChannelValue(@Nullable String value) {
        return value == null ? null : VALUE_TO_ALGORITHM.get(value);
    }

    // endregion
}
