/**
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter;

import androidx.annotation.NonNull;

import com.compdfkit.flutter.compdfkit_flutter.plugin.ComPDFKitSDKPlugin;
import com.compdfkit.flutter.compdfkit_flutter.platformview.CPDFViewCtrlFactory;

import com.compdfkit.tools.common.utils.glide.CPDFGlideInitializer;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;


public class CompdfkitFlutterPlugin implements FlutterPlugin, ActivityAware {

    private BinaryMessenger mMessenger;

    private PlatformViewRegistry mRegistry;

    private static final String PDF_DOCUMENT_VIEW_TYPE_ID = "com.compdfkit.flutter.ui.pdfviewer";
    private FlutterPluginBinding pluginBinding;

    private ActivityPluginBinding activityPluginBinding;

    private ComPDFKitSDKPlugin comPDFKitSDKPlugin;
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.pluginBinding = flutterPluginBinding;
        mMessenger = flutterPluginBinding.getBinaryMessenger();
        mRegistry = flutterPluginBinding.getPlatformViewRegistry();

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activityPluginBinding = binding;
        setUp();
    }

    private void setUp(){
        CPDFGlideInitializer.register(activityPluginBinding.getActivity().getApplicationContext());
        comPDFKitSDKPlugin = new ComPDFKitSDKPlugin(activityPluginBinding.getActivity(), mMessenger);
        comPDFKitSDKPlugin.register();
        activityPluginBinding.addActivityResultListener(comPDFKitSDKPlugin);
        if (mRegistry != null) {
            mRegistry.registerViewFactory(PDF_DOCUMENT_VIEW_TYPE_ID,new CPDFViewCtrlFactory(mMessenger));
        }
    }

    private void clear(){
        this.activityPluginBinding.removeActivityResultListener(comPDFKitSDKPlugin);
        this.activityPluginBinding = null;
        this.comPDFKitSDKPlugin = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        clear();
    }
}
