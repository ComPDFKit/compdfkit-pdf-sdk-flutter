/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.sdk;

import androidx.annotation.NonNull;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public final class SdkPluginRegistry {

    private static final ConcurrentMap<String, CPDFDocumentPlugin> DOCUMENT_PLUGINS = new ConcurrentHashMap<>();

    private SdkPluginRegistry() {
    }

    public static void registerDocumentPlugin(@NonNull String id,
            @NonNull CPDFDocumentPlugin documentPlugin) {
        CPDFDocumentPlugin previous = DOCUMENT_PLUGINS.put(id, documentPlugin);
        if (previous != null) {
            previous.unregister();
        }
    }

    public static void unregisterDocumentPlugin(@NonNull String id) {
        CPDFDocumentPlugin documentPlugin = DOCUMENT_PLUGINS.remove(id);
        if (documentPlugin != null) {
            documentPlugin.unregister();
        }
    }

    public static void unregisterAll() {
        for (String id : DOCUMENT_PLUGINS.keySet()) {
            unregisterDocumentPlugin(id);
        }
    }
}
