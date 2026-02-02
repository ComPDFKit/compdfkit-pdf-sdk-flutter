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

import android.util.Log;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFDocumentPermissionInfo;
import com.compdfkit.core.document.CPDFInfo;
import com.compdfkit.tools.common.utils.date.CDateUtil;
import java.util.HashMap;
import java.util.Map;

public class CPDFDocumentInfoUtil {

  public static Map<String, Object> getDocumentInfo(CPDFDocument document) {
    Map<String, Object> documentInfo = new HashMap<>();
    CPDFInfo info = document.getInfo();
    try {
      documentInfo.put("title", info.getTitle());
      documentInfo.put("author", info.getAuthor());
      documentInfo.put("subject", info.getSubject());
      documentInfo.put("keywords", info.getKeywords());
      documentInfo.put("creator", info.getCreator());
      documentInfo.put("producer", info.getProducer());
      long createDateTimes = CAppUtils.toTimes(CDateUtil.transformPDFDate(info.getCreationDate()));
      if (createDateTimes != 0L) {
        documentInfo.put("creationDate", createDateTimes);
      }
      long modificationDateTimes = CAppUtils.toTimes(CDateUtil.transformPDFDate(info.getModificationDate()));
      if (modificationDateTimes != 0L) {
        documentInfo.put("modificationDate", modificationDateTimes);
      }
      return documentInfo;
    } catch (Exception e) {
      return documentInfo;
    }
  }

  public static Map<String, Object> getPermissionsInfo(CPDFDocument document) {
    Map<String, Object> map = new HashMap<>();
    try {
      CPDFDocumentPermissionInfo permissionInfo = document.getPermissionsInfo();
      map.put("allowsPrinting", permissionInfo.isAllowsPrinting());
      map.put("allowsHighQualityPrinting", permissionInfo.isAllowsHighQualityPrinting());
      map.put("allowsCopying", permissionInfo.isAllowsCopying());
      map.put("allowsDocumentChanges", permissionInfo.isAllowsDocumentChanges());
      map.put("allowsDocumentAssembly", permissionInfo.isAllowsDocumentAssembly());
      map.put("allowsCommenting", permissionInfo.isAllowsCommenting());
      map.put("allowsFormFieldEntry", permissionInfo.isAllowsFormFieldEntry());
      return map;
    } catch (Exception e) {
      return map;
    }
  }
}
