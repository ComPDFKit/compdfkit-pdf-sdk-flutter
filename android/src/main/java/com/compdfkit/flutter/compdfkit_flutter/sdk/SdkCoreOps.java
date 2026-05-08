/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.sdk;

import android.content.Context;
import android.net.Uri;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFSdk;
import com.compdfkit.flutter.compdfkit_flutter.bridge.ChannelResult;
import com.compdfkit.tools.common.utils.CUriUtil;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;

public final class SdkCoreOps {

    private SdkCoreOps() {
    }

    public static void initSdk(@NonNull Context context, String key,
            @NonNull MethodChannel.Result result) {
        CPDFSdk.init(context, key, true, (code, msg) -> {
            Log.e("ComPDFKit-Plugin", "INIT_SDK: code:" + code + ", msg:" + msg);
            ChannelResult.success(result, code == CPDFSdk.VERIFY_SUCCESS);
        });
    }

    public static void initSdkKeys(@NonNull Context context, String licenseKey,
            @NonNull MethodChannel.Result result) {
        CPDFSdk.init(context, licenseKey, false, (code, msg) -> {
            Log.e("ComPDFKit-Plugin", "INIT_SDK_KEYS: code:" + code + ", msg:" + msg);
            ChannelResult.success(result, code == CPDFSdk.VERIFY_SUCCESS);
        });
    }

    public static void initSdkWithPath(@NonNull Context context, String xmlPath,
            @NonNull MethodChannel.Result result) {
        CPDFSdk.initWithPath(context, xmlPath, (verifyCode, verifyMsg) -> {
            Log.e("ComPDFKit-Plugin", "INIT_SDK: code:" + verifyCode + ", msg:" + verifyMsg);
            ChannelResult.success(result, verifyCode == CPDFSdk.VERIFY_SUCCESS);
        });
    }

    public static String getTempDirectory(@NonNull Context context) {
        return context.getCacheDir().getAbsolutePath();
    }

    public static void createUri(@NonNull Context context, String fileName, String mimeType,
            String childDirectoryName, @NonNull MethodChannel.Result result) {
        String directory = Environment.DIRECTORY_DOWNLOADS;
        if (!TextUtils.isEmpty(childDirectoryName)) {
            directory += File.separator + childDirectoryName;
        }
        Uri uri = CUriUtil.createFileUri(context, directory, fileName, mimeType);
        if (uri != null) {
            ChannelResult.success(result, uri.toString());
            return;
        }
        ChannelResult.error(result, "CREATE_URI_FAIL", "create uri fail", "");
    }
}
