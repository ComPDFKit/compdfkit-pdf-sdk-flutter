/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'cpdf_context_menu_item.dart';
import 'cpdf_context_menu_options.dart';

class CPDFContentEditorModeContextMenu {

  final List<CPDFContextMenuItem<CPDFContentEditorEditTextAreaMenuKey>> editTextArea;
  final List<CPDFContextMenuItem<CPDFContentEditorEditSelectTextMenuKey>> editSelectText;
  final List<CPDFContextMenuItem<CPDFContentEditorEditTextMenuKey>> editText;
  final List<CPDFContextMenuItem<CPDFContentEditorImageAreaMenuKey>> imageArea;
  final List<CPDFContextMenuItem<CPDFContentEditorImageCropMenuKey>> imageCropMode;
  final List<CPDFContextMenuItem<CPDFContentEditorEditPathMenuKey>> editPathContent;
  final List<CPDFContextMenuItem<CPDFContentEditorLongPressWithEditTextModeMenuKey>> longPressWithEditTextMode;
  final List<CPDFContextMenuItem<CPDFContentEditorLongPressWithEditImageModeMenuKey>> longPressWithEditImageMode;
  final List<CPDFContextMenuItem<CPDFContentEditorLongPressWithAllModeMenuKey>> longPressWithAllMode;
  final List<CPDFContextMenuItem<CPDFContentEditorSearchReplaceMenuKey>> searchReplace;


  const CPDFContentEditorModeContextMenu({
    this.editTextArea = const [
      CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.properties),
      CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.edit),
      CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.cut),
      CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.copy),
      CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.delete),
    ],
    this.editSelectText = const [
      CPDFContextMenuItem(CPDFContentEditorEditSelectTextMenuKey.properties),
      CPDFContextMenuItem(CPDFContentEditorEditSelectTextMenuKey.opacity, subItems: [
        CPDFContextMenuOpacityKey.opacity25,
        CPDFContextMenuOpacityKey.opacity50,
        CPDFContextMenuOpacityKey.opacity75,
        CPDFContextMenuOpacityKey.opacity100,
      ]),
      CPDFContextMenuItem(CPDFContentEditorEditSelectTextMenuKey.cut),
      CPDFContextMenuItem(CPDFContentEditorEditSelectTextMenuKey.copy),
      CPDFContextMenuItem(CPDFContentEditorEditSelectTextMenuKey.delete),
    ],
    this.editText = const [
      CPDFContextMenuItem(CPDFContentEditorEditTextMenuKey.select),
      CPDFContextMenuItem(CPDFContentEditorEditTextMenuKey.selectAll),
      CPDFContextMenuItem(CPDFContentEditorEditTextMenuKey.paste),
    ],
    this.imageArea = const [
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.properties),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.rotateLeft),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.rotateRight),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.replace),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.export),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.opacity, subItems: [
        CPDFContextMenuOpacityKey.opacity25,
        CPDFContextMenuOpacityKey.opacity50,
        CPDFContextMenuOpacityKey.opacity75,
        CPDFContextMenuOpacityKey.opacity100,
      ]),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.flipHorizontal),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.flipVertical),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.crop),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.delete),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.copy),
      CPDFContextMenuItem(CPDFContentEditorImageAreaMenuKey.cut),
    ],
    this.imageCropMode = const [
      CPDFContextMenuItem(CPDFContentEditorImageCropMenuKey.done),
      CPDFContextMenuItem(CPDFContentEditorImageCropMenuKey.cancel),
    ],
    this.editPathContent = const [
      CPDFContextMenuItem(CPDFContentEditorEditPathMenuKey.delete),
    ],
    this.longPressWithEditTextMode = const [
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditTextModeMenuKey.addText),
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditTextModeMenuKey.paste),
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditTextModeMenuKey.keepTextOnly),
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditTextModeMenuKey.keepSourceFormatingPaste),
    ],
    this.longPressWithEditImageMode = const [
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditImageModeMenuKey.addImages),
      CPDFContextMenuItem(CPDFContentEditorLongPressWithEditImageModeMenuKey.paste),
    ],
    this.longPressWithAllMode = const [
      CPDFContextMenuItem(CPDFContentEditorLongPressWithAllModeMenuKey.paste),
      CPDFContextMenuItem(CPDFContentEditorLongPressWithAllModeMenuKey.keepSourceFormatingPaste),
    ],
    this.searchReplace = const [
      CPDFContextMenuItem(CPDFContentEditorSearchReplaceMenuKey.replace),
    ],
  });


  Map<String, dynamic> toJson() {
    return {
      'editTextAreaContent': editTextArea.map((item) => item.toJson()).toList(),
      'editSelectTextContent': editSelectText.map((item) => item.toJson()).toList(),
      'editTextContent': editText.map((item) => item.toJson()).toList(),
      'imageAreaContent': imageArea.map((item) => item.toJson()).toList(),
      'imageCropMode': imageCropMode.map((item) => item.toJson()).toList(),
      'editPathContent': editPathContent.map((item) => item.toJson()).toList(),
      'longPressWithEditTextMode': longPressWithEditTextMode.map((item) => item.toJson()).toList(),
      'longPressWithEditImageMode': longPressWithEditImageMode.map((item) => item.toJson()).toList(),
      'longPressWithAllMode': longPressWithAllMode.map((item) => item.toJson()).toList(),
      'searchReplace': searchReplace.map((item) => item.toJson()).toList(),
    };
  }

}