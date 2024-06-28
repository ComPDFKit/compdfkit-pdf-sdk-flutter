/**
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
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

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;


public class CompdfkitFlutterPlugin implements FlutterPlugin, ActivityAware {

    private BinaryMessenger mMessenger;

    private PlatformViewRegistry mRegistry;

    private static final String PDF_DOCUMENT_VIEW_TYPE_ID = "com.compdfkit.flutter.ui.pdfviewer";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mMessenger = flutterPluginBinding.getBinaryMessenger();
        mRegistry = flutterPluginBinding.getPlatformViewRegistry();
        new ComPDFKitSDKPlugin(flutterPluginBinding.getApplicationContext(), mMessenger)
                .register();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (mRegistry != null) {
            mRegistry.registerViewFactory(PDF_DOCUMENT_VIEW_TYPE_ID,new CPDFViewCtrlFactory(mMessenger));
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {

    }
}
