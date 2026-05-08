/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.compdfkit.tools.common.utils.CFileUtils;
import io.flutter.plugin.common.MethodChannel;

public final class SdkActivityDelegate {

    private final Context context;

    private Activity activity;
    private MethodChannel.Result pendingResult;

    public SdkActivityDelegate(@NonNull Context context) {
        this.context = context.getApplicationContext();
    }

    public void attachActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    public void detachActivity() {
        activity = null;
        clearPendingResult();
    }

    public boolean pickFile(@NonNull MethodChannel.Result result, int requestCode) {
        clearPendingResult();
        pendingResult = result;
        if (activity == null) {
            clearPendingResult();
            return false;
        }
        activity.startActivityForResult(CFileUtils.getContentIntent(), requestCode);
        return true;
    }

    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data,
            int expectedRequestCode) {
        if (requestCode != expectedRequestCode) {
            return false;
        }
        if (resultCode == Activity.RESULT_OK && data != null && data.getData() != null) {
            Uri uri = data.getData();
            CFileUtils.takeUriPermission(context, uri);
            successResult(uri.toString());
            return true;
        }
        successResult(null);
        return true;
    }

    private void successResult(@Nullable String uri) {
        if (pendingResult != null) {
            pendingResult.success(uri);
        }
        clearPendingResult();
    }

    private void clearPendingResult() {
        pendingResult = null;
    }
}
