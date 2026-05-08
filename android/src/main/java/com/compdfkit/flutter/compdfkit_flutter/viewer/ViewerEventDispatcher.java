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
import io.flutter.plugin.common.MethodChannel;

public final class ViewerEventDispatcher {

    private ViewerEventDispatcher() {
    }

    public static void dispatch(@Nullable MethodChannel channel, @NonNull String eventName,
            @Nullable Object payload) {
        if (channel == null) {
            return;
        }
        channel.invokeMethod(eventName, payload);
    }

    public static void dispatchIfSubscribed(@Nullable MethodChannel channel,
            @NonNull CPDFViewContext context, @NonNull String eventName,
            @Nullable Object payload) {
        if (!context.getSubscribedEvents().contains(eventName)) {
            return;
        }
        dispatch(channel, eventName, payload);
    }
}