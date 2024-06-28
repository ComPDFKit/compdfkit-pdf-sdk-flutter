/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class CPDFViewCtrlPlugin extends BaseMethodChannelPlugin{

    private int viewId;

    private CPDFDocumentFragment documentFragment;

    public CPDFViewCtrlPlugin(Context context, BinaryMessenger binaryMessenger, int viewId) {
        super(context, binaryMessenger);
        this.viewId = viewId;
    }

    public void setDocumentFragment(CPDFDocumentFragment documentFragment) {
        this.documentFragment = documentFragment;
    }

    @Override
    public String methodName() {
        return "com.compdfkit.flutter.ui.pdfviewer." + viewId;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:" + call.method);
        switch (call.method) {
            case "save":
                if (documentFragment != null) {
                    documentFragment.pdfView.savePDF((s, uri) -> {
                        Log.e(LOG_TAG, "CPDFViewCtrlPlugin:onMethodCall:save-success");
                        result.success(true);
                    },e-> {
                        Log.e(LOG_TAG, "CPDFViewCtrlPlugin:onMethodCall:save-fail");
                        result.success(false);
                    });
                }else {
                    Log.e(LOG_TAG, "CPDFViewCtrlPlugin:onMethodCall:save-fail");
                    result.success(false);
                }
                break;
            default:
                Log.e(LOG_TAG, "CPDFViewCtrlFlutter:onMethodCall:notImplemented");
                result.notImplemented();
                break;
        }
    }
}
