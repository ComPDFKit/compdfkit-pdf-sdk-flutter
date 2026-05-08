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

import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFDocumentInfoUtil;
import io.flutter.plugin.common.MethodChannel;

public final class DocumentInfoOps {

    private DocumentInfoOps() {
    }

    public static String getFileName(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().getFileName();
    }

    public static boolean isEncrypted(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().isEncrypted();
    }

    public static void isImageDoc(@NonNull CPDFDocumentContext context,
            @NonNull MethodChannel.Result result) {
        result.success(context.requireDocument().isImageDoc());
    }

    public static int getPermissions(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().getPermissions().id;
    }

    public static boolean checkOwnerUnlocked(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().checkOwnerUnlocked();
    }

    public static boolean checkOwnerPassword(@NonNull CPDFDocumentContext context,
            @NonNull String password) {
        return context.requireDocument().checkOwnerPassword(password);
    }

    public static boolean close(@NonNull CPDFDocumentContext context) {
        context.requireDocument().close();
        return true;
    }

    public static boolean hasChange(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().hasChanges();
    }

    public static int getPageCount(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().getPageCount();
    }

    public static String getDocumentPath(@NonNull CPDFDocumentContext context) {
        CPDFDocument document = context.requireDocument();
        if (!TextUtils.isEmpty(document.getAbsolutePath())) {
            return document.getAbsolutePath();
        }
        return document.getUri().toString();
    }

    public static Object getDocumentInfo(@NonNull CPDFDocumentContext context) {
        return CPDFDocumentInfoUtil.getDocumentInfo(context.requireDocument());
    }

    public static int getMajorVersion(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().getMajorVersion();
    }

    public static int getMinorVersion(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().getMinorVersion();
    }

    public static Object getPermissionsInfo(@NonNull CPDFDocumentContext context) {
        return CPDFDocumentInfoUtil.getPermissionsInfo(context.requireDocument());
    }

    public static boolean isLocked(@NonNull CPDFDocumentContext context) {
        return context.requireDocument().isLocked();
    }
}