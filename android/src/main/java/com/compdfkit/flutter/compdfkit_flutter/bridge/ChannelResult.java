/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.bridge;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.MethodChannel;

public final class ChannelResult {

    private ChannelResult() {
    }

    public static void success(MethodChannel.Result result, @Nullable Object value) {
        result.success(value);
    }

    public static void error(MethodChannel.Result result, String code, String message,
            @Nullable Object details) {
        result.error(code, message, details);
    }
}
