/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter;

import androidx.annotation.NonNull;
import com.compdfkit.flutter.compdfkit_flutter.platformview.CPDFPlatformViewFactory;
import com.compdfkit.flutter.compdfkit_flutter.plugin.ComPDFKitSDKPlugin;
import com.compdfkit.tools.common.utils.glide.CPDFGlideInitializer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class CompdfkitFlutterPlugin implements FlutterPlugin, ActivityAware {

    private static final String PDF_DOCUMENT_VIEW_TYPE_ID = "com.compdfkit.flutter.ui.pdfviewer";

    private BinaryMessenger mMessenger;

    private ActivityPluginBinding activityPluginBinding;

    private ComPDFKitSDKPlugin comPDFKitSDKPlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mMessenger = flutterPluginBinding.getBinaryMessenger();
        CPDFGlideInitializer.register(flutterPluginBinding.getApplicationContext());
        comPDFKitSDKPlugin = new ComPDFKitSDKPlugin(flutterPluginBinding.getApplicationContext(),
                mMessenger);
        comPDFKitSDKPlugin.register();
        PlatformViewRegistry registry = flutterPluginBinding.getPlatformViewRegistry();
        registry.registerViewFactory(PDF_DOCUMENT_VIEW_TYPE_ID,
            new CPDFPlatformViewFactory(mMessenger));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        detachActivityBinding();
        if (comPDFKitSDKPlugin != null) {
            comPDFKitSDKPlugin.unregister();
            comPDFKitSDKPlugin = null;
        }
        mMessenger = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activityPluginBinding = binding;
        if (comPDFKitSDKPlugin != null) {
            comPDFKitSDKPlugin.attachActivity(binding.getActivity());
            binding.addActivityResultListener(comPDFKitSDKPlugin);
        }
    }

    private void detachActivityBinding() {
        if (activityPluginBinding != null && comPDFKitSDKPlugin != null) {
            activityPluginBinding.removeActivityResultListener(comPDFKitSDKPlugin);
            comPDFKitSDKPlugin.detachActivity();
        }
        activityPluginBinding = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        detachActivityBinding();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        detachActivityBinding();
    }
}
