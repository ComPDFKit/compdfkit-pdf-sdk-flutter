/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.viewer.ops;

import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CHANGE_EDIT_TYPE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_CAN_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_REDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.CONTENT_EDITOR_UNDO;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.GET_FORM_CREATION_MODE;
import static com.compdfkit.flutter.compdfkit_flutter.constants.CPDFConstants.ChannelMethod.SET_FORM_CREATION_MODE;

import com.compdfkit.core.edit.CPDFEditManager;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.tools.common.pdf.CPDFConfigurationUtils;
import com.compdfkit.tools.common.pdf.CPDFDocumentFragment;
import com.compdfkit.ui.reader.CPDFReaderView;
import com.compdfkit.ui.reader.CPDFReaderView.ViewMode;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.List;

public final class ViewerEditorOps {

    private ViewerEditorOps() {
    }

    public static boolean handle(MethodCall call, MethodChannel.Result result,
            CPDFDocumentFragment documentFragment, CPDFReaderView readerView) {
        switch (call.method) {
            case CHANGE_EDIT_TYPE:
                List<Integer> types = (List<Integer>) call.arguments;
                if (readerView.getViewMode() != ViewMode.PDFEDIT
                        && readerView.getViewMode() != ViewMode.ALL) {
                    result.error("1002",
                            "Current mode is not contentEditor mode, please switch to CPDFViewMode.contentEditor mode first.",
                            null);
                    return true;
                }
                CPDFEditManager changeTypeManager = readerView.getEditManager();
                if (changeTypeManager == null) {
                    result.error("1001",
                            "EditManager is null, please check if Edit feature is enabled.", null);
                    return true;
                }
                int editType = 0;
                for (Integer type : types) {
                    editType |= type;
                }
                changeTypeManager.changeEditType(editType);
                documentFragment.editToolBar.updateTypeStatus();
                result.success(true);
                return true;
            case CONTENT_EDITOR_CAN_REDO:
                CPDFEditManager redoManager = readerView.getEditManager();
                result.success(redoManager != null && redoManager.canRedo());
                return true;
            case CONTENT_EDITOR_CAN_UNDO:
                CPDFEditManager undoManager = readerView.getEditManager();
                result.success(undoManager != null && undoManager.canUndo());
                return true;
            case CONTENT_EDITOR_UNDO:
                CPDFEditManager editorUndoManager = readerView.getEditManager();
                if (editorUndoManager == null || !editorUndoManager.canUndo()) {
                    result.success(false);
                    return true;
                }
                editorUndoManager.undo();
                result.success(true);
                return true;
            case CONTENT_EDITOR_REDO:
                CPDFEditManager editorRedoManager = readerView.getEditManager();
                if (editorRedoManager == null || !editorRedoManager.canRedo()) {
                    result.success(false);
                    return true;
                }
                editorRedoManager.redo();
                result.success(true);
                return true;
            case SET_FORM_CREATION_MODE:
                String mode = (String) call.arguments;
                WidgetType widgetType = CPDFConfigurationUtils.getWidgetType(mode);
                documentFragment.formToolBar.switchFormMode(widgetType);
                result.success(true);
                return true;
            case GET_FORM_CREATION_MODE:
                result.success(getFormMode(readerView));
                return true;
            default:
                return false;
        }
    }

    private static String getFormMode(CPDFReaderView readerView) {
        switch (readerView.getCurrentFocusedFormType()) {
            case Widget_TextField:
                return "textField";
            case Widget_CheckBox:
                return "checkBox";
            case Widget_RadioButton:
                return "radioButton";
            case Widget_ListBox:
                return "listBox";
            case Widget_ComboBox:
                return "comboBox";
            case Widget_PushButton:
                return "pushButton";
            case Widget_SignatureFields:
                return "signaturesFields";
            default:
                return "unknown";
        }
    }
}