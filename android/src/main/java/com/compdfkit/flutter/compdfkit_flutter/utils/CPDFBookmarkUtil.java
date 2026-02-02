/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.text.TextUtils;
import com.compdfkit.core.common.CPDFDate;
import com.compdfkit.core.document.CPDFBookmark;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.tools.common.utils.date.CDateUtil;
import io.flutter.plugin.common.MethodChannel.Result;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class CPDFBookmarkUtil {

    public static List<Map<String, Object>> getBookmarks(CPDFDocument document) {
        try {
            ArrayList<Map<String, Object>> bookmarkArray = new ArrayList<>();

            List<CPDFBookmark> bookmarks = document.getBookmarks();
            if (bookmarks == null || bookmarks.isEmpty()) {
                return bookmarkArray;
            }
            for (CPDFBookmark bookmark : bookmarks) {
                Map<String, Object> map = new HashMap<>();
                if (!TextUtils.isEmpty(bookmark.getTitle())) {
                    map.put("title", bookmark.getTitle());
                }
                map.put("pageIndex", bookmark.getPageIndex());
                if (!TextUtils.isEmpty(bookmark.getDate())) {
                    try {
                        if (bookmark.getDate().startsWith("D:")) {

                            CPDFDate createDate = CPDFDate.standardDateStr2LocalDate(
                                    bookmark.getDate());
                            map.put("date", CDateUtil.transformToTimestamp(createDate));
                        } else {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmZ",
                                    Locale.ENGLISH);
                            Date date = sdf.parse(bookmark.getDate());
                            if (date != null) {
                                long timestampMillis = date.getTime();
                                map.put("date", timestampMillis);
                            }
                        }
                    } catch (Exception ignored) {

                    }
                }
                map.put("uuid", bookmark.bookmarkPtr + "");
                bookmarkArray.add(map);
            }
            return bookmarkArray;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public static boolean addBookmark(CPDFDocument document, String title, int pageIndex) {
        try {
            return document.addBookmark(
                    new CPDFBookmark(pageIndex, title, CPDFDate.toStandardDate(
                            TTimeUtil.getCurrentDate())));
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean updateBookmark(CPDFDocument document, String uuid, String newTitle) {
        try {
            List<CPDFBookmark> bookmarks = document.getBookmarks();
            if (bookmarks == null || bookmarks.isEmpty()) {
                return false;
            }
            for (CPDFBookmark bookmark : bookmarks) {
                if ((bookmark.bookmarkPtr + "").equals(uuid)) {
                    bookmark.setTitle(newTitle);
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}
