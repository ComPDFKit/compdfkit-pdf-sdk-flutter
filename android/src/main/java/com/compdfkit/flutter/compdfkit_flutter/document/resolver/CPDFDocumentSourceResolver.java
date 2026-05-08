/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.document.resolver;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.annotation.NonNull;
import com.compdfkit.tools.common.pdf.CPDFDocumentActivity;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.CUriUtil;
import java.io.File;

public final class CPDFDocumentSourceResolver {

    public static final String ASSETS_SCHEME = "file:///android_asset";
    public static final String CONTENT_SCHEME = "content://";
    public static final String FILE_SCHEME = "file://";

    private CPDFDocumentSourceResolver() {
    }

    public static void applyDocumentToIntent(@NonNull Context context, @NonNull String document,
            @NonNull Intent intent) {
        if (isAssetsSource(document)) {
            intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PATH,
                    resolveAssetSource(context, document));
            return;
        }
        if (isUriSource(document)) {
            intent.setData(Uri.parse(document));
            return;
        }
        intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PATH, document);
    }

    public static String resolveImportFilePath(@NonNull Context context, @NonNull String source) {
        if (isAssetsSource(source)) {
            return resolveAssetSource(context, source);
        }
        if (isContentSource(source)) {
            Uri uri = Uri.parse(source);
            String fileName = CUriUtil.getUriFileName(context, uri);
            String dir = new File(context.getCacheDir(),
                    CFileUtils.CACHE_FOLDER + File.separator + "xfdfFile").getAbsolutePath();
            return CFileUtils.copyFileToInternalDirectory(context, uri, dir, fileName);
        }
        if (isFileSource(source)) {
            Uri uri = Uri.parse(source);
            return uri.getPath() == null ? source : uri.getPath();
        }
        return source;
    }

    public static boolean isContentSource(String source) {
        return source != null && source.startsWith(CONTENT_SCHEME);
    }

    public static boolean isFileSource(String source) {
        return source != null && source.startsWith(FILE_SCHEME);
    }

    public static boolean isUriSource(String source) {
        return isContentSource(source) || isFileSource(source);
    }

    public static Uri parseUri(String source) {
        return Uri.parse(source);
    }

    private static boolean isAssetsSource(String source) {
        return source != null && source.startsWith(ASSETS_SCHEME);
    }

    private static String resolveAssetSource(@NonNull Context context, @NonNull String source) {
        String assetsPath = source.replace(ASSETS_SCHEME + "/", "");
        String[] parts = source.split("/");
        String fileName = parts[parts.length - 1];
        return CFileUtils.getAssetsTempFile(context, assetsPath, fileName);
    }
}