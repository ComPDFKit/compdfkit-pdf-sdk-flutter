/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.platformview;


import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class CPDFViewCtrlFactory extends PlatformViewFactory {

    private final BinaryMessenger binaryMessenger;

    public CPDFViewCtrlFactory(BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        this.binaryMessenger = binaryMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        @SuppressWarnings("unchecked")
        Map<String, Object> creationParams = (Map<String, Object>) args;
        return new CPDFViewCtrlFlutter(context, binaryMessenger, viewId, creationParams);
    }
}
