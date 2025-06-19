/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

/// contextMenuConfig - global - screen menu key
enum CPDFScreenShotMenuKey {
  exit,
  share,
}


enum CPDFViewModeTextSelectKey {
  copy
}


enum CPDFAnnotationTextSelectMenuKey {
  copy,
  highlight,
  underline,
  strikeout,
  squiggly,
}

enum CPDFAnnotationLongPressMenuKey {
  paste,
  note,
  textBox,
  stamp,
  image,
}

enum CPDFAnnotationMarkupMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
}

enum CPDFAnnotationSoundMenuKey {
  reply,
  viewReply,
  play,
  record,
  delete,
}

enum CPDFAnnotationInkMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
}

enum CPDFAnnotationShapeMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
}

enum CPDFAnnotationFreeTextMenuKey {
  properties,
  edit,
  reply,
  viewReply,
  delete,
}

enum CPDFAnnotationSignMenuKey {
  signHere,
  delete,
  rotate,
}

enum CPDFAnnotationStampMenuKey {
  note,
  reply,
  viewReply,
  delete,
  rotate,
}

enum CPDFAnnotationLinkMenuKey {
  edit,
  delete,
}


enum CPDFContentEditorEditTextAreaMenuKey {
  properties,
  edit,
  cut,
  copy,
  delete,
}

enum CPDFContentEditorEditSelectTextMenuKey {
  properties,
  opacity,
  cut,
  copy,
  delete,
}

enum CPDFContentEditorEditTextMenuKey {
  select,
  selectAll,
  paste,
}

enum CPDFContentEditorImageAreaMenuKey {
  properties,
  rotateLeft,
  rotateRight,
  replace,
  export,
  opacity,
  flipHorizontal,
  flipVertical,
  crop,
  delete,
  copy,
  cut,
}

enum CPDFContentEditorImageCropMenuKey {
  done,
  cancel,
}

enum CPDFContentEditorEditPathMenuKey {
  delete,
}

enum CPDFContentEditorLongPressWithEditTextModeMenuKey {
  addText,
  paste,
  keepTextOnly,
  keepSourceFormatingPaste,
}

enum CPDFContentEditorLongPressWithEditImageModeMenuKey {
  addImages,
  paste,
}

enum CPDFContentEditorLongPressWithAllModeMenuKey {
  paste,
  keepSourceFormatingPaste,
}

enum CPDFContentEditorSearchReplaceMenuKey {
  replace,
}

/// FormMode 菜单类型
enum CPDFFormTextFieldMenuKey {
  properties,
  delete,
}

enum CPDFFormCheckBoxMenuKey {
  properties,
  delete,
}

enum CPDFFormRadioButtonMenuKey {
  properties,
  delete,
}

enum CPDFFormListBoxMenuKey {
  options,
  properties,
  delete,
}

enum CPDFFormComboBoxMenuKey {
  options,
  properties,
  delete,
}

enum CPDFFormSignatureFieldMenuKey {
  startToSign,
  delete,
}

enum CPDFFormPushButtonMenuKey {
  options,
  properties,
  delete,
}

class CPDFContextMenuOpacityKey {


  static const opacity25 = '25%';
  static const opacity50 = '50%';
  static const opacity75 = '75%';
  static const opacity100 = '100%';

}