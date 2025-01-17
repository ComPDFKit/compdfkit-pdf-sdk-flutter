/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
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
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_WATERMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ENCRYPT_ALGORITHM;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_COUNT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PRINT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FILE_NAME;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PERMISSIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HAS_CHANGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_ENCRYPTED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_IMAGE_DOC;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.OPEN_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_WATERMARKS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_AS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils.CONTENT_SCHEME;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import com.bumptech.glide.request.target.Target;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentEncryptAlgo;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentSaveType;
import com.compdfkit.core.document.CPDFDocumentPermissionInfo;
import com.compdfkit.core.watermark.CPDFWatermark;
import com.compdfkit.core.watermark.CPDFWatermark.Horizalign;
import com.compdfkit.core.watermark.CPDFWatermark.Type;
import com.compdfkit.core.watermark.CPDFWatermark.Vertalign;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.glide.GlideApp;
import com.compdfkit.tools.common.utils.image.CBitmapUtil;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.utils.threadpools.SimpleBackgroundTask;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.reader.CPDFReaderView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;
import java.util.Objects;
import java.util.concurrent.ExecutionException;

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
        if (filePath.startsWith(CONTENT_SCHEME) || filePath.startsWith(
            FileUtils.FILE_SCHEME)) {
          pdfView.openPDF(Uri.parse(filePath), openPwd, () -> {
            result.success(true);
          });
        } else {
          pdfView.openPDF(filePath, openPwd, () -> {
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
        break;
      case CLOSE:
        document.close();
        result.success(true);
        break;
      case HAS_CHANGE:
        result.success(document.hasChanges());
        break;
      case IMPORT_ANNOTATIONS:
        try {
          String xfdfFilePath = FileUtils.getImportAnnotationsPath(context,
              (String) call.arguments);
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
      case SAVE:
        pdfView.savePDF((s, uri) -> {
          Log.e(LOG_TAG, "CPDFViewCtrlPlugin:onMethodCall:save-success");
          result.success(true);
        }, e -> {
          Log.e(LOG_TAG, "CPDFViewCtrlPlugin:onMethodCall:save-fail");
          result.success(false);
        });
        break;
      case SAVE_AS:
        String savePath = call.argument("save_path");
        boolean removeSecurity = call.argument("remove_security");
        boolean fontSubSet = call.argument("font_sub_set");
        CThreadPoolUtils.getInstance().executeIO(() -> {
          try {
            boolean saveResult;
            if (savePath.startsWith(CONTENT_SCHEME)) {
              saveResult = document.saveAs(Uri.parse(savePath), removeSecurity, fontSubSet);
            } else {
              saveResult = document.saveAs(savePath, removeSecurity, false, fontSubSet);
            }
            if (document.shouleReloadDocument()) {
              document.reload();
            }
            result.success(saveResult);
          } catch (CPDFDocumentException e) {
            e.printStackTrace();
            result.error("SAVE_FAIL",
                "The current saved directory is: " + savePath
                    + ", please make sure you have write permission to this directory", "");
          }
        });
        break;
      case PRINT:
        String path = readerView.getPDFDocument().getAbsolutePath();
        Uri uri = readerView.getPDFDocument().getUri();
        CFileUtils.startPrint(context, path, uri);
        break;
      case REMOVE_PASSWORD:
        CThreadPoolUtils.getInstance().executeIO(() -> {
          try {
            boolean saveResult = document.save(PDFDocumentSaveType.PDFDocumentSaveRemoveSecurity,
                true);
            result.success(saveResult);
            if (document.shouleReloadDocument()) {
              document.reload();
            }
          } catch (Exception e) {
            result.error("SAVE_FAIL",
                "An exception occurs when remove document opening password and saving it.,"
                    + e.getMessage(), "");
          }
        });
        break;
      case SET_PASSWORD:
        CThreadPoolUtils.getInstance().executeIO(() -> {
          try {
            String userPassword = call.argument("user_password");
            String ownerPassword = call.argument("owner_password");
            boolean allowsPrinting = call.argument("allows_printing");
            boolean allowsCopying = call.argument("allows_copying");
            String encryptAlgo = call.argument("encrypt_algo");

            if (!TextUtils.isEmpty(userPassword)) {
              document.setUserPassword(userPassword);
            }
            if (!TextUtils.isEmpty(ownerPassword)) {
              document.setOwnerPassword(ownerPassword);
              CPDFDocumentPermissionInfo permissionInfo = document.getPermissionsInfo();
              permissionInfo.setAllowsPrinting(allowsPrinting);
              permissionInfo.setAllowsCopying(allowsCopying);
              document.setPermissionsInfo(permissionInfo);
            }

            switch (encryptAlgo) {
              case "rc4":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentRC4);
                break;
              case "aes128":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentAES128);
                break;
              case "aes256":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentAES256);
                break;
              case "noEncryptAlgo":
                document.setEncryptAlgorithm(PDFDocumentEncryptAlgo.PDFDocumentNoEncryptAlgo);
                break;
              default:
                break;
            }

            boolean saveResult = document.save(
                CPDFDocument.PDFDocumentSaveType.PDFDocumentSaveIncremental, true);

            if (document.shouleReloadDocument()) {
              if (!TextUtils.isEmpty(userPassword)) {
                document.reload(userPassword);
              } else if (!TextUtils.isEmpty(ownerPassword)) {
                document.reload(ownerPassword);
              } else {
                document.reload();
              }
            }
            result.success(saveResult);
          } catch (Exception e) {
            result.error("SAVE_FAIL",
                "An exception occurs when setting a document opening password and saving it.,"
                    + e.getMessage(), "");
          }
        });
        break;
      case GET_ENCRYPT_ALGORITHM:
        switch (document.getEncryptAlgorithm()) {
          case PDFDocumentRC4:
            result.success("rc4");
            break;
          case PDFDocumentAES128:
            result.success("aes128");
            break;
          case PDFDocumentAES256:
            result.success("aes256");
            break;
          case PDFDocumentNoEncryptAlgo:
            result.success("noEncryptAlgo");
            break;
        }
        break;
      case CREATE_WATERMARK:
        Object object = call.arguments;
        Log.e("ComPDFKit-Flutter", "watermark:" + object.toString());
        createWatermark(call, result, pdfView, document);
        break;
      case REMOVE_ALL_WATERMARKS:
        for (int watermarkCount = document.getWatermarkCount(); watermarkCount > 0;
            watermarkCount--) {
          document.getWatermark(watermarkCount - 1).clear();
        }
        pdfView.getCPdfReaderView().reloadPages();
        break;
      default:
        break;
    }
  }

  private void createWatermark(MethodCall call, Result result, CPDFViewCtrl pdfView,
      CPDFDocument document) {

    String type = call.argument("type");
    String textContent = call.argument("text_content");
    String imagePath = call.argument("image_path");
    String textColor = call.argument("text_color");
    int fontSize = call.argument("font_size");
    double scaleDouble = call.argument("scale");
    float scale = (float) scaleDouble;
    double rotationDouble = call.argument("rotation");
    float rotation = (float) rotationDouble;
    double opacityDouble = call.argument("opacity");
    float opacity = (float) opacityDouble;
    String verticalAlignment = call.argument("vertical_alignment");
    String horizontalAlignment = call.argument("horizontal_alignment");
    double verticalOffsetDouble = call.argument("vertical_offset");
    float verticalOffset = (float) verticalOffsetDouble;
    double horizontalOffsetDouble = call.argument("horizontal_offset");
    float horizontalOffset = (float) horizontalOffsetDouble;
    String pages = call.argument("pages");
    boolean isFront = call.argument("is_front");
    boolean isTilePage = call.argument("is_tile_page");
    double horizontalSpacingDouble = call.argument("horizontal_spacing");
    float horizontalSpacing = (float) horizontalSpacingDouble;
    double verticalSpacingDouble = call.argument("vertical_spacing");
    float verticalSpacing = (float) verticalSpacingDouble;

    if (TextUtils.isEmpty(pages)) {
      result.error("WATERMARK_FAIL",
          "The page range cannot be empty, please set the page range, for example: pages: \"0,1,2,3\"",
          "");
      return;
    }
    if ("image".equals(type) && TextUtils.isEmpty(imagePath)) {
      Log.e("ComPDFKit-Flutter", "image path:" + imagePath);
      result.error("WATERMARK_FAIL", "image path is empty.", "");
      return;
    }
      new SimpleBackgroundTask<Bitmap>(pdfView.getContext()){

        @Override
        public Bitmap onRun() {
          if ("text".equals(type)) {
            return null;
          }else {
            try {
              Bitmap bitmap = GlideApp.with(context).asBitmap().load(imagePath).submit(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL).get();
              return bitmap;
            }catch (Exception e){
              return null;
            }
          }
        }

        @Override
        public void onSuccess(Bitmap bitmap) {

          CPDFWatermark watermark;
          if ("text".equals(type)) {
            watermark = document.createWatermark(Type.WATERMARK_TYPE_TEXT);
            watermark.setText(textContent);
            watermark.setFontName("Helvetica");
            watermark.setTextRGBColor(Color.parseColor(textColor));
            watermark.setFontSize(fontSize);
          } else {
            if (bitmap == null) {
              result.error("WATERMARK_FAIL", "image path is invalid. bitmap == null", "");
              return;
            }
            watermark = document.createWatermark(Type.WATERMARK_TYPE_IMG);
            watermark.setImage(bitmap, bitmap.getWidth(), bitmap.getHeight());
          }

          watermark.setOpacity(opacity);
          watermark.setFront(isFront);

          switch (verticalAlignment) {
            case "top":
              watermark.setVertalign(Vertalign.WATERMARK_VERTALIGN_TOP);
              break;
            case "center":
              watermark.setVertalign(Vertalign.WATERMARK_VERTALIGN_CENTER);
              break;
            case "bottom":
              watermark.setVertalign(Vertalign.WATERMARK_VERTALIGN_BOTTOM);
              break;
          }

          switch (horizontalAlignment) {
            case "left":
              watermark.setHorizalign(Horizalign.WATERMARK_HORIZALIGN_LEFT);
              break;
            case "center":
              watermark.setHorizalign(Horizalign.WATERMARK_HORIZALIGN_CENTER);
              break;
            case "right":
              watermark.setHorizalign(Horizalign.WATERMARK_HORIZALIGN_RIGHT);
              break;
          }
          float a = (float) -(rotation * Math.PI / 180);
          watermark.setRotation(a);
          watermark.setVertOffset(
              verticalOffset);// Translation offset relative to the vertical position. Positive values move downward, while negative values move upward.
          watermark.setHorizOffset(
              horizontalOffset);// Translation offset relative to the horizontal position. Positive values move to the right, while negative values move to the left.
          watermark.setScale(
              scale);// Scaling factor for the watermark, with a default value of 1. If it is an image watermark, 1 represents the original size of the image. If it is a text watermark, 1 represents the `textFont` font size.
          watermark.setPages(pages);// Set the watermark for pages 3, 4, and 5.
          watermark.setFullScreen(
              isTilePage);// Enable watermark tiling (not applicable for image watermarks).
          watermark.setHorizontalSpacing(
              horizontalSpacing);// Set the horizontal spacing for tiled watermarks.
          watermark.setVerticalSpacing(
              verticalSpacing);// Set the vertical spacing for tiled watermarks.
          watermark.update();
          watermark.release();
          pdfView.getCPdfReaderView().reloadPages();
          result.success(true);
        }
      }.execute();
  }
}
