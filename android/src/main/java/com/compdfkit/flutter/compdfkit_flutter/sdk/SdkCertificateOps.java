/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */
package com.compdfkit.flutter.compdfkit_flutter.sdk;

import android.content.Context;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.compdfkit.core.signature.CPDFCertInfo;
import com.compdfkit.core.signature.CPDFOwnerInfo;
import com.compdfkit.core.signature.CPDFSignature;
import com.compdfkit.core.signature.CPDFX509;
import com.compdfkit.flutter.compdfkit_flutter.bridge.ThreadDispatch;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

public final class SdkCertificateOps {
    private SdkCertificateOps() {}

    public static void generate(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Map<String, Object> request = call.arguments();
        Map<String, Object> subject = request == null ? null : (Map<String, Object>) request.get("subject");
        String password = string(request, "password");
        String outputPath = string(request, "output_path");
        int usage = number(request, "usage", 1);
        if (subject == null || TextUtils.isEmpty(password) || TextUtils.isEmpty(outputPath)) {
            result.error("INVALID_CERTIFICATE_REQUEST", "Certificate request is incomplete", null);
            return;
        }
        ThreadDispatch.runIo(() -> {
            boolean success = CPDFSignature.generatePKCS12Cert(ownerInfo(subject), password,
                    outputPath, CPDFSignature.CertUsage.toEnum(usage));
            result.success(success);
        });
    }

    public static void check(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> result.success(CPDFSignature.checkPKCS12Password(
                argument(call, "path"), argument(call, "password"))));
    }

    public static void load(@NonNull Context context, @NonNull MethodCall call,
            @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            CPDFX509 certificate = CPDFSignature.getX509ByPKCS12Cert(
                    argument(call, "path"), argument(call, "password"));
            if (certificate == null || !certificate.isValid()) {
                result.success(null);
                return;
            }
            CPDFCertInfo info = certificate.getCertInfo();
            Map<String, Object> value = new HashMap<>();
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
            value.put("is_trusted", certificate.checkCertificateIsTrusted(context));
            result.success(value);
        });
    }

    public static void configure(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        result.error("UNSUPPORTED_CERTIFICATE_DIRECTORY_CONFIGURATION",
                "Android manages certificate directories inside the application sandbox", null);
    }

    public static void addTrusted(@NonNull Context context, @NonNull MethodCall call,
            @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            CPDFX509 certificate = CPDFSignature.getX509ByPKCS12Cert(
                    argument(call, "path"), argument(call, "password"));
            result.success(certificate != null && certificate.isValid()
                    && certificate.addToTrustedCertificates(context));
        });
    }

    private static CPDFOwnerInfo ownerInfo(Map<String, Object> subject) {
        CPDFOwnerInfo owner = new CPDFOwnerInfo();
        owner.setCountry(string(subject, "country"));
        owner.setProvince(string(subject, "state"));
        owner.setLocality(string(subject, "locality"));
        owner.setOrgnize(string(subject, "organization"));
        owner.setOrgnizeUnit(string(subject, "organizational_unit"));
        owner.setCommonName(string(subject, "common_name"));
        owner.setEmail(string(subject, "email"));
        return owner;
    }

    private static String argument(MethodCall call, String key) {
        Object value = call.argument(key);
        return value == null ? "" : String.valueOf(value);
    }

    private static String string(Map<String, Object> map, String key) {
        Object value = map == null ? null : map.get(key);
        return value == null ? "" : String.valueOf(value);
    }

    private static int number(Map<String, Object> map, String key, int fallback) {
        Object value = map == null ? null : map.get(key);
        return value instanceof Number ? ((Number) value).intValue() : fallback;
    }
}
