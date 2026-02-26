/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

/// contextMenuConfig - global - screen menu key
enum CPDFScreenShotMenuKey { exit, share, custom }

enum CPDFViewModeTextSelectKey { copy, custom }

enum CPDFAnnotationTextSelectMenuKey {
  copy,
  highlight,
  underline,
  strikeout,
  squiggly,
  custom;
}

enum CPDFAnnotationLongPressMenuKey {
  paste,
  note,
  textBox,
  stamp,
  image,
  custom;
}

enum CPDFAnnotationMarkupMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
  custom;
}

enum CPDFAnnotationSoundMenuKey {
  reply,
  viewReply,
  play,
  record,
  delete,
  custom;
}

enum CPDFAnnotationInkMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
  custom;
}

enum CPDFAnnotationShapeMenuKey {
  properties,
  note,
  reply,
  viewReply,
  delete,
  custom;
}

enum CPDFAnnotationFreeTextMenuKey {
  properties,
  edit,
  reply,
  viewReply,
  delete,
  custom;
}

enum CPDFAnnotationSignMenuKey {
  signHere,
  delete,
  rotate,
  custom;
}

enum CPDFAnnotationStampMenuKey {
  note,
  reply,
  viewReply,
  delete,
  rotate,
  custom;
}

enum CPDFAnnotationLinkMenuKey {
  edit,
  delete,
  custom;
}

enum CPDFContentEditorEditTextAreaMenuKey {
  properties,
  edit,
  cut,
  copy,
  delete,
  custom;
}

enum CPDFContentEditorEditSelectTextMenuKey {
  properties,
  opacity,
  cut,
  copy,
  delete,
  custom;
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
  custom;
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
  custom;
}

enum CPDFContentEditorLongPressWithEditImageModeMenuKey {
  addImages,
  paste,
  custom;
}

enum CPDFContentEditorLongPressWithAllModeMenuKey {
  paste,
  keepSourceFormatingPaste,
  custom;
}

enum CPDFContentEditorSearchReplaceMenuKey {
  replace,
}

/// FormMode
enum CPDFFormTextFieldMenuKey { properties, delete, custom }

enum CPDFFormCheckBoxMenuKey {
  properties,
  delete,
  custom;
}

enum CPDFFormRadioButtonMenuKey {
  properties,
  delete,
  custom;
}

enum CPDFFormListBoxMenuKey {
  options,
  properties,
  delete,
  custom;
}

enum CPDFFormComboBoxMenuKey {
  options,
  properties,
  delete,
  custom;
}

enum CPDFFormSignatureFieldMenuKey {
  startToSign,
  delete,
  custom;
}

enum CPDFFormPushButtonMenuKey {
  options,
  properties,
  delete,
  custom;
}

class CPDFContextMenuOpacityKey {
  static const opacity25 = '25%';
  static const opacity50 = '50%';
  static const opacity75 = '75%';
  static const opacity100 = '100%';
}
