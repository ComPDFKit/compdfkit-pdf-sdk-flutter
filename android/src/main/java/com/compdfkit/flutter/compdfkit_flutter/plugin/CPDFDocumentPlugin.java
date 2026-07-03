/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.plugin;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_ANNOTATION_REPLY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_BOOKMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_OUTLINE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_WIDGET_IMAGE_SIGNATURE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.ADD_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHECK_OWNER_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHECK_OWNER_UNLOCKED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CLOSE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.COPY_PAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_NEW_IMAGE_AREA;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_NEW_TEXT_AREA;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CREATE_WATERMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXPORT_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.EXTRACT_IMAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.FLATTEN_ALL_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_MARK_STATE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_REPLIES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ANNOTATION_REVIEW_STATE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RENDER_ANNOTATION_APPEARANCE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_BOOKMARKS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DOCUMENT_INFO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_DOCUMENT_PATH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_ENCRYPT_ALGORITHM;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FILE_NAME;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_WATERMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_WATERMARKS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_WATERMARK_COUNT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_MAJOR_VERSION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_MINOR_VERSION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_OUTLINE_ROOT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_COUNT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_ROTATION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_SIZE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_TEXT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_TEXT_IN_RECT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PAGE_TEXT_LINES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PERMISSIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_PERMISSIONS_INFO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_SEARCH_TEXT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HAS_BOOKMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.HAS_CHANGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IMPORT_WIDGETS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INSERT_BLANK_PAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.INSERT_IMAGE_WITH_PATH;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_ENCRYPTED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_IMAGE_DOC;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.IS_LOCKED;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.MOVE_PAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.MOVE_TO_OUTLINE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.NEW_OUTLINE_ROOT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.OPEN_DOCUMENT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.PRINT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_ANNOTATIONS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_ANNOTATION_REPLIES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ALL_WATERMARKS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ANNOTATION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_ANNOTATION_REPLY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_BOOKMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_EDIT_AREA;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_OUTLINE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_WATERMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.REMOVE_WIDGET;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.RENDER_PAGE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SAVE_AS;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT_CLEAR;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SEARCH_TEXT_SELECTION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_ANNOTATION_MARK_STATE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_ANNOTATION_REVIEW_STATE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PAGE_ROTATION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_PASSWORD;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SPLIT_DOCUMENT_PAGES;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_ANNOTATION;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_ANNOTATION_REPLY;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_BOOKMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_OUTLINE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_WATERMARK;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.UPDATE_WIDGET;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.common.CPDFDocumentException;
import com.compdfkit.core.document.CPDFBookmark;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentEncryptAlgo;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentError;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentImageMode;
import com.compdfkit.core.document.CPDFDocument.PDFDocumentSaveType;
import com.compdfkit.core.document.CPDFDocumentPermissionInfo;
import com.compdfkit.core.edit.CPDFEditArea;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.page.CPDFPage.PDFFlattenOption;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.core.watermark.CPDFWatermark;
import com.compdfkit.core.watermark.CPDFWatermark.Type;
import com.compdfkit.flutter.compdfkit_flutter.bridge.BaseMethodChannelPlugin;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentContext;
import com.compdfkit.flutter.compdfkit_flutter.document.CPDFDocumentRegistry;
import com.compdfkit.flutter.compdfkit_flutter.document.codec.CPDFPageCodec;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentAnnotationOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentEditAreaOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentInfoOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentOpenOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentOutlineOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentPageOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentRenderOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentSaveOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentSearchOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentSecurityOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentTransferOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentTaskOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentTextOps;
import com.compdfkit.flutter.compdfkit_flutter.document.ops.DocumentWatermarkOps;
import com.compdfkit.flutter.compdfkit_flutter.document.resolver.CPDFDocumentSourceResolver;
import com.compdfkit.flutter.compdfkit_flutter.sdk.SdkPluginRegistry;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFBookmarkUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFDocumentInfoUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEditAreaUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFEnumConvertUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFOutlineJsonUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CPDFSearchUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.annotation.pdfannotationlist.data.CPDFAnnotDatas;
import com.compdfkit.tools.common.utils.CFileUtils;
import com.compdfkit.tools.common.utils.date.CDateUtil;
import com.compdfkit.tools.common.utils.glide.CPDFWrapper;
import com.compdfkit.tools.common.utils.glide.wrapper.impl.CPDFDocumentPageWrapper;
import com.compdfkit.tools.common.utils.print.CPDFPrintUtils;
import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;
import com.compdfkit.tools.common.utils.threadpools.SimpleBackgroundTask;
import com.compdfkit.tools.common.utils.viewutils.CViewUtils;
import com.compdfkit.tools.common.views.pdfview.CPDFPageIndicatorView;
import com.compdfkit.tools.common.views.pdfview.CPDFViewCtrl;
import com.compdfkit.ui.proxy.CPDFBaseAnnotImpl;
import com.compdfkit.ui.reader.CPDFPageView;
import com.compdfkit.ui.reader.CPDFReaderView;
import com.compdfkit.ui.reader.CPDFReaderView.ViewMode;
import com.compdfkit.ui.textsearch.CPDFTextSearcher;
import com.compdfkit.ui.textsearch.ITextSearcher;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class CPDFDocumentPlugin extends BaseMethodChannelPlugin {

    private final String documentUid;

    private final CPDFDocumentContext documentContext;

    private CPDFViewCtrl pdfView;

    private CPDFPageCodec pageUtil;

    public CPDFDocumentPlugin(Context context,
            BinaryMessenger binaryMessenger, String documentUid) {
        super(context, binaryMessenger);
        this.documentUid = documentUid;
        this.documentContext = new CPDFDocumentContext(context, documentUid);
        this.pageUtil = documentContext.getPageCodec();
        CPDFDocumentRegistry.register(documentContext);
    }

    public void setReaderView(CPDFViewCtrl pdfView) {
        this.pdfView = pdfView;
        documentContext.attachReaderView(pdfView);
        this.pageUtil = documentContext.getPageCodec();
    }

    public void setDocument(CPDFDocument cpdfDocument) {
        documentContext.attachDocument(cpdfDocument);
        this.pageUtil = documentContext.getPageCodec();
    }

    public CPDFPageCodec getPageUtil() {
        return pageUtil;
    }

    @Override
    public void unregister() {
        CPDFDocumentRegistry.unregister(documentUid);
        documentContext.attachDocument(null);
        super.unregister();
    }

    @Override
    public String methodName() {
        return "com.compdfkit.flutter.document_" + documentUid;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        CPDFDocument document = documentContext.getDocument();
        pageUtil = documentContext.getPageCodec();
        if (document == null) {
            result.error("-1", "CPDFReaderView isnull or CPDFDocument is null", null);
            return;
        }
        switch (call.method) {
            case OPEN_DOCUMENT: {
                String filePath = call.argument("filePath");
                String openPwd = call.argument("password");
                DocumentOpenOps.OpenResult openResult = DocumentOpenOps.open(documentContext,
                        filePath, openPwd);
                result.success(DocumentOpenOps.toFlutterResult(openResult.getError()));
                break;
            }
            case GET_FILE_NAME:
                result.success(DocumentInfoOps.getFileName(documentContext));
                break;
            case IS_ENCRYPTED:
                result.success(DocumentInfoOps.isEncrypted(documentContext));
                break;
            case IS_IMAGE_DOC:
                CThreadPoolUtils.getInstance().executeIO(
                        () -> DocumentInfoOps.isImageDoc(documentContext, result));
                break;
            case GET_PERMISSIONS:
                result.success(DocumentInfoOps.getPermissions(documentContext));
                break;
            case CHECK_OWNER_UNLOCKED:
                result.success(DocumentInfoOps.checkOwnerUnlocked(documentContext));
                break;
            case CHECK_OWNER_PASSWORD: {
                String password = call.argument("password");
                result.success(DocumentInfoOps.checkOwnerPassword(documentContext, password));
                break;
            }
            case CLOSE: {
                boolean closeResult = DocumentInfoOps.close(documentContext);
                SdkPluginRegistry.unregisterDocumentPlugin(documentUid);
                result.success(closeResult);
                break;
            }
            case HAS_CHANGE:
                result.success(DocumentInfoOps.hasChange(documentContext));
                break;
            case IMPORT_ANNOTATIONS:
                result.success(DocumentTransferOps.importAnnotations(documentContext,
                        (String) call.arguments));
                break;
            case EXPORT_ANNOTATIONS:
                result.success(DocumentTransferOps.exportAnnotations(documentContext));
                break;
            case REMOVE_ALL_ANNOTATIONS:
                result.success(DocumentAnnotationOps.removeAllAnnotations(documentContext));
                break;
            case GET_PAGE_COUNT:
                result.success(DocumentInfoOps.getPageCount(documentContext));
                break;
            case RENDER_ANNOTATION_APPEARANCE:
                DocumentRenderOps.renderAnnotationAppearance(documentContext, call, result);
                break;
            case SAVE: {
                boolean saveIncremental = call.argument("save_incremental");
                boolean fontSubSet = call.argument("font_sub_set");
                DocumentTaskOps.saveAsync(documentContext, saveIncremental, fontSubSet, result);
                break;
            }
            case SAVE_AS: {
                String savePath = call.argument("save_path");
                boolean removeSecurity = call.argument("remove_security");
                boolean fontSubSet = call.argument("font_sub_set");
                DocumentTaskOps.saveAsAsync(documentContext, savePath, removeSecurity,
                        fontSubSet, result);
                break;
            }
            case PRINT:
                DocumentTaskOps.print(documentContext, result);
                break;
            case REMOVE_PASSWORD:
                DocumentTaskOps.removePasswordAsync(documentContext, result);
                break;
            case SET_PASSWORD:
                String userPassword = call.argument("user_password");
                String ownerPassword = call.argument("owner_password");
                boolean allowsPrinting = call.argument("allows_printing");
                boolean allowsCopying = call.argument("allows_copying");
                String encryptAlgo = call.argument("encrypt_algo");
                DocumentTaskOps.setPasswordAsync(documentContext, userPassword, ownerPassword,
                        allowsPrinting, allowsCopying, encryptAlgo, result);
                break;
            case GET_ENCRYPT_ALGORITHM:
                result.success(DocumentSecurityOps.getEncryptAlgorithm(documentContext));
                break;
            case CREATE_WATERMARK:
                Object watermarkObj = call.arguments;
                Log.e("ComPDFKit-Flutter", "watermark:" + watermarkObj.toString());
                DocumentWatermarkOps.createWatermark(documentContext, call, result);
                break;
            case REMOVE_ALL_WATERMARKS:
                DocumentWatermarkOps.removeAllWatermarks(documentContext, result);
                break;
            case GET_WATERMARK_COUNT:
                DocumentWatermarkOps.getWatermarkCount(documentContext, result);
                break;
            case GET_WATERMARK:
                DocumentWatermarkOps.getWatermark(documentContext, call, result);
                break;
            case GET_WATERMARKS:
                DocumentWatermarkOps.getWatermarks(documentContext, call, result);
                break;
            case UPDATE_WATERMARK:
                DocumentWatermarkOps.updateWatermark(documentContext, call, result);
                break;
            case REMOVE_WATERMARK:
                DocumentWatermarkOps.removeWatermark(documentContext, call, result);
                break;
            case IMPORT_WIDGETS:
                result.success(DocumentTransferOps.importWidgets(documentContext,
                        (String) call.arguments));
                break;
            case EXPORT_WIDGETS:
                result.success(DocumentTransferOps.exportWidgets(documentContext));
                break;
            case FLATTEN_ALL_PAGES:
                try {
                    String flttenSavePath = call.argument("save_path");
                    boolean fontSubset = call.argument("font_subset");
                    boolean saveResult = DocumentTransferOps.flattenAllPages(documentContext,
                            flttenSavePath, fontSubset);
                    if (!saveResult) {
                        result.error("FLATTEN_FAIL", "Flatten all pages failed.", "");
                        return;
                    }
                    result.success(saveResult);
                } catch (Exception e) {
                    if (e instanceof CPDFDocumentException) {
                        result.error("FLATTEN_FAIL",
                                "ErrType: " + ((CPDFDocumentException) e).getErrType().name(),
                                e.getMessage());
                    } else {
                        result.error("FLATTEN_FAIL",
                                "An exception occurs when saving the document.",
                                e.getMessage());
                    }
                }
                break;
            case IMPORT_DOCUMENT: {
                String importFilePath = call.argument("file_path");
                ArrayList<Integer> pages = call.argument("pages");
                int insertPosition = call.argument("insert_position");
                String password = call.argument("password");

                boolean importResult = DocumentTransferOps.importDocument(documentContext,
                        importFilePath, pages, insertPosition, password);
                result.success(importResult);
                if (importResult && pdfView != null) {
                    updatePageIndicatorView(document);
                }
                break;
            }
            case INSERT_BLANK_PAGE: {
                int pageIndex = call.argument("page_index");
                int width = call.argument("page_width");
                int height = call.argument("page_height");
                boolean insertBlankResult = DocumentPageOps.insertBlankPage(documentContext,
                        pageIndex, width, height);
                if (insertBlankResult) {
                    updatePageIndicatorView(document);
                }
                result.success(insertBlankResult);
                break;
            }
            case COPY_PAGE: {
                int pageIndex = call.argument("page_index");
                int insertIndex = call.argument("insert_index");
                boolean copyPageResult = DocumentPageOps.copyPage(documentContext, pageIndex,
                        insertIndex);
                if (copyPageResult) {
                    updatePageIndicatorView(document);
                }
                result.success(copyPageResult);
                break;
            }
            case SPLIT_DOCUMENT_PAGES: {
                String savePath = call.argument("save_path");
                ArrayList<Integer> pages = call.argument("pages");
                if (pages == null || pages.isEmpty()) {
                    result.error("SPLIT_DOCUMENT_FAIL",
                            "The number of pages must be greater than 1", "");
                    return;
                }
                CThreadPoolUtils.getInstance().executeIO(() -> {
                    try {
                        boolean saveResult = DocumentPageOps.splitDocumentPages(documentContext,
                                savePath, pages);
                        result.success(saveResult);
                    } catch (CPDFDocumentException e) {
                        result.error("SPLIT_DOCUMENT_FAIL", "error:" + e.getErrType().name(), "");
                    }
                });
                break;
            }
            case EXTRACT_IMAGES: {
                String directoryPath = call.argument("directory_path");
                ArrayList<Integer> pages = call.argument("pages");
                if (TextUtils.isEmpty(directoryPath)) {
                    result.error("EXTRACT_IMAGES_FAIL", "directory_path is empty", null);
                    return;
                }
                if (pages != null) {
                    int pageCount = document.getPageCount();
                    for (Integer page : pages) {
                        if (page == null || page < 0 || page >= pageCount) {
                            result.error("EXTRACT_IMAGES_FAIL",
                                    "Invalid page index: " + page, null);
                            return;
                        }
                    }
                }
                CThreadPoolUtils.getInstance().executeIO(() -> {
                    try {
                        result.success(DocumentPageOps.extractImages(documentContext,
                                directoryPath, pages));
                    } catch (Exception e) {
                        result.error("EXTRACT_IMAGES_FAIL", e.getMessage(), null);
                    }
                });
                break;
            }
            case GET_DOCUMENT_PATH: {
                result.success(DocumentInfoOps.getDocumentPath(documentContext));
                break;
            }
            case GET_ANNOTATIONS: {
                int pageIndex = (int) call.arguments;
                result.success(DocumentAnnotationOps.getAnnotations(documentContext, pageIndex));
                break;
            }
            case ADD_ANNOTATION_REPLY: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String content = call.argument("content");
                String title = call.argument("title");
                DocumentAnnotationOps.addAnnotationReply(documentContext, pageIndex, annotPtr,
                        content, title, result);
                break;
            }
            case GET_ANNOTATION_REPLIES: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                DocumentAnnotationOps.getAnnotationReplies(documentContext, pageIndex, annotPtr,
                        result);
                break;
            }
            case UPDATE_ANNOTATION_REPLY: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                String content = call.argument("content");
                String title = call.argument("title");
                DocumentAnnotationOps.updateAnnotationReply(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, content, title, result);
                break;
            }
            case REMOVE_ANNOTATION_REPLY: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                DocumentAnnotationOps.removeAnnotationReply(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, result);
                break;
            }
            case REMOVE_ALL_ANNOTATION_REPLIES: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                DocumentAnnotationOps.removeAllAnnotationReplies(documentContext, pageIndex,
                        annotPtr, result);
                break;
            }
            case SET_ANNOTATION_MARK_STATE: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                String markState = call.argument("mark_state");
                DocumentAnnotationOps.setAnnotationMarkState(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, markState, result);
                break;
            }
            case GET_ANNOTATION_MARK_STATE: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                DocumentAnnotationOps.getAnnotationMarkState(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, result);
                break;
            }
            case SET_ANNOTATION_REVIEW_STATE: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                String reviewState = call.argument("review_state");
                DocumentAnnotationOps.setAnnotationReviewState(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, reviewState, result);
                break;
            }
            case GET_ANNOTATION_REVIEW_STATE: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String nativeId = call.argument("native_id");
                String replyKey = call.argument("reply_key");
                String parentUuid = call.argument("parent_uuid");
                DocumentAnnotationOps.getAnnotationReviewState(documentContext, pageIndex, annotPtr,
                        nativeId, replyKey, parentUuid, result);
                break;
            }
            case GET_WIDGETS: {
                int pageIndex = (int) call.arguments;
                result.success(DocumentAnnotationOps.getWidgets(documentContext, pageIndex));
                break;
            }
            case REMOVE_ANNOTATION:
            case REMOVE_WIDGET: {
                int pageIndex = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                DocumentAnnotationOps.removeAnnotation(documentContext, pageIndex, annotPtr,
                        result);
                break;
            }
            case GET_OUTLINE_ROOT:
                result.success(DocumentOutlineOps.getOutlineRoot(documentContext));
                break;
            case NEW_OUTLINE_ROOT:
                result.success(DocumentOutlineOps.newOutlineRoot(documentContext));
                break;
            case ADD_OUTLINE:
                result.success(DocumentOutlineOps.addOutline(documentContext, call));
                break;
            case REMOVE_OUTLINE:
                String outlineUUid = call.arguments.toString();
                result.success(DocumentOutlineOps.removeOutline(documentContext, outlineUUid));
                break;
            case UPDATE_OUTLINE: {
                String uid = call.argument("uuid");
                String title = call.argument("title");
                int destPageIndex = call.argument("page_index");
                result.success(DocumentOutlineOps.updateOutline(documentContext, uid, title,
                        destPageIndex));
                break;
            }
            case MOVE_TO_OUTLINE: {
                String uid = call.argument("uuid");
                int insertIndex = call.argument("insert_index");
                String parentUid = call.argument("new_parent_uuid");
                result.success(DocumentOutlineOps.moveToOutline(documentContext, uid, parentUid,
                        insertIndex));
                break;
            }
            case HAS_BOOKMARK:
                result.success(DocumentOutlineOps.hasBookmark(documentContext,
                        (Integer) call.arguments));
                break;
            case REMOVE_BOOKMARK:
                int pageIndex = (int) call.arguments;
                result.success(DocumentOutlineOps.removeBookmark(documentContext, pageIndex));
                break;
            case GET_BOOKMARKS:
                result.success(DocumentOutlineOps.getBookmarks(documentContext));
                break;
            case ADD_BOOKMARK:
                String title = call.argument("title");
                int bookMarkPageIndex = call.argument("page_index");
                boolean addResult = DocumentOutlineOps.addBookmark(documentContext, title,
                        bookMarkPageIndex);
                result.success(addResult);
                break;
            case UPDATE_BOOKMARK: {
                String editTitle = call.argument("title");
                String uuid = call.argument("uuid");
                boolean updateResult = DocumentOutlineOps.updateBookmark(documentContext, uuid,
                        editTitle);
                result.success(updateResult);
                break;
            }
            case RENDER_PAGE:
                DocumentRenderOps.renderPageToImage(documentContext, call, result);
                break;
            case GET_PAGE_SIZE:
                int page = call.argument("page_index");
                result.success(DocumentPageOps.getPageSize(documentContext, page));
                break;
            case INSERT_IMAGE_WITH_PATH: {
                int index = call.argument("page_index");
                int width = call.argument("page_width");
                int height = call.argument("page_height");
                String imagePath = call.argument("image_path");
                boolean insertResult = DocumentPageOps.insertImageWithPath(documentContext, index,
                        width, height, imagePath);
                if (insertResult) {
                    updatePageIndicatorView(document);
                }
                result.success(insertResult);
                break;
            }
            case GET_PAGE_ROTATION: {
                int _pageIndex = (int) call.arguments;
                try {
                    result.success(DocumentPageOps.getPageRotation(documentContext, _pageIndex));
                } catch (IllegalArgumentException e) {
                    result.error("GET_PAGE_ROTATION_FAIL", e.getMessage(), null);
                }
                break;
            }
            case SET_PAGE_ROTATION: {
                int _pageIndex = call.argument("page_index");
                int rotation = call.argument("rotation");
                try {
                    result.success(
                            DocumentPageOps.setPageRotation(documentContext, _pageIndex, rotation));
                } catch (IllegalArgumentException e) {
                    result.error("SET_PAGE_ROTATION_FAIL", e.getMessage(), null);
                }
                break;
            }
            case REMOVE_PAGES: {
                ArrayList<Integer> pages = (ArrayList<Integer>) call.arguments;
                if (pages == null || pages.isEmpty()) {
                    result.error("REMOVE_PAGES_FAIL", "The number of pages must be greater than 1",
                            "");
                    return;
                }
                result.success(DocumentPageOps.removePages(documentContext, pages));
                break;
            }
            case MOVE_PAGE: {
                int sourcePageIndex = call.argument("from_index");
                int targetPageIndex = call.argument("to_index");
                result.success(
                        DocumentPageOps.movePage(documentContext, sourcePageIndex, targetPageIndex));
                break;
            }
            case GET_DOCUMENT_INFO: {
                result.success(DocumentInfoOps.getDocumentInfo(documentContext));
                break;
            }
            case GET_MAJOR_VERSION:
                result.success(DocumentInfoOps.getMajorVersion(documentContext));
                break;
            case GET_MINOR_VERSION:
                result.success(DocumentInfoOps.getMinorVersion(documentContext));
                break;
            case GET_PERMISSIONS_INFO:
                result.success(DocumentInfoOps.getPermissionsInfo(documentContext));
                break;
            case IS_LOCKED:
                result.success(DocumentInfoOps.isLocked(documentContext));
                break;
            case SEARCH_TEXT:
                String keywords = call.argument("keywords");
                int options = call.argument("search_options");
                result.success(DocumentSearchOps.searchText(documentContext, keywords, options));
                break;
            case SEARCH_TEXT_SELECTION:
                DocumentSearchOps.selectText(documentContext, call);
                result.success(null);
                break;
            case SEARCH_TEXT_CLEAR:
                DocumentSearchOps.clearSearch(documentContext);
                result.success(null);
                break;
            case GET_SEARCH_TEXT:
                result.success(DocumentSearchOps.getSearchText(documentContext, call));
                break;
            case GET_PAGE_TEXT: {
                int pageIndex1 = call.argument("page_index");
                try {
                    result.success(DocumentTextOps.getPageText(documentContext, pageIndex1));
                } catch (IllegalArgumentException e) {
                    result.error("GET_PAGE_TEXT_FAIL", e.getMessage(), null);
                }
                break;
            }
            case GET_PAGE_TEXT_IN_RECT: {
                int pageIndex1 = call.argument("page_index");
                HashMap<String, Object> rect = call.argument("rect");
                try {
                    result.success(
                            DocumentTextOps.getPageTextInRect(documentContext, pageIndex1, rect));
                } catch (IllegalArgumentException e) {
                    result.error("GET_PAGE_TEXT_IN_RECT_FAIL", e.getMessage(), null);
                }
                break;
            }
            case GET_PAGE_TEXT_LINES: {
                int pageIndex1 = call.argument("page_index");
                try {
                    result.success(DocumentTextOps.getPageTextLines(documentContext, pageIndex1));
                } catch (IllegalArgumentException e) {
                    result.error("GET_PAGE_TEXT_LINES_FAIL", e.getMessage(), null);
                }
                break;
            }
            case UPDATE_ANNOTATION: {
                int pageIndex1 = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                HashMap<String, Object> properties = call.argument("data");
                DocumentAnnotationOps.updateAnnotation(documentContext, pageIndex1, annotPtr,
                        properties, result);
                break;
            }
            case UPDATE_WIDGET: {
                int pageIndex1 = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                HashMap<String, Object> properties = call.argument("data");
                DocumentAnnotationOps.updateWidget(documentContext, pageIndex1, annotPtr,
                        properties, result);
                break;
            }
            case ADD_WIDGET_IMAGE_SIGNATURE: {
                int pageIndex1 = call.argument("page_index");
                String annotPtr = call.argument("uuid");
                String imagePath = call.argument("image_path");
                DocumentAnnotationOps.addWidgetImageSignature(documentContext, pageIndex1,
                        annotPtr, imagePath, result);
                break;
            }
            case REMOVE_EDIT_AREA: {
                int pageIndex1 = call.argument("page_index");
                String uuid1 = call.argument("uuid");
                String editAreaType = call.argument("type");
                DocumentEditAreaOps.removeEditArea(documentContext, pageIndex1, uuid1,
                        editAreaType, result);
                break;
            }
            case ADD_ANNOTATIONS: {
                ArrayList<HashMap<String, Object>> annotList = call.argument("annotations");
                boolean addResult1 = DocumentAnnotationOps.addAnnotations(documentContext,
                        annotList);
                result.success(addResult1);
                break;
            }
            case ADD_WIDGETS: {
                ArrayList<HashMap<String, Object>> widgetList = call.argument("widgets");
                boolean addResult1 = DocumentAnnotationOps.addWidgets(documentContext,
                        widgetList);
                result.success(addResult1);
                break;
            }
            case CREATE_NEW_TEXT_AREA: {
                DocumentEditAreaOps.createNewTextArea(documentContext, call, result);
                break;
            }
            case CREATE_NEW_IMAGE_AREA: {
                DocumentEditAreaOps.createNewImageArea(documentContext, call, result);
                break;
            }
            default:
                break;
        }
    }

    private void updatePageIndicatorView(CPDFDocument document) {
        if (pdfView != null) {
            CPDFPageIndicatorView indicatorView = pdfView.indicatorView;
            indicatorView.setTotalPage(document.getPageCount());
            indicatorView.setCurrentPageIndex(pdfView.getCPdfReaderView().getPageNum());
            pdfView.refreshSlideBarDocumentState();
        }
    }
}
