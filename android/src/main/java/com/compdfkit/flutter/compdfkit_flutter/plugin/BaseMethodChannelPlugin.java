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

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;


public abstract class BaseMethodChannelPlugin implements MethodChannel.MethodCallHandler {

    protected MethodChannel methodChannel = null;

    protected Context context;

    public BaseMethodChannelPlugin(Context context, BinaryMessenger binaryMessenger) {
        this.context = context;
        methodChannel = new MethodChannel(binaryMessenger, methodName());
        methodChannel.setMethodCallHandler(this);
    }

    public abstract String methodName();

}
