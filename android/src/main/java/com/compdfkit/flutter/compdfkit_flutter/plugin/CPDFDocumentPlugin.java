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
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_SEARCH_TEXT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT_CLEAR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT_SELECTION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXPORT_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.FLATTEN_ALL_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DOCUMENT_PATH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ENCRYPT_ALGORITHM;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_COUNT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INSERT_BLANK_PAGE;
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
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ANNOTATION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_WIDGET;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_AS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SPLIT_DOCUMENT_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils.CONTENT_SCHEME;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentEncryptAlgo;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentSaveType;
import com.compdfkit.core.document.CPDFDocumentPermissionInfo;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFPage.PDFFlattenOption;
import com.compdfkit.core.watermark.CPDFWatermark;
import com.compdfkit.core.watermark.CPDFWatermark.Horizalign;
import com.compdfkit.core.watermark.CPDFWatermark.Type;
import com.compdfkit.core.watermark.CPDFWatermark.Vertalign;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFPageUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFSearchUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.annotation.pdfannotationlist.data.CPDFAnnotDatas;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.print.CPDFPrintUtils;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.utils.threadpools.SimpleBackgroundTask;
import com.compdfkit.tools.common.utils.viewutils.CViewUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFPageIndicatorView;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.textsearch.CPDFTextSearcher;
import com.compdfkit.ui.textsearch.ITextSearcher;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;
import java.util.ArrayList;

public class CPDFDocumentPlugin extends BaseMethodChannelPlugin {

  private String documentUid;

  private CPDFViewCtrl pdfView;

  private CPDFDocument mDocument;

  CPDFPageUtil pageUtil = new CPDFPageUtil();

  public CPDFDocumentPlugin(Context context,
      BinaryMessenger binaryMessenger, String documentUid) {
    super(context, binaryMessenger);
    this.documentUid = documentUid;
  }

  public void setReaderView(CPDFViewCtrl pdfView) {
    this.pdfView = pdfView;
    this.mDocument = pdfView.getCPdfReaderView().getPDFDocument();
  }

  public void setDocument(CPDFDocument cpdfDocument) {
    this.mDocument = cpdfDocument;
  }

  @Override
  public String methodName() {
    return "com.compdfkit.flutter.document_" + documentUid;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    CPDFDocument document;
    if (pdfView != null) {
      document = pdfView.getCPdfReaderView().getPDFDocument();
    } else {
      document = mDocument;
    }
    pageUtil.setDocument(document);
    if (document == null) {
      result.error("-1", "CPDFReaderView isnull or CPDFDocument is null", null);
      return;
    }
    switch (call.method) {
      case OPEN_DOCUMENT: {
        String filePath = call.argument("filePath");
        String openPwd = call.argument("password");
        PDFDocumentError error;
        Object object;
        if (filePath.startsWith(CONTENT_SCHEME) || filePath.startsWith(
            FileUtils.FILE_SCHEME)) {
          object = Uri.parse(filePath);
          error = document.open(Uri.parse(filePath), openPwd);
        } else {
          object = filePath;
          error = document.open(filePath, openPwd);
        }
        switch (error) {
          case PDFDocumentErrorSuccess:
            result.success("success");
            break;
          case PDFDocumentErrorPassword:
            result.success("errorPassword");
            break;
          case PDFDocumentErrorFile:
            result.success("errorFile");
            break;
          case PDFDocumentErrorPage:
            result.success("errorPage");
            break;
          case PDFDocumentErrorFormat:
            result.success("errorFormat");
            break;
          case PDFDocumentErrorUnknown:
            result.success("unknown");
            break;
          case PDFDocumentErrorSecurity:
            result.success("errorSecurity");
            break;
          case PDFDocumentNotVerifyLicense:
            result.success("notVerifyLicense");
            break;
          case PDFDocumentErrorNoReadPermission:
            result.success("noReadPermission");
            break;
        }
        if (error == PDFDocumentError.PDFDocumentErrorSuccess && pdfView != null) {
          pdfView.setPDFDocument(document, object, error, null);
        }
        break;
      }
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
      case CHECK_OWNER_PASSWORD: {
        String password = call.argument("password");
        result.success(document.checkOwnerPassword(password));
        break;
      }
      case CLOSE:
        document.close();
        result.success(true);
        break;
      case HAS_CHANGE:
        result.success(document.hasChanges());
        break;
      case IMPORT_ANNOTATIONS:
        try {
          String xfdfFilePath = FileUtils.getImportFilePath(context,
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
          if (pdfView != null) {
            pdfView.getCPdfReaderView().reloadPages();
          }
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
        if (deleteResult && pdfView != null) {
          pdfView.getCPdfReaderView().invalidateAllChildren();
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
      case SAVE_AS: {
        String savePath = call.argument("save_path");
        boolean removeSecurity = call.argument("remove_security");
        boolean fontSubSet = call.argument("font_sub_set");
        if (pdfView != null) {
          pdfView.exitEditMode();
        }
        CThreadPoolUtils.getInstance().executeIO(() -> {
          try {
            boolean saveResult;
            if (savePath.startsWith(CONTENT_SCHEME)) {
              saveResult = document.saveAs(Uri.parse(savePath), removeSecurity, fontSubSet);
            } else {
              saveResult = document.saveAs(savePath, removeSecurity, false, fontSubSet);
            }
            CThreadPoolUtils.getInstance().executeMain(() -> {
              try{
                if (document.shouleReloadDocument()) {
                  document.reload();
                  if (pdfView != null) {
                    pdfView.getCPdfReaderView().reloadPages2();
                  }
                }
              }catch (Exception e){

              }
              result.success(saveResult);
            });
          } catch (CPDFDocumentException e) {
            e.printStackTrace();
            result.error("SAVE_FAIL",
                "The current saved directory is: " + savePath
                    + ", please make sure you have write permission to this directory", "");
          }
        });
        break;
      }
      case PRINT:
        FragmentActivity fragmentActivity = CViewUtils.getFragmentActivity(pdfView.getContext());
        if (fragmentActivity != null) {
          CPDFPrintUtils.printCurrentDocument(fragmentActivity, document);
        }
        result.success(null);
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
        Object watermarkObj = call.arguments;
        Log.e("ComPDFKit-Flutter", "watermark:" + watermarkObj.toString());
        createWatermark(call, result, pdfView, document);
        break;
      case REMOVE_ALL_WATERMARKS:
        for (int watermarkCount = document.getWatermarkCount(); watermarkCount > 0;
            watermarkCount--) {
          document.getWatermark(watermarkCount - 1).clear();
        }
        if (pdfView != null) {
          pdfView.getCPdfReaderView().reloadPages();
        }
        result.success(null);
        break;
      case IMPORT_WIDGETS:
        try {
          String xfdfFilePath = FileUtils.getImportFilePath(context,
              (String) call.arguments);
          File file = new File(xfdfFilePath);
          if (!file.exists()) {
            result.success(false);
            return;
          }
          boolean importWidgetResult = CPDFAnnotDatas.importWidgets(document, xfdfFilePath);
          if (pdfView != null) {
            pdfView.getCPdfReaderView().reloadPages();
          }
          result.success(importWidgetResult);
        } catch (Exception e) {
          e.printStackTrace();
          result.success(false);
        }
        break;
      case EXPORT_WIDGETS:
        try {
          File saveDir = new File(context.getFilesDir(), "compdfkit/widgets/export/");
          saveDir.mkdirs();
          String fileName = CFileUtils.getFileNameNoExtension(document.getFileName());

          File cacheFile = new File(context.getCacheDir(),
              CFileUtils.CACHE_FOLDER + File.separator + "widgetExportCache/" + fileName);
          cacheFile.mkdirs();

          File saveFile = new File(saveDir, fileName + "_widgets.xfdf");
          saveFile = CFileUtils.renameNameSuffix(saveFile);
          boolean exportResult = document.exportWidgets(saveFile.getAbsolutePath(),
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
      case FLATTEN_ALL_PAGES:
        try {
          String flttenSavePath = call.argument("save_path");
          boolean fontSubset = call.argument("font_subset");
          boolean success = document.flattenAllPages(PDFFlattenOption.FLAT_NORMALDISPLAY);
          if (!success) {
            result.error("FLATTEN_FAIL", "Flatten all pages failed.", "");
            return;
          }
          boolean saveResult;
          if (flttenSavePath.startsWith(CONTENT_SCHEME)) {
            saveResult = document.saveAs(Uri.parse(flttenSavePath), false, fontSubset);
          } else {
            saveResult = document.saveAs(flttenSavePath, false, false, fontSubset);
          }
          if (document.shouleReloadDocument()) {
            document.reload();
          }
          result.success(saveResult);
        } catch (Exception e) {
          e.printStackTrace();
          if (e instanceof CPDFDocumentException) {
            result.error("FLATTEN_FAIL",
                "ErrType: " + ((CPDFDocumentException) e).getErrType().name(), e.getMessage());
          } else {
            result.error("FLATTEN_FAIL", "An exception occurs when saving the document.",
                e.getMessage());
          }
        }
        break;
      case IMPORT_DOCUMENT: {
        String importFilePath = call.argument("file_path");
        ArrayList<Integer> pages = call.argument("pages");
        int insertPosition = call.argument("insert_position");
        String password = call.argument("password");

        String importDocumentPath = FileUtils.getImportFilePath(context, importFilePath);
        CPDFDocument importDocument = new CPDFDocument(context);
        PDFDocumentError error = importDocument.open(importDocumentPath, password);
        if (error != PDFDocumentError.PDFDocumentErrorSuccess) {
          result.error("IMPORT_DOCUMENT_FAIL", "open import document fail, error:" + error.name(),
              "");
          return;
        }
        if (pages == null || pages.isEmpty()) {
          int pageCount = importDocument.getPageCount();
          pages = new ArrayList<>();
          for (int i = 0; i < pageCount; i++) {
            pages.add(i);
          }
        }
        int[] pagesArray = new int[pages.size()];
        for (int i = 0; i < pages.size(); i++) {
          pagesArray[i] = pages.get(i);
        }
        if (insertPosition == -1) {
          insertPosition = document.getPageCount();
        }
        boolean importResult = document.importPages(importDocument, pagesArray, insertPosition);
        result.success(importResult);
        if (pdfView != null) {
          pdfView.getCPdfReaderView().reloadPages();
          updatePageIndicatorView(document);
        }
        break;
      }
      case INSERT_BLANK_PAGE: {
        int pageIndex = call.argument("page_index");
        int width = call.argument("page_width");
        int height = call.argument("page_height");
        CPDFPage page = document.insertBlankPage(pageIndex, width, height);
        if (page != null && page.isValid()) {
          updatePageIndicatorView(document);
        }
        result.success(page != null && page.isValid());
        break;
      }
      case SPLIT_DOCUMENT_PAGES: {
        String savePath = call.argument("save_path");
        ArrayList<Integer> pages = call.argument("pages");
        if (pages == null || pages.isEmpty()) {
          result.error("SPLIT_DOCUMENT_FAIL", "The number of pages must be greater than 1", "");
          return;
        }
        int[] pagesArray = new int[pages.size()];
        for (int i = 0; i < pages.size(); i++) {
          pagesArray[i] = pages.get(i);
        }
        CThreadPoolUtils.getInstance().executeIO(() -> {
          try {
            CPDFDocument newDocument = CPDFDocument.createDocument(context);
            newDocument.importPages(document, pagesArray, 0);
            boolean saveResult;
            if (savePath.startsWith(CONTENT_SCHEME)) {
              saveResult = newDocument.saveAs(Uri.parse(savePath), false, true);
            } else {
              saveResult = newDocument.saveAs(savePath, false, false, true);
            }
            result.success(saveResult);
            newDocument.close();
          } catch (CPDFDocumentException e) {
            result.error("SPLIT_DOCUMENT_FAIL", "error:" + e.getErrType().name(), "");
          }
        });
        break;
      }
      case GET_DOCUMENT_PATH: {
        if (!TextUtils.isEmpty(document.getAbsolutePath())) {
          result.success(document.getAbsolutePath());
          return;
        }
        result.success(document.getUri().toString());
        break;
      }
      case GET_ANNOTATIONS: {
        int pageIndex = (int) call.arguments;
        result.success(pageUtil.getAnnotations(pageIndex));
        break;
      }
      case GET_WIDGETS: {
        int pageIndex = (int) call.arguments;
        result.success(pageUtil.getWidgets(pageIndex));
        break;
      }
      case REMOVE_ANNOTATION:
      case REMOVE_WIDGET: {
        int pageIndex = call.argument("page_index");
        String annotPtr = call.argument("uuid");
        CPDFAnnotation annotation = pageUtil.getAnnotation(pageIndex, annotPtr);
        if (annotation == null) {
          Log.e("ComPDFKit-Flutter",
              "not found this annotation, pageIndex:" + pageIndex + ", annotPtr:" + annotPtr);
          result.error("REMOVE_FAIL", "not found this annotation", "");
          return;
        }
        if (pdfView != null) {
          CPDFPageView pageView = (CPDFPageView) pdfView.getCPdfReaderView().getChild(pageIndex);
          if (pageView != null) {
            CPDFBaseAnnotImpl baseAnnot = pageView.getAnnotImpl(annotation);
            pageView.deleteAnnotation(baseAnnot);
            result.success(true);
          } else {
            result.success(pageUtil.deleteAnnotation(pageIndex, annotPtr));
          }
        } else {
          result.success(pageUtil.deleteAnnotation(pageIndex, annotPtr));
        }
        break;
      }
      case SEARCH_TEXT:
        String keywords = call.argument("keywords");
        int options = call.argument("search_options");
        ITextSearcher iTextSearcher = null;
        if (pdfView != null) {
          iTextSearcher = pdfView.getCPdfReaderView().getTextSearcher();
        } else {
          iTextSearcher = new CPDFTextSearcher(context, document);
        }
        result.success(CPDFSearchUtil.search(document, iTextSearcher, keywords, options));
        break;
      case SEARCH_TEXT_SELECTION:
        CPDFSearchUtil.selection(context, pdfView, document, call);
        result.success(null);
        break;
      case SEARCH_TEXT_CLEAR:
        CPDFSearchUtil.clearSearch(context, pdfView, document);
        result.success(null);
        break;
      case GET_SEARCH_TEXT:
        result.success(CPDFSearchUtil.getText(document, call));
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
    new SimpleBackgroundTask<Bitmap>(pdfView.getContext()) {

        @Override
        public Bitmap onRun() {
          if ("text".equals(type)) {
            return null;
          }else {
            try {
              Bitmap bitmap = Glide.with(context).asBitmap().load(imagePath).submit(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL).get();
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

  private void updatePageIndicatorView(CPDFDocument document) {
    if (pdfView != null) {
      CPDFPageIndicatorView indicatorView = pdfView.indicatorView;
      indicatorView.setTotalPage(document.getPageCount());
      indicatorView.setCurrentPageIndex(pdfView.getCPdfReaderView().getPageNum());
      pdfView.slideBar.setPageCount(document.getPageCount());
      pdfView.slideBar.requestLayout();
    }
  }
}
