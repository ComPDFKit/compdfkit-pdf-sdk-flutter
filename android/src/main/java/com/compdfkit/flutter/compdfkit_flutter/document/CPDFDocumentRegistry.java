/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public final class CPDFDocumentRegistry {

    private static final ConcurrentMap<String, CPDFDocumentContext> CONTEXTS = new ConcurrentHashMap<>();

    private CPDFDocumentRegistry() {
    }

    public static void register(@NonNull CPDFDocumentContext context) {
        CONTEXTS.put(context.getDocumentUid(), context);
    }

    @Nullable
    public static CPDFDocumentContext find(String documentUid) {
        return CONTEXTS.get(documentUid);
    }

    public static void unregister(@NonNull String documentUid) {
        CONTEXTS.remove(documentUid);
    }
}