/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public final class CPDFViewRegistry {

    private static final ConcurrentMap<Integer, CPDFViewContext> CONTEXTS = new ConcurrentHashMap<>();

    private CPDFViewRegistry() {
    }

    public static void register(@NonNull CPDFViewContext context) {
        CONTEXTS.put(context.getViewId(), context);
    }

    @Nullable
    public static CPDFViewContext find(int viewId) {
        return CONTEXTS.get(viewId);
    }

    public static void unregister(int viewId) {
        CONTEXTS.remove(viewId);
    }
}