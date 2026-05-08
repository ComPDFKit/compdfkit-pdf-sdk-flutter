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
import android.content.Intent;
import androidx.annotation.NonNull;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.flutter.compdfkit_flutter.plugin.CPDFDocumentPlugin;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentActivity;
import com.compdfkit.tools.common.pdf.config.CPDFConfiguration;
import com.compdfkit.tools.common.utils.CFileUtils;
import io.flutter.plugin.common.BinaryMessenger;
import java.io.File;

public final class SdkDocumentOps {

    private SdkDocumentOps() {
    }

    public static void openDocument(@NonNull Context context, @NonNull String filePath,
            String password, String configurationJson) {
        CPDFConfiguration configuration = CPDFConfigurationUtils.fromJson(configurationJson);
        Intent intent = new Intent(context, CPDFDocumentActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        FileUtils.parseDocument(context, filePath, intent);
        intent.putExtra(CPDFDocumentActivity.EXTRA_FILE_PASSWORD, password);
        intent.putExtra(CPDFDocumentActivity.EXTRA_CONFIGURATION, configuration);
        context.startActivity(intent);
    }

    public static boolean removeSignFileList(@NonNull Context context) {
        File dirFile = new File(context.getFilesDir(), CFileUtils.SIGNATURE_FOLDER);
        return CFileUtils.deleteDirectory(dirFile.getAbsolutePath());
    }

    public static void createDocumentPlugin(@NonNull Context context,
            @NonNull BinaryMessenger binaryMessenger, @NonNull String id) {
        CPDFDocumentPlugin documentPlugin = new CPDFDocumentPlugin(context, binaryMessenger, id);
        documentPlugin.setDocument(new CPDFDocument(context));
        documentPlugin.register();
        SdkPluginRegistry.registerDocumentPlugin(id, documentPlugin);
    }

    public static void createDocument(@NonNull Context context,
            @NonNull BinaryMessenger binaryMessenger, @NonNull String id) {
        CPDFDocumentPlugin documentPlugin = new CPDFDocumentPlugin(context, binaryMessenger, id);
        documentPlugin.setDocument(CPDFDocument.createDocument(context));
        documentPlugin.register();
        SdkPluginRegistry.registerDocumentPlugin(id, documentPlugin);
    }
}
