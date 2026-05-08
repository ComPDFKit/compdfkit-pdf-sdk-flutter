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
import com.compdfkit.core.document.CPDFDocument.PDFDocumentEncryptAlgo;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentSaveType;
import com.compdfkit.core.document.CPDFDocumentPermissionInfo;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;

public final class DocumentSecurityOps {

    private DocumentSecurityOps() {
    }

    public static boolean removePassword(@NonNull CPDFDocumentContext context) throws Exception {
        CPDFDocument document = context.requireDocument();
        boolean saveResult = document.save(PDFDocumentSaveType.PDFDocumentSaveRemoveSecurity, true);
        if (document.shouleReloadDocument()) {
            document.reload();
        }
        return saveResult;
    }

    public static boolean setPassword(@NonNull CPDFDocumentContext context, String userPassword,
            String ownerPassword, boolean allowsPrinting, boolean allowsCopying,
            String encryptAlgo) throws Exception {
        CPDFDocument document = context.requireDocument();
        if (!TextUtils.isEmpty(userPassword)) {
            document.setUserPassword(userPassword);
        }
        if (!TextUtils.isEmpty(ownerPassword)) {
            document.setOwnerPassword(ownerPassword);
            CPDFDocumentPermissionInfo permissionInfo = document.getPermissionsInfo();
            permissionInfo.setAllowsPrinting(allowsPrinting);
            permissionInfo.setAllowsCopying(allowsCopying);
            document.setPermissionsInfo(permissionInfo);
        }
        applyEncryptAlgorithm(document, encryptAlgo);
        boolean saveResult = document.save(CPDFDocument.PDFDocumentSaveType.PDFDocumentSaveIncremental,
                true);
        if (document.shouleReloadDocument()) {
            if (!TextUtils.isEmpty(userPassword)) {
                document.reload(userPassword);
            } else if (!TextUtils.isEmpty(ownerPassword)) {
                document.reload(ownerPassword);
            } else {
                document.reload();
            }
        }
        return saveResult;
    }

    public static String getEncryptAlgorithm(@NonNull CPDFDocumentContext context) {
        switch (context.requireDocument().getEncryptAlgorithm()) {
            case PDFDocumentRC4:
                return "rc4";
            case PDFDocumentAES128:
                return "aes128";
            case PDFDocumentAES256:
                return "aes256";
            case PDFDocumentNoEncryptAlgo:
            default:
                return "noEncryptAlgo";
        }
    }

    private static void applyEncryptAlgorithm(CPDFDocument document, String encryptAlgo) {
        if (TextUtils.isEmpty(encryptAlgo)) {
            return;
        }
        switch (encryptAlgo) {
            case "rc4":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentRC4);
                break;
            case "aes128":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentAES128);
                break;
            case "aes256":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentAES256);
                break;
            case "noEncryptAlgo":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentNoEncryptAlgo);
                break;
            default:
                break;
        }
    }
}