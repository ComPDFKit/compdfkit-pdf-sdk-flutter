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
import android.content.MutableContextWrapper;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentContainerView;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFViewCtrlPlugin;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.pdf.config.CPDFConfiguration;
import com.compdfkit.tools.common.utils.customevent.CPDFCustomEventCallbackHelper;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class CPDFViewCtrlFlutter implements PlatformView {

    public static final String LOG_TAG = "ComPDFKit-Plugin";
    private FragmentContainerView fragmentContainerView;

    private CPDFDocumentFragment documentFragment;

    private BinaryMessenger binaryMessenger;

    private int viewId;

    private CPDFViewCtrlPlugin methodChannel;

    public CPDFViewCtrlFlutter(Context context, BinaryMessenger binaryMessenger, int viewId,
            Map<String, Object> creationParams) {
        this.binaryMessenger = binaryMessenger;
        this.viewId = viewId;

        // Initialize CPDFViewCtrl and initialize related configuration information
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter:Create CPDFDocumentFragment");
        initCPDFViewCtrl(context, creationParams);

        // Register plug-ins related to interaction with the document
        // interface to control document display, such as setting the document scrolling
        // direction.
        methodChannel = new CPDFViewCtrlPlugin(context, binaryMessenger, viewId);
        methodChannel.register();
        methodChannel.setDocumentFragment(documentFragment);

    }

    private void initCPDFViewCtrl(Context context, Map<String, Object> creationParams) {
        fragmentContainerView = new FragmentContainerView(context);
        fragmentContainerView.setId(View.generateViewId());
        String filePath = (String) creationParams.get("document");
        String password = (String) creationParams.get("password");

        String configurationJson = (String) creationParams.get("configuration");
        int pageIndex = (int) creationParams.get("pageIndex");

        CPDFConfiguration configuration = CPDFConfigurationUtils.fromJson(configurationJson);

        Bundle args = new Bundle();
        args.putString(CPDFDocumentFragment.EXTRA_FILE_PASSWORD, password);
        args.putSerializable(CPDFDocumentFragment.EXTRA_CONFIGURATION, configuration);
        args.putInt(CPDFDocumentFragment.EXTRA_PAGE_INDEX, pageIndex);
        if (filePath.startsWith(FileUtils.CONTENT_SCHEME) || filePath.startsWith(
                FileUtils.FILE_SCHEME)) {
            args.putParcelable(CPDFDocumentFragment.EXTRA_FILE_URI, Uri.parse(filePath));
        } else {
            args.putString(CPDFDocumentFragment.EXTRA_FILE_PATH, filePath);
        }
        documentFragment = CPDFDocumentFragment.newInstance(args);
        fragmentContainerView.addOnAttachStateChangeListener(
                new View.OnAttachStateChangeListener() {
                    @Override
                    public void onViewAttachedToWindow(@NonNull View v) {
                        Log.e(LOG_TAG, "CPDFViewCtrlFlutter: Attached CPDFDocumentFragment to window");
                        FragmentActivity fragmentActivity = getFragmentActivity(context);
                        if (fragmentActivity == null) {
                            throw new RuntimeException(
                                    "Please use FlutterFragmentActivity to host MainActivity");
                        }
                        fragmentActivity.getSupportFragmentManager()
                                .beginTransaction()
                                // .setCustomAnimations(
                                // R.anim.fade_in, // enter
                                // R.anim.fade_out, // exit
                                // R.anim.fade_in, // popEnter
                                // R.anim.fade_out // popExit
                                // )
                                .add(fragmentContainerView.getId(), documentFragment, "documentFragment")
                                .setReorderingAllowed(true)
                                .commitAllowingStateLoss();
                    }

                    @Override
                    public void onViewDetachedFromWindow(@NonNull View v) {
                        detachedFragment(context);
                    }
                });
    }

    private void detachedFragment(Context context) {
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter: Detached CPDFDocumentFragment from window");

        if (documentFragment == null || fragmentContainerView == null) return;

        FragmentActivity fragmentActivity = getFragmentActivity(context);
        if (fragmentActivity == null) return;

        fragmentContainerView.post(() -> {
            if (fragmentActivity.isFinishing() || fragmentActivity.isDestroyed()) return;

            try {
                fragmentActivity.getSupportFragmentManager()
                    .beginTransaction()
                    .remove(documentFragment)
                    .setReorderingAllowed(true)
                    .commitAllowingStateLoss();
            } catch (Exception e) {
                Log.e(LOG_TAG, "Error removing CPDFDocumentFragment", e);
            } finally {
                documentFragment = null;
            }
        });
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
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter: dispose()");
        fragmentContainerView = null;
        CPDFCustomEventCallbackHelper.getInstance().removeCustomEventCallback(methodChannel);
    }

    @Override
    public void onInputConnectionLocked() {
        PlatformView.super.onInputConnectionLocked();
    }

    @Override
    public void onInputConnectionUnlocked() {
        PlatformView.super.onInputConnectionUnlocked();
    }

    private FragmentActivity getFragmentActivity(Context context) {
        if (context instanceof FragmentActivity) {
            return (FragmentActivity) context;
        } else if (context instanceof MutableContextWrapper) {
            return getFragmentActivity(((MutableContextWrapper) context).getBaseContext());
        } else {
            return null;
        }
    }
}
