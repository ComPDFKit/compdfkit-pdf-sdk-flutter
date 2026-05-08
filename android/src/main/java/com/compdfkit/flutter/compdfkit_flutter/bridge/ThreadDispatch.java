/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 * <p>
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.bridge;

import com.compdfkit.tools.common.utils.threadpools.CThreadPoolUtils;

public final class ThreadDispatch {

    private ThreadDispatch() {
    }

    public static void runIo(Runnable runnable) {
        CThreadPoolUtils.getInstance().executeIO(runnable);
    }

    public static void runMain(Runnable runnable) {
        CThreadPoolUtils.getInstance().executeMain(runnable);
    }
}
