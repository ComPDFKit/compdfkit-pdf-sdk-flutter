/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */
package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.document.CPDFDocument;
import java.util.HashMap;

public interface FlutterCPDFWidget {

  public HashMap<String, Object> getWidget(CPDFAnnotation annotation);

  public void updateWidget(
      CPDFAnnotation annotation,
      HashMap<String, Object> annotMap);

  CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap);

}
