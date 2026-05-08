/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_DOCUMENT_PLUGIN;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_URI;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FONTS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_TEMP_DIRECTORY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INIT_SDK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INIT_SDK_KEYS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INIT_SDK_WITH_PATH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.OPEN_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PICK_FILE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_SIGN_FILE_LIST;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SDK_BUILD_TAG;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SDK_VERSION_CODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_IMPORT_FONT_DIRECTORY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_IMPORT_FONT_DIRECTORY;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.flutter.compdfkit_flutter.bridge.BaseMethodChannelPlugin;
import com.compdfkit.flutter.compdfkit_flutter.bridge.ChannelResult;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkActivityDelegate;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkCoreOps;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkDocumentOps;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkFontOps;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkPluginRegistry;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class ComPDFKitSDKPlugin extends BaseMethodChannelPlugin implements PluginRegistry.ActivityResultListener {
    private static final int REQUEST_CODE = (ComPDFKitSDKPlugin.class.hashCode() + 43) & 0x0000ffff;

    private final SdkActivityDelegate activityDelegate;

    public ComPDFKitSDKPlugin(Context context, BinaryMessenger binaryMessenger) {
        super(context, binaryMessenger);
        this.activityDelegate = new SdkActivityDelegate(context);
    }

    public void attachActivity(@Nullable Activity activity) {
        activityDelegate.attachActivity(activity);
    }

    public void detachActivity() {
        activityDelegate.detachActivity();
    }

    @Override
    public void unregister() {
        detachActivity();
        SdkPluginRegistry.unregisterAll();
        super.unregister();
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
                SdkCoreOps.initSdk(context, key, result);
                break;
            case INIT_SDK_KEYS:
                String androidLicenseKey = call.argument("androidOnlineLicense");
                SdkCoreOps.initSdkKeys(context, androidLicenseKey, result);
                break;
            case INIT_SDK_WITH_PATH:
                String xmlPath = call.arguments();
                SdkCoreOps.initSdkWithPath(context, xmlPath, result);
                break;
            case SDK_VERSION_CODE:
                result.success(com.compdfkit.core.document.CPDFSdk.getSDKVersion());
                break;
            case SDK_BUILD_TAG:
                result.success(com.compdfkit.core.document.CPDFSdk.getSDKBuildTag());
                break;
            case OPEN_DOCUMENT:
                String filePath = call.argument("document");
                String password = call.argument("password");
                String configurationJson = call.argument("configuration");
                SdkDocumentOps.openDocument(context, filePath, password, configurationJson);
                result.success(null);
                break;
            case GET_TEMP_DIRECTORY:
                result.success(SdkCoreOps.getTempDirectory(context));
                break;
            case REMOVE_SIGN_FILE_LIST:
                result.success(SdkDocumentOps.removeSignFileList(context));
                break;
            case PICK_FILE:
                if (!activityDelegate.pickFile(result, REQUEST_CODE)) {
                    ChannelResult.error(result, "PICK_FILE_FAIL", "Activity is null", "");
                }
                break;
            case CREATE_URI:
                String fileName = call.argument("file_name");
                String mimeType = call.argument("mime_type");
                String childDirectoryName = call.argument("child_directory_name");
                SdkCoreOps.createUri(context, fileName, mimeType, childDirectoryName, result);
                break;
            case SET_IMPORT_FONT_DIRECTORY:
                String importFontDir = call.argument("dir_path");
                boolean addSysFont = call.argument("add_sys_font");
                SdkFontOps.setImportFontDirectory(importFontDir, addSysFont);
                result.success(true);
                break;
            case UPDATE_IMPORT_FONT_DIRECTORY:
                String updateFontDir = call.argument("dir_path");
                boolean addSysFont1 = call.argument("add_sys_font");
                SdkFontOps.updateImportFontDirectory(updateFontDir, addSysFont1, result);
                break;
            case CREATE_DOCUMENT_PLUGIN: {
                String id = call.arguments();
                SdkDocumentOps.createDocumentPlugin(context, binaryMessenger, id);
                result.success(true);
                break;
            }
            case CREATE_DOCUMENT: {
                String id = call.arguments();
                SdkDocumentOps.createDocument(context, binaryMessenger, id);
                result.success(true);
                break;
            }
            case GET_FONTS:
                SdkFontOps.getFonts(result);
                break;
            default:
                break;
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        return activityDelegate.onActivityResult(requestCode, resultCode, data, REQUEST_CODE);
    }
}
