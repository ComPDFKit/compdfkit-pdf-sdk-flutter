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


import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHECK_OWNER_UNLOCKED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHECK_OWNER_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CLOSE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_COUNT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FILE_NAME;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PERMISSIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HAS_CHANGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_ENCRYPTED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_IMAGE_DOC;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.OPEN_DOCUMENT;

import android.content.Context;
import android.net.Uri;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;

public class CPDFDocumentPlugin extends BaseMethodChannelPlugin {

  private String documentUid;

  private CPDFViewCtrl pdfView;

  public CPDFDocumentPlugin(Context context,
      BinaryMessenger binaryMessenger, String documentUid) {
    super(context, binaryMessenger);
    this.documentUid = documentUid;
  }

  public void setReaderView(CPDFViewCtrl pdfView) {
    this.pdfView = pdfView;
  }


  @Override
  public String methodName() {
    return "com.compdfkit.flutter.document_" + documentUid;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (pdfView == null || pdfView.getCPdfReaderView().getPDFDocument() == null) {
      result.error("-1", "CPDFReaderView isnull or CPDFDocument is null", null);
      return;
    }
    CPDFReaderView readerView = pdfView.getCPdfReaderView();
    CPDFDocument document = readerView.getPDFDocument();
    switch (call.method) {
      case OPEN_DOCUMENT:
        String filePath = call.argument("filePath");
        String openPwd = call.argument("password");
        PDFDocumentError error;
        if (filePath.startsWith(FileUtils.CONTENT_SCHEME) || filePath.startsWith(FileUtils.FILE_SCHEME)){
          pdfView.openPDF(Uri.parse(filePath), openPwd, ()->{
            result.success(true);
          });
        }else {
          pdfView.openPDF(filePath,openPwd, ()->{
            result.success(true);
          });
        }
        break;
      case GET_FILE_NAME:
        result.success(document.getFileName());
        break;
      case IS_ENCRYPTED:
        result.success(document.isEncrypted());
        break;
      case IS_IMAGE_DOC:
        CThreadPoolUtils.getInstance().executeIO(() -> {
          boolean isImageDoc = document.isImageDoc();
          result.success(isImageDoc);
        });
        break;
      case GET_PERMISSIONS:
        result.success(document.getPermissions().id);
        break;
      case CHECK_OWNER_UNLOCKED:
        result.success(document.checkOwnerUnlocked());
        break;
      case CHECK_OWNER_PASSWORD:
        String password = call.argument("password");
        result.success(document.checkOwnerPassword(password));
      case CLOSE:
        document.close();
        result.success(true);
        break;
      case HAS_CHANGE:
        result.success(document.hasChanges());
        break;
      case IMPORT_ANNOTATIONS:
        try {
          String xfdfFilePath = FileUtils.getImportAnnotationsPath(context,  (String) call.arguments);
          File file = new File(xfdfFilePath);
          if (!file.exists()) {
            result.success(false);
            return;
          }
          File cacheFile = new File(context.getCacheDir(),
              CFileUtils.CACHE_FOLDER + File.separator + "importAnnotCache/"
                  + CFileUtils.getFileNameNoExtension(document.getFileName()));
          cacheFile.mkdirs();
          boolean importResult = document.importAnnotations(xfdfFilePath,
              cacheFile.getAbsolutePath());
          readerView.reloadPages();
          result.success(importResult);
        } catch (Exception e) {
          e.printStackTrace();
          result.success(false);
        }
        break;
      case EXPORT_ANNOTATIONS:
        try {
          File dirFile = new File(context.getFilesDir(), "compdfkit/annotation/export/");
          dirFile.mkdirs();
          String fileName = CFileUtils.getFileNameNoExtension(document.getFileName());
          File cacheFile = new File(context.getCacheDir(),
              CFileUtils.CACHE_FOLDER + File.separator + "exportAnnotCache/" + fileName);
          cacheFile.mkdirs();
          File saveFile = new File(dirFile, fileName + ".xfdf");
          saveFile = CFileUtils.renameNameSuffix(saveFile);
          boolean exportResult = document.exportAnnotations(saveFile.getAbsolutePath(),
              cacheFile.getAbsolutePath());
          if (exportResult) {
            result.success(saveFile.getAbsolutePath());
          } else {
            result.success("");
          }
        } catch (Exception e) {
          e.printStackTrace();
          result.success("");
        }
        break;
      case REMOVE_ALL_ANNOTATIONS:
        boolean deleteResult = document.removeAllAnnotations();
        if (deleteResult) {
          readerView.invalidateAllChildren();
        }
        result.success(deleteResult);
        break;
      case GET_PAGE_COUNT:
        result.success(document.getPageCount());
        break;
      default:
        break;
    }
  }
}
