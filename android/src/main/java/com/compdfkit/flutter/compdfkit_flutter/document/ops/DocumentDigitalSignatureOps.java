/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document.ops;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFSignatureWidget;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.signature.CPDFCertInfo;
import com.compdfkit.core.signature.CPDFDigitalSigConfig;
import com.compdfkit.core.signature.CPDFLtvDssInfo;
import com.compdfkit.core.signature.CPDFLtvReadinessInfo;
import com.compdfkit.core.signature.CPDFLtvReadinessResult;
import com.compdfkit.core.signature.CPDFLtvService;
import com.compdfkit.core.signature.CPDFPadesOptions;
import com.compdfkit.core.signature.CPDFPadesResult;
import com.compdfkit.core.signature.CPDFPadesSigner;
import com.compdfkit.core.signature.CPDFSignature;
import com.compdfkit.core.signature.CPDFSignatureValidationOptions;
import com.compdfkit.core.signature.CPDFSignatureValidationReport;
import com.compdfkit.core.signature.CPDFSignatureValidationResult;
import com.compdfkit.core.signature.CPDFSignatureValidator;
import com.compdfkit.core.signature.CPDFSigner;
import com.compdfkit.core.signature.CPDFValidationReportItem;
import com.compdfkit.core.signature.CPDFX509;
import com.compdfkit.flutter.compdfkit_flutter.bridge.ThreadDispatch;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.codec.CPDFPageCodec;
import com.compdfkit.ui.reader.CPDFReaderView;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/** Document-level digital signature operations. */
public final class DocumentDigitalSignatureOps {

    private static final String INVALID_DOCUMENT = "invalid_document";
    private static final String OWNER_PERMISSION_REQUIRED = "owner_permission_required";
    private static final String CERTIFICATE_NOT_FOUND = "certificate_not_found";
    private static final String INVALID_CERTIFICATE_PASSWORD = "invalid_certificate_password";
    private static final String CERTIFICATE_NOT_TRUSTED = "certificate_not_trusted";
    private static final String SIGNATURE_WIDGET_NOT_FOUND = "signature_widget_not_found";
    private static final String SIGNATURE_VERIFICATION_FAILED = "signature_verification_failed";
    private static final String SIGNATURE_TIMESTAMP_FAILED = "signature_timestamp_failed";
    private static final String LTV_READINESS_FAILED = "ltv_readiness_failed";
    private static final String LTV_OUTPUT_INVALID = "ltv_output_invalid";

    private DocumentDigitalSignatureOps() {
    }

    public static void getDigitalSignatures(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            try {
                CPDFDocument document = context.requireDocument();
                ArrayList<HashMap<String, Object>> signatures = new ArrayList<>();
                for (int index = 0; index < document.getSignatureCount(); index++) {
                    CPDFSignature signature = document.getPdfSignature(index);
                    if (signature != null && signature.isValid()) {
                        signatures.add(toSignatureMap(context, document, signature, index));
                    }
                }
                result.success(signatures);
            } catch (Exception ignored) {
                result.error(INVALID_DOCUMENT, "The PDF document is not valid.", null);
            }
        });
    }

    public static void verifyDigitalSignature(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Number signatureIndex = call.argument("signature_index");
        if (signatureIndex == null || signatureIndex.intValue() < 0) {
            result.error(SIGNATURE_VERIFICATION_FAILED, "The signature index is invalid.", null);
            return;
        }
        // Validation reads the saved file and may be slow; keep it off the UI thread.
        ThreadDispatch.runIo(() -> {
            try {
                CPDFDocument document = context.requireDocument();
                CPDFSignature signature = document.getPdfSignature(signatureIndex.intValue());
                if (signature == null || !signature.isValid()) {
                    result.error(SIGNATURE_VERIFICATION_FAILED,
                            "The digital signature could not be found.", null);
                    return;
                }
                boolean signatureValid = signature.verify(document);
                boolean documentUnmodified = signature.verifyDocument(document);
                VerificationState state = certificateState(context, signature, document);
                boolean timestampTrusted = signature.veryfyTimestamp(context.getContext());
                CPDFSignatureValidationReport report = validationReport(document, signature);
                HashMap<String, Object> value = new HashMap<>();
                value.put("signature_valid", signatureValid);
                value.put("document_unmodified", documentUnmodified);
                value.put("certificate_trusted", state.trusted);
                value.put("certificate_expired", state.expired);
                value.put("timestamp_trusted", timestampTrusted);
                value.put("timestamp_source", signature.getTimestampSource().getId());
                value.put("embedded_timestamp_valid",
                        report == null ? null : report.hasEmbeddedTimestamp());
                value.put("ltv_enabled", documentLtvReady(document));
                result.success(value);
            } catch (SecurityException ignored) {
                result.error(OWNER_PERMISSION_REQUIRED,
                        "Owner permission is required to verify this document.", null);
            } catch (Exception ignored) {
                result.error(SIGNATURE_VERIFICATION_FAILED,
                        "The digital signature could not be verified.", null);
            }
        });
    }

    public static void getLtvReadiness(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            try {
                CPDFLtvReadinessResult readiness =
                        CPDFLtvService.assessReadiness(context.requireDocument());
                if (readiness == null) {
                    result.error(LTV_READINESS_FAILED,
                            "The document LTV material could not be inspected.", null);
                    return;
                }
                result.success(toReadinessMap(readiness));
            } catch (SecurityException ignored) {
                result.error(OWNER_PERMISSION_REQUIRED,
                        "Owner permission is required to inspect this document.", null);
            } catch (Exception ignored) {
                result.error(LTV_READINESS_FAILED,
                        "The document LTV material could not be inspected.", null);
            }
        });
    }

    public static void addSignatureLtv(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String outputPath = call.argument("output_path");
        Map<String, Object> options = call.argument("options");
        if (TextUtils.isEmpty(outputPath) || options == null) {
            result.error(LTV_OUTPUT_INVALID, "The LTV output request is invalid.", null);
            return;
        }
        String trustedCertificatePath = string(options, "trusted_certificate_path");
        if (!new File(trustedCertificatePath).isFile()) {
            result.error(CERTIFICATE_NOT_FOUND,
                    "The trusted certificate file could not be found.", null);
            return;
        }
        boolean appendDocumentTimestamp =
                booleanValue(options, "append_document_timestamp", false);
        String ltaOutputPath = nullableString(options, "lta_output_path");
        String timestampServerUrl = nullableString(options, "timestamp_server_url");
        if (appendDocumentTimestamp
                && (TextUtils.isEmpty(ltaOutputPath) || TextUtils.isEmpty(timestampServerUrl))) {
            result.error(LTV_OUTPUT_INVALID,
                    "A document timestamp needs a TSA URL and a separate output path.", null);
            return;
        }

        ThreadDispatch.runIo(() -> {
            try {
                CPDFDocument document = context.requireDocument();
                String inputPath = document.getAbsolutePath();
                if (TextUtils.isEmpty(inputPath) || !new File(inputPath).isFile()) {
                    result.error(INVALID_DOCUMENT,
                            "LTV material can only be added to a document saved as a file.", null);
                    return;
                }
                if (!isValidOutput(inputPath, outputPath)
                        || (appendDocumentTimestamp
                        && (!isValidOutput(inputPath, ltaOutputPath)
                        || samePath(outputPath, ltaOutputPath)))) {
                    result.error(LTV_OUTPUT_INVALID,
                            "The LTV output path must be a new file in an existing directory.",
                            null);
                    return;
                }
                CPDFPadesOptions padesOptions = new CPDFPadesOptions()
                        .setTrustedCertPath(trustedCertificatePath)
                        .setRevocationUrls(strings(options, "ocsp_urls"),
                                strings(options, "crl_urls"))
                        .setAppendDocumentTimestamp(appendDocumentTimestamp);
                if (appendDocumentTimestamp) {
                    padesOptions.setLtaTsaUrl(timestampServerUrl);
                }
                CPDFPadesResult padesResult = CPDFPadesSigner.prolongLtv(inputPath, outputPath,
                        appendDocumentTimestamp ? ltaOutputPath : null, padesOptions);
                result.success(toLtvResultMap(padesResult));
            } catch (SecurityException ignored) {
                result.error(OWNER_PERMISSION_REQUIRED,
                        "Owner permission is required to update this document.", null);
            } catch (Exception ignored) {
                result.error(INVALID_DOCUMENT, "The LTV material could not be added.", null);
            }
        });
    }

    public static void writeSignature(@NonNull CPDFDocumentContext context,
            @NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Number pageIndex = call.argument("page_index");
        String uuid = call.argument("uuid");
        String outputPath = call.argument("output_path");
        Map<String, Object> config = call.argument("config");
        if (pageIndex == null || pageIndex.intValue() < 0 || TextUtils.isEmpty(uuid)) {
            result.error(SIGNATURE_WIDGET_NOT_FOUND,
                    "The signature form field could not be found.", null);
            return;
        }
        if (TextUtils.isEmpty(outputPath) || config == null) {
            result.error(INVALID_DOCUMENT, "The signature output request is invalid.", null);
            return;
        }
        String certificatePath = string(config, "certificate_path");
        String password = string(config, "password");
        if (!new File(certificatePath).isFile()) {
            result.error(CERTIFICATE_NOT_FOUND, "The signing certificate could not be found.", null);
            return;
        }
        if (TextUtils.isEmpty(password)) {
            result.error(INVALID_CERTIFICATE_PASSWORD, "The certificate password is invalid.", null);
            return;
        }
        File output = new File(outputPath);
        try {
            if (output.getCanonicalFile().equals(new File(context.requireDocument().getAbsolutePath()).getCanonicalFile())) {
                result.error(INVALID_DOCUMENT, "The signed PDF must be written to a new file.", null);
                return;
            }
        } catch (Exception ignored) {
            result.error(INVALID_DOCUMENT, "The signature output request is invalid.", null);
            return;
        }

        ThreadDispatch.runIo(() -> {
            try {
                CPDFDocument document = context.requireDocument();
                CPDFAnnotation annotation = context.getPageCodec().getAnnotation(
                        pageIndex.intValue(), uuid);
                if (!(annotation instanceof CPDFSignatureWidget) || !annotation.isValid()) {
                    result.error(SIGNATURE_WIDGET_NOT_FOUND,
                            "The signature form field could not be found.", null);
                    return;
                }
                CPDFSignatureWidget widget = (CPDFSignatureWidget) annotation;
                Map<String, Object> appearanceValues = map(config, "appearance");
                if (hasInvalidBitmap(appearanceValues, "logo_path")
                        || hasInvalidBitmap(appearanceValues, "image_path")) {
                    result.error(INVALID_DOCUMENT,
                            "The signature appearance image could not be loaded.", null);
                    return;
                }
                CPDFDigitalSigConfig appearance = toAppearance(config);
                if (!widget.updateApWithDigitalSigConfig(appearance)) {
                    result.error(SIGNATURE_VERIFICATION_FAILED,
                            "The digital signature appearance could not be prepared.", null);
                    return;
                }
                int permission = number(config, "permissions", 2);
                String timestampServerUrl = nullableString(config, "timestamp_server_url");
                boolean success = timestampServerUrl == null
                        ? document.writeSignature(widget, outputPath, certificatePath,
                        password, nullableString(config, "location"),
                        nullableString(config, "reason"),
                        CPDFDocument.PDFDocMdpP.valueOf(permission))
                        : document.writeSignature(widget, outputPath, certificatePath,
                        password, nullableString(config, "location"),
                        nullableString(config, "reason"),
                        CPDFDocument.PDFDocMdpP.valueOf(permission), timestampServerUrl);
                if (!success && timestampServerUrl != null) {
                    // The native call only reports a boolean. With a TSA the most
                    // likely cause is an unreachable or rejecting timestamp server.
                    result.error(SIGNATURE_TIMESTAMP_FAILED,
                            "The digital signature could not be written with the requested "
                                    + "timestamp. The TSA may be unreachable or rejected the request.",
                            null);
                    return;
                }
                if (!success) {
                    result.error(SIGNATURE_VERIFICATION_FAILED,
                            "The digital signature could not be written.", null);
                    return;
                }
                result.success(true);
            } catch (SecurityException ignored) {
                result.error(OWNER_PERMISSION_REQUIRED,
                        "Owner permission is required to sign this document.", null);
            } catch (Exception ignored) {
                result.error(SIGNATURE_VERIFICATION_FAILED,
                        "The digital signature could not be written.", null);
            }
        });
    }

    private static HashMap<String, Object> toSignatureMap(@NonNull CPDFDocumentContext context,
            @NonNull CPDFDocument document, @NonNull CPDFSignature signature, int signatureIndex) {
        HashMap<String, Object> value = new HashMap<>();
        RectF bounds = signature.getBounds();
        value.put("signature_index", signatureIndex);
        value.put("field_name", signature.getFieldName());
        value.put("page_index", signature.getPageIndex(document));
        value.put("bounds", toRect(bounds));
        value.put("name", signature.getName());
        value.put("date", signature.getDate());
        value.put("reason", signature.getReason());
        value.put("location", signature.getLocation());
        value.put("filter", signature.getFilter());
        value.put("sub_filter", signature.getSubFilter());
        value.put("permissions", signature.getPermissionType().id);
        value.put("signers", toSigners(context, document, signature));
        // Android Core does not expose public modification details in this SDK version.
        value.put("modifications", new ArrayList<HashMap<String, Object>>());
        return value;
    }

    private static ArrayList<HashMap<String, Object>> toSigners(
            @NonNull CPDFDocumentContext context, @NonNull CPDFDocument document,
            @NonNull CPDFSignature signature) {
        ArrayList<HashMap<String, Object>> values = new ArrayList<>();
        CPDFSigner[] signers = signature.getSignerArr();
        if (signers == null) {
            return values;
        }
        boolean signatureVerified = signature.verify(document);
        for (CPDFSigner signer : signers) {
            if (signer == null || !signer.isValid()) {
                continue;
            }
            CPDFX509 certificate = signer.getCert();
            boolean certificateTrusted = certificate != null
                    && certificate.checkCertificateIsTrusted(context.getContext());
            HashMap<String, Object> value = new HashMap<>();
            value.put("signature_verified", signatureVerified);
            value.put("certificate_trusted", certificateTrusted);
            ArrayList<HashMap<String, Object>> certificates = new ArrayList<>();
            if (certificate != null && certificate.isValid()) {
                certificates.add(toCertificateMap(certificate, certificateTrusted));
            }
            value.put("certificates", certificates);
            values.add(value);
        }
        return values;
    }

    private static HashMap<String, Object> toCertificateMap(@NonNull CPDFX509 certificate,
            boolean trusted) {
        CPDFCertInfo info = certificate.getCertInfo();
        HashMap<String, Object> value = new HashMap<>();
        if (info == null) {
            return value;
        }
        value.put("version", info.getVersion());
        value.put("serial_number", info.getSeriaNumber());
        value.put("key_type", info.getKeyType());
        value.put("signature_algorithm", info.getSignatureAlgOid());
        value.put("issuer", info.getIssuer() == null ? null : info.getIssuer().toString());
        value.put("subject", info.getSubject() == null ? null : info.getSubject().toString());
        value.put("valid_from", info.getValidDateBegin());
        value.put("valid_to", info.getValidDateEnd());
        value.put("sha1_digest", info.getSha1Digest());
        value.put("md5_digest", info.getMd5Digest());
        value.put("is_trusted", trusted);
        return value;
    }

    private static VerificationState certificateState(@NonNull CPDFDocumentContext context,
            @NonNull CPDFSignature signature, @NonNull CPDFDocument document) {
        VerificationState state = new VerificationState();
        CPDFSigner[] signers = signature.getSignerArr();
        if (signers == null) {
            return state;
        }
        for (CPDFSigner signer : signers) {
            if (signer == null || !signer.isValid()) {
                continue;
            }
            CPDFX509 certificate = signer.getCert();
            if (certificate != null && certificate.isValid()) {
                state.trusted = certificate.checkCertificateIsTrusted(context.getContext()) || state.trusted;
                state.expired = certificate.isExpired() || state.expired;
            }
        }
        return state;
    }

    @Nullable
    private static CPDFSignatureValidationReport validationReport(@NonNull CPDFDocument document,
            @NonNull CPDFSignature signature) {
        String fieldName = signature.getFieldName();
        CPDFSignatureValidationResult validation = CPDFSignatureValidator.validate(document,
                new CPDFSignatureValidationOptions().setFieldName(fieldName));
        if (validation == null || validation.getReports() == null) {
            return null;
        }
        for (CPDFSignatureValidationReport report : validation.getReports()) {
            if (report != null && TextUtils.equals(report.getFieldName(), fieldName)) {
                return report;
            }
        }
        return null;
    }

    /** Matches the document-level LTV check used by the Android ComPDFKit_Tools demo. */
    private static boolean documentLtvReady(@NonNull CPDFDocument document) {
        CPDFLtvReadinessResult result = CPDFLtvService.assessReadiness(document);
        return result != null
                && result.isSuccess()
                && result.getReadinessInfo() != null
                && result.getReadinessInfo().isLtvReady();
    }

    private static HashMap<String, Object> toReadinessMap(
            @NonNull CPDFLtvReadinessResult readiness) {
        HashMap<String, Object> value = new HashMap<>();
        CPDFLtvReadinessInfo info = readiness.getReadinessInfo();
        value.put("success", readiness.isSuccess());
        value.put("has_dss", info != null && info.hasDss());
        value.put("has_vri", info != null && info.hasVri());
        value.put("has_certificates", info != null && info.hasCertificates());
        value.put("has_revocation", info != null && info.hasRevocation());
        value.put("ltv_ready", info != null && info.isLtvReady());
        value.put("profile_hint", info == null ? "" : info.getProfileHint());
        ArrayList<String> missingMaterials = new ArrayList<>();
        if (info != null && info.getMissingMaterials() != null) {
            for (String material : info.getMissingMaterials()) {
                if (!TextUtils.isEmpty(material)) {
                    missingMaterials.add(material);
                }
            }
        }
        value.put("missing_materials", missingMaterials);
        HashMap<String, Object> dss = new HashMap<>();
        CPDFLtvDssInfo dssInfo = info == null ? null : info.getDssInfo();
        dss.put("certificates_count", dssInfo == null ? 0 : dssInfo.getCertificatesCount());
        dss.put("ocsp_responses_count", dssInfo == null ? 0 : dssInfo.getOcspResponsesCount());
        dss.put("crls_count", dssInfo == null ? 0 : dssInfo.getCrlsCount());
        dss.put("vri_entries_count", dssInfo == null ? 0 : dssInfo.getVriEntriesCount());
        value.put("dss", dss);
        value.put("errors", toIssues(readiness.getErrors()));
        value.put("warnings", toIssues(readiness.getWarnings()));
        return value;
    }

    private static HashMap<String, Object> toLtvResultMap(@Nullable CPDFPadesResult padesResult) {
        HashMap<String, Object> value = new HashMap<>();
        boolean success = padesResult != null && padesResult.isSuccess();
        value.put("success", success);
        // Paths are reported only for a successful run; a failed run may still
        // echo the requested path even though no usable file was produced.
        value.put("ltv_path", success ? padesResult.getLtvPath() : "");
        value.put("lta_path", success ? padesResult.getLtaPath() : "");
        value.put("errors", toIssues(padesResult == null ? null : padesResult.getErrors()));
        value.put("warnings", toIssues(padesResult == null ? null : padesResult.getWarnings()));
        return value;
    }

    private static ArrayList<HashMap<String, Object>> toIssues(
            @Nullable CPDFValidationReportItem[] items) {
        ArrayList<HashMap<String, Object>> values = new ArrayList<>();
        if (items == null) {
            return values;
        }
        for (CPDFValidationReportItem item : items) {
            if (item != null) {
                values.add(issue(item.getCode(), item.getMessage()));
            }
        }
        return values;
    }

    /** Converts the core's {@code code: message} lines into issue maps. */
    private static ArrayList<HashMap<String, Object>> toIssues(@Nullable String[] lines) {
        ArrayList<HashMap<String, Object>> values = new ArrayList<>();
        if (lines == null) {
            return values;
        }
        for (String line : lines) {
            if (TextUtils.isEmpty(line)) {
                continue;
            }
            int separator = line.indexOf(": ");
            values.add(separator < 0
                    ? issue(line, "")
                    : issue(line.substring(0, separator), line.substring(separator + 2)));
        }
        return values;
    }

    private static HashMap<String, Object> issue(@Nullable String code, @Nullable String message) {
        HashMap<String, Object> value = new HashMap<>();
        value.put("code", code == null ? "" : code);
        value.put("message", message == null ? "" : message);
        return value;
    }

    private static boolean isValidOutput(@NonNull String inputPath, @Nullable String outputPath) {
        if (TextUtils.isEmpty(outputPath)) {
            return false;
        }
        File parent = new File(outputPath).getAbsoluteFile().getParentFile();
        return parent != null && parent.isDirectory() && !samePath(inputPath, outputPath);
    }

    private static boolean samePath(@Nullable String first, @Nullable String second) {
        if (first == null || second == null) {
            return false;
        }
        try {
            return new File(first).getCanonicalFile().equals(new File(second).getCanonicalFile());
        } catch (Exception ignored) {
            return new File(first).getAbsoluteFile().equals(new File(second).getAbsoluteFile());
        }
    }

    @Nullable
    private static String[] strings(@NonNull Map<String, Object> values, String key) {
        Object value = values.get(key);
        if (!(value instanceof List)) {
            return null;
        }
        ArrayList<String> items = new ArrayList<>();
        for (Object item : (List<?>) value) {
            if (item != null && !TextUtils.isEmpty(String.valueOf(item))) {
                items.add(String.valueOf(item));
            }
        }
        return items.isEmpty() ? null : items.toArray(new String[0]);
    }

    private static CPDFDigitalSigConfig toAppearance(@NonNull Map<String, Object> config) {
        CPDFDigitalSigConfig appearance = new CPDFDigitalSigConfig();
        Map<String, Object> values = map(config, "appearance");
        String text = string(values, "text");
        if (TextUtils.isEmpty(text)) {
            text = string(config, "name");
        }
        appearance.setText(text);
        appearance.setContent(string(values, "content"));
        appearance.setDrawLogo(booleanValue(values, "draw_logo", true));
        appearance.setDrawOnlyContent(booleanValue(values, "draw_only_content", false));
        appearance.setContentAlginLeft(booleanValue(values, "content_align_left", true));
        appearance.setTextColor(parseColor(string(values, "text_color"), Color.BLACK));
        appearance.setContentColor(parseColor(string(values, "content_color"), Color.BLACK));
        Bitmap logo = bitmap(values, "logo_path");
        Bitmap image = bitmap(values, "image_path");
        if (logo != null) {
            appearance.setLogo(logo);
        }
        if (image != null) {
            appearance.setImage(image);
        }
        return appearance;
    }

    @Nullable
    private static Bitmap bitmap(@NonNull Map<String, Object> values, String key) {
        String path = string(values, key);
        return TextUtils.isEmpty(path) ? null : BitmapFactory.decodeFile(path);
    }

    private static boolean hasInvalidBitmap(@NonNull Map<String, Object> values, String key) {
        String path = string(values, key);
        return !TextUtils.isEmpty(path) && BitmapFactory.decodeFile(path) == null;
    }

    private static Map<String, Object> map(@NonNull Map<String, Object> values, String key) {
        Object value = values.get(key);
        return value instanceof Map ? (Map<String, Object>) value : new HashMap<>();
    }

    private static HashMap<String, Object> toRect(@Nullable RectF rect) {
        HashMap<String, Object> value = new HashMap<>();
        if (rect == null) {
            value.put("left", 0f);
            value.put("top", 0f);
            value.put("right", 0f);
            value.put("bottom", 0f);
            return value;
        }
        value.put("left", rect.left);
        value.put("top", rect.top);
        value.put("right", rect.right);
        value.put("bottom", rect.bottom);
        return value;
    }

    private static int parseColor(String value, int fallback) {
        if (TextUtils.isEmpty(value)) {
            return fallback;
        }
        try {
            return Color.parseColor(value);
        } catch (IllegalArgumentException ignored) {
            return fallback;
        }
    }

    private static String string(@Nullable Map<String, Object> values, String key) {
        Object value = values == null ? null : values.get(key);
        return value == null ? "" : String.valueOf(value);
    }

    @Nullable
    private static String nullableString(@NonNull Map<String, Object> values, String key) {
        String value = string(values, key);
        return value.isEmpty() ? null : value;
    }

    private static int number(@NonNull Map<String, Object> values, String key, int fallback) {
        Object value = values.get(key);
        return value instanceof Number ? ((Number) value).intValue() : fallback;
    }

    private static boolean booleanValue(@NonNull Map<String, Object> values, String key,
            boolean fallback) {
        Object value = values.get(key);
        return value instanceof Boolean ? (Boolean) value : fallback;
    }

    private static final class VerificationState {
        boolean trusted;
        boolean expired;
    }
}
