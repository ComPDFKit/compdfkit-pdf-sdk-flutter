/**
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_TEMP_DIRECTORY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INIT_SDK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INIT_SDK_KEYS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.OPEN_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PICK_FILE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_SIGN_FILE_LIST;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SDK_BUILD_TAG;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SDK_VERSION_CODE;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import androidx.annotation.Nullable;
import com.compdfkit.core.document.CPDFSdk;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentActivity;
import com.compdfkit.tools.common.pdf.config.CPDFConfiguration;
import com.compdfkit.tools.common.utils.CFileUtils;

import io.flutter.plugin.common.PluginRegistry;
import java.io.File;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class ComPDFKitSDKPlugin extends BaseMethodChannelPlugin implements PluginRegistry.ActivityResultListener {
    private static final int REQUEST_CODE = (ComPDFKitSDKPlugin.class.hashCode() + 43) & 0x0000ffff;

    private Activity activity;

    private MethodChannel.Result pendingResult;

    public ComPDFKitSDKPlugin(Activity activity, BinaryMessenger binaryMessenger) {
        super(activity, binaryMessenger);
        this.activity = activity;
    }

    @Override
    public String methodName() {
        return "com.compdfkit.flutter.plugin";
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case INIT_SDK:
                String key = call.argument("key");
                CPDFSdk.init(context, key, true, (code, msg) -> {
                    Log.e("ComPDFKit-Plugin", "INIT_SDK: code:" + code + ", msg:" + msg);
                });
                break;
            case INIT_SDK_KEYS:
                String androidLicenseKey = call.argument("androidOnlineLicense");
                CPDFSdk.init(context, androidLicenseKey, false, (code, msg) -> {
                    Log.e("ComPDFKit-Plugin", "INIT_SDK_KEYS: code:" + code + ", msg:" + msg);
                });
                break;
            case SDK_VERSION_CODE:
                result.success(CPDFSdk.getSDKVersion());
                break;
            case SDK_BUILD_TAG:
                result.success(CPDFSdk.getSDKBuildTag());
                break;
            case OPEN_DOCUMENT:
                String filePath = call.argument("document");
                String password = call.argument("password");
                String configurationJson = call.argument("configuration");
                CPDFConfiguration configuration = CPDFConfigurationUtils.fromJson(configurationJson);
                Intent intent = new Intent(context, CPDFDocumentActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                FileUtils.parseDocument(context, filePath, intent);
                intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PASSWORD, password);
                intent.putExtra(CPDFDocumentActivity.EXTRA_CONFIGURATION, configuration);
                context.startActivity(intent);
                break;
            case GET_TEMP_DIRECTORY:
                result.success(context.getCacheDir().getPath());
                break;
            case REMOVE_SIGN_FILE_LIST:
                File dirFile = new File(context.getFilesDir(), CFileUtils.SIGNATURE_FOLDER);
                boolean deleteResult = CFileUtils.deleteDirectory(dirFile.getAbsolutePath());
                result.success(deleteResult);
                break;
            case PICK_FILE:
                pendingResult = result;
                if (activity != null) {
                    activity.startActivityForResult(CFileUtils.getContentIntent(), REQUEST_CODE);
                }
                break;
            default:
                break;
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK){
            if(data != null && data.getData() != null){
                Uri uri = data.getData();
                successResult(uri.toString());
            }
            return true;
        } else if (requestCode == REQUEST_CODE && resultCode != Activity.RESULT_OK){
            successResult(null);
        }

        return false;
    }

    private void successResult(String uri){
        if(pendingResult != null){
            pendingResult.success(uri);
        }
        clearPendingResult();
    }

    private void clearPendingResult() {
        pendingResult = null;
    }
}
