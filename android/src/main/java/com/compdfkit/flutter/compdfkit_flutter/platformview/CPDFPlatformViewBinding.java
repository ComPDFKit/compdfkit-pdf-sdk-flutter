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
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.tools.common.pdf.config.CPDFConfiguration;
import java.util.Map;

final class CPDFPlatformViewBinding {

    private static final String FRAGMENT_TAG = "documentFragment";

    private final Context context;
    private final FragmentContainerView fragmentContainerView;

    private CPDFDocumentFragment documentFragment;

    private CPDFPlatformViewBinding(@NonNull Context context,
            @NonNull FragmentContainerView fragmentContainerView,
            @NonNull CPDFDocumentFragment documentFragment) {
        this.context = context;
        this.fragmentContainerView = fragmentContainerView;
        this.documentFragment = documentFragment;
    }

    static CPDFPlatformViewBinding create(@NonNull Context context,
            @NonNull Map<String, Object> creationParams) {
        FragmentContainerView containerView = new FragmentContainerView(context);
        containerView.setId(View.generateViewId());
        CPDFDocumentFragment documentFragment = CPDFDocumentFragment.newInstance(
                createFragmentArguments(creationParams));
        CPDFPlatformViewBinding binding = new CPDFPlatformViewBinding(context, containerView,
                documentFragment);
        binding.bindAttachListener();
        return binding;
    }

    @NonNull
    FragmentContainerView getContainerView() {
        return fragmentContainerView;
    }

    @Nullable
    CPDFDocumentFragment getDocumentFragment() {
        return documentFragment;
    }

    void dispose() {
        detachFragment();
    }

    private void bindAttachListener() {
        fragmentContainerView.addOnAttachStateChangeListener(new View.OnAttachStateChangeListener() {
            @Override
            public void onViewAttachedToWindow(@NonNull View view) {
                attachFragment();
            }

            @Override
            public void onViewDetachedFromWindow(@NonNull View view) {
                detachFragment();
            }
        });
    }

    private void attachFragment() {
        Log.e(CPDFPlatformView.LOG_TAG,
                "CPDFPlatformViewBinding: attached CPDFDocumentFragment to window");
        if (documentFragment == null) {
            return;
        }
        FragmentActivity fragmentActivity = getFragmentActivity(context);
        if (fragmentActivity == null) {
            throw new RuntimeException("Please use FlutterFragmentActivity to host MainActivity");
        }
        if (fragmentActivity.isFinishing() || fragmentActivity.isDestroyed()) {
            return;
        }
        fragmentActivity.getSupportFragmentManager()
                .beginTransaction()
                .add(fragmentContainerView.getId(), documentFragment, FRAGMENT_TAG)
                .setReorderingAllowed(true)
                .commitAllowingStateLoss();
    }

    private void detachFragment() {
        Log.e(CPDFPlatformView.LOG_TAG,
                "CPDFPlatformViewBinding: detached CPDFDocumentFragment from window");
        if (documentFragment == null) {
            return;
        }
        FragmentActivity fragmentActivity = getFragmentActivity(context);
        if (fragmentActivity == null || fragmentContainerView == null) {
            return;
        }
        fragmentContainerView.post(() -> {
            if (fragmentActivity.isFinishing() || fragmentActivity.isDestroyed()) {
                return;
            }
            try {
                fragmentActivity.getSupportFragmentManager()
                        .beginTransaction()
                        .remove(documentFragment)
                        .setReorderingAllowed(true)
                        .commitAllowingStateLoss();
            } catch (Exception e) {
                Log.e(CPDFPlatformView.LOG_TAG, "Error removing CPDFDocumentFragment", e);
            } finally {
                documentFragment = null;
            }
        });
    }

    private static Bundle createFragmentArguments(@NonNull Map<String, Object> creationParams) {
        String filePath = (String) creationParams.get("document");
        String password = (String) creationParams.get("password");
        String configurationJson = (String) creationParams.get("configuration");
        int pageIndex = (int) creationParams.get("pageIndex");

        CPDFConfiguration configuration = CPDFConfigurationUtils.fromJson(configurationJson);
        Bundle args = new Bundle();
        args.putString(CPDFDocumentFragment.EXTRA_FILE_PASSWORD, password);
        args.putSerializable(CPDFDocumentFragment.EXTRA_CONFIGURATION, configuration);
        args.putInt(CPDFDocumentFragment.EXTRA_PAGE_INDEX, pageIndex);
        if (filePath.startsWith(FileUtils.CONTENT_SCHEME)
                || filePath.startsWith(FileUtils.FILE_SCHEME)) {
            args.putParcelable(CPDFDocumentFragment.EXTRA_FILE_URI, Uri.parse(filePath));
        } else {
            args.putString(CPDFDocumentFragment.EXTRA_FILE_PATH, filePath);
        }
        return args;
    }

    @Nullable
    private static FragmentActivity getFragmentActivity(Context context) {
        if (context instanceof FragmentActivity) {
            return (FragmentActivity) context;
        }
        if (context instanceof MutableContextWrapper) {
            return getFragmentActivity(((MutableContextWrapper) context).getBaseContext());
        }
        return null;
    }
}
