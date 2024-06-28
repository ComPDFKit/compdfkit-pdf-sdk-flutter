/**
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;



import android.content.Context;
import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;


public abstract class BaseMethodChannelPlugin implements MethodChannel.MethodCallHandler {

    public static final String LOG_TAG = "ComPDFKit-Plugin";

    protected MethodChannel methodChannel = null;

    protected Context context;

    protected BinaryMessenger binaryMessenger;

    public BaseMethodChannelPlugin(Context context, BinaryMessenger binaryMessenger) {
        this.context = context;
        this.binaryMessenger = binaryMessenger;
    }

    public abstract String methodName();

    public void register(){
        Log.e(LOG_TAG, "create MethodChannel:" + methodName());
        methodChannel = new MethodChannel(binaryMessenger, methodName());
        methodChannel.setMethodCallHandler(this);
    }

}
