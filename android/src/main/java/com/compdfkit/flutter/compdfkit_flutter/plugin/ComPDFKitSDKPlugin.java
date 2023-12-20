/**
 * Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.compdfkit.core.document.CPDFSdk;
import com.compdfkit.flutter.compdfkit_flutter.pdf.CPDFConfiguration;
import com.compdfkit.flutter.compdfkit_flutter.pdf.CPDFConfigurationUtils;
import com.compdfkit.flutter.compdfkit_flutter.pdf.CPDFDocumentActivity;
import com.compdfkit.tools.common.utils.CToastUtil;

import org.json.JSONObject;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class ComPDFKitSDKPlugin extends BaseMethodChannelPlugin {

    public static final String INIT_SDK = "init_sdk";

    public static final String SDK_VERSION_CODE = "sdk_version_code";

    public static final String SDK_BUILD_TAG = "sdk_build_tag";

    public ComPDFKitSDKPlugin(Context context, BinaryMessenger binaryMessenger) {
        super(context, binaryMessenger);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case INIT_SDK:
                Map<String, Object> map = (Map<String, Object>) call.arguments;
                String key = (String) map.get("key");
                CPDFSdk.init(context, key);
                break;
            case SDK_VERSION_CODE:
                result.success(CPDFSdk.getSDKVersion());
                break;
            case SDK_BUILD_TAG:
                result.success(CPDFSdk.getSDKBuildTag());
                break;
            case "openDocument":
                Map<String, Object> arguments = (Map<String, Object>) call.arguments;
                String filePath = (String) arguments.get("document");
                String password = (String) arguments.get("password");
                CPDFConfiguration configuration = CPDFConfigurationUtils.fromJson((String) arguments.get("configuration"));
                Intent intent = new Intent(context, CPDFDocumentActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PATH, filePath);
                intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PASSWORD, password);
                intent.putExtra(CPDFDocumentActivity.EXTRA_CONFIGURATION, configuration);
                context.startActivity(intent);
                break;
            case "getTemporaryDirectory":
                result.success(context.getCacheDir().getPath());
                break;
            default:
                break;
        }
    }

    @Override
    public String methodName() {
        return "com.compdfkit.flutter.plugin";
    }
}
