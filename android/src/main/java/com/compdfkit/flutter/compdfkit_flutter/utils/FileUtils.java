/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import com.compdfkit.tools.common.pdf.CPDFDocumentActivity;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.CUriUtil;
import java.io.File;


public class FileUtils {

  public static final String ASSETS_SCHEME = "file:///android_asset";

  public static final String CONTENT_SCHEME = "content://";
  public static final String FILE_SCHEME = "file://";

  public static void parseDocument(Context context, String document, Intent intent) {
    if (document.startsWith(ASSETS_SCHEME)) {
      String assetsPath = document.replace(ASSETS_SCHEME + "/","");
      String[] strs = document.split("/");
      String fileName = strs[strs.length -1];
      String samplePDFPath = CFileUtils.getAssetsTempFile(context, assetsPath, fileName);
      intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PATH, samplePDFPath);
    } else if (document.startsWith(CONTENT_SCHEME)) {
      Uri uri = Uri.parse(document);
      intent.setData(uri);
    } else if (document.startsWith(FILE_SCHEME)) {
      Uri uri = Uri.parse(document);
      intent.setData(uri);
    } else {
      intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PATH, document);
    }
  }

  public static String getImportAnnotationsPath(Context context, String xfdf) {
    if (xfdf.startsWith(ASSETS_SCHEME)) {
      String assetsPath = xfdf.replace(ASSETS_SCHEME + "/","");
      String[] strs = xfdf.split("/");
      String fileName = strs[strs.length -1];
      return CFileUtils.getAssetsTempFile(context, assetsPath, fileName);
    } else if (xfdf.startsWith(CONTENT_SCHEME)) {
      Uri uri = Uri.parse(xfdf);
      String fileName = CUriUtil.getUriFileName(context, uri);
      String dir = new File(context.getCacheDir(), CFileUtils.CACHE_FOLDER + File.separator + "xfdfFile").getAbsolutePath();
      // Get the saved file path
      return CFileUtils.copyFileToInternalDirectory(context, uri, dir, fileName);
    } else if (xfdf.startsWith(FILE_SCHEME)) {
      return xfdf;
    } else {
      return xfdf;
    }
  }
}
