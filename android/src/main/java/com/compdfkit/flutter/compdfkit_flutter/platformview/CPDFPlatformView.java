/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.platformview;

import android.content.Context;
import android.util.Log;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentContainerView;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFViewCtrlPlugin;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class CPDFPlatformView implements PlatformView {

    public static final String LOG_TAG = "ComPDFKit-Plugin";

    private FragmentContainerView fragmentContainerView;
    private CPDFPlatformViewBinding platformViewBinding;
    private CPDFViewCtrlPlugin methodChannel;

    public CPDFPlatformView(Context context, BinaryMessenger binaryMessenger, int viewId,
            Map<String, Object> creationParams) {
        Log.e(LOG_TAG, "CPDFPlatformView: create CPDFDocumentFragment binding");
        platformViewBinding = CPDFPlatformViewBinding.create(context, creationParams);
        fragmentContainerView = platformViewBinding.getContainerView();
        CPDFDocumentFragment documentFragment = platformViewBinding.getDocumentFragment();

        methodChannel = new CPDFViewCtrlPlugin(context, binaryMessenger, viewId);
        methodChannel.register();
        methodChannel.setDocumentFragment(documentFragment);
    }

    @Nullable
    @Override
    public View getView() {
        return fragmentContainerView;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
        PlatformView.super.onFlutterViewAttached(flutterView);
    }

    @Override
    public void onFlutterViewDetached() {
        PlatformView.super.onFlutterViewDetached();
    }

    @Override
    public void dispose() {
        Log.e(LOG_TAG, "CPDFPlatformView: dispose()");
        if (methodChannel != null) {
            methodChannel.unregister();
            methodChannel = null;
        }
        if (platformViewBinding != null) {
            platformViewBinding.dispose();
            platformViewBinding = null;
        }
        fragmentContainerView = null;
    }

    @Override
    public void onInputConnectionLocked() {
        PlatformView.super.onInputConnectionLocked();
    }

    @Override
    public void onInputConnectionUnlocked() {
        PlatformView.super.onInputConnectionUnlocked();
    }
}
