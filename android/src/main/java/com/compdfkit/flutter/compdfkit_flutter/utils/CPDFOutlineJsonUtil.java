/**
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import com.compdfkit.core.document.CPDFDestination;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.document.CPDFOutline;
import com.compdfkit.core.document.action.CPDFAction;
import com.compdfkit.core.document.action.CPDFGoToAction;
import com.compdfkit.core.document.action.CPDFUriAction;
import io.flutter.plugin.common.MethodCall;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

public class CPDFOutlineJsonUtil {

    public static Map<String, Object> newOutlineRoot(CPDFDocument document) {
        if (document.getOutlineRoot() != null) {
            return getOutlineJson(document);
        }
        document.newOutlineRoot();
        return getOutlineJson(document);
    }

    public static Map<String, Object> getOutlineJson(CPDFDocument document) {
        CPDFOutline outline = document.getOutlineRoot();
        if (outline == null) {
            return null;
        }
        try {
            return getOutlineJson(document, outline);
        } catch (Exception e) {
        }
        return null;
    }

    private static Map<String, Object> getOutlineJson(CPDFDocument document, CPDFOutline outline) throws Exception {
        if (outline.outlinePtr == 0) {
            return new HashMap<>();
        }
        Map<String, Object> map = new HashMap<>();
        map.put("uuid", outline.outlinePtr + "");
        map.put("tag", outline.getTag());
        map.put("title", outline.getTitle());
        map.put("level", outline.getLevel());
        Map<String, Object> actionMap = getActionMap(document, outline.getAction());
        if (actionMap != null) {
            map.put("action", actionMap);
        }
        Map<String, Object> destinationMap = getDestinationMap(outline.getDestination());
        if (destinationMap != null) {
            map.put("destination", destinationMap);
            Map<String, Object> gotoMap = new HashMap<>();

            gotoMap.put("pageIndex", outline.getDestination().getPageIndex());
            gotoMap.put("actionType", "goTo");

            map.put("action", gotoMap);
        }

        if (outline.getChildList() != null && outline.getChildList().length > 0) {
            List<Map<String, Object>> childList = new java.util.ArrayList<>();
            for (CPDFOutline child : outline.getChildList()) {
                Map<String, Object> childMap = getOutlineJson(document, child);
                if (!childMap.isEmpty()) {
                    childList.add(childMap);
                }
            }
            map.put("childList", childList);
        }
        return map;
    }

    private static Map<String, Object> getActionMap(CPDFDocument document, CPDFAction action) {
        Map<String, Object> actionMap = new HashMap<>();

        if (action == null) {
            return null;
        }
        switch (action.getActionType()) {
            case PDFActionType_URI:
                actionMap.put("actionType", "uri");
                CPDFUriAction uriAction = (CPDFUriAction) action;
                actionMap.put("uri", uriAction.getUri());
                break;
            case PDFActionType_GoTo:
                CPDFGoToAction goToAction = (CPDFGoToAction) action;
                actionMap.put("actionType", "goTo");
                CPDFDestination destination = goToAction.getDestination(document);
                if (destination != null) {
                    actionMap.put("destination", getDestinationMap(destination));
                }
                break;
        }
        return actionMap;
    }

    private static Map<String, Object> getDestinationMap(CPDFDestination destination) {
        if (destination == null) {
            return null;
        }
        Map<String, Object> destMap = new HashMap<>();
        destMap.put("pageIndex", destination.getPageIndex());
        destMap.put("zoom", destination.getZoom());
        destMap.put("positionX", destination.getPosition_x());
        destMap.put("positionY", destination.getPosition_y());
        return destMap;
    }

    public static boolean addOutline(CPDFDocument document, MethodCall call) {
        String parentUUid = call.argument("parent_uuid");
        int insertIndex = call.argument("insert_index");
        String title = call.argument("title");
        int pageIndex = call.argument("page_index");
        CPDFOutline parentOutline = findOutlineByUUid(document.getOutlineRoot(), parentUUid);
        if (parentOutline == null) {
            return false;
        }
        if (insertIndex == -1) {
            insertIndex = parentOutline.getChildList() != null ? parentOutline.getChildList().length : 0;
        }
        CPDFOutline newOutline = parentOutline.insertChildAtIndex(insertIndex);
        newOutline.setTitle(title);
        CPDFDestination destination = new CPDFDestination(pageIndex, 0, 0, 1F);
        newOutline.setDestination(destination);
        return true;
    }

    public static boolean moveTo(CPDFDocument document, String uuid, String newParentUuid, int insertIndex) {
        CPDFOutline outline = findOutlineByUUid(document.getOutlineRoot(), uuid);
        CPDFOutline newParentOutline = findOutlineByUUid(document.getOutlineRoot(), newParentUuid);
        if (outline == null || newParentOutline == null) {
            return false;
        }
        if (insertIndex == -1) {
            insertIndex = newParentOutline.getChildList() != null ? newParentOutline.getChildList().length : 0;
        }
        return outline.moveTo(newParentOutline, insertIndex);
    }

    public static boolean deleteOutline(CPDFDocument document, String uuid) {
        CPDFOutline outline = findOutlineByUUid(document.getOutlineRoot(), uuid);
        if (outline == null) {
            return false;
        }
        return outline.removeFromParent();
    }

    public static boolean updateOutlineTitle(CPDFDocument document, String uuid, String newTitle, int pageIndex) {
        CPDFOutline outline = findOutlineByUUid(document.getOutlineRoot(), uuid);
        if (outline == null) {
            return false;
        }
        outline.setTitle(newTitle);
        outline.setDestination(new CPDFDestination(pageIndex, 0, 0, 1F));
        return true;
    }

    private static CPDFOutline findOutlineByUUid(CPDFOutline rootOutline, String uuid) {
        if (rootOutline == null || uuid == null) {
            return null;
        }
        if ((rootOutline.outlinePtr + "").equals(uuid)) {
            return rootOutline;
        }
        if (rootOutline.getChildList() != null) {
            for (CPDFOutline child : rootOutline.getChildList()) {
                CPDFOutline result = findOutlineByUUid(child, uuid);
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }

}
