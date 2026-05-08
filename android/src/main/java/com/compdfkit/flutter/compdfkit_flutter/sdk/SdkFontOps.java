/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.sdk;

import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFSdk;
import com.compdfkit.core.font.CPDFFont;
import com.compdfkit.core.font.CPDFFontName;
import com.compdfkit.flutter.compdfkit_flutter.bridge.ThreadDispatch;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class SdkFontOps {

    private SdkFontOps() {
    }

    public static void setImportFontDirectory(String directoryPath, boolean addSystemFont) {
        CPDFSdk.setImportFontDir(directoryPath, addSystemFont);
    }

    public static void updateImportFontDirectory(String directoryPath, boolean addSystemFont,
            @NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            File file = new File(directoryPath);
            if (file.isDirectory()) {
                CPDFDocument.importFontDir(directoryPath, addSystemFont);
                result.success(true);
            } else {
                result.error("UPDATE_IMPORT_FONT_DIR_FAIL", "update import font dir fail",
                        "dir path is not exist or not directory");
            }
        });
    }

    public static void getFonts(@NonNull MethodChannel.Result result) {
        ThreadDispatch.runIo(() -> {
            List<CPDFFontName> fontNames = CPDFFont.getFontName();
            List<Map<String, Object>> fontList = new ArrayList<>();
            for (CPDFFontName fontName : fontNames) {
                Map<String, Object> fontMap = new HashMap<>();
                fontMap.put("familyName", fontName.getFamilyName());
                fontMap.put("styleNames", fontName.getStyleName());
                fontList.add(fontMap);
            }
            result.success(fontList);
        });
    }
}
